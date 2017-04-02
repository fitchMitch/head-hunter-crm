# == Schema Information
#
# Table name: comactions
#
#  id         :integer          not null, primary key
#  name       :string
#  status     :string
#  type_action:string
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
  belongs_to :person
  belongs_to :user

  #default_scope -> { select(user_id: current_user.id) }

  validates :name , presence: true, length: { maximum: 50 }
  validates :status , presence: true
  validates :action_type , presence: true

  @@comstatus = ['en prospection', '1er appel', '2eme appel' ,'3eme appel', 'accord pour mission', 'mission remplie']
  @@candidatesStatus = ['en prospection' '1er appel' '2eme appel' '3eme appel' 'accord pour mission' 'mission remplie']
  @@action_types = %w[Client Candidat]

  # ------------------------
  # --    PRIVATE        ---
  # ------------------------
  private

end
