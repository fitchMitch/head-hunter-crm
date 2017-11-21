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
  has_many :comactions, dependent: :destroy
  # has_many :people, dependent: :destroy is not wished but they must be reaffected
  attr_accessor :remember_token,
    :activation_token,
    :reset_token
  before_save   :downcase_email
  before_create :create_activation_digest
  before_destroy :admin_user
  #:primary_key, :string, :text, :integer, :float, :decimal, :datetime, :timestamp,
  #:time, :date, :binary, :boolean, :references


  validates :name,  presence: true, length: { maximum: 50 }
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

  scope :other_admins, ->(me) { where('admin = ? and id != ?', true , me.id ) }

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
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end
  # Returns true if the given token matches the digest.
  def authenticated?(attribute, token)
    digest = send("#{attribute }_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end
  # Forgets a user.
  def forget
    update_attribute(:remember_digest, nil)
  end
  # Activates an account.
  def activate
    update_columns(activated: true, activated_at: Time.zone.now)
  end

  # Sends activation email.
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end
  # Sets the password reset attributes.
  def create_reset_digest
    self.reset_token = User.new_token
    update_columns(reset_digest:  User.digest(reset_token), reset_sent_at: Time.zone.now)
  end

  # Sends password reset email.
  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  # Returns true if a password reset has expired.
  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end

  def trigram
    trigram = name.split(' ').count>1 ?  name.split(' ')[0][0] +  name.split(' ')[1][0..1] : name[0..2]
    trigram.upcase
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

    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end


end
