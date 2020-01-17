require 'test_helper'

class TagsSearchTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)

    @note1 = @user.notes.create(
      title: "test note1 with tag1 and tag2",
      outline: "test note1 outline",
      mode: Note::MODE_WEB,
    )
    @note2 = @user.notes.create(
      title: "test note2 with tag2 and tag3",
      outline: "test note2 outline",
      mode: Note::MODE_WEB,
    )
    @note3 = @user.notes.create(
      title: "test note3 with tag3 and tag4",
      outline: "test note3 outline",
      mode: Note::MODE_WEB,
    )
    @note4 = @user.notes.create(
      title: "test note4 with tag4 and tag1",
      outline: "test note4 outline",
      mode: Note::MODE_WEB,
    )
    
    @note1.add_tag("test_tag1")
    @note1.add_tag("test_tag2")
    @note2.add_tag("test_tag2")
    @note2.add_tag("test_tag3")
    @note3.add_tag("test_tag3")
    @note3.add_tag("test_tag4")
    @note4.add_tag("test_tag4")
    @note4.add_tag("test_tag1")
  end

  test "search test @notes#index" do
    get notes_path
    assert_response :success
    assert_template 'notes/index'
    assert_select "a[href=?]", notes_path(search: "test_tag1"), count: 3
    assert_select "a[href=?]", notes_path(search: "test_tag2"), count: 3
    assert_select "a[href=?]", notes_path(search: "test_tag3"), count: 3
    assert_select "a[href=?]", notes_path(search: "test_tag4"), count: 3

    # search test

    get notes_path(search: "test_tag1")
    assert_response :success
    assert_template 'notes/index'
    assert_select "a[href=?]", notes_path(search: "test_tag1"), count: 3
    assert_select "a[href=?]", notes_path(search: "test_tag2"), count: 2
    assert_select "a[href=?]", notes_path(search: "test_tag3"), count: 1
    assert_select "a[href=?]", notes_path(search: "test_tag4"), count: 2

    get notes_path(search: "test_tag2")
    assert_response :success
    assert_template 'notes/index'
    assert_select "a[href=?]", notes_path(search: "test_tag1"), count: 2
    assert_select "a[href=?]", notes_path(search: "test_tag2"), count: 3
    assert_select "a[href=?]", notes_path(search: "test_tag3"), count: 2
    assert_select "a[href=?]", notes_path(search: "test_tag4"), count: 1

    get notes_path(search: "test_tag3")
    assert_response :success
    assert_template 'notes/index'
    assert_select "a[href=?]", notes_path(search: "test_tag1"), count: 1
    assert_select "a[href=?]", notes_path(search: "test_tag2"), count: 2
    assert_select "a[href=?]", notes_path(search: "test_tag3"), count: 3
    assert_select "a[href=?]", notes_path(search: "test_tag4"), count: 2

    get notes_path(search: "test_tag4")
    assert_response :success
    assert_template 'notes/index'
    assert_select "a[href=?]", notes_path(search: "test_tag1"), count: 2
    assert_select "a[href=?]", notes_path(search: "test_tag2"), count: 1
    assert_select "a[href=?]", notes_path(search: "test_tag3"), count: 2
    assert_select "a[href=?]", notes_path(search: "test_tag4"), count: 3

    # and test

    get notes_path(search: "test_tag1 & test_tag2")
    assert_response :success
    assert_template 'notes/index'
    assert_select "a[href=?]", notes_path(search: "test_tag1"), count: 2
    assert_select "a[href=?]", notes_path(search: "test_tag2"), count: 2
    assert_select "a[href=?]", notes_path(search: "test_tag3"), count: 1
    assert_select "a[href=?]", notes_path(search: "test_tag4"), count: 1

    get notes_path(search: "test_tag2 & test_tag3")
    assert_response :success
    assert_template 'notes/index'
    assert_select "a[href=?]", notes_path(search: "test_tag1"), count: 1
    assert_select "a[href=?]", notes_path(search: "test_tag2"), count: 2
    assert_select "a[href=?]", notes_path(search: "test_tag3"), count: 2
    assert_select "a[href=?]", notes_path(search: "test_tag4"), count: 1

    get notes_path(search: "test_tag3 & test_tag4")
    assert_response :success
    assert_template 'notes/index'
    assert_select "a[href=?]", notes_path(search: "test_tag1"), count: 1
    assert_select "a[href=?]", notes_path(search: "test_tag2"), count: 1
    assert_select "a[href=?]", notes_path(search: "test_tag3"), count: 2
    assert_select "a[href=?]", notes_path(search: "test_tag4"), count: 2

    get notes_path(search: "test_tag4 & test_tag1")
    assert_response :success
    assert_template 'notes/index'
    assert_select "a[href=?]", notes_path(search: "test_tag1"), count: 2
    assert_select "a[href=?]", notes_path(search: "test_tag2"), count: 1
    assert_select "a[href=?]", notes_path(search: "test_tag3"), count: 1
    assert_select "a[href=?]", notes_path(search: "test_tag4"), count: 2

    # or test

    get notes_path(search: "test_tag1 | test_tag2")
    assert_response :success
    assert_template 'notes/index'
    assert_select "a[href=?]", notes_path(search: "test_tag1"), count: 3
    assert_select "a[href=?]", notes_path(search: "test_tag2"), count: 3
    assert_select "a[href=?]", notes_path(search: "test_tag3"), count: 2
    assert_select "a[href=?]", notes_path(search: "test_tag4"), count: 2

    get notes_path(search: "test_tag2 | test_tag3")
    assert_response :success
    assert_template 'notes/index'
    assert_select "a[href=?]", notes_path(search: "test_tag1"), count: 2
    assert_select "a[href=?]", notes_path(search: "test_tag2"), count: 3
    assert_select "a[href=?]", notes_path(search: "test_tag3"), count: 3
    assert_select "a[href=?]", notes_path(search: "test_tag4"), count: 2

    get notes_path(search: "test_tag3 | test_tag4")
    assert_response :success
    assert_template 'notes/index'
    assert_select "a[href=?]", notes_path(search: "test_tag1"), count: 2
    assert_select "a[href=?]", notes_path(search: "test_tag2"), count: 2
    assert_select "a[href=?]", notes_path(search: "test_tag3"), count: 3
    assert_select "a[href=?]", notes_path(search: "test_tag4"), count: 3

    get notes_path(search: "test_tag4 | test_tag1")
    assert_response :success
    assert_template 'notes/index'
    assert_select "a[href=?]", notes_path(search: "test_tag1"), count: 3
    assert_select "a[href=?]", notes_path(search: "test_tag2"), count: 2
    assert_select "a[href=?]", notes_path(search: "test_tag3"), count: 2
    assert_select "a[href=?]", notes_path(search: "test_tag4"), count: 3
    
    # not test

    get notes_path(search: "! test_tag1")
    assert_response :success
    assert_template 'notes/index'
    assert_select "a[href=?]", notes_path(search: "test_tag1"), count: 1
    assert_select "a[href=?]", notes_path(search: "test_tag2"), count: 2
    assert_select "a[href=?]", notes_path(search: "test_tag3"), count: 3
    assert_select "a[href=?]", notes_path(search: "test_tag4"), count: 2

    get notes_path(search: "! test_tag2")
    assert_response :success
    assert_template 'notes/index'
    assert_select "a[href=?]", notes_path(search: "test_tag1"), count: 2
    assert_select "a[href=?]", notes_path(search: "test_tag2"), count: 1
    assert_select "a[href=?]", notes_path(search: "test_tag3"), count: 2
    assert_select "a[href=?]", notes_path(search: "test_tag4"), count: 3

    get notes_path(search: "! test_tag3")
    assert_response :success
    assert_template 'notes/index'
    assert_select "a[href=?]", notes_path(search: "test_tag1"), count: 3
    assert_select "a[href=?]", notes_path(search: "test_tag2"), count: 2
    assert_select "a[href=?]", notes_path(search: "test_tag3"), count: 1
    assert_select "a[href=?]", notes_path(search: "test_tag4"), count: 2

    get notes_path(search: "! test_tag4")
    assert_response :success
    assert_template 'notes/index'
    assert_select "a[href=?]", notes_path(search: "test_tag1"), count: 2
    assert_select "a[href=?]", notes_path(search: "test_tag2"), count: 3
    assert_select "a[href=?]", notes_path(search: "test_tag3"), count: 2
    assert_select "a[href=?]", notes_path(search: "test_tag4"), count: 1
  end

end
