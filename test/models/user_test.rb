# == Schema Information
#
# Table name: users
#
#  id                :integer          not null, primary key
#  name              :string
#  email             :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  password_digest   :string
#  remember_digest   :string
#  admin             :boolean          default(FALSE)
#  activation_digest :string
#  activated         :boolean          default(FALSE)
#  activated_at      :datetime
#  reset_digest      :string
#  reset_sent_at     :datetime
#
require 'test_helper'

class UserTest < ActiveSupport::TestCase

  def setup
    @user = create(:user)
  end

  test 'should be valid' do
    assert @user.valid?
  end

  test "name should be present" do
    @user.name = "     "
    refute @user.valid?
  end

  test "email should be present" do
    @user.email = "     "
    refute @user.valid?
  end

  test "name should not be too long" do
    @user.name = "a" * 51
    refute @user.valid?
  end

  test "email should not be too long" do
    @user.email = "a" * 244 + "@example.com"
    refute @user.valid?
  end

  test "email validation should accept valid addresses" do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?, "#{valid_address.inspect} should be valid"
    end
  end

  test "email addresses should be unique" do
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase
    @user.save
    refute duplicate_user.valid?
  end

  test "email addresses should be saved as lower-case" do
    mixed_case_email = "Foo@ExAMPle.CoM"
    @user.email = mixed_case_email
    @user.save
    assert_equal mixed_case_email.downcase, @user.reload.email
  end

  test "password should be present (nonblank)" do
    @user.password = @user.password_confirmation = " " * 6
    refute @user.valid?
  end

  test "password should have a minimum length" do
    @user.password = @user.password_confirmation = "a" * 5
    refute @user.valid?
  end

  test "authenticated? should return false for a user with nil digest" do
    refute @user.authenticated?(:remember, '')
  end

  test "trigram ok" do
    @user.name = "Patrick Person"
    assert_equal @user.trigram,"PPE", "trigram OK for real"
  end

end
