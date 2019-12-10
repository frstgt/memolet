require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  test "full title helper" do
    assert_equal full_title,         app_name
    assert_equal full_title("Help"), "Help | #{app_name}"
  end
end