# == Schema Information
#
# Table name: people
#
#  id                   :integer          not null, primary key
#  firstname            :string
#  lastname             :string
#  email                :string
#  phone_number         :string
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  is_jj_hired          :boolean
#  is_client            :boolean
#  note                 :text
#  user_id              :integer
#  cv_docx_file_name    :string
#  cv_docx_content_type :string
#  cv_docx_file_size    :integer
#  cv_docx_updated_at   :datetime
#  approx_age           :integer
#  cv_content           :text
#

require 'test_helper'

class PersonTest < ActiveSupport::TestCase
  def setup
    @person = build(:person)
  end

  test 'should be valid' do
    assert @person.valid?
  end

  test 'should lastname exist' do
    @person.lastname=''
    refute @person.valid?
  end

  test "email validation should accept valid addresses" do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
      @person.email = valid_address
      assert @person.valid?, "#{valid_address.inspect } should be valid"
    end
  end

  test 'phone_number should be long enough' do
    @person.phone_number='a'* 9
    refute @person.valid?
  end

  test 'phone_number should not be too long ' do
    @person.phone_number='a'* 19
    refute @person.valid?
  end
end
