require 'test_helper'

class StaticPagesControllerTest < ActionDispatch::IntegrationTest

  def setup
    @base_title = I18n.t("brand")
    @user       = create(:user)
    @mission   = create(:mission)
    @company   = @mission.company
    @person    = @mission.person

    log_in_as(@user)
  end

  test "should get root" do
    get root_path
    assert_response :success
  end

  test "should get about" do
    get about_path
    assert_response :success
    assert_select "title", "#{I18n.t("about")} | #{@base_title }"
  end

  test "should get contact" do
    get contact_path
    assert_response :success
    assert_select "title", "#{I18n.t("contact")} | #{@base_title }"
  end

  test "should search and find people" do
    get search_path, params: {quest: @person.lastname}
    assert_response :success
    assert_select "div.person>a", @person.full_name
  end

  test "should search and find missions" do
    get search_path, params: {quest: @mission.name}
    assert_response :success
    assert_select "div.mission>strong>a", @mission.name
  end

  test "should search and find companies" do
    get search_path, params: {quest: @company.company_name}
    assert_response :success
    assert_select "div.company>a>span", @company.company_name
  end

  test "should not allow empty search" do
    get search_path, params: {quest: " "}
    assert_response :success
    # assert_select "span.badge" , { :count => 1, :text => '0' }
    assert_select "span.badge" do |c|
      assert_equal c.text,0
    end
  end

  # test "should not allow full empty search" do
  #   get search_path, params: {quest: ""}
  #   assert_response :success
  #   assert_select "span.badge" do |c|
  #     assert_equal c,0
  #   end
  # end


end
