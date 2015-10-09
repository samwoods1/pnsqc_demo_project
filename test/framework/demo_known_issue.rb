require 'json'

module KnownIssue
  FIXED_ISSUE_STATUSES = ['READY FOR TEST', 'READY FOR REVIEW', 'READY FOR CI', 'RESOLVED', 'CLOSED']

  # Specify a defect, or ticket in Jira that is causing a test case to fail until it is fixed.
  # This queries Jira and executes the test if the ticket has been fixed, and skips the test
  # if the ticket has not been fixed
  #
  # @example Typical usage
  #   known_issue('PUP-1234')
  #
  # @param [String] ID of Jira ticket
  # @author Sam Woods (<tt>sam.woods@puppetlabs.com</tt>)
  # TODO: This is not generic, I built it for puppet and didn't strip out any non generic stuff,
  # or make it easy to override the URI or list of values acceptable to consider a ticket 'fixed'
  def known_issue(id)
    skip_message = nil
    DemoLogger.log.info "Checking status of KnownIssue '#{id}'"
    uri = URI.parse("https://tickets.puppetlabs.com/rest/api/2/issue/#{id}?fields=summary,status")

    max_tries = 2
    max_tries.downto(0) do |tries_left|
      begin
        Net::HTTP.start(uri.host, uri.port,
                        :use_ssl => uri.scheme == 'https') do |http|
          request = Net::HTTP::Get.new uri
          request['Content-Type'] = "application/json"

          response = http.request request
          # If issue can't be found, log a warning and continue test case execution
          if response.code != "200"
            raise "The specified known_issue #{id} could not be found in Jira, or the server could not be reached.  Response code #{response.code}"
          end

          parsed_response = JSON.parse(response.body)

          # Verify that the response is for the correct issue and not a "closest match".
          if parsed_response["key"].to_s.downcase != id.downcase
            raise "The specified known_issue '#{id}' could not be found in Jira."
          end

          # Determine if ticket is marked as fixed or not
          status = parsed_response["fields"]["status"]["name"]

          fixed = false

          FIXED_ISSUE_STATUSES.each do |fixed_status|
            fixed = true if fixed_status == status.upcase
          end

          # If status of issue is fixed, log a warning with a reminder to remove known_issue and execute test.end
          if fixed
            DemoLogger.log.warn "Issue '#{id}' - #{parsed_response["fields"]["summary"]} is fixed!  " +
                             "Remove the known_issue from the automation, and update automated test if it is still failing."
            return nil
          else
            # If status of issue is not fixed, log a warning and skip test
            DemoLogger.log.warn "Issue '#{id}' - #{parsed_response["fields"]["summary"]} is NOT fixed.  Skipping test."
            skip_message = "SKIPPING TEST - Blocking known issue '#{id}' has not been fixed."
          end

          #TODO: Should also look at the resolution to see if it is fixed or done.

          return skip_message
        end
      rescue StandardError => ex
        DemoLogger.log.warn "Unable to determine status of defect '#{id}'.  Exception: #{ex}. Retrying #{tries_left} times"
        sleep 5
      end
    end
    return skip_message
  end
end
