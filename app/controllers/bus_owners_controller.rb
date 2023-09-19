class BusOwnersController < ApplicationController
	before_action :authenticate_admin_or_bus_owner!, only: [:index, :show]

	def index
		@bus_owners = BusOwner.all 
		authorize current_user, policy_class: BusOwnerPolicy
	end
	
	def show    
		@bus_owner = BusOwner.find(params[:id])
		authorize @bus_owner, policy_class: BusOwnerPolicy
	end
	
end


