class FirmsController < ApplicationController
  before_filter :find_firm, :only => [:show, :edit, :update, :destroy]

  def index
    @firms = Firm.where("is_active = 1").order(:name).paginate :page => params[:page], :per_page => 20
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
  end
 
end
