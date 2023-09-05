
class ApplicationController < ActionController::Base
    include Pundit::Authorization

    rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
    rescue_from ActiveRecord::RecordNotFound, with: :handle_not_found

    private

    def user_not_authorized
        redirect_to root_path, 
        alert:"You are not authorized to access this page."
    end

    def handle_not_found
        redirect_to root_path, 
        alert: "Record not found"
    end

    def pundit_user
        if current_user 
            current_user
        else 
            current_bus_owner
        end
    end

    def authenticate_admin_or_bus_owner!
        unless current_user&.type=="Admin" || bus_owner_signed_in?
          redirect_to root_path ,
          notice: "Unauthorized access! please login/signup"
        end
    end

    def authenticate_any!
       unless (bus_owner_signed_in? || user_signed_in? || (current_user&.type=="Admin"))
        redirect_to new_user_session_path ,
        notice: "Unauthorized access! please login/signup"
       end
    end
    
    def active_user
        current_user || current_bus_owner 
    end
    helper_method :active_user

end
