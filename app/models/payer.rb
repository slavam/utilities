# encoding: UTF-8
class Payer < ActiveRecord::Base
  has_many :bankbooks, :class_name => 'Bankbook', :foreign_key => 'id_human'
  has_many :orders
  belongs_to :city, :class_name => 'City', :foreign_key => 'id_city'
  belongs_to :room_location, :class_name => 'RoomLocation', :foreign_key => 'id_room_location'

  set_table_name "humans"

  def address
    return (room_location.house_location.zip_code>0 ?
      room_location.house_location.zip_code.to_s+', ' : '') +
      room_location.house_location.street_location.city.city_type.short_name.to_utf + ' ' + 
      room_location.house_location.street_location.city.name_rus.to_utf + ', ' + 
      room_location.house_location.street_location.street_type.short_name.to_utf + ' ' +  
      room_location.house_location.street_location.name.to_utf + ', дом '+ 
      room_location.house_location.house.n_house.to_s + 
      (room_location.house_location.house.f_house>0 ? '-' +
      room_location.house_location.house.f_house.to_s : '') + 
      (room_location.house_location.house.d_house>0 ? '/'+
      room_location.house_location.house.d_house.to_s : '') + 
      (room_location.house_location.house.a_house>'' ?
      '"'+room_location.house_location.house.a_house.to_utf+'"' : '') + 
      (room_location.room.n_room>0 ? ', кв. '+
      room_location.room.n_room.to_s : '')+
      (room_location.room.a_room>'' ?
      '"'+room_location.room.a_room.to_utf+'"' : '') 
  end
end
