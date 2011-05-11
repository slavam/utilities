class City < ActiveRecord::Base
#  has_and_belongs_to_many :city_type, :join_table => 'city_types',
#    :association_foreign_key => 'id_type'
#  has_one :city_type
#  belongs_to :city_type
  has_many :street_locations, :dependent => :destroy, :class_name => 'StreetLocation', :foreign_key => 'id_city'
  has_many :humans
  has_many :bankunits
  has_many :filials
  belongs_to :city_type, :class_name => 'CityType', :foreign_key => 'id_type'
  validates_presence_of :name_rus
  cattr_reader :per_page
  @@per_page = 20
end
