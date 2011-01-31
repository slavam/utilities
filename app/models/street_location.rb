class StreetLocation < ActiveRecord::Base
  has_many :house_location, :class_name => 'HouseLocation', :foreign_key => 'id_street_location'
  belongs_to :city, :class_name => 'City', :foreign_key => 'id_city'
  belongs_to :street_type, :class_name => 'StreetType', :foreign_key => 'id_type'
end
