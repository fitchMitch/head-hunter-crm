module Users
  module Authenticate
    extend ActiveSupport::Concern

    included do
      before_create  :create_activation_digest
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
    # Returns true if a password reset has expired.
    def password_reset_expired?
      reset_sent_at < 2.hours.ago
    end
    # Sets the password reset attributes.
    def create_reset_digest
      self.reset_token = User.new_token
      update_columns(reset_digest: User.digest(reset_token), reset_sent_at: Time.zone.now)
    end

  end
end
