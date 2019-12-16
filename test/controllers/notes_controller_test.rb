require 'test_helper'

class NotesControllerTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
    @other_user = users(:archer)
    @site_user = users(:lana)
    @local_user = users(:malory)

    @web_note = notes(:michael_note1)
    @site_note = notes(:michael_note2)
    @local_note = notes(:michael_note3)
  end

  test "should get index" do
    get notes_path
    assert_response :success
    assert_template 'notes/index'
    assert_select 'span.badge', "web"
    assert_no_match "site", response.body
    assert_no_match "local", response.body
    assert_match "dummy ad code", response.body

    log_in_as(@user)
    get notes_path
    assert_response :success
    assert_template 'notes/index'
    assert_select 'span.badge', 'web'
    assert_select 'span.badge', 'site'
    assert_no_match "local", response.body
    assert_no_match "dummy ad code", response.body
  end

  test "should get show" do
    get note_path(@local_note)
    assert_redirected_to root_url
    get note_path(@site_note)
    assert_redirected_to root_url
    get note_path(@web_note)
    assert_response :success
    assert_template 'notes/show'
    assert_select 'span.badge', 'web'
    assert_match "dummy ad code", response.body

    log_in_as(@other_user)
    get note_path(@local_note)
    assert_redirected_to root_url

    get note_path(@site_note)
    assert_response :success
    assert_template 'notes/show'
    assert_select 'span.badge', 'site'
    assert_no_match "dummy ad code", response.body

    get note_path(@web_note)
    assert_response :success
    assert_template 'notes/show'
    assert_select 'span.badge', 'web'
    assert_no_match "dummy ad code", response.body

    log_in_as(@user)
    get note_path(@local_note)
    assert_response :success
    assert_template 'notes/show'
    assert_select 'span.badge', 'local'
    assert_no_match "dummy ad code", response.body

    get note_path(@site_note)
    assert_response :success
    assert_template 'notes/show'
    assert_select 'span.badge', 'site'
    assert_no_match "dummy ad code", response.body

    get note_path(@web_note)
    assert_response :success
    assert_template 'notes/show'
    assert_select 'span.badge', 'web'
    assert_no_match "dummy ad code", response.body
  end

  test "should get new/create" do
    get new_note_path
    assert_redirected_to login_url

    log_in_as(@user)
    get new_note_path
    assert_response :success
    assert_template 'notes/new'

    assert_difference '@user.notes.count', 1 do
      post notes_path,
            params: { note: {title: "Test Note", outline: "This is a test.",
                      user_id: @user.id} }
    end
    assert_redirected_to @user
  end

  test "should get edit/update" do
    get edit_note_path(@web_note)
    assert_redirected_to login_url
    patch note_path(@web_note), params: { note: { title: @web_note.title, outline: "This is a edit test." } }
    assert_redirected_to login_url

    log_in_as(@other_user)
    get edit_note_path(@site_note)
    assert_redirected_to root_url
    patch note_path(@site_note), params: { note: { title: @site_note.title, outline: "This is a edit test." } }
    assert_redirected_to root_url

    log_in_as(@user)
    get edit_note_path(@local_note)
    assert_response :success
    assert_template 'notes/edit'
    patch note_path(@local_note), params: { note: { title: @local_note.title, outline: "This is a edit test." } }
    assert_redirected_to @local_note
  end

  test "should get delete" do
    assert_difference '@user.notes.count', 0 do
      delete note_path(@web_note)
    end
    assert_redirected_to login_url

    log_in_as(@other_user)
    assert_difference '@user.notes.count', 0 do
      delete note_path(@site_note)
    end
    assert_redirected_to root_path

    log_in_as(@user)
    assert_difference '@user.notes.count', -1 do
      delete note_path(@local_note)
    end
    assert_redirected_to @user
  end

end
