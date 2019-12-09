require 'test_helper'

class NotesControllerTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
    @other_user = users(:archer)
    @site_user = users(:lana)
    @local_user = users(:malory)
  end

  test "should get index" do
    get notes_path
    assert_response :success
    assert_template 'notes/index'
    assert_select 'span.badge', "web"
    assert_no_match "site", response.body
    assert_no_match "local", response.body

    log_in_as(@user)
    get notes_path
    assert_response :success
    assert_template 'notes/index'
    assert_select 'span.badge', 'web'
    assert_select 'span.badge', 'site'
    assert_no_match "local", response.body
  end

  test "should get show" do




  end

end
