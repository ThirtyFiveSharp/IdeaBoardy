class BoardMailer < ActionMailer::Base
  default from: "ThirtyFive.Sharp@gmail.com"

  def invitation_email(hostname, to, board)
    @board = board
    @hostname = hostname
    @uri = board_url board.id, host: hostname
    mail to: to, subject: "Board '#{board.name}' is created"
  end

end
