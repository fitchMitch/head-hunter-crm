require 'test_helper'

class CompaniesControllerTest < ActionDispatch::IntegrationTest
  def setup
    @company = create(:company)
    @user = create(:user)
  end

  test "should get edit" do
    log_in_as(@user)
    get edit_company_path(@company)
    assert_response :success
  end

  test "should redirect home when disconnected" do
    get edit_company_path(@company)
    assert_redirected_to login_url
  end

  test "should get new" do
    log_in_as(@user)
    get new_company_path
    assert_response :success
  end

  test "should get show" do
    log_in_as(@user)
    get company_path(@company.id)
    assert_response :success
  end

  test "should redirect update" do
    log_in_as(@user)
    patch company_path(@company), params: { company: { company_name: @company.company_name } }
    refute flash[:success].empty?
    assert_redirected_to companies_url
  end

  test "should edit when wrong update" do
    log_in_as(@user)
    patch company_path(@company), params: { company: { company_name:""} }
    refute flash[:danger].empty?
    assert_template 'companies/edit'
  end

  test "should list people from a company" do
    log_in_as(@user)
    get list_people_company_path(@company.id)
    assert_response :success
    assert_template 'companies/company_people'
  end

  test "Should get properly sorted list" do
    log_in_as(@user)
    company = Company.order('company_name DESC').first
    get companies_path, params: { sort: '-updated_at' }
    assert_response :success
  end

  test "should NOT create company" do
    get new_company_path
    @some_params = {
        'company' => {
          'name' => 'ACME'
        }
    }
    post companies_url,params: @some_params
    assert_response :success
    assert_template "companies/new"
  end

  test "should create company" do
    n = Company.all.count
    get new_company_path
    @some_params = {
        'company' => {
          'company_name' => 'ACME'
        }
    }
    post companies_url,params: @some_params
    assert_redirected_to companies_url
    follow_redirect!
    assert_equal n+1, Company.all.count
  end

  # test "should redirect destroy" do
  #   log_in_as(@user)
  #   assert_difference 'Company.count', -1 do
  #     delete company_path(@company)
  #   end
  #   assert_redirected_to companies_path
  # end
end
