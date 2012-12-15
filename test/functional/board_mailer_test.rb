require 'test_helper'

class BoardMailerTest < ActionMailer::TestCase
  #test "should create invitation email" do
  #  hostname = "ideaboardy.herokuapp.com"
  #  to = "group@abc.com"
  #  board = boards(:board_one)
  #
  #  email = BoardMailer.invitation_email(hostname, to, board).deliver
  #
  #  assert !ActionMailer::Base.deliveries.empty?
  #  assert_equal [to], email.to
  #  assert_equal "Board '#{board.name}' is created", email.subject
  #  assert_match /Board '#{board.name}'/, email.encoded
  #  assert_match /#{hostname}\/board\?uri=http%3A%2F%2F#{hostname}%2Fapi%2Fboards%2F#{board.id}/, email.encoded
  #end
end