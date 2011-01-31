class StreetType < ActiveRecord::Base
  has_many :street_locations
end
