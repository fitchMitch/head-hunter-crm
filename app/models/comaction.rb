# == Schema Information
#
# Table name: comactions
#
#  id          :integer          not null, primary key
#  name        :string
#  status      :string
#  action_type :string
#  due_date    :datetime
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

  attr_accessor :is_dated

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
  #default_scope -> {order(due_date: :asc)}
  scope :older_than, ->(d) {
    d ||=7
    where('due_date < ? OR due_date is null', d.days.ago)
  }
  scope :newer_than, ->(d) {
    d ||=7
    where('due_date >= ? OR due_date is null', d.days.ago)
  }
  scope :unscheduled, -> { where('due_date is null') }
  scope :sourced, -> { where('comactions.status = ?' ,STATUS_SOURCED ) }
  scope :preselected, -> { where('comactions.status = ?' , STATUS_PRESELECTED ) }
  scope :appoint, -> { where('comactions.status = ?' , STATUS_APPOINT) }
  scope :pres, -> { where('comactions.status = ?' ,STATUS_PRES ) }
  scope :opres, -> { where('comactions.status = ?' , STATUS_O_PRES) }
  scope :hired, -> { where('comactions.status = ?' ,STATUS_HIRED) }
  scope :working, -> { where('comactions.status = ?' , STATUS_WORKING) }
  #default_scope -> { select(user_id: current_user.id) }

  validates :name , presence: true, length: { maximum: 50 }
  validates :status , presence: true
  validates :action_type , presence: true

  validates :status, inclusion: {in: STATUSES}
  validates :action_type, inclusion: {in: ACTION_TYPES}

  # ------------------------
  # --    PRIVATE        ---
  # ------------------------
  private

end
