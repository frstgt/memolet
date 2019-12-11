require 'test_helper'

class MemosControllerTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
    @other_user = users(:archer)
    @site_user = users(:lana)
    @local_user = users(:malory)

    @web_note = notes(:michael_note1)
    @site_note = notes(:michael_note2)
    @local_note = notes(:michael_note3)

    @web_memo = memos(:michael_note1_memo1)
    @site_memo = memos(:michael_note2_memo1)
    @local_memo = memos(:michael_note3_memo1)
  end

  test "should get new/create" do
    get new_note_memo_path(@web_note)
    assert_redirected_to login_url

    log_in_as(@other_user)
    get new_note_memo_path(@site_note)
    assert_redirected_to root_url

    log_in_as(@user)
    get new_note_memo_path(@local_note)
    assert_response :success
    assert_template 'memos/new'

    assert_difference '@local_note.memos.count', 1 do
      post note_memos_path(@local_note),
            params: { memo: {content: "Test Memo", number: 1,
                              note_id: @local_note.id} }
    end
    assert_redirected_to @local_note
  end

  test "should get edit/update" do
    get edit_note_memo_path(@web_note, @web_memo)
    assert_redirected_to login_url
    patch note_memo_path(@web_note, @web_memo), params: { memo: { content: "This is a edit test.", number: 1 } }
    assert_redirected_to login_url

    log_in_as(@other_user)
    get edit_note_memo_path(@site_note, @site_memo)
    assert_redirected_to root_url
    patch note_memo_path(@site_note, @site_memo), params: { memo: { content: "This is a edit test.", number: 1 } }
    assert_redirected_to root_url

    log_in_as(@user)
    get edit_note_memo_path(@local_note, @local_memo)
    assert_response :success
    assert_template 'memos/edit'
    patch note_memo_path(@local_note, @local_memo), params: { memo: { content: "This is a edit test.", number: 1 } }
    assert_redirected_to @local_note
  end

  test "should get delete" do
    assert_difference '@web_note.memos.count', 0 do
      delete note_memo_path(@web_note, @web_memo)
    end
    assert_redirected_to login_url

    log_in_as(@other_user)
    assert_difference '@site_note.memos.count', 0 do
      delete note_memo_path(@site_note, @site_memo)
    end
    assert_redirected_to root_path

    log_in_as(@user)
    assert_difference '@local_note.memos.count', -1 do
      delete note_memo_path(@local_note, @local_memo)
    end
    assert_redirected_to @local_note
  end

end
