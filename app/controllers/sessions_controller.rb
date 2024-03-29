class SessionsController < ApplicationController
	def new
	end
	
	def create
	  user = User.find_by_email(params[:session][:email])
	  if user && user.authenticate(params[:session][:password])
	  	sign_in user

	  	flash[:notice] = "Hi!!! you are successfully signed in."
	    redirect_to user_path(user)
	  else
		flash[:error] = "Invalid email/password combination"
		render 'new' 	
	  end   
	end

	def destroy	
      sign_out
      redirect_to home_path
	end

end
