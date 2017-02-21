# == Schema Information
#
# Table name: missions
#
#  id          :integer          not null, primary key
#  name        :string
#  reward      :float
#  paid_amount :float
#  min_salary  :float
#  max_salary  :float
#  criteria    :string
#  min_age     :integer
#  max_age     :integer
#  signed      :boolean
#  is_done     :boolean
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  person_id   :integer
#  company_id  :integer
#

require 'test_helper'

class MissionTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
