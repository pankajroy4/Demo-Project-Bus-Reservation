class BusOwnersController < ApplicationController
    before_action :authenticate_admin_or_bus_owner! , only:[:index]

    def index
        @bus_owners=BusOwner.all
    end
    
    def show    
        @bus_owner=BusOwner.find(params[:id])
        authorize @bus_owner
    end
end


