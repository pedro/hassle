Feature: Integration into Rails Apps
  As someone who loves syntactically awesome stylesheets
  I want to be able to use sass when on (mostly) read only file systems and using Rails
  In order to make css less of a hassle

  Scenario: Use hassle with Rails in production mode
    Given I have a Rails app
    And I have a file "public/stylesheets/sass/hassle.sass" with:
    """
    h1
      :font-size 42em
    """
    When Hassle is installed as a plugin
    And the Rails app is initialized in "production" mode
    Then I should see the following in "tmp/hassle/stylesheets/hassle.css":
    """
    h1 {
      font-size: 42em; }
    """

  Scenario: Use hassle with Rails in development mode
    Given I have a Rails app
    And I have a file "public/stylesheets/sass/hassle.sass" with:
    """
    h1
      :font-size 42em
    """
    When Hassle is installed as a plugin
    And the Rails app is initialized in "development" mode
    Then the file "tmp/hassle/stylesheets/hassle.css" should not exist
