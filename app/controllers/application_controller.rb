class ApplicationController < ActionController::Base
	include Pundit::Authorization
	rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
	rescue_from ActiveRecord::RecordNotFound, with: :handle_not_found

	private

	def user_not_authorized
		redirect_to root_path, 
		alert: "You are not authorized to access this page."
	end

	def handle_not_found
		redirect_to root_path, alert: "Record not found"
	end

	def active_user
		current_user || current_bus_owner 
	end

	def pundit_user
		active_user
	end

	def authenticate_admin_or_bus_owner!
		unless user_signed_in? || bus_owner_signed_in?
			redirect_to root_path,
			alert: "Unauthorized access! please login/signup"
		end
	end

	def authenticate_any!
		unless  bus_owner_signed_in? || user_signed_in? 
			redirect_to new_user_session_path, 
			alert: "Unauthorized access! please login/signup"
		end
	end
		
	helper_method :active_user
end
