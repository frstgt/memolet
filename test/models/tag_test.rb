require 'test_helper'

class TagTest < ActiveSupport::TestCase

  def setup
    @tag = Tag.new(name: "test_tag")
  end

  test "should be valid" do
    assert @tag.valid?
  end

  test "name should be present" do
    @tag.name = "     "
    assert_not @tag.valid?
  end

  test "name should not be too long" do
    @tag.name = "a" * 101
    assert_not @tag.valid?
  end

  test "name should be unique" do
    duplicate_tag = @tag.dup
    @tag.save
    assert_not duplicate_tag.valid?
  end

  test "name shoud not be able to include & | ! ()" do
    skip "SearchParse is working with REGEX but Tag is not working with same one"
    @tag.name = "test&test"
    assert_not @tag.valid?
    @tag.name = "test|test"
    assert_not @tag.valid?
    @tag.name = "test!test"
    assert_not @tag.valid?
    @tag.name = "test(test"
    assert_not @tag.valid?
    @tag.name = "test)test"
    assert_not @tag.valid?
  end

  test "name shoud be able to include - _" do
    @tag.name = "test-test"
    assert @tag.valid?
    @tag.name = "test_test"
    assert @tag.valid?
  end

end
