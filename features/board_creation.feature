Feature: Board Creation
  In order to collect ideas relate to specific topic
  As a board user
  I want to create a new board

  @javascript
  Scenario:
    Given I go to Ideaboardy
    When I try to create board with following information:
      | Name       | Description      |
      | team retro | for iteration 15 |
    Then I should see board "team retro" in board list