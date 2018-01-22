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
  PERSPECTIVE = 6 # next n days

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

  validate  :check_conditions
  # ===========
  def check_conditions
    check_upside_down
    check_overlap if errors.empty?
  end

  def check_upside_down
    cond_current_time_data = start_time.present? && end_time.present?
    if cond_current_time_data && end_time < start_time
      errors.add :end_time, I18n.t('comaction.upside_down_error')
    end
  end

  def check_overlap
    return if start_time.nil? || end_time.nil?
    Comaction.mine(user_id).each do |other|
      next if other.start_time.nil? || other.end_time.nil?
      next if other == self
      time_frame = TimeFrame.new(min: start_time, max: end_time)
      time_frame_other = TimeFrame.new(min: other.start_time, max: other.end_time)
      if time_frame.overlaps?(time_frame_other)
        logger.debug("---------------- occuring overlap : other\'s name : #{ other.name } | self\'s name : #{name}-------------------")
        errors.add(:end_time, "Superposition de rendez-vous #{other.name} avec : (#{other.person.full_name}) ")
      end
    end
  end

  # Sends meeting email.
  def self.t_com_status(k)
    I18n.t("comaction.status.#{k}")
  end

  def send_meeting_email(u, is_new)
    if Rails.configuration.mail_wanted
      ComactionMailer.one_event_saving(self, u, is_new).deliver_now
    end
  end


  # ------------------------
  # --    PRIVATE        ---
  # ------------------------

  private
end
