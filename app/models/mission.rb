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
#  signed             :boolean
#  is_done            :boolean
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  person_id          :integer
#  company_id         :integer
#  whished_start_date :date
#  status             :integer          default("opportunity")
#  user_id            :integer
#  signed_at          :datetime
#

class Mission < ApplicationRecord
  belongs_to :person
  belongs_to :company
  has_many :comactions, dependent: :destroy

  default_scope { order(updated_at: :desc) }

  enum status: [:opportunity,
                :contract_sent,
                :contract_signed,
                :mission_billed,
                :mission_payed ]

  include PgSearch
  pg_search_scope :search_name,
                  against: [ [:name, 'A'], [:criteria , 'B'] ],
                  associated_against: {
                    company: :company_name,
                    person: [:firstname, :lastname]
                  },
                  using: {
                    # ignoring: :accents,
                    tsearch: { any_word: true, prefix: true },
                    trigram: {
                        threshold: 0.5
                      }
                  }
  def self.rebuild_pg_search_documents
    find_each { |record| record.update_pg_search_document }
  end

  scope :active, -> {
    where('status != ? AND status != ?', status[:mission_billed], status[:mission_payed])
  }
  scope :mine, ->(uid) { where('user_id = ?', uid) }


  validates :name, presence: true, length: { maximum: 50 }
  # validates :reward, presence: true
  # validates :whished_start_date, presence: true
  validates :status, inclusion: { in: statuses }
  # validate :max_age_is_max

  # ------------------------
  # --    PRIVATE        ---
  # ------------------------
  private


end
