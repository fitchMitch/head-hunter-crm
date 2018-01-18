# == Schema Information
#
# Table name: comactions
#
#  id          :integer          not null, primary key
#  name        :string
#  start_time  :datetime
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  user_id     :integer
#  mission_id  :integer
#  person_id   :integer
#  end_time    :datetime
#  status      :integer
#  action_type :integer
#

class Comaction < ApplicationRecord
  attr_accessor :is_dated

  belongs_to :mission
  belongs_to :person
  belongs_to :user

  WORK_HOURS = (8..22).to_a
  SHORTEST_MEETING_TIME = 45

  include PgSearch
  pg_search_scope :search_name,
                  against: [[:name, 'A'], [:status, 'B']],
                  associated_against: {
                    person: :lastname,
                    mission: :name
                  },
                  using: {
                    # ignoring: :accents,
                    tsearch: { any_word: true, prefix: true },
                    trigram: {
                      threshold: 0.5
                    }
                  }
  def self.rebuild_pg_search_documents
    find_each(&:update_pg_search_document)
  end

  enum status: [:sourced,
                :preselected,
                :appointed,
                :pres,
                :o_pres,
                :hired,
                :working ]
  enum action_type: [:client_type,
                    :apply_type,
                    :apply_customer_type,
                    :exploration_type,
                    :other_type]


  # ===========
  # Initialization
  # ===========
  after_initialize :set_new_comaction, if: :new_record?

  def set_new_comaction
    self.is_dated = 1
  end
  # ===========
  # Scopes
  # ===========
  scope :newer_than, ->(d) {
    d ||= 7
    where('(start_time >= ? OR start_time is null) ', d.days.ago)
  }
  scope :older_than, ->(d) {
    d ||= 0
    d = -d
    where('(start_time <= ?)', d.days.ago)
  }
  scope :mine,          ->(uid) { where('comactions.user_id = ?', uid) }
  scope :unscheduled,   -> { where('start_time is null ') }
  scope :scheduled,     -> { where('start_time is not null ') }

  scope :mission_list,  ->(mission) { where('comactions.mission_id = ?', mission.id) }
  scope :from_person,   ->(person) { where('comactions.person_id = ?', person.id) }

  # ===========
  # Validations
  # ===========
  validates :name, presence: true, length: { maximum: 100 }
  validates :status, presence: true
  validates :action_type, presence: true

  validates :status, inclusion: { in: statuses }
  validates :action_type, inclusion: { in: action_types }
  validate  :end_time_is_after_and_overlap

  # Sends meeting email.
  def self.t_com_status(k)
    I18n.t("comaction.status.#{k}")
  end

  def send_meeting_email(u, is_new)
    if Rails.configuration.mail_wanted
      is_new == 1  ? ComactionMailer.one_event_saving(self, u).deliver_now : ComactionMailer.event_saving_upd(self, u).deliver_now
    end
  end

  def end_time_is_after_and_overlap
    cond_current_time_data = start_time.present? && end_time.present?
    if cond_current_time_data && end_time < start_time
      errors.add :end_time, I18n.t('comaction.upside_down_error')
    end
    Comaction.mine(user_id).each do |other|
      o_cond_current_time_data = other.start_time.present? && other.end_time.present?
      test_condition_ok = other.user_id == user_id && o_cond_current_time_data && cond_current_time_data 
      next if !test_condition_ok || self == other

      # there's overlapping in any case Ci below
      c1 = (other.start_time < start_time && start_time < other.end_time)
      logger.debug('c1 #{c1}') if c1
      c2 = (other.start_time < end_time && end_time < other.end_time)
      logger.debug('c2 #{c2}') if c2
      c3 = (start_time < other.start_time && other.end_time < end_time)
      logger.debug('c3 #{c3}') if c3
      c4 = (other.start_time < start_time && end_time < other.end_time)
      logger.debug('c4 #{c4}') if c4
      if c1 || c2 || c3 || c4
        logger.debug("---------------- occuring overlap : other\'s name : #{ other.name } | self\'s name : #{name}-------------------")
        errors.add(:end_time, "Superposition de rendez-vous   #{ other.name } avec : (#{ other.person.full_name }) ")
      end
    end
  end
  # ------------------------
  # --    PRIVATE        ---
  # ------------------------

  private
end
