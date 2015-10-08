
# This is a basic example of how you can determine the top stack trace of all executed tests
# to try to group them together into common failures.  It is not the most efficient or best way to do this,
# but it is a simple implementation to show how easy it can be to at least experiment with this idea.
# Parsing text log files with Ruby is probably not the best tool for this job.  Ideally, you would send
# test results to a database of some sort and have the logic to parse and compare logs in the database.
module DemoLogParser
  def self.parse (dir_path, cut_bottom, ignore_lines_containing = [])
    # The path must be a directory
    if !File.directory? dir_path
      raise('Path to logs must be a directory')
    end

    # To store all of the stack traces we care about
    stack_traces = {}

    # Iterate over each file in the directory.
    Dir.foreach(dir_path) { |file_path|
      # If it is a .log extension, check for errors
      if File.extname(file_path) == '.log'
        # Are we still looking for the error message, cutting out the top, or capturing the top stack?
        state = 'error_message'

        # Track only the lines of the stack that we care about
        top_stack = []
        File.foreach(dir_path + file_path) { |line|
          if line.include?('ERROR -- : ')
            case
              when state == 'error_message'
                then
                # The first line with an ERROR is always the message
                message = '     ' + line[/ERROR -- : (.*)/]
                # If the message indicates that it was an assertion failure, ignore it.  For stack trace analysis, you
                # only care about the unhandled exceptions
                if message.include? 'ERROR -- : Assertion'
                  break
                end
                top_stack.push(message)
                state = 'save'
              when state == 'save'
                # Once we hit a line that includes the path we don't care about at the bottom of the stack, ignore it.
                then
                break if line.include? cut_bottom
                ignore = false
                ignore_lines_containing.each { |ignore_string|
                  if line.include? ignore_string
                    ignore = true
                    break
                  end
                }

                top_stack.push('     ' + line[/ERROR -- : (.*)/]) if !ignore
            end

          end
        }
        stack_traces.store(file_path, top_stack.join("\n")) if !top_stack.empty?
      end
    }
    compare_traces stack_traces
  end

  # Compares the lists of stack traces to group all failures with unique stack traces
  def self.compare_traces (stack_traces)
    puts("\n----------------------------------------- Top Stack Info ---------------------------------------\n" +
             "-Total failed tests due to unhandled exception: #{stack_traces.size}")

    unique_traces = {}
    stack_traces_dup = stack_traces.dup
    # Find all of the unique traces by comparing the stored top_stack's.  If there are no matches,
    # add it to unique_traces.  If there is a match, add the test name to the array for the existing unique trace.
    while stack_traces_dup.size > 0 do
      traces_array = stack_traces_dup.to_a
      if unique_traces.has_key? traces_array[0][1]
        unique_traces[traces_array[0][1]].push traces_array[0][0]
      else
        unique_traces.store(traces_array[0][1], [traces_array[0][0]])
      end

      stack_traces_dup.delete(traces_array[0][0])
    end
    unique_traces_sorted = unique_traces.sort_by{|x| (x[1].size * -1)}
    # Print out all of the unique stack traces
    puts("-Total unique stack traces: #{unique_traces_sorted.size}")
    unique_traces_sorted.each { |trace, tests|
      puts "\n---------------------------------------- #{tests.size} test(s) with matching top stack:"
      puts "-#{tests.join("\n-")}"
      puts trace
    }

    # TODO: Probably could make this not O(n2) somehow...
    near_match_traces = {}
    # Print out all stack traces where 75% or more of lines match
    stack_traces.each_with_index { |trace, index |
      stack_traces
      matches = DemoLogParser.stack_matches_greater_than_percent(stack_traces.values, trace[1], 75)
      if near_match_traces.keys.include?(matches)
        near_match_traces[matches].push trace[0]
      else
        near_match_traces.store(trace[1], [trace[0]])
      end
    }

    near_match_traces_sorted = near_match_traces.sort_by{|x| (x[1].size * -1)}
    # Print out all of the nearly matching stack traces
    puts("\n-Total near match (> 75%) stack traces: #{near_match_traces_sorted.size}")
    near_match_traces_sorted.each { |trace, tests |
      puts "\n---------------------------------------- #{tests.size} test(s) with near matching top stack:"
      puts "-#{tests.join("\n-")}"
      puts trace
    }

  end

  def self.stack_matches_greater_than_percent(trace_array, trace_match, percent)
    trace_match_lines = trace_match.split "\n"
    largest = trace_match
    trace_array.each { |trace|
      next if trace == trace_match
      trace_lines = trace.split "\n"
      # Cheating here a bit with using intersection.  Technically, I should be evaluating lines in order,
      # while intersection would match even out of order lines.
      intersecting = trace_lines & trace_match_lines
      next if intersecting.size == 0
      if trace_lines.size > trace_match_lines.size
        largest_lines = trace_lines
        largest_temp = trace
      else
        largest_lines = trace_match_lines
        largest_temp = trace_match
      end
      if (intersecting.size / largest_lines.size.to_f) * 100 > percent
        largest = largest_temp
      end
    }
    return largest
  end
end
