# == Schema Information
#
# Table name: companies
#
#  id           :integer          not null, primary key
#  company_name :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class Company < ApplicationRecord
  has_many :jobs #, -> { includes :person }

  validates :company_name,  presence: true, length: { maximum: 50 }, uniqueness: { case_sensitive: false }

  # ------------------------
  # --    PRIVATE        ---
  # ------------------------
  private

end
