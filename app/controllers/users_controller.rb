class UsersController < ApplicationController
	before_action :authenticate_any!

	def index
		@users = User.all
		authorize User
	end

	def show    
		@user = User.find_by(id: params[:id])
		if @user
			authorize @user
		else
			 redirect_to root_path, alert: "Record not found!"
		end
	end
end
