class BusesController < ApplicationController
	before_action :authenticate_bus_owner!, only: [:new, :edit, :update, :destroy]
	before_action :authenticate_admin_or_bus_owner!, only: [:index]
	before_action :authorize_bus_owner, only: [:edit, :update, :destroy, :index]

	def reservations_list
		@date = params[:date]
		@bus = Bus.find(params[:bus_id])
		@reservations = @bus.reservations.where(date: @date)
		authorize @bus
	end
	
	def new
		@busowner = BusOwner.find(params[:bus_owner_id])
		@bus = @busowner.buses.new
	end

	def show   
		@busowner = BusOwner.find(params[:bus_owner_id])
		@bus = @busowner.buses.find(params[:id])
		@available_seats = @bus.seats
	end

	def create
		@busowner = BusOwner.find(params[:bus_owner_id])
		@bus = @busowner.buses.new(bus_params)
		if @bus.save 
			redirect_to bus_owner_path(@busowner), 
			notice: "Bus added successfully!"
		else
			render :new, status: :unprocessable_entity
		end
	end

	def index
		@buses = @busowner.buses.all
	end

	def edit
		@bus = @busowner.buses.find(params[:id])
	end

	def update
		@bus = @busowner.buses.find(params[:id])
		if @bus.update(bus_params)
			redirect_to bus_owner_bus_path(@busowner, @bus), 
			notice: "Bus info. updated successfully!"
		else 
			render :edit, status: :unprocessable_entity
		end 
	end

	def destroy
		@bus = @busowner.buses.find(params[:id])
		@bus.destroy 
		redirect_to  bus_owner_buses_path(@busowner),  
		status: :see_other, notice: "Bus removed successfully!"
	end

	private

	def bus_params
		params.require(:bus).permit(:name, :registration_no, :route, :total_seat, :approved, :main_image)
	end

	def authorize_bus_owner
		@busowner = BusOwner.find_by(id: params[:bus_owner_id])
		authorize @busowner, policy_class: BusPolicy
	end
end