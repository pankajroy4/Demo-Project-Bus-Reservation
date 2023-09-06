class AdminsController < ApplicationController
	before_action :authenticate_admin!
	before_action :authorize_admin, only: [:show, :approve, :disapprove]

	def show
	end

	def approve
		@bus = Bus.find(params[:id])
		@bus.approve!
		redirect_to bus_owner_buses_path(params[:bus_owner]), 
		notice: 'Bus approved successfully!'
	end

	def disapprove
		@bus = Bus.find(params[:id])
		@bus.disapprove!
		redirect_to bus_owner_buses_path(params[:bus_owner]), 
		alert: 'Bus approval cancelled!'
	end
	
	private

	def authorize_admin
		@admin = current_user
		authorize @admin, policy_class: AdminPolicy
	end

	def authenticate_admin!
		unless user_signed_in?
			redirect_to new_user_session_path, alert: "Requires login/signup!"
		end
	end
end

