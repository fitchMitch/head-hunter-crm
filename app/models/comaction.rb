# == Schema Information
#
# Table name: comactions
#
#  id         :integer          not null, primary key
#  name       :string
#  status     :string
#  type       :string
#  due_date   :date
#  done_date  :date
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :integer
#  mission_id :integer
#  person_id  :integer
#

class Comaction < ApplicationRecord
  belongs_to :mission
  has_many :people
  has_many :users

  validates :name , presence: true, length: { maximum: 50 }
  validates :status , presence: true
  validates :type , presence: true
  validates :due_date , presence: true

  # ------------------------
  # --    PRIVATE        ---
  # ------------------------
  private

end
