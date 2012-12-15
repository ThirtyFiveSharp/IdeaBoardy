require 'test_helper'

class EmailsControllerTest < ActionController::TestCase

  test "should send invitation" do
    board = boards(:board_one)
    post :invitation, to: "group@abc.com", board: Hash[id: board.id]
    assert_response :success
    response_body = ActiveSupport::JSON.decode @response.body
    assert_equal "success", response_body["result"]
  end

end
