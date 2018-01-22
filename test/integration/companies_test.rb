require 'test_helper'

class CompaniesTest < ActionDispatch::IntegrationTest
  def setup
    @company = create(:company)
    @user= create(:user)
    log_in_as(@user)
  end

  test 'should get new on saving error' do
    get new_company_path
    assert_template 'companies/new'
    company2 = attributes_for(:company, company_name: '')
    post companies_path, params: { company: company2 }
    assert_template 'companies/new'
  end

  test 'should land on show when saving' do
    company2 = attributes_for(:company)
    get new_company_path
    post companies_path, params: { company: company2 }
    follow_redirect!
    assert_response :success
    assert_match /Société sauvegardée/, flash[:info]
  end

  test 'there\'s an access to companies\'s detail page' do
    get companies_path
    Company.all.each do |com|
      # assert_select 'a[href=?]', list_people_path(com)
      assert_select 'a[href=?]', edit_company_path(com)
    end
  end
end
