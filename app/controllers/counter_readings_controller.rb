class CounterReadingsController < ApplicationController
#  before_filter :get_bankbook_utility_id, :only => [:index, :new]
  before_filter :find_counter
  before_filter :find_readings
  before_filter :get_last_reading, :only => [:new, :create]
  

  def index
  end

  def new
    @reading = CounterReading.new
  end

  def create
    @reading = @counter.counter_readings.build(params[:counter_reading])
    @reading.date = Time.now

#p ">>>>>>>>>>>>>>>>>value="+@reading.value.to_s

    if @reading.value < @last_reading
      flash_error 'new_reading_value_too_small'
      render :new
    else 
      if not @reading.save
        render :new
      else
        notice_created
        redirect_to :action => 'index', :counter_id => @counter.id
      end
    end
  end

  private
 
  def find_counter
    @counter = Counter.find params[:counter_id]
  end
  
  def find_readings
    @readings = @counter.counter_readings.all(:order => "date DESC")
  end
  
  def get_last_reading
#    @readings = CounterReading.all(:conditions => ['c.bankbook_utility_id=?', @get_bankbook_utility_id],
#      :joins => 'left join counters c on c.id=counter_id',
#      :order => "counter_readings.id DESC" )
    if @readings.size==0
      @last_reading = 0
    else
      @last_reading = @readings[0].value
      @last_reading_date = @readings[0].date
    end  
  end

#  def show
#    @audit = Audit.find params[:id]
#    @value_field_names = @audit.action == 'update' ? 
#      ['Old Value', 'New Value'] : ['Value']
#  end
end
