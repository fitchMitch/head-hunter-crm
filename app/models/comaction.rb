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

    STATUSES = [STATUS_SOURCED = 'Sourcé'.freeze,
                STATUS_PRESELECTED = 'Préselectionné'.freeze,
                STATUS_APPOINT = 'RDV JJ'.freeze,
                STATUS_PRES = 'Présentation client'.freeze,
                STATUS_O_PRES = 'Autre RDV client'.freeze,
                STATUS_HIRED = 'Engagé'.freeze,
                STATUS_WORKING = 'En poste'.freeze].freeze

    ACTION_TYPES = [CLIENT_TYPE = 'Rendez-vous Client'.freeze,
                    PROSPECTION_TYPE = 'Rendez-vous Candidat'.freeze,
                    OTHER_TYPE = 'Autre rendez-vous'.freeze].freeze

    STATUS_RELATED = {
        STATUS_SOURCED => :sourced,
        STATUS_PRESELECTED => :preselected,
        STATUS_APPOINT => :appoint,
        STATUS_PRES => :pres,
        STATUS_O_PRES => :opres,
        STATUS_HIRED => :hired,
        STATUS_WORKING => :working
    }.freeze



    # scope :older_than, ->(d, being_id) {
    #     d ||= 7
    #     where('start_time < ? OR start_time is null AND comactions.user_id = ?', d.days.ago, being_id)
    # }
    scope :newer_than, ->(d) {
        d ||= 7
        where('(start_time >= ? OR start_time is null) ', d.days.ago)
    }
    scope :mine, ->(being_id) {
      where('comactions.user_id = ?', being_id)
    }
    scope :unscheduled, -> {
       where('start_time is null ')
     }
    scope :scheduled, -> {
       where('start_time is not null ')
     }
    scope :sourced, -> {
       where('comactions.status = ? ', STATUS_SOURCED)
     }
    scope :preselected, -> {
       where('comactions.status = ? ', STATUS_PRESELECTED)
     }
    scope :appoint, -> {
       where('comactions.status = ?  ', STATUS_APPOINT)
     }
    scope :pres, -> {
       where('comactions.status = ?  ', STATUS_PRES)
     }
    scope :opres, -> {
       where('comactions.status =  ? ', STATUS_O_PRES)
     }
    scope :hired, -> {
       where('comactions.status = ? ', STATUS_HIRED)
     }
    scope :working, -> {
       where('comactions.status = ? ', STATUS_WORKING)
     }

    # validates :name, presence: true, length: { maximum: 50 }
    validates :status, presence: true
    validates :action_type, presence: true

    validates :status, inclusion: { in: STATUSES }
    validates :action_type, inclusion: { in: ACTION_TYPES }
    validate  :end_time_is_after
    validate  :check_for_overlap

    # Sends meeting email.
    def send_meeting_email(u, is_new)
        is_new == 1 ? ComactionMailer.one_event_saving(self, u).deliver_now : ComactionMailer.event_saving_upd(self, u).deliver_now
    end

    def check_for_overlap
        Comaction.mine(user_id).each do |other|
            c0 = other.user_id == user_id && !other.start_time.nil? && !other.end_time.nil? && !start_time.nil? && !end_time.nil? # overlap is possible only if c0 is true
            next unless c0

            # there's overlapping in any case Ci below
            c1 = (other.start_time < start_time && start_time < other.end_time)
            logger.debug('c1 #{c1 }') if c1
            c2 = (other.start_time < end_time && end_time < other.end_time)
            logger.debug('c2 #{c2 }') if c2
            c3 = (start_time < other.start_time && other.end_time < end_time)
            logger.debug('c3 #{c3 }') if c3
            c4 = (other.start_time < start_time && end_time < other.end_time)
            logger.debug('c4 #{c4 }') if c4
            if c1 || c2 || c3 || c4
                logger.debug('----------------occuring overlap : other\'s name : #{other.name } | self\'s name : #{name }-------------------')
                errors.add(:end_time, 'Superposition de rendez-vous v\u00E9rifiez votre agenda :-) : #{other.name } ')
            end
        end
    end

    def end_time_is_after
        if is_dated == true && end_time - start_time < 0
            errors.add(:end_time, 'La fin vient apr\u00E8s le d\u00E9but :-)')
        end
    end
    # ------------------------
    # --    PRIVATE        ---
    # ------------------------

    private
end
