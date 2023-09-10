class ReservationsController < ApplicationController
	before_action :authenticate_any!
	before_action :require_approved, except: [:booking]
	
	def new #this will execute when user click on "check availability/book ticket"
		@user = active_user
		@reservation = Reservation.new 
		@date = params[:date] || Date.today
		@available_seats = Reservation.display_searched_date_seats(@bus, @date)
	end

	def create # this will run when user click on "confirm bookings"
		param = params[:reservation]
		bus_id = param[:bus_id]
		user_id = param[:user_id]
		seat_ids = param[:seat_id]
		date = param[:date]
		parsed_date = Date.parse(date)
		@success = Reservation.create_reservations(user_id, bus_id, seat_ids, parsed_date)
		@success ? ( redirect_to bookings_path(user_id), notice: "Booking successful!") : (redirect_to new_ticket_path(bus_id), status: :unprocessable_entity, alert: "Please select seat first!")
	end

	def destroy
		@reservation = Reservation.find(params[:reservation_id])
		@user = User.find_by(id: params[:id])
		authorize @user, policy_class: ReservationPolicy
		@reservation.destroy 
		respond_to do |format|
			format.html {redirect_to  bookings_path(active_user.id),notice: "Ticket cancelled!." }
			format.turbo_stream {	flash.now[:alert] = "Ticket Cancelled!."}
		end
	end

	def booking
		@user = params[:user_id]
		@bookings = policy_scope(Reservation)
	end

	private 

	def require_approved 
		@bus = Bus.find(params[:bus_id])
		unless @bus.approved 
			redirect_to root_path, alert:"Bus not approved yet!"
		end
	end
end
