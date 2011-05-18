# coding: utf-8
class CitiesController < ApplicationController
  before_filter :find_active_cities, :only => :index_active_cities
  before_filter :find_city, :only => [:show, :edit, :update, :destroy, :city_print]
  before_filter :find_region, :only => :show

  def index
    @cities = City.where("id_type > 0").order(:name_rus).paginate :page => params[:page], :per_page => 20
  end

  def index_active_cities
  end

  def show
  end

  def edit
  end

  def update
    if not @city.update_attributes params[:city]
      render :edit
    else
      notice_updated
      redirect_to city_path(@city)
    end
  end

  def new
    @city = City.new
  end

  def create
    @city = City.create params[:city]

    if not @city.save
      render :new
    else
      notice_created
      redirect_to cities_path
    end
  end

  def destroy
    @city.destroy
    redirect_to cities_path
  end

  def city_print
    output = Town.new.to_pdf(@city)
    respond_to do |format|
      format.pdf do
        send_data output, :filename => "city.pdf", :type => "application/pdf"
      end
    end
  end

  private
  
  def find_city
    @city = City.find params[:id]
  end
 
  def find_active_cities
    @cities = City.find(:all, 
      :conditions => ["id_parent in (select id from cities where lastGenErcCode>0) and id_parent != 0 and id_type > 0"], 
      :order => :name_rus)
  end
  
  def find_region
    @region_name = ''
    if @city.code_koatuu % 100000 == 0
      template = @city.code_koatuu - (@city.code_koatuu % 10000000)
    else
      if @city.code_koatuu % 1000 == 0
        template = @city.code_koatuu - (@city.code_koatuu % 1000)
      else
        template = @city.code_koatuu - (@city.code_koatuu % 100)
        region = Region.where("code=?", template).first
        if region
          @region_name = region.description
          if (@city.code_koatuu % 100000)>80000
            template = @city.code_koatuu - (@city.code_koatuu % 10000)
          else
            return
          end
        else
          template = @city.code_koatuu - (@city.code_koatuu % 1000)
          region = Region.where("code=?", template).first
          if region
            @region_name = region.description
            @region_name = @region_name.to_utf
            return
          else
            template = @city.code_koatuu - (@city.code_koatuu % 100000)
          end
        end  
      end  
    end
    region = Region.where("code=?", template).first
    if region and (@region_name != region.description)
      @region_name = @region_name +' '+ region.description
    else
      @region_name = region.description
    end
    @region_name = @region_name.to_utf
  end

end
