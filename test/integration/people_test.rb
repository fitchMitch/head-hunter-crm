require 'test_helper'

class PeopleTest < ActionDispatch::IntegrationTest
  def setup
    @person = create(:person)
    @user= @person.user
    log_in_as(@user)
  end

  test "should get new on saving error" do
    get new_person_path
    assert_template 'people/new'
    person2 = attributes_for(:person, firstname: '')
    post people_path, params: {person: person2}
    assert_template 'people/new'
  end

  test "should land on show when saving" do
    person2 = attributes_for(:person)
    get new_person_path
    post people_path, params: { person: person2}
    follow_redirect!
    assert_response :success
    assert_match /Contact sauvegardé/, flash[ :success]
  end

  test "people should get destroyed" do
    get people_path
    assert_response :success
    assert_template 'people/index'
    first_page_of_people = Person.paginate(page: 1)
    @person=first_page_of_people.first
    puts "just some indications"
    first_page_of_people.each do |per|
      assert_select 'a[href=?]', person_path(per)
    end
    assert_difference 'Person.count', -1 do
      delete person_path(@person)
    end
  end

  test "there's an access to people's detail page" do
    get people_path
    Person.paginate(page: 1).each do |per|
      assert_select 'a[href=?]', person_path(per)
      assert_select 'a[href=?]', edit_person_path(per)
    end
  end

  test "dependent resources shoud be destroyed when people are" do
    @job = create(:job)
    @person = @job.person
    assert_difference 'Job.count', -1 do
      delete person_path(@person)
    end
  end
end
