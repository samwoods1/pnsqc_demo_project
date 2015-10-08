# pnsqc_demo_project
Ruby Selenium based UI automation project for PNSQC demo.

This project is set up to demonstrate some UI automation strategies that I have found to be useful.  
It is built with Ruby on top of Selenium Webdriver.  Everything under the framework directory is a 
lightweight framework intended to be generic and separate from the application abstraction layer
or automated test cases.

Some of the things this project demonstrates are:
1. Use of the Page Object Pattern, including:
 - Types of helper methods
 - Modeling application data
 - When to throw exceptions
 - Options for helper functions
2. Logging at the test, page and framework levels
3. Screenshots on test failures
4. Use of implicit waits
5. Using setup and teardown methods
6. Using inheritance to minimize duplicated code in tests and pages
7. Use of direct http requests to generate data required for tests (like creating a user)
8. Stack trace analysis to bucket failures into similar or same root causes

Some of the things I am hoping to add soon are:
1. Integrating unit testing framework with defect tracking for known issues
2. Creating dependencies on test results, so for example you could know that if login test fails, all 
   tests depending on login would also fail and should be treated as unknown results, not failed results.
