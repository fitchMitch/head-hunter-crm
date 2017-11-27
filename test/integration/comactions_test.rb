require 'test_helper'

class ComactionsTest < ActionDispatch::IntegrationTest
	def setup
    	@comaction = create(:comaction)
    	@user= create(:user)
    	@person = create(:person)
    	@mission = create (:mission)
    	log_in_as(@user)
	end
	# -----------------

	test "should comaction post be a success" do
		comaction2 = create(:former_comaction)
		comaction2.person = @person
		comaction2.mission = @mission
		comaction2Param  = attributes_for(:comaction)
		get new_comaction_path
		post comactions_path, params: {comaction: comaction2Param}
		follow_redirect!
	    assert_response :success
		assert_template 'comactions/index'
	end

end
