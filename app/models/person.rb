# == Schema Information
#
# Table name: people
#
#  id                :integer          not null, primary key
#  title             :string
#  firstname         :string
#  lastname          :string
#  email             :string
#  phone_number      :string
#  cell_phone_number :string
#  birthdate         :date
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  is_jj_hired       :boolean
#  is_client         :boolean
#  note              :text
#  user_id           :integer
#

class Person < ApplicationRecord
  has_many :jobs , dependent: :destroy
  #accepts_nested_attributes_for :jobs, allow_destroy: true
  belongs_to :user
  before_save   :downcase_email
  before_save   :upcase_name
  has_and_belongs_to_many :tags
  #:primary_key, :string, :text, :integer, :float, :decimal, :datetime, :timestamp,
  #:time, :date, :binary, :boolean, :references


  validates :firstname,  presence: true, length: { maximum: 35 }
  validates :lastname,  presence: true, length: { maximum: 40 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 }, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }
  validates :phone_number,  length: { minimum:10,maximum: 18 }
  validates :cell_phone_number,  length: { minimum:10,maximum: 18 }

  def full_name
    title + "  " + firstname + " " + lastname.upcase
  end

  # ------------------------
  private
  # ------------------------
  def downcase_email
    self.email = email.downcase
  end
  def upcase_name
    self.lastname = lastname.upcase
  end

end
