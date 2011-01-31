class CityType < ActiveRecord::Base
  has_many :cities
  validates_presence_of :full_name
end
