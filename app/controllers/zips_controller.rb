class ZipsController < ApplicationController
#	before_filter :get_bank
  def show_map

    @map = GMap.new("map_div")
    @map.control_init(:large_map => true,:map_type => true)
    @map.center_zoom_init([params[:lat], params[:long]],16)
#    @map.center_zoom_init(request.remote_ip,16)
    @map.overlay_init(GMarker.new([params[:lat], params[:long]], :title => params[:name], :info_window => params[:name]))
  end

  private
  
  def get_bank
    @bankunit = Bankunit.find params[:bankunit]
  end

end
