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
#

require 'test_helper'

class JobTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
