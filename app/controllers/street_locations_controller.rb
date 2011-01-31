class StreetLocationsController < ApplicationController
  before_filter :find_city, :only => [:index, :actual_streets]
  before_filter :find_street, :only => [:show, :edit, :update, :destroy]
  before_filter :find_streets_by_city, :only => :actual_streets

  def index
    @street_locations = @city.street_locations.all(:order => :name)
  end

  def actual_streets
    if @streets.size==0
      flash_error 'no_streets_by_city'
      redirect_back_or_default :controller => "cities", :action => "index_active_cities"
    end
  end
  
  def show
  end

  def edit
    @street.name = @street.name.to_utf
  end

  def update
    if not @street_location.update_attributes params[:id]
      render :edit
    else
      notice_updated
      redirect_to city_street_location_path(@city, @street_location)
    end
  end

  def new
    @street_location = @city.street_locations.build
  end

  def create
    @street_location = @city.street_locations.create params[:street_location]

    if not @street_location.save
      render :new
    else
      notice_created
      redirect_to city_street_locations_path(@city)
    end
  end

  def destroy
    @street_location.destroy
    redirect_to city_street_locations_path(@city)
  end
  
  private

  def find_city
    if params[:city_id]
      @city = City.find params[:city_id]
    else
      @city = City.find params[:city][:id]
    end
  end

  def find_street
#    @street = @city.street_locations.find params[:id]
    @street = StreetLocation.find params[:id]
  end

  def find_streets_by_city
    @streets = @city.street_locations
  end

end
