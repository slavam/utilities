class HouseLocation < ActiveRecord::Base
  has_many :room_locations, :class_name => 'RoomLocation', :foreign_key => 'id_house_location'
  belongs_to :street_location, :class_name => 'StreetLocation', :foreign_key => 'id_street_location'
  belongs_to :house, :class_name => 'House', :foreign_key => 'id_house'

end
