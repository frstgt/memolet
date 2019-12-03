require 'test_helper'

class MemoTest < ActiveSupport::TestCase

  def setup
    @note = notes(:michael_note)
    @memo = @note.memos.build(
      content: "content for test",
      number: 1
    )
  end

  test "should be valid" do
    assert @note.valid?
  end

  test "note id should be present" do
    @memo.note_id = nil
    assert_not @memo.valid?
  end

  test "content should not be too long" do
    @memo.content = "a" * 4001
    assert_not @memo.valid?
  end

  test "number should be present" do
    @memo.number = nil
    assert_not @memo.valid?
  end

end
