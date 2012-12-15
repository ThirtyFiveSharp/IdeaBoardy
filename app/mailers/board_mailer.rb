class BoardMailer < ActionMailer::Base
  default from: "ThirtyFive.Sharp@gmail.com"

  def invitation_email(hostname, to, board)
    @board = board
    @url = "#{root_url(host: hostname)}board?uri=#{board_url board.id, host: hostname}"
    mail to: to, subject: "Board '#{board.name}' is created"
  end

end
