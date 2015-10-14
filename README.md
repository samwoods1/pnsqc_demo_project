# pnsqc_demo_project
Ruby Selenium based UI automation project for my PNSQC presentation 'Obtaining True UI Automation Speed' http://www.pnsqc.org/obtaining-true-ui-automation-speed/.

This project is set up to demonstrate some UI automation strategies that I have found to be useful.  
It is built with Ruby on top of Selenium Webdriver.  Everything under the framework directory is a 
lightweight framework intended to be generic and separate from the application abstraction layer
or automated test cases.

Some of the things this project demonstrates are:
 - Use of the Page Object Pattern, including:
  - Types of helper methods
  - Modeling application data
  - When to throw exceptions
  - Options for helper functions
 - Logging at the test, page and framework levels
 - Screenshots on test failures
 - Use of implicit waits
 - Using setup and teardown methods
 - Using inheritance to minimize duplicated code in tests and pages
 - Use of direct http requests to generate data required for tests (like creating a user)
 - Stack trace analysis to bucket failures into similar or same root causes
 - Integrating unit testing framework with defect tracking for known issues

The last thing I hope to add before PNSQC on Monday is:

 - Creating dependencies on test results, so for example you could know that if login test fails, all 
   tests depending on login would also fail and should be treated as unknown results, not failed results.
