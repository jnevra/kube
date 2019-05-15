require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
  @user = User.new(name: "edi nababan", email: "sakalamook@yahoo.com",
    password: "manson115", password_confirmation: "manson115")
    end
  ...
    test "associated microposts should be destroyed" do
      @user.save
      @user.microposts.create!(content: "Lorem ipsum")
      assert_difference 'Micropost.count', -1 do
        @user.destroy
      end
  end
end
