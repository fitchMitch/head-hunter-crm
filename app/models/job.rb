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
#

class Job < ApplicationRecord
  has_one  :job_history
end
