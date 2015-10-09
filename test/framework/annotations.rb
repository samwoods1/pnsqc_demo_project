# Taken from http://stackoverflow.com/questions/3157426/how-to-simulate-java-like-annotations-in-ruby
# Used to simplify and make known_issue be more efficient by also not running the associated setup and teardown functions.

module Annotations
  def annotations(meth=nil)
    return @__annotations__[meth] if meth
    @__annotations__
  end

  private

  def method_added(m)
    (@__annotations__ ||= {})[m] = @__last_annotation__ if @__last_annotation__
    @__last_annotation__ = nil
    super
  end

  def method_missing(meth, *args)
    return super unless /\A_/ =~ meth
    @__last_annotation__ ||= {}
    @__last_annotation__[meth[1..-1].to_sym] = args.size == 1 ? args.first : args
  end
end

class Class
  private

  def annotate!
    extend Annotations
  end
end
