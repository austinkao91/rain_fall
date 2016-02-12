# == Schema Information
#
# Table name: locations
#
#  id         :integer          not null, primary key
#  zip_code   :integer          not null
#  precip     :integer          not null
#  timestamp  :date             not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'test_helper'

class LocationTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
