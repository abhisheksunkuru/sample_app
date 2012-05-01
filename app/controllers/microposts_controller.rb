class MicropostsController < ApplicationController
  before_filter :signed_in_user, only: [:create, :destroy]
  before_filter :correct_user,   only: :destroy
  def index
  end

  def create
  	@micropost = current_user.microposts.build(params[:micropost])
  	if @micropost.save
  		flash[:success]= "Micrpost Created"
  		redirect_to home_path
  	else
  		@feed_items = []
  	   render 'staticpages/home'	
  	end   
  end

  def destroy
  	@micropost.destroy
    redirect_back_or root_path
  end
  private

    def correct_user
      @micropost = current_user.microposts.where(:id => params[:id]).first
    	
      redirect_to root_path unless current_user?(@micropost.user)
    end	
end
