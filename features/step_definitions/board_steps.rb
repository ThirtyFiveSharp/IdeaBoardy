When(/^I try to create board with following information:$/) do |board|
  # table is a | team retro | for iteration 15 |
  page.should have_content('+ 1 board')
  click_link('+ 1 board')
end

Then(/^I should see board "([^"]*)" in board list$/) do |name|
  pending
end