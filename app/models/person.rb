# == Schema Information
#
# Table name: people
#
#  id                   :integer          not null, primary key
#  title                :string
#  firstname            :string
#  lastname             :string
#  email                :string
#  phone_number         :string
#  cell_phone_number    :string
#  birthdate            :date
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  is_jj_hired          :boolean
#  is_client            :boolean
#  note                 :text
#  user_id              :integer
#  cv_docx_file_name    :string
#  cv_docx_content_type :string
#  cv_docx_file_size    :integer
#  cv_docx_updated_at   :datetime
#

class Person < ApplicationRecord
  has_many :jobs, dependent: :destroy
  #accepts_nested_attributes_for :jobs, allow_destroy: true
  has_many :missions, dependent: :destroy
  has_many :comactions, dependent: :destroy
  belongs_to :user

  before_save   :downcase_email
  before_save   :upcase_name

  has_and_belongs_to_many :tags

  #has_attached_file :cv_docx, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/assets/images/missing.jpg"
  has_attached_file :cv_docx
  validates_attachment_content_type :cv_docx, content_type: /\Aapplication\/vnd\.openxmlformats/
  validates_with AttachmentSizeValidator, attributes: :cv_docx, less_than: 2.megabytes
  # Validate filename
  #validates_attachment_file_name :avatar, matches: [/doc?\z/]
  #:primary_key, :string, :text, :integer, :float, :decimal, :datetime, :timestamp,
  #:time, :date, :binary, :boolean, :references


  validates :firstname,
    presence: true,
    length: { maximum: 35 }
  validates :lastname,
    presence: true,
    length: { maximum: 40 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true,
    length: { maximum: 255 },
    format: { with: VALID_EMAIL_REGEX },
    uniqueness: { case_sensitive: false }
  validates :phone_number,
    length: { minimum:10, maximum: 18 }
  validates :cell_phone_number,
    length: { minimum:10, maximum: 18 }

  def full_name
    title + '  ' + firstname + ' ' + lastname.upcase
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
