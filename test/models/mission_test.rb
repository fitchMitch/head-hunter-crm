# == Schema Information
#
# Table name: missions
#
#  id                 :integer          not null, primary key
#  name               :string
#  reward             :float
#  paid_amount        :float
#  min_salary         :float
#  max_salary         :float
#  criteria           :string
#  min_age            :integer
#  max_age            :integer
#  signed             :boolean
#  is_done            :boolean
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  person_id          :integer
#  company_id         :integer
#  whished_start_date :date
#
require 'test_helper'

class MissionTest < ActiveSupport::TestCase
  def setup
    @mission = build(:mission)
  end

  test "mission name should not be empty" do
    @mission.name = ''
    refute @mission.valid?
  end

  test "mission name should not be long" do
    @mission.name = 'a'*51
    refute @mission.valid?
  end

  test "reward should not be empty" do
    @mission.reward = ''
    refute @mission.valid?
  end

  test "whished_start_date should exist" do
    @mission.whished_start_date = ''
    refute @mission.valid?
  end

  test "min_age should be lower than max_age" do
    @mission.max_age , @mission.min_age = @mission.min_age, @mission.max_age
    refute @mission.valid?
  end

  test "saving missions should be ok" do
    @mission2 = build(:mission)
    assert @mission2.valid?
    assert_difference 'Mission.count' do
      @mission2.save
    end
  end
end
