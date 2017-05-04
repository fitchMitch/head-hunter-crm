# == Schema Information
#
# Table name: comactions
#
#  id          :integer          not null, primary key
#  name        :string
#  status      :string
#  action_type :string
#  start_time  :datetime
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  user_id     :integer
#  mission_id  :integer
#  person_id   :integer
#  end_time    :datetime
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
    OTHER_TYPE = 'Autre rendez-vous']

  STATUS_RELATED = {
    STATUS_SOURCED =>:sourced,
    STATUS_PRESELECTED => :preselected,
    STATUS_APPOINT => :appoint,
    STATUS_PRES => :pres,
    STATUS_O_PRES => :opres,
    STATUS_HIRED => :hired,
    STATUS_WORKING => :working
  }
  #default_scope -> {order(start_time: :asc)}
  scope :older_than, ->(d,being_id) {
    d ||=7
    where('start_time < ? OR start_time is null AND user_id = ?', d.days.ago,being_id)
  }
  scope :newer_than, ->(d,being_id) {
    d ||=7
    where('start_time >= ? OR start_time is null AND user_id = ?', d.days.ago,being_id)
  }
  scope :unscheduled, -> (being_id) { where('start_time is null AND user_id = ?', being_id) }
  scope :scheduled, -> (being_id) { where('start_time is not null AND user_id = ?', being_id) }
  scope :sourced, -> (being_id) { where('comactions.status = ? AND user_id = ?' ,STATUS_SOURCED, being_id ) }
  scope :preselected, -> (being_id) { where('comactions.status = ? AND user_id = ?' , STATUS_PRESELECTED, being_id ) }
  scope :appoint, -> (being_id) { where('comactions.status = ? AND user_id = ? ' , STATUS_APPOINT, being_id) }
  scope :pres, -> (being_id) { where('comactions.status = ? AND user_id = ? ' ,STATUS_PRES, being_id ) }
  scope :opres, -> (being_id) { where('comactions.status = ? AND user_id = ? ' , STATUS_O_PRES, being_id) }
  scope :hired, -> (being_id) { where('comactions.status = ?  AND user_id = ?' ,STATUS_HIRED, being_id) }
  scope :working, -> (being_id) { where('comactions.status = ? AND user_id = ?' , STATUS_WORKING, being_id) }
  #default_scope -> { select(user_id: current_user.id) }

  validates :name , presence: true, length: { maximum: 50 }
  validates :status , presence: true
  validates :action_type , presence: true

  validates :status, inclusion: {in: STATUSES}
  validates :action_type, inclusion: {in: ACTION_TYPES}
  validate  :end_time_is_after

  # Sends meeting email.
  def send_meeting_email(u,is_new)
    is_new == 1 ? ComactionMailer.event_saving(self,u).deliver_now : ComactionMailer.maj_event_saving(self,u).deliver_now
  end

  # ------------------------
  # --    PRIVATE        ---
  # ------------------------
  private
  def end_time_is_after
    if is_dated == true  && end_time - start_time < 0
      errors.add(:end_time, "La fin vient après le début :-)")
    end
  end

end
