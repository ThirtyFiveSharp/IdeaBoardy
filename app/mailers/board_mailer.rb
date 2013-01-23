class BoardMailer < ActionMailer::Base
  include ShortenUrl

  default from: "ThirtyFive.Sharp@gmail.com"

  def invitation_email(hostname, to, board)
    @board = board
    @hostname = hostname
    @uri = get_shorten_url("api_board", board.id)
    mail to: to, subject: "Board '#{board.name}' is created"
  end

  def share_email(hostname, to, board)
    @board = board
    mail to: to, subject: "report for '#{@board.name}'"
  end

end
