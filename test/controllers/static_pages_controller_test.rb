require 'test_helper'

class StaticPagesControllerTest < ActionDispatch::IntegrationTest

  def setup
    @base_title = "Memolet"
    @user = users(:michael)
  end

  test "should get home" do
    skip "implement is changed"
    get root_path
    assert_response :success
    assert_select "title", "#{@base_title}"
  end

end
