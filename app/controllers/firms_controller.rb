class FirmsController < ApplicationController
#  before_filter :find_city_type
#  before_filter :find_region, :except => :details
  before_filter :find_firm, :only => [:show, :edit, :update, :destroy]
#  skip_before_filter

  def index
    @firms = Firm.all(
#    :select => "firms.*, fa.*, a.* ",
      :conditions => "is_active = 1", 
#      :joins => " inner join firm_accounts as fa on code=fa.code_firm 
#        inner join firm_account_attributes as a on fa.id=a.id_firm_account", 
      :order => :name)
    for @firm in @firms 
      @firm.name = @firm.name.to_utf
    end
  end

  def show
  end

  def edit
  end

  def update
    if not @firm.update_attributes params[:firm]
      render :edit
    else
      notice_updated
      redirect_to firm_path(@firm)
    end
  end

  def new
    @firm = Firm.new
  end

  def create
    @firm = Firm.create params[:firm]

    if not @firm.save
      render :new
    else
      notice_created
      redirect_to firms_path
    end
  end

  def destroy
    @city.destroy
    redirect_to firms_path
  end

  private

  def find_firm
    @firm = Firm.find params[:id]
    @firm.name = @firm.name.to_utf
    if @firm.legal_address
      @firm.legal_address = @firm.legal_address.to_utf
    end  
    if @firm.info_manager
      @firm.info_manager = @firm.info_manager.to_utf
    end  
  end
 
end
