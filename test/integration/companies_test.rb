require 'test_helper'

class CompaniesTest < ActionDispatch::IntegrationTest
  def setup
    @company = create(:company)
    @user=  create(:user)
    log_in_as(@user)
  end

  test "should get new on saving error" do
    get new_company_path
    assert_template 'companies/new'
    company2 = attributes_for(:company, company_name: '')
    post companies_path, params: {company: company2}
    assert_template 'companies/new'
  end

  test "should land on show when saving" do
    company2 = attributes_for(:company)
    get new_company_path
    post companies_path, params: { company: company2}
    follow_redirect!
    assert_response :success
    assert_match /Société sauvegardée/, flash[:info]
  end
  #
  # test "companies should get destroyed" do
  #   get companies_path
  #   assert_response :success
  #   assert_template 'companies/index'
  #   first_page_of_companies = company.paginate(page: 1)
  #   @company=first_page_of_companies.first
  #   puts "just some indications"
  #   first_page_of_companies.each do |per|
  #     assert_select 'a[href=?]', company_path(per)
  #   end
  #   assert_difference 'company.count', -1 do
  #     delete company_path(@company)
  #   end
  # end
  #
  test "there's an access to companies's detail page" do
    get companies_path
    Company.paginate(page: 1).each do |com|
      assert_select 'a[href=?]', company_path(com)
      assert_select 'a[href=?]', edit_company_path(com)
    end
  end
  #
  # test "dependent resources shoud be destroyed when companies are" do
  #   @job = create(:job)
  #   @company = @job.company
  #   assert_difference 'Job.count', -1 do
  #     delete company_path(@company)
  #   end
  # end
end
