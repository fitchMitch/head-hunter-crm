# == Schema Information
#
# Table name: comactions
#
#  id          :integer          not null, primary key
#  name        :string
#  status      :string
#  action_type :string
#  due_date    :datetime
#  done_date   :date
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  user_id     :integer
#  mission_id  :integer
#  person_id   :integer
#

class Comaction < ApplicationRecord
  belongs_to :mission
  belongs_to :person
  belongs_to :user
  default_scope -> {order(due_date: :asc)}

  #default_scope -> { select(user_id: current_user.id) }

  validates :name , presence: true, length: { maximum: 50 }
  validates :status , presence: true
  validates :action_type , presence: true

  STATUSES = [STATUS_SOURCED = 'Sourcé',
      STATUS_PRESELECTED= 'Préselectionné',
      STATUS_APPOINT = 'RDV JJ',
      STATUS_PRES = 'Présentation client',
      STATUS_O_PRES = 'Autre RDV client',
      STATUS_HIRED = 'Engagé',
      STATUS_WORKING = 'En poste']
  ACTION_TYPES = [CLIENT_TYPE = 'Rendez-vous Client',
      PROSPECTION_TYPE= 'Rendez-vous Candidat',
      OTHER_TYPE = 'Autre']
  validates :status, inclusion: {in: STATUSES}
  validates :action_type, inclusion: {in: ACTION_TYPES}

  # ------------------------
  # --    PRIVATE        ---
  # ------------------------
  private

end
