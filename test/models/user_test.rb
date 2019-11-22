require 'test_helper'

class UserTest < ActiveSupport::TestCase

  def setup
    @user = User.new(name: "Example User",
                     password: "z8aKm$@3rTEp#+2s", password_confirmation: "z8aKm$@3rTEp#+2s")
  end

  test "should be valid" do
    assert @user.valid?
  end

  test "name should be present" do
    @user.name = "     "
    assert_not @user.valid?
  end

  test "name should not be too long" do
    @user.name = "a" * 65
    assert_not @user.valid?
  end

  test "name should not be too short" do
    @user.name = "a" * 7
    assert_not @user.valid?
  end

  test "name should be unique" do
    duplicate_user = @user.dup
    @user.save
    assert_not duplicate_user.valid?
  end

  test "password should be present (nonblank)" do
    @user.password = @user.password_confirmation = " " * 6
    assert_not @user.valid?
  end

  test "password should satisfy some requirements" do
    password = "z8aKm$@3rTEp#+2s" # valid password
    @user.password = @user.password_confirmation = password
    assert @user.valid?

    password = "z8aKm$@3rTEp#+2" # 15chars
    @user.password = @user.password_confirmation = password
    assert_not @user.valid?

    password = "z8aKm$@3rTEp#+2s" * 4 + "E" # 65chars
    @user.password = @user.password_confirmation = password
    assert_not @user.valid?

    password = "z8akm$@3rtep#+2s" # no uppercase
    @user.password = @user.password_confirmation = password
    assert_not @user.valid?
    password = "z8akm$@3rTep#+2s" # one uppercase
    @user.password = @user.password_confirmation = password
    assert_not @user.valid?
    password = "z8aKm$@3rTep#+2s" # two uppercase
    @user.password = @user.password_confirmation = password
    assert_not @user.valid?

    password = "Z8AKM$@3RTEP#+2S" # no lowercase
    @user.password = @user.password_confirmation = password
    assert_not @user.valid?
    password = "Z8AKm$@3RTEP#+2S" # one lowercase
    @user.password = @user.password_confirmation = password
    assert_not @user.valid?
    password = "z8AKm$@3RTEP#+2S" # two lowercase
    @user.password = @user.password_confirmation = password
    assert_not @user.valid?

    password = "zEaKm$@TrTEp#+bs" # no number
    @user.password = @user.password_confirmation = password
    assert_not @user.valid?
    password = "zEaKm$@3rTEp#+bs" # one number
    @user.password = @user.password_confirmation = password
    assert_not @user.valid?
    password = "z8aKm$@3rTEp#+bs" # two number
    @user.password = @user.password_confirmation = password
    assert_not @user.valid?

    password = "z8aKmDA3rTEpSP2s" # no special character
    @user.password = @user.password_confirmation = password
    assert_not @user.valid?
    password = "z8aKmDA3rTEp#P2s" # one special character
    @user.password = @user.password_confirmation = password
    assert_not @user.valid?
    password = "z8aKmD@3rTEp#P2s" # two special character
    @user.password = @user.password_confirmation = password
    assert_not @user.valid?
  end

end
