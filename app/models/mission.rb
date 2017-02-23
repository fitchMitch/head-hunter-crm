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

class Mission < ApplicationRecord
  belongs_to :person
  belongs_to :company

  validates :name , presence: true, length: { maximum: 50 }
  validates :reward , presence: true
  validates :whished_start_date , presence: true
end