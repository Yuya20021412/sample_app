require "test_helper"

class UsersEditTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
  end

  test "unsuccessful edit" do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), params: { user: { name:  "",
                                              email: "foo@invalid",
                                              password:              "foo",
                                              password_confirmation: "bar" } }

    assert_template 'users/edit'
    assert_select 'div.alert', 'The form contains 4 errors.'
  end

  test "successful edit with friendly forwarding" do
    get edit_user_path(@user)
    log_in_as(@user)
    assert_redirected_to edit_user_url(@user)
    name  = "Foo Bar"
    email = "foo@bar.com"
    patch user_path(@user), params: { user: { name:  name,
                                              email: email,
                                              password:              "",
                                              password_confirmation: "" } }
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal name,  @user.name
    assert_equal email, @user.email
  end


  #演習10.3
  # test "layout links without login" do
  #   get root_path
  #   assert_select "a[href=?]", root_path
  #   assert_select "a[href=?]", help_path
  #   assert_select "a[href=?]", about_path
  #   assert_select "a[href=?]", contact_path
  #   assert_select "a[href=?]", login_path
  #   assert_select "a[href=?]", users_path,            count: 0
  #   assert_select "a[href=?]", user_path(@user),      count: 0
  #   assert_select "a[href=?]", edit_user_path(@user), count: 0
  #   assert_select "a[href=?]", logout_path,           count: 0
  # end

  # test "layout links without login" do
  #   get root_path
  #   assert_select "a[href=?]", root_path
  #   assert_select "a[href=?]", help_path
  #   assert_select "a[href=?]", about_path
  #   assert_select "a[href=?]", contact_path
  #   assert_select "a[href=?]", login_path,            count: 0
  #   assert_select "a[href=?]", users_path,           
  #   assert_select "a[href=?]", user_path(@user),     
  #   assert_select "a[href=?]", edit_user_path(@user), 
  #   assert_select "a[href=?]", logout_path,           
  # end
end
