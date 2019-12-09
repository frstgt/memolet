require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest

  test "layout links" do
    skip "implement changed"
    get root_path
    assert_template 'notes/index'
    assert_select "a[href=?]", root_path, count: 1
  end

end
