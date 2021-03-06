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

require 'net/http'

class Location < ActiveRecord::Base
  validates :zip_code, :precip, :timestamp, presence: true
  validates :zip_code, uniqueness: {:scope => :timestamp}

  def self.last_days(zip_code, limit=10)
    first_date = (Time.now - limit.days).to_s.split(" ").first
    Location.where("zip_code = ? AND timestamp >= ?", zip_code, first_date)
                .limit(limit)
                .order(:precip => :desc, :timestamp => :desc)
  end


  def self.save_locations(parsed_body, zip_code)

    parsed_body.map! do |el|
       el["zip_code"] = zip_code.to_i
       el
     end
    parsed_body.each { |loc| Location.new(loc).save }

    parsed_body.sort { |el1, el2| el2["precip"].to_f <=> el1["precip"].to_f }
  end


  def self.isoParse(time)
    time_arr = time.to_s.split(" ")
    "#{time_arr[0]}T#{time_arr[1]}#{time_arr[2]}"
  end
end
