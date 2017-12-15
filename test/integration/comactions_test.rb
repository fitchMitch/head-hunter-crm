require 'test_helper'

class ComactionsTest < ActionDispatch::IntegrationTest
	def setup
		@comaction = create(:comaction)
		@user = create(:user)
		@mission = create (:mission)
		@person = create(:person)
		log_in_as(@user)
	end

	test "should comaction post be a success" do
		comaction2Param  = attributes_for(:comaction)
		comaction2Param['person_id'] = @person.id
		comaction2Param['mission_id'] = @mission.id
		get new_comaction_path
		post comactions_path, params: {comaction: comaction2Param}
		follow_redirect!
	  assert_response :success
		assert_template partial: '_month_calendar', count: 1
	end

	test "should filter with statuses" do
		@comaction_hired = create(:comaction_hired)
		@comaction_hired.update(user_id: @user.id)
		get comactions_url,
				params: {
					filter: "hired",
					v: "table_view" }
		# assert_select "body>div.container>div.row.spaceDown>div.row.spaceDown>#tab_list.tab-pane>div.row.mission_data>div.col-xs-1.status>small" , {minimum: 1, text: "Engagé"}
		  assert_select ".status>small" , {minimum: 1, text: "Engagé"}

	end

	test "should filter with statuses and fail" do
		@comaction_hired = create(:comaction_hired)
		@comaction_hired.update(user_id: @user.id)
		get comactions_url,
				params: {
					"filter" => "appointed",
					"v" => "table_view" }
		assert_select "div.mission_data", false
	end

end
