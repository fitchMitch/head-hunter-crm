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
  has_many :jobs , dependent: :destroy #, -> { includes :person }
  has_many :people, through: :jobs
  has_many :missions, dependent: :destroy

  before_save   :upcase_company_name

  validates :company_name,  presence: true, length: { maximum: 40 }, uniqueness: { case_sensitive: false }

  # ------------------------
  # --    PRIVATE        ---
  # ------------------------
  private
    def upcase_company_name
      # first letter only
      self.company_name = company_name.sub(/[a-z]/i,&:upcase)
    end
end
