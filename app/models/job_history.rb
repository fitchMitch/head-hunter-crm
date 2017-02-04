# == Schema Information
#
# Table name: job_histories
#
#  id         :integer          not null, primary key
#  job_id     :integer
#  person_id  :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class JobHistory < ApplicationRecord
  belongs_to :person
  has_many :jobs
  accepts_nested_attributes_for :jobs
end
