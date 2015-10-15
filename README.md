# pnsqc_demo_project
Ruby Selenium based UI automation project for my PNSQC presentation and technical paper 'Obtaining True UI Automation Speed' http://uploads.pnsqc.org/2015/papers/t-137_Woods_paper.pdf.

This project is set up to demonstrate some UI automation strategies that I have found to be useful.  
It is built with Ruby on top of Selenium Webdriver.  Everything under the framework directory is a 
lightweight framework intended to be generic and separate from the application abstraction layer
or automated test cases.  I have it in the same project just to simplify my demonstration.

The implementation is not what I am endorsing, simply the ideas.  This was a quickly thrown together project for demonstration purposes.  I used Minitest (rather than rspec) because it is an XUnit style framework which is in wider use across many languages.  I tried to keep things relatively simple so that these ideas could be understood and ported to whatever language you may want to implement them in.

Some of the things this project demonstrates are:
 - Use of the Page Object Pattern, including:
  - Types of helper methods - Methods that perform some user action and methods that validate something.
  - Modeling application data (user.rb)
  - Useful options for helper functions (submit?, validate?) to avoid calling multiple helper functions for submitting and validating
  - Exceptions vs Assertions and why it matters, including why it is a good idea to have on assertion or block of assertions at the end of a test and not sprinkled all throughout the test.
  - A pattern for testing negative tests (expected failures)
 - Using setup and teardown methods
 - Using inheritance to minimize duplicated code in tests and pages (base page and base test class)
 - Use of direct http requests to generate data required for tests (like creating a user)

Some specific features that were implemented as part of the framework that I have found to be useful:
 - Logging at the element, page and unit testing framework levels including:
  - Finding an element
  - Interacting with an element
  - Transitioning pages
  - Beginning a helper function
  - Exception if helper function fails
  - Log all exceptions and assertions (before they get swallowed by the test framework)
  - Beginning and ending of class setup, class teardown, test setup, test teardown, test execution
 - Screenshots on test failures
 - Automatic use of implicit waits
 - All elements use lazy initialization - meaning that you can specify an instance of the element in your page constructor regardless of whether that element currently exists in the browser, and the first time you access a property or method it will then initialize itself and find the element within the DOM.  This simplifies the page object pattern and removes the need for a singleton factory, instead you simply instantiate your page class and declare and instantiate all elements in it's constructor.
 - No difference between an element and array of elements, they are all arrays.  If you evaluate an element property or method it will be applied to the first element in the list (or the only element if there is only 1 match), and if there are more than 1 element it is also an array and can be used that way.  For example:
  - my_button = DemoElement.new('#my_button'); my_button.click  # matches one or more elements
  - my_links = DemoElement.new('.link'); my_links[3].click # matches more than one element
 - Stack trace analysis to bucket failures into similar or same root causes
  - For example, you run 50 tests, have 10 failures but it finds only 3 unique top stack traces.  You can then fix the first failed test in each bucket, then re-run tests to ensure you fixed all of the problems, avoiding needing to triage and investigate the other 7 non unique failures
 - Integration of unit testing framework (minitest) with defect tracking (jira) for known issues with the _known_issue annotation
  - This allows you to mark a failing test as a known issue tied to a specific ticket (defect or story) which will then be skipped, until the associated ticket is resolved, where it will then start executing again.
 - A base page class that allows you to 
  - Specify a URL and navigate to the page
  - Specify required elements and validate that the page has loaded with all of the specified required elements visible.
  - Specify a timeout value for pages (defaults to 30 seconds)
  - Automatically waits for jquery processing to finish (if your site uses jquery) before interacting with elements.

- A base test class that
 - Sets up logging
 - Logs
 - Processes annotations
 - Takes screenshot on failure
 - Starts and stops Selenium Webdriver driver
- Very basic helper to create and execute direct web requests 

One last thing I will implement soon that didn't make it into my PNSQC presentation:

 - Creating dependencies on test results
   - Example: If login test fails, all tests depending on login would also fail and should be treated as unknown results, not failed results.
   - Note, this does not prevent execution, otherwise we would have to walk the dependency tree of every test prior to the run and run tests in a specific order (assuming you had no circular dependencies).  All tests are executed, and only the test results are compared against the dependencies.
