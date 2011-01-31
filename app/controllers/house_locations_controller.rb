class HouseLocationsController < ApplicationController
  before_filter :find_street, :only => :index

  def index
    @houses = @street.house_location.all(:order => :id_house)
    if @houses.size==0
      flash_error 'no_homes_on_street'
      redirect_back_or_default :controller => "street_locations", :action => "actual_streets", :city_id => @street.id_city
    end
  end
  
  private

  def find_street
    @street = StreetLocation.find params[:street][:id]
  end
end
