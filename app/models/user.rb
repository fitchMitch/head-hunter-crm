# == Schema Information
#
# Table name: users
#
#  id                :integer          not null, primary key
#  name              :string
#  email             :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  password_digest   :string
#  remember_digest   :string
#  admin             :boolean          default(FALSE)
#  activation_digest :string
#  activated         :boolean          default(FALSE)
#  activated_at      :datetime
#  reset_digest      :string
#  reset_sent_at     :datetime
#

class User < ApplicationRecord
  include Users::Authenticate

  has_many :comactions, dependent: :destroy
  # has_many :people, dependent: :destroy is not wished but they must be reaffected
  attr_accessor :remember_token,
                :activation_token,
                :reset_token
  before_save :downcase_email


  validates :name,
            presence: true,
            length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+0-9\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email,
            presence: true,
            length: { maximum: 255 },
            format: { with: VALID_EMAIL_REGEX },
            uniqueness: { case_sensitive: false }
  has_secure_password
  validates :password,
            presence: true,
            length: { minimum: 6 },
            allow_nil: true
  validates :password_confirmation,
            presence: true,
            allow_nil: true

  scope :other_admins, ->(me) { where('admin = ? and id != ?', true, me.id) }

  # Returns the hash digest of the given string.
  class << self
    def digest(string)
      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
      BCrypt::Password.create(string, cost: cost)
    end
    # Returns a random token.
    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  # Sends activation email.
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  # Sends password reset email.
  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  def trigram
    if name.split(' ').count > 1
      name.split(' ')[0][0] + name.split(' ')[1][0..1]
    else
      name[0..2]
    end.upcase
  end
  # ------------------------
  # --    PRIVATE        ---
  # ------------------------
  private
    def downcase_email
      self.email = email.downcase
    end
    # Creates and assigns the activation token and digest.
    def create_activation_digest
      self.activation_token  = User.new_token
      self.activation_digest = User.digest(activation_token)
    end

end
