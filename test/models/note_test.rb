require 'test_helper'

class NoteTest < ActiveSupport::TestCase

  def setup
    @user = users(:michael)
    @note = @user.notes.build(
      title: "title for test",
      outline: "outline for test",
    )
  end

  test "should be valid" do
    assert @note.valid?
  end

  test "user id should be present" do
    @note.user_id = nil
    assert_not @note.valid?
  end

  test "title should be present" do
    @note.title = "    "
    assert_not @note.valid?
  end

  test "title should not be too long" do
    @note.title = "a" * 101
    assert_not @note.valid?
  end

  test "outline should not be too long" do
    @note.outline = "a" * 1001
    assert_not @note.valid?
  end

end
