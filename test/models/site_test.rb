require 'test_helper'

class SiteTest < ActiveSupport::TestCase

  def setup
    @site = Site.new()
  end

  test "should be valid" do
    assert @site.valid?
  end

  test "name should be present" do
    @site.name = "     "
    assert_not @site.valid?
  end

  test "mode should be present" do
    @site.mode = "     "
    assert_not @site.valid?
  end

end
