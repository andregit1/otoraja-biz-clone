require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "Should not save user with the same email" do
    user_one = User.new(user_id: "test@test.com", uid: "test@test.com", name: "test", role: :owner, password: "123456", status: "enabled")
    user_one.save!
    user_two = User.new(user_id: "test@test.com", uid: "test@test.com", name: "test", role: :owner, password: "123456", status: "enabled")
    assert_not user_two.save
  end

  test "Should found user by user_id" do
    User.create!(
      user_id: "test@test.com", 
      uid: "test@test.com", 
      name: "test", 
      role: :owner, 
      password: "123456", 
      status: "enabled"
    )
    params = {:user_id=>"test@test.com"}
    user_test = User.search_by_userid_or_email(params[:user_id])
    assert_not_nil user_test, "User found with the user_id"
  end

  test "Should found users with non staff or staff role" do
    users = [
      {
        user_id: "test@test.com", 
        uid: "test@test.com", 
        name: "test", 
        role: :owner, 
        password: "123456", 
        status: "enabled"
      },
      {
        user_id: "test2@test.com", 
        uid: "test2@test.com", 
        name: "test2", 
        role: :staff, 
        password: "123456", 
        status: "enabled"
      }
    ]
    User.create(users)
    param_staff = {:user_id=>"test2@test.com"}
    param_non_staff = {:user_id=>"test@test.com"}

    user_test = User.search_by_userid_or_email(param_staff[:user_id])
    assert user_test.staff?, "This User must be a staff"

    user_test = User.search_by_userid_or_email(param_non_staff[:user_id])
    assert_not user_test.staff?, "This User must be non staff"
  end
end
