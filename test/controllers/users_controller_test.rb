require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
    @other_user = users(:archer)
    @site_user = users(:lana)
    @local_user = users(:malory)
  end

  test "should get index" do
    get users_path
    assert_response :success
    assert_template 'users/index'
    assert_select 'span.badge', "web"
    assert_no_match "site", response.body
    assert_no_match "local", response.body

    log_in_as(@user)
    get users_path
    assert_response :success
    assert_template 'users/index'
    assert_select 'span.badge', 'web'
    assert_select 'span.badge', 'site'
    assert_no_match "local", response.body
  end

  test "should get show" do
    get user_path(@local_user)
    assert_redirected_to root_url

    get user_path(@site_user)
    assert_redirected_to root_url

    get user_path(@user)
    assert_response :success
    assert_template 'users/show'
    assert_select 'span.badge', "web"
    assert_no_match "site", response.body
    assert_no_match "local", response.body

    log_in_as(@other_user)
    get user_path(@local_user)
    assert_redirected_to root_url

    get user_path(@site_user)
    assert_response :success
    assert_template 'users/show'
    assert_select 'span.badge', "web"
    assert_select 'span.badge', 'site'
    assert_no_match "local", response.body
  
    get user_path(@user)
    assert_response :success
    assert_template 'users/show'
    assert_select 'span.badge', 'web'
    assert_select 'span.badge', 'site'
    assert_no_match "local", response.body

    log_in_as(@user)
    get user_path(@user)
    assert_response :success
    assert_template 'users/show'
    assert_select 'span.badge', 'web'
    assert_select 'span.badge', 'site'
    assert_select 'span.badge', 'local'
  end

  test "should get new" do
    get signup_path
    assert_response :success
  end

  test "should redirect edit when not logged in" do
    get edit_user_path(@user)
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect update when not logged in" do
    patch user_path(@user), params: { user: { name: @user.name } }
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect edit when logged in as wrong user" do
    log_in_as(@other_user)
    get edit_user_path(@user)
    assert flash.empty?
    assert_redirected_to root_url
  end

  test "should redirect update when logged in as wrong user" do
    log_in_as(@other_user)
    patch user_path(@user), params: { user: { name: @user.name } }
    assert flash.empty?
    assert_redirected_to root_url
  end

  test "should not allow the admin attribute to be edited via the web" do
    log_in_as(@other_user)
    assert_not @other_user.admin?
    patch user_path(@other_user), params: {
                                    user: { password:              '',
                                            password_confirmation: '',
                                            admin: true } }
    assert_not @other_user.reload.admin?
  end

  test "should redirect destroy when not logged in" do
    assert_no_difference 'User.count' do
      delete user_path(@user)
    end
    assert_redirected_to login_url
  end

  test "should redirect destroy when logged in as a non-admin" do
    log_in_as(@other_user)
    assert_no_difference 'User.count' do
      delete user_path(@user)
    end
    assert_redirected_to root_url
  end

end
