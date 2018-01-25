require 'test_helper'
require 'fileutils'

class PeopleTest < ActionDispatch::IntegrationTest
  def setup
    @person = create(:person_with_cv)
    @user = @person.user
    @admin = create(:admin)
  end

  test 'should get new on saving error' do
    log_in_as(@user)
    get new_person_path
    assert_template 'people/new'
    person2 = attributes_for(:person, lastname: '')
    post people_path, params: { person: person2 }
    assert_template 'people/new'
  end

  test 'should land on show when saving' do
    log_in_as(@user)
    person2 = attributes_for(:person)
    get new_person_path
    post people_path, params: { person: person2 }
    follow_redirect!
    assert_response :success
    assert_match /Contact sauvegardé/, flash[:success]
  end

  test 'as simple user, people should get destroyed' do
    log_in_as(@user)
    get people_path
    assert_response :success
    assert_template 'people/index'
    first_page_of_people = Person.paginate(page: 1)
    @person=first_page_of_people.first
    first_page_of_people.each do |per|
      assert_select 'a[href=?]', person_path(per)
    end
    assert_no_difference 'Person.count' do
      delete person_path(@person)
    end
  end

  test 'as admin, people should get destroyed' do
    log_in_as(@admin)
    get people_path
    assert_response :success
    assert_template 'people/index'
    first_page_of_people = Person.paginate(page: 1)
    @person=first_page_of_people.first
    first_page_of_people.each do |per|
      assert_select 'a[href=?]', person_path(per)
    end
    assert_difference 'Person.count', -1 do
      delete person_path(@person)
    end
  end

  test 'as admin, there\'s an access to people\'s detail page' do
    log_in_as(@admin)
    get people_path
    Person.paginate(page: 1).each do |per|
      assert_select 'a[href=?]', person_path(per)
      assert_select 'a[href=?]', edit_person_path(per)
    end
  end

  test 'as user, there aint no access to people\'s detail page' do
    log_in_as(@user)
    get people_path
    Person.paginate(page: 1).each do |per|
      assert_select 'a[href=?]', person_path(per)
      assert_select 'a[href=?]', edit_person_path(per) , count: 0 unless per.user_id = @user.id
    end
  end

  test 'dependent resources shoud be destroyed when people are' do
    log_in_as(@admin)
    @job = create(:job)
    person = @job.person
    @job.save!
    assert_difference 'Job.count', -1 do
      delete person_path(person)
    end
  end

  test 'dependent docx resources shoud be destroyed when people are' do
    log_in_as(@admin)
    get people_path
    file_path  = @person.cv_docx.url.split(/\?/).first
    refute File.exists?(file_path) do
      delete person_path(@person)
    end
  end

  test 'policy test on destroyed resources' do
    @user2 = create(:user2)
    log_in_as(@user2)
    @job = create(:job)
    person = @job.person
    @job.save!
    puts person.full_name
    assert_no_difference 'Job.count' do
      delete person_path(person)
    end
  end

end
