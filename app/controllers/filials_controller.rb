class FilialsController < ApplicationController
  before_filter :find_filial, :only => :show

  def show
    
  end
  
  def new
    @filial = Filial.new
  end
  
  def create
    @filial = Filial.create params[:filial]

    if not @filial.save
      render :new
    else
      notice_created
      redirect_to bankunits_path
    end
  end
  
  private
  
  def find_filial
    @filial = Filial.find params[:id]
  end
end
