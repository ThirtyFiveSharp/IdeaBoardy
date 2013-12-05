module Api
  class EmailsController < ApiController

    def invitation
      board = Board.find(params[:board][:id])
      email = BoardMailer.invitation_email(request.host_with_port, params[:to], board)
      email.deliver
      render :json => {result: "success"}
    end

    def share
      board = Board.find(params[:board][:id])
      email = BoardMailer.share_email(request.host_with_port, params[:to], board)
      email.deliver
      render :json => {result: "success"}
    end
  end
end