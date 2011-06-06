class UsersController < ApplicationController
#  before_filter :require_admin, :except => [:new, :update]
  before_filter :find_user, :only => [:show, :edit, :update]

  def index
    @users = User.all(:order => :login)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new params[:user]
    @user.randomize_password
    @human = Payer.where("code_erc=? and id_city=?", params[:code_erc], params[:city][:id]).first
    @user.id_human = @human.id

    if not @user.save
      render :new
    else
      @user.deliver_new_user_instructions!
      notice_created
      redirect_to :users
    end
  end

  def show
  end

  def edit
  end

  def update
    if not @user.update_attributes params[:user]
      render :action => :edit
    else
      notice_updated
      redirect_to user_path(@user)
    end
  end

  private
    def find_user
      @user = User.find params[:id]  
    end
end
