class Room < ActiveRecord::Base
  has_many :room_locations
end
