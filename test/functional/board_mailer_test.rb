require 'test_helper'

class BoardMailerTest < ActionMailer::TestCase
  include ShortenUrl

  test "should create invitation email" do
    hostname = "ideaboardy.herokuapp.com"
    to = "group@abc.com"
    board = boards(:board_one)

    email = BoardMailer.invitation_email(hostname, to, board).deliver

    assert !ActionMailer::Base.deliveries.empty?
    assert_equal [to], email.to
    assert_equal "Board '#{board.name}' is created", email.subject
    assert_match /Board '#{board.name}'/, email.encoded
    assert_match /#{hostname}\/board\/#{get_shorten_url("api_board", board.id)}/, email.encoded
  end

  test "should create share report email" do
    hostname = "ideaboardy.herokuapp.com"
    to = "group@abc.com"
    board = boards(:board_one)

    email = BoardMailer.share_email(hostname, to, board).deliver

    assert !ActionMailer::Base.deliveries.empty?
    assert_equal [to], email.to
    assert_equal "report for '#{board.name}'", email.subject
  end
end