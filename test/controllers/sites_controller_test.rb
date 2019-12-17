require 'test_helper'

class SitesControllerTest < ActionDispatch::IntegrationTest
  
  def setup
    @admin = users(:michael)
    @other_user = users(:archer)
    @site = sites(:site0)
  end

  test "should get edit/update" do
    get edit_site_path(@site)
    assert_redirected_to login_url
    patch site_path(@site), params: { site: { name: @site.name, mode: 0 } }
    assert_redirected_to login_url

    log_in_as(@other_user)
    get edit_site_path(@site)
    assert_redirected_to root_url
    patch site_path(@site), params: { site: { name: @site.name, mode: 0 } }
    assert_redirected_to root_url

    log_in_as(@admin)
    get edit_site_path(@site)
    assert_response :success
    assert_template 'sites/edit'
    patch site_path(@site), params: { site: { name: @site.name, mode: 0 } }
    assert_redirected_to root_url
  end

end