# == Schema Information
#
# Table name: companies
#
#  id           :integer          not null, primary key
#  company_name :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

require 'test_helper'

class CompanyTest < ActiveSupport::TestCase

  def setup
    @company = build(:company)
  end

  test "company should be valid" do
    assert @company.valid?
  end

  test "company_name should be present" do
    @company.company_name = "     "
    refute @company.valid?
  end

  test "company_name should be present - 2 " do
    @company.company_name = ""
    refute @company.valid?
  end

  test "company_name should not be too long" do
    @company.company_name = "a"* 41
    refute @company.valid?
  end

  test "company_name should be unique" do
    @company2 = create(:company)
    @company.company_name = @company2.company_name
    refute @company.valid?
  end
end
