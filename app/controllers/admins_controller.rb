class AdminsController < ApplicationController
	before_action :authenticate_admin!
	before_action :authorize_admin, only: [:show, :approve, :disapprove]

	def show
		@admin = current_user
	end

	def approve
		@bus = Bus.find(params[:id])
    if @bus.approve!
      render json: { status: 'success', message: 'Bus approved successfully' }
    else
      render json: { status: 'error', message: 'Failed to approve bus' }
    end

	end

	def disapprove
		@bus = Bus.find(params[:id])
    if @bus.disapprove!
      render json: { status: 'success', message: 'Bus disapproved successfully' }
    else
      render json: { status: 'error', message: 'Failed to disapprove bus' }
    end
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

