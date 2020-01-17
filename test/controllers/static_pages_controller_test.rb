require 'test_helper'

class StaticPagesControllerTest < ActionDispatch::IntegrationTest

  def setup
    @base_title = "Memolet"
    @user = users(:michael)
  end

  test "should get notes#index as home" do
    get root_path
    assert_response :success
    assert_template 'notes/index'
    assert_select "title", "Notes | #{@base_title}"
  end

end
