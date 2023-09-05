class AdminsController < ApplicationController

    before_action :authenticate_admin!
    before_action :require_admin , only: [:approve,:disapprove]
    before_action :set_admin ,only: [:show]

    def show
    end
    def approve
        @bus =Bus.find(params[:id])
        @bus.approve!
        redirect_to bus_owner_buses_path(params[:bus_owner]), 
        notice: 'Bus approved successfully!'
    end
    def disapprove
        @bus =Bus.find(params[:id])
        @bus.disapprove!
        redirect_to bus_owner_buses_path(params[:bus_owner]), 
        alert: 'Bus approval cancelled!'
    end
    
    private
   
    def set_admin 
        @admin=Admin.find(params[:id])
        authorize @admin
    end
    def require_admin 
        @admin=current_user
        authorize @admin
    end
    def authenticate_admin!
        current_user&.type=="Admin"
    end

end

