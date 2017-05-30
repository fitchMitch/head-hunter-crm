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
#  status             :string
#

class Mission < ApplicationRecord
  belongs_to :person
  belongs_to :company
  has_many :comactions, dependent: :destroy

  STATUSES = [STATUS_HOPE = 'Opportunité',
    STATUS_SENT= 'Contrat envoyé',
    STATUS_SIGNED = 'Contrat signé',
    STATUS_BILLED = 'Mission facturée',
    STATUS_PAYED = 'Mission payée'
  ]
  # attr_accessor :hope,
  #   :sent,
  #   :signed,
  #   :billed,
  #   :payed

  scope :active, -> { where('status != ? AND status != ?', STATUS_BILLED, STATUS_PAYED) }
  scope :not_paid, -> { where('status != ?', STATUS_PAYED) }

  validates :name, presence: true, length: { maximum: 50 }
  validates :reward, presence: true
  validates :whished_start_date, presence: true
  validates :status, inclusion: {in: STATUSES }
  validate :max_age_is_max

  def max_age_is_max
    if min_age.present? && max_age.present? && min_age > max_age
      errors.add(:max_age, 'Plutôt un âge plus avancé')
    end
  end
  # ------------------------
  # --    PRIVATE        ---
  # ------------------------
  private


end
