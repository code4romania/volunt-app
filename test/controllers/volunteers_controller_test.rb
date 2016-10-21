require 'test_helper'

class VolunteersControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get volunteers_index_url
    assert_response :success
  end

  test "should get show" do
    get volunteers_show_url
    assert_response :success
  end

  test "should get search" do
    get volunteers_search_url
    assert_response :success
  end

end
