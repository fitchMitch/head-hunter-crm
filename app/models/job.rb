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

class Job < ApplicationRecord
  belongs_to  :person, touch: true
  belongs_to  :company

  include PgSearch
  # multisearchable :against => :job_title

  def self.rebuild_pg_search_documents
    find_each { |record| record.update_pg_search_document }
  end

  scope :reversed_time, -> { order(start_date: :desc) }

  validates :job_title, presence: true, length: { maximum: 50 }
  validates :salary, length: { maximum: 10 }
  validates :start_date,  presence: true, date: true
  validates :end_date, presence: true, date: { after: :start_date }, unless: :no_end?
  validate :double_current_job?

  def self.double_jobs(person_id)
    Job.where("person_id = ? AND no_end = ?", person_id, true).count > 1
  end

  def self.current_job(person_id)
    Job.find_by_person_id_and_no_end(person_id, true)
  end

  def has_current_job?
    Job.current_job(self.person_id) != nil
  end

  def self.last_job(person_id)
    Job.where('person_id = ?', person_id).reversed_time.first
  end

  def double_current_job?
    if has_current_job? and self.no_end
      errors.messages[:job_title] << I18n.t("job.double_jobs")
    end
  end

  # ------------------------
  # --    PRIVATE        ---
  # ------------------------
  private

end
