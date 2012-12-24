require 'test_helper'

class Api::IdeasControllerTest < ActionController::TestCase
  NON_EXISTED_ID = 99999

  setup do
    @idea1 = ideas(:idea_one)
    @idea2 = ideas(:idea_two)
    @tag1 = tags(:tag_one)
    @tag2 = tags(:tag_two)
  end

  test "should show idea" do
    get :show, id: @idea1.id
    assert_response :success
    actual_idea = ActiveSupport::JSON.decode @response.body
    assert_equal @idea1.id, actual_idea['id']
    assert_equal @idea1.content, actual_idea['content']
    assert_equal @idea1.vote, actual_idea['vote']
    assert_equal @idea1.tags.count, actual_idea['tags'].count
    @idea1.tags.each_with_index do |tag, index|
      assert_equal @idea1.tags[index].id, actual_idea['tags'][index]["id"]
      assert_equal @idea1.tags[index].name, actual_idea['tags'][index]["name"]
      tag_links = actual_idea['tags'][index]["links"]
      assert_equal 1, tag_links.count
      tag_self_link = tag_links.select { |l| l['rel'] == 'self' }.first
      assert_equal api_tag_url(@idea1.tags[index].id), tag_self_link['href']
    end
    links = actual_idea['links']
    assert_equal 4, links.count
    self_link = links.select { |l| l['rel'] == 'self' }.first
    assert_equal api_idea_url(@idea1.id), self_link['href']
    vote_link = links.select { |l| l['rel'] == 'vote' }.first
    assert_equal vote_api_idea_url(@idea1.id), vote_link['href']
    merging_link = links.select { |l| l['rel'] == 'merging' }.first
    assert_equal merging_api_idea_url(@idea1.id), merging_link['href']
    tags_link = links.select { |l| l['rel'] == 'tags' }.first
    assert_equal api_idea_tags_url(@idea1.id), tags_link['href']
  end

  test "should return 404 Not Found when idea is not existed (GET)" do
    get :show, id: NON_EXISTED_ID
    assert_response :not_found
    assert_blank @response.body
  end

  test "should update idea" do
    expected_content = "New Content"
    put :update, id: @idea1.id, idea: {content: expected_content}
    assert_response :no_content
    assert_blank @response.body
    actual_idea = Idea.find @idea1.id
    assert_equal expected_content, actual_idea.content, "should update content of the idea"
  end

  test "should return unprocessable_entity status when clear content of a section" do
    put :update, id: @idea1.id, idea: { content: "" }
    assert_response :unprocessable_entity
    errors = ActiveSupport::JSON.decode @response.body
    assert_includes errors["content"], "can't be blank"
  end

  test "should return 404 Not Found when idea is not existed (UPDATE)" do
    put :update, id: NON_EXISTED_ID
    assert_response :not_found
    assert_blank @response.body
  end

  test "should destroy existed idea" do
    assert_difference('Idea.count', -1) do
      delete :destroy, id: @idea1.id
    end
    assert_response :no_content
    assert_blank @response.body
    assert_equal false, Idea.exists?(@idea1.id), "idea should be deleted"
  end

  test "should return 204 No Content when idea is not existed" do
    delete :destroy, id: NON_EXISTED_ID
    assert_response :no_content
    assert_blank @response.body
  end

  test "should return 204 No Content and add one vote number when vote for idea" do
    assert_difference('Idea.find(@idea1.id).vote') do
      post :vote, id: @idea1
    end
    assert_response :no_content
  end

  test "should return 404 Not Found when idea is not existed (VOTE)" do
    post :vote, id: NON_EXISTED_ID
    assert_response :not_found
    assert_blank @response.body
  end

  test "should merge two ideas with given contents and sum up their votes" do
    merged_content = 'merged content'
    assert_difference('Idea.find(@idea2.id).vote', Idea.find(@idea1.id).vote) do
      post :merging, id:@idea2, content: merged_content, source: @idea1.id
    end
    assert_response :no_content
    assert_blank @response.body
    assert_equal merged_content, Idea.find(@idea2.id).content
    assert_equal false, Idea.exists?(@idea1.id)
  end

  test "should return 404 Not Found when target idea is not existed (MERGING)" do
    post :merging, id: NON_EXISTED_ID, content: 'merged content', source: @idea1.id
    assert_response :not_found
    assert_blank @response.body
  end

  test "should return 400 Bad Request when source idea is not existed (MERGING)" do
    post :merging, id: @idea2, content: 'merged content', source: NON_EXISTED_ID
    assert_response :bad_request
    errors = ActiveSupport::JSON.decode @response.body
    assert_includes errors["source"], "Source idea does not exist."
  end

  test "should update tags of an idea" do
    expected_tags = [@tag1, @tag2]
    put :tags, id: @idea2, tags: expected_tags.collect{|tag| tag.id}
    assert_response :no_content
    assert_blank @response.body
    actual_idea = Idea.find(@idea2.id)
    assert_equal expected_tags.count, actual_idea.tags.count
    expected_tags.sort_by{|tag| tag.name}.each_with_index {|expected_tag, index|
      assert_equal expected_tag.id, actual_idea.tags[index].id
    }
  end

  test "should return 404 Not Found when idea is not existed (UPDATE TAGS)" do
    put :tags, id: NON_EXISTED_ID, tags: []
    assert_response :not_found
    assert_blank @response.body
  end
end
