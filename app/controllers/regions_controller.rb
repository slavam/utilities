# coding: utf-8
class RegionsController < ApplicationController
  before_filter :find_region, :only => :show

  def index
    @regions = Region.all  
    for @region in @regions
      @region.description = @region.description.to_utf
    end
  end
  
  def show
  end
  
  def new
    @region = Region.new
  end
  
  def create
    @region = Region.create params[:region]

    if not @region.save
      render :new
    else
#      notice_created
      redirect_to region_path(@region)
    end
  end
  
  private
  
  def find_region
    @region = Region.find params[:code]
  end
end
