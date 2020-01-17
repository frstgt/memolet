require 'test_helper'

class UsersShowTest < ActionDispatch::IntegrationTest

  def setup
    @admin     = users(:michael)
    @non_admin1 = users(:archer)
    @non_admin2 = users(:lana)
  end

  test "users#show as admin including delete links" do
    log_in_as(@admin)
    get user_path(@non_admin1)
    assert_template 'users/show'
    assert_select 'a[href=?]', user_path(@non_admin1), text: '[delete]'
    assert_difference 'User.count', -1 do
      delete user_path(@non_admin1)
    end
  end

  test "users#show as non-admin" do
    log_in_as(@non_admin1)
    get user_path(@non_admin2)
    assert_select 'a', text: '[delete]', count: 0
  end

end
