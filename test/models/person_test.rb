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

require 'test_helper'

class PersonTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
