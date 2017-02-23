# == Schema Information
#
# Table name: tags
#
#  id         :integer          not null, primary key
#  tag_name   :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Tag < ApplicationRecord
  has_and_belongs_to_many :persons
end