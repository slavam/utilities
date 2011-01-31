class BankunitsController < ApplicationController
  before_filter :find_bankunit, :only => [:show]
  before_filter :find_bankunits, :only => [:index]
  def index
  end

  def show
  end

  def new
    @bankunit = Bankunit.new
  end

  def create
    @bankunit = Bankunit.create params[:bankunit]

    if not @bankunit.save
      render :new
    else
      notice_created
      redirect_to bankunits_path
    end
  end

  private
  
  def find_bankunits
    @bankunits = Bankunit.all
  end

  def find_bankunit
    @bankunit = Bankunit.find params[:id]
  end
  
end
