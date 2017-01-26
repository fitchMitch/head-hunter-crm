# == Schema Information
#
# Table name: job_histories
#
#  id             :integer          not null, primary key
#  job_history_id :integer
#  person_id      :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

require 'test_helper'

class JobHistoryTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
