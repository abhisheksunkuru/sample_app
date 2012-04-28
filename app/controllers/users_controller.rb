class UsersController < ApplicationController
  before_filter :already_signed_in?, only: [:new,:create]
  before_filter :signed_in_user, only: [:index, :edit, :update]
  before_filter :correct_user, only: [:edit, :update]
  before_filter :admin_user, only: :destroy

  def index
    @users = User.paginate( page: params[:page])
  end  

  def new
    @user = User.new
  end
  
  def create
    @user=User.new(params[:user])
    if @user.save
      sign_in @user
      flash[:success] = "welcome to the Sample App!"
      redirect_to @user
    else
      render 'new'
    end
  end

  def show
    @user=User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id]) 
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated"
      sign_in @user
      redirect_to @user
    else
      render 'edit'
    end  
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "user destroyed"
    redirect_to users_path 
  end  

  private

    def signed_in_user
      unless signed_in?
        store_location  
        redirect_to signin_path, notice: "Please sign in." unless signed_in?
      end
    end 

    def correct_user
      @user = User.find(params[:id])
      redirect_to(home_path) unless current_user?(@user)
    end 

    def admin_user
      redirect_to(home_path) unless current_user.admin?
    end

    def already_signed_in?
      if current_user.present?
        redirect_to home_path
      end
    end
end
