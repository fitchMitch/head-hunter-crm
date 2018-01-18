require 'test_helper'

class PeopleControllerTest < ActionDispatch::IntegrationTest
  def setup
    @person = create(:person)
    @user = @person.user
  end

  test 'should get edit'
    log_in_as(@user)
    get edit_person_path(@person)
    assert_response :success
  end

  test 'should redirect home when disconnected'
    get edit_person_path(@person)
    assert_redirected_to login_url
  end

  test 'should get new'
    log_in_as(@user)
    get new_person_path
    assert_response :success
  end

  test 'should get show'
    log_in_as(@user)
    get person_path(@person.id)
    assert_response :success
  end

  test 'should redirect update'
    log_in_as(@user)
    patch person_path(@person), params: { person: { firstname: @person.firstname, email: @person.email } }
    refute flash[:success] == ''
    assert_redirected_to person_url
  end

  test 'should edit when wrong update'
    log_in_as(@user)
    patch person_path(@person), params: { person: { lastname:"", email: @person.email } }
    refute flash[:danger].empty?
    assert_template 'people/edit'
  end

end
