require 'selenium-webdriver'
require_relative 'demo_base_test'
require_relative 'demo_element_wait'

# Implements all of the same methods as a webdriver element, except uses lazy initialization,
# and is an array of elements which by default will operate on the first element in the array.
class DemoElement
  attr_accessor :selenium_elements, :element_timeout
  include Enumerable
  @element_timeout

  # Get or set the timeout value for a specific element, otherwise it uses the default element timeout
  def element_timeout
    @element_timeout ||= DemoElementWait.default_element_timeout
  end

  # A collection of all matching elements as selenium Element instances
  @selenium_elements = nil

  # Optionally provide a parent when initializing the element.
  def initialize(css_locator, parent = nil)
    @locator = css_locator
    @parent = parent
    @index = 0
  end

  # This class can be treated like either an array of elements or a single element.
  # Getting back an element within an array with elements[3] will return an instance of itself,
  # with the default element index to operate on set to the provided index.
  def each(&block)
    @selenium_elements.each_index do |index|
      @index = index
      block.call(self)
    end
  end

  # Lazily initialize the element
  def get_selenium_elements
    # if the selenium_elements hasn't been initialized, or has 0 elements, try to get the elements again.
    ret_val = @selenium_elements.nil? || @selenium_elements.size <= 0 ? get_elements : @selenium_elements
    ret_val
  end

  # Gets elements matching the css locator and optionally parent
  def get_elements
    if @parent.nil?
      DemoElementWait.wait_for(element_timeout) { set_selenium_elements(DemoBaseTest.driver, { :css => @locator }) }
    else
      begin
        DemoElementWait.wait_for(element_timeout) { set_selenium_elements(@parent.get_selenium_elements[@index], { :css => @locator }) }
      rescue Selenium::WebDriver::Error::StaleElementReferenceError
        @parent.get_selenium_elements
        DemoElementWait.wait_for(element_timeout) { set_selenium_elements(@parent.get_selenium_elements[@index], { :css => @locator }) }
      end
    end
    if !@parent.nil? && @parent.get_selenium_elements.size < 1
      raise "parent element for element #{self.to_s} does not exist"
    end
    @selenium_elements
  end

  # Make get_elements private
  private :get_elements

  # sets @selenium_elements to current list of elements matching locator and parent.
  def set_selenium_elements (parent, locator)
    @selenium_elements = parent.find_elements(locator)
    return @selenium_elements.size > 0
  end

  # Override to_s so you see a nice string representing the element while debugging
  def to_s
    ret_val = "locator '#{@locator}'"
    ret_val += ", parent = '#{@parent.to_s}'" if !@parent.nil?
    ret_val
  end

  def select_option(option_text)
    get_selenium_elements[@index]
    drop_down = Selenium::WebDriver::Support::Select.new @selenium_elements[@index]
    drop_down.select_by(:text, option_text)
  end

  # ------------------------------------- Existing Selenium Methods Below -------------------------------------

  #Finds an array of elements
  def find_element(css_locator)
    find_elements(css_locator)
  end

  #finds an array of elements with this element as the parent
  def find_elements(css_locator)
    DemoElement.new(css_locator, self)
  end

  #
  # Click this element. If this causes a new page to load, this method will
  # attempt to block until the page has loaded. If
  # click() causes a new page to be loaded via an event or is done by
  # sending a native event then the method will *not* wait for it to be
  # loaded and the caller should verify that a new page has been loaded.
  #
  # There are some preconditions for an element to be clicked.  The element
  # must be visible and it must have a height and width greater then 0.
  #
  # Equivalent to:
  #   driver.action.click(element)
  #
  # @example Click on a button
  #
  #    driver.find_element(:tag_name, "button").click
  #
  # @raise [StaleElementReferenceError] if the element no longer exists as
  #  defined
  #

  def click
    get_selenium_elements[@index].click
  end

  #
  # Get the tag name of the element.
  #
  # @example Get the tagname of an INPUT element(returns "input")
  #
  #    driver.find_element(:xpath, "//input").tag_name
  #
  # @return [String] The tag name of this element.
  #

  def tag_name
    get_selenium_elements[@index].tag_name
  end

  #
  # Get the value of a the given attribute of the element. Will return the current value, even if
  # this has been modified after the page has been loaded. More exactly, this method will return
  # the value of the given attribute, unless that attribute is not present, in which case the
  # value of the property with the same name is returned. If neither value is set, nil is
  # returned. The "style" attribute is converted as best can be to a text representation with a
  # trailing semi-colon. The following are deemed to be "boolean" attributes, and will
  # return either "true" or "false":
  #
  # async, autofocus, autoplay, checked, compact, complete, controls, declare, defaultchecked,
  # defaultselected, defer, disabled, draggable, ended, formnovalidate, hidden, indeterminate,
  # iscontenteditable, ismap, itemscope, loop, multiple, muted, nohref, noresize, noshade, novalidate,
  # nowrap, open, paused, pubdate, readonly, required, reversed, scoped, seamless, seeking,
  # selected, spellcheck, truespeed, willvalidate
  #
  # Finally, the following commonly mis-capitalized attribute/property names are evaluated as
  # expected:
  #
  # class, readonly
  #
  # @param [String]
  #   attribute name
  # @return [String,nil]
  #   attribute value
  #

  def attribute(name)
    get_selenium_elements[@index].attribute(name)
  end

  #
  # Get the text content of this element
  #
  # @return [String]
  #

  def text
    get_selenium_elements[@index].text
  end

  #
  # Send keystrokes to this element
  #
  # @param [String, Symbol, Array]
  #
  # Examples:
  #
  #     element.send_keys "foo"                     #=> value: 'foo'
  #     element.send_keys "tet", :arrow_left, "s"   #=> value: 'test'
  #     element.send_keys [:control, 'a'], :space   #=> value: ' '
  #
  # @see Keys::KEYS
  #

  def send_keys(*args)
    get_selenium_elements[@index].send_keys(*args)
  end
  alias_method :send_key, :send_keys

  #
  # If this element is a text entry element, this will clear the value. Has no effect on other
  # elements. Text entry elements are INPUT and TEXTAREA elements.
  #
  # Note that the events fired by this event may not be as you'd expect.  In particular, we don't
  # fire any keyboard or mouse events.  If you want to ensure keyboard events are
  # fired, consider using #send_keys with the backspace key. To ensure you get a change event,
  # consider following with a call to #send_keys with the tab key.
  #

  def clear
    get_selenium_elements[@index].clear
  end

  #
  # Is the element enabled?
  #
  # @return [Boolean]
  #

  def enabled?
    get_selenium_elements[@index].enabled?
  end

  #
  # Is the element selected?
  #
  # @return [Boolean]
  #

  def selected?
    get_selenium_elements[@index].selected?
  end

  #
  # Is the element displayed?
  #
  # @return [Boolean]
  #

  def displayed?
    get_selenium_elements[@index].displayed?
  end

  #
  # Submit this element
  #

  def submit
    get_selenium_elements[@index].submit
  end

  #
  # Get the value of the given CSS property
  #
  # Note that shorthand CSS properties (e.g. background, font, border, border-top, margin,
  # margin-top, padding, padding-top, list-style, outline, pause, cue) are not returned,
  # in accordance with the DOM CSS2 specification - you should directly access the longhand
  # properties (e.g. background-color) to access the desired values.
  #
  # @see http://www.w3.org/TR/DOM-Level-2-Style/css.html#CSS-CSSStyleDeclaration
  #

  def css_value(prop)
    get_selenium_elements[@index].css_value(prop)
  end
  alias_method :style, :css_value

  #
  # Get the location of this element.
  #
  # @return [WebDriver::Point]
  #

  def location
    get_selenium_elements[@index].location
  end

  #
  # Determine an element's location on the screen once it has been scrolled into view.
  #
  # @return [WebDriver::Point]
  #

  def location_once_scrolled_into_view
    get_selenium_elements[@index].location_once_scrolled_into_view
  end

  #
  # Get the size of this element
  #
  # @return [WebDriver::Dimension]
  #

  def size
    get_selenium_elements[@index].size
  end


  #-------------------------------- sugar  --------------------------------

  #
  #   element.first(:id, 'foo')
  #

  alias_method :first, :find_element

  #
  #   element.all(:class, 'bar')
  #

  alias_method :all, :find_elements

  #
  #   element['class'] or element[:class] #=> "someclass"
  #
  alias_method :[], :attribute

end
