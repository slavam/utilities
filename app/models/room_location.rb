class RoomLocation < ActiveRecord::Base
  has_many :hunans
  belongs_to :house_location, :class_name => 'HouseLocation', :foreign_key => 'id_house_location'
  belongs_to :room, :class_name => 'Room', :foreign_key => 'id_room'

end
