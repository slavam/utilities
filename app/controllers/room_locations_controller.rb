class RoomLocationsController < ApplicationController
  before_filter :find_house, :only => :index

  def index
    @rooms = @house.room_locations.all(:order => :id_room)
    if @rooms.size==1
      redirect_to :controller => "payers", :action => "find_payer_by_address", :room_id => @rooms[0].id
    end
  end
  
  private

  def find_house
    @house = HouseLocation.find params[:house][:id]
  end
end
