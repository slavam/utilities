# coding: utf-8
require 'iconv'
class CitiesController < ApplicationController
  before_filter :find_active_cities, :only => :index_active_cities
  before_filter :find_city, :only => [:show, :edit, :update, :destroy, :city_print]
  before_filter :find_region, :only => :show

  def index
    Encoding.default_internal, Encoding.default_external = ['utf-8'] * 2
    @cities = City.all(:select => "cities.*, short_name",
#    @cities = City.all(:select => "CAST(cities.name_rus AS nvarchar(6)) AS name_rus, cities.id_parent, cities.name_ukr, cities.id, cities.code_koatuu, t.short_name AS short_name",
      :conditions => "id_type > 0", 
      :joins => " inner join city_types as t on id_type=t.id", 
      :order => :name_rus)
    for @city in @cities
#      @city.name_rus = Iconv.iconv('utf-8', 'cp1251',@city.name_rus);

      @city.name_rus = @city.name_rus.to_utf
#      @city.name_rus =  @city.name_rus.encoding
#      @city.name_rus = @city.name_rus.to_s.encode('UTF-8')
      @city.city_type.short_name = @city.city_type.short_name.to_utf
    end
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
    @city.name_rus = @city.name_rus.to_utf
    @city.city_type.full_name = @city.city_type.full_name.to_utf
    @city.name_ukr = @city.name_ukr.to_utf
  end
 
  def find_active_cities
    @cities = City.find(:all, :conditions => ["id_parent in (select id from cities where lastGenErcCode>0)"])
#      City.all(:select => "cities.*, short_name",
#      :conditions => "id_type > 0", 
#      :joins => " inner join city_types as t on id_type=t.id", 
#      :order => :name_rus)
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
        region = Region.find(:first, :conditions => ["code=?", template])
        if region
          @region_name = region.description
          if (@city.code_koatuu % 100000)>80000
            template = @city.code_koatuu - (@city.code_koatuu % 10000)
          else
            return
          end
        else
          template = @city.code_koatuu - (@city.code_koatuu % 1000)
          region = Region.find(:first, :conditions => ["code=?", template])
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
    region = Region.find(:first, :conditions => ["code=?", template])
    if region and (@region_name != region.description)
      @region_name = @region_name +' '+ region.description
    else
      @region_name = region.description
    end
    @region_name = @region_name.to_utf
  end

end
