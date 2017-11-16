# == Schema Information
#
# Table name: people
#
#  id                   :integer          not null, primary key
#  firstname            :string
#  lastname             :string
#  email                :string
#  phone_number         :string
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
#  approx_age           :integer
#  cv_content           :text
#

class Person < ApplicationRecord
  has_many :jobs, dependent: :destroy
  #accepts_nested_attributes_for :jobs, allow_destroy: true
  has_many :missions, dependent: :destroy
  has_many :comactions, dependent: :destroy
  belongs_to :user

  before_save   :downcase_email
  before_save   :upcase_name
  before_save   :phone_number_format

  # TODO
  before_destroy :remove_docx


  # ----- Search part
  include PgSearch
  # multisearchable :against => [:firstname, :lastname, :email, :note]
  pg_search_scope :search_name,
                :against => [[:firstname , 'B'],[:lastname, 'A'], [:note, 'C'] , [:cv_content, 'D']],
                :associated_against => { :jobs => :job_title } ,
                :using => {
                  #:ignoring => :accents,
                  :tsearch => {:any_word => true, :prefix => true},
                  :trigram => {
                      :threshold => 0.5
                    }
                }

  def self.rebuild_pg_search_documents
    find_each { |record| record.update_pg_search_document }
  end
  # ----- End of Search part
  default_scope { order(updated_at: :desc) }

  #has_attached_file :cv_docx, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/assets/images/missing.jpg"
  has_attached_file :cv_docx
  validates_attachment_content_type :cv_docx, content_type: /\Aapplication\/vnd\.openxmlformats/
  validates_with AttachmentSizeValidator, attributes: :cv_docx, less_than: 2.megabytes
  validates :lastname,
    presence: true,
    length: { maximum: 40 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  SPACES = /\A\s*(.*)\s*\z/
  # validates :email,
  #   length: { maximum: 255 },
  #   format: { with: VALID_EMAIL_REGEX },
  #   uniqueness: { case_sensitive: false } ,
  #   if: :email.present?
  validates :phone_number,
     length: { minimum:10, maximum: 18 },
     if: Proc.new {|p| p.phone_number.present? }

  validate :is_email_an_email

  scope :found_by, -> (user_id) { where('user_id = ?', user_id) }

  def is_email_an_email
    if email.present? && VALID_EMAIL_REGEX.match(email) == nil
      errors.add(:email, '... une erreur sur l\'email, certainement')
    end
  end

  def full_name
    firstname.nil? ?  lastname.upcase : firstname + ' ' + lastname.upcase
  end

  def get_cv
    if cv_docx.file?
      pth = "public/" + cv_docx.url.to_s.split("?")[0]
      Docx::Document.open(pth)
    end
  end

  def remove_docx
    self.remove_index_content
    self.cv_docx = nil
  end

  def index_cv_content
    doc = get_cv
    return if doc == nil
    ctt = []
    doc.paragraphs.each do |pa|
        ctt << pa.text.tr('\'' , ' ')
    end
    content =  ctt.join(' ')
    ActiveRecord::Base.connection.execute <<-SQL
    INSERT INTO pg_search_documents (searchable_type, searchable_id, content, created_at, updated_at)
    VALUES ('Person' ,
            #{self.id} ,
            '#{content}'::text ,
            now(),
            now())
    SQL
  end

  def remove_index_content
    ActiveRecord::Base.connection.execute <<-SQL
      DELETE FROM  pg_search_documents where searchable_id = #{self.id}
    SQL
  end

  def set_cv_content
    doc = get_cv
    return if doc == nil
    ctt = []
    doc.paragraphs.each  { |pa| ctt << pa.text.tr('\'' , ' ')}
    self.update(:cv_content => ctt.join(' '))

  end
  # ------------------------
  private
  # ------------------------
  def downcase_email
    return if email.nil? || email === ""
    self.email = email.downcase
    self.email = SPACES.match(email)[1]
  end

  def upcase_name
    self.lastname = lastname.upcase
  end

  def phone_number_format
    self.phone_number = format_by_two(phone_number) unless (phone_number.nil?)
  end

  def format_by_two (nr)
    nr = nr.sub( '+33' , '0').tr '^0-9', ''

    reg2 = /(\d{2})(\d{2})(\d{2})(\d{2})(\d+)/
    my_match = reg2.match(nr)
    return nr if my_match == nil
    my_match.captures.compact.join(" ")
  end

end
