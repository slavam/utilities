class CountersController < ApplicationController
  before_filter :get_bankbook_utility_id, :only => [:new, :index, :create]
  before_filter :get_bankbook_utility
  before_filter :get_counter_type, :only => [:index, :create]
  before_filter :find_counters, :only => :index
#  before_filter :require_admin

#  def show
#    @audit = Audit.find params[:id]
#    @value_field_names = @audit.action == 'update' ? 
#      ['Old Value', 'New Value'] : ['Value']
#  end
  
  def index
  end

  def new
    @counter = Counter.new
    @counter.bankbook_utility_id = @bankbook_utility_id
  end

  def create
    @counter = @bankbook_utility.counters.build(params[:counter])
    @counter.counter_type_id = @counter_type_id
    
    if not @counter.save
      render :new
    else
      notice_created
      redirect_to :action => 'index', :bankbook_utility_id => @bankbook_utility_id
    end
  end

  private
  
  def get_bankbook_utility
    @bankbook_utility = BankbookUtility.find @bankbook_utility_id  
  end
  
  def get_bankbook_utility_id
    @bankbook_utility_id = params[:bankbook_utility_id]
  end

  def find_counters
    @counters = @bankbook_utility.counters.all
  end
  
  def get_counter_type
    if @bankbook_utility.code_utility.to_i == 8
      @counter_type_id = 1
    else 
      if @bankbook_utility.code_utility.to_i == 20
        @counter_type_id = 4
      else 
        if @bankbook_utility.code_utility.to_i == 21
          @counter_type_id = 2
        else 
          if @bankbook_utility.code_utility.to_i == 39
            @counter_type_id = 3
          else
            @counter_type_id = 5
          end
        end
      end
    end  
    ct = CounterType.find @counter_type_id
    @counter_name = ct.description
  end
  
end
