class BusesController < ApplicationController
    before_action :authenticate_bus_owner!, only: [:new,:edit,:update,:destroy]
    before_action :authenticate_admin_or_bus_owner! ,only: [:index]
    before_action :set_bus_owner, only: [:edit,:update,:destroy]
    before_action :require_approved ,only: [:get_list]


    def reservations_list
        @date = Date.parse(params[:date])
        @bus=Bus.find(params[:bus_id])
        @reservations=@bus.reservations.where(date: @date)
        authorize @bus
    end

    def get_list
        @bus=Bus.new(id: params[:bus_id],bus_owner_id: current_bus_owner&.id)
        @date=Date.today
        authorize @bus
    end
 
    def index
        @busowner=BusOwner.find(params[:bus_owner_id])
        @buses=@busowner.buses.all
    end

    def new
        @busowner=BusOwner.find(params[:bus_owner_id])
        @bus=@busowner.buses.new
    end

    def create
        @busowner=BusOwner.find(params[:bus_owner_id])
        @bus=@busowner.buses.new(bus_params)
        if @bus.save 
            redirect_to bus_owner_path(@busowner) ,
            notice: "Bus added successfully!"
        else
            render :new, status: :unprocessable_entity
        end
    end

    def show   
        @busowner=BusOwner.find(params[:bus_owner_id])
        @bus=@busowner.buses.find(params[:id])
        @available_seats=@bus.seats
    end
    
    def edit
    end

    def update

        if @bus.update(bus_params)
            redirect_to bus_owner_bus_path(@busowner,@bus) ,
            notice: "Bus info. updated successfully!"
        else 
            render :edit ,status: :unprocessable_entity
        end 
    end

    def destroy
        @bus.destroy 
        redirect_to  bus_owner_buses_path(@busowner) , 
        status: :see_other,notice: "Bus removed successfully !"
    end

    private
        def bus_params
            params.require(:bus).permit(:name,:registration_no,:route,:total_seat,:approved,:main_image)
        end
        def set_bus_owner
            @busowner=BusOwner.find(params[:bus_owner_id])
            @bus=@busowner.buses.find(params[:id])
            authorize @bus
        end
end