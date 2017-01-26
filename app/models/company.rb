class Company < ApplicationRecord
  has_many :jobs
  has_many :job_histories ,through: :jobs

  validates :company_name,  presence: true, length: { maximum: 50 },uniqueness: { case_sensitive: false }

  # ------------------------
  # --    PRIVATE        ---
  # ------------------------
  private

end
