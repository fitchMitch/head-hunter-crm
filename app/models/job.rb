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

class Job < ApplicationRecord
  belongs_to  :person, dependent: :destroy
  belongs_to  :company

  #:primary_key, :string, :text, :integer, :float, :decimal, :datetime, :timestamp,
  #:time, :date, :binary, :boolean, :references


  validates :job_title , presence: true, length: { maximum: 50 }
  validates :salary , length: { maximum: 50 } # TODO : numeric only !
  validates :start_date,  presence: true

  # ------------------------
  # --    PRIVATE        ---
  # ------------------------
  private
end
