# == Schema Information
#
# Table name: jobs
#
#  id         :integer          not null, primary key
#  job_title  :string
#  salary     :float
#  start_date :date
#  end_date   :date
#  jj_job     :boolean
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  company_id :integer
#  person_id  :integer
#  no_end     :boolean
#

require 'test_helper'

class JobTest < ActiveSupport::TestCase
  def setup
    @job = build(:job)
  end

  test "job_title should exist" do
    @job.job_title = ''
    refute @job.valid?
  end

  test "salary but not too much !" do
    @job.salary = '12345678901'
    refute @job.valid?
  end

  test "start_date should exist" do
    @job.start_date = ''
    refute @job.valid?
  end

  test "end_date should exist when no_end is false" do
    @job.no_end = false
    @job.end_date = ''
    refute @job.valid?
  end

  test "start_date should be before end_date" do
    @job.start_date , @job.end_date = @job.end_date , @job.start_date
    assert_no_difference 'Job.count' do
      @job.save
    end
  end
end
