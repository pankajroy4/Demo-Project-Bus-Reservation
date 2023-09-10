class Reservation < ApplicationRecord
  belongs_to :bus
  belongs_to :user
  belongs_to :seat
  validates :date, presence: {message: "should be given"}


  def self.display_searched_date_seats(bus,date)
    reservations_on_searched_date = bus.reservations.where(date: date)
    seat_ids_booked = reservations_on_searched_date.pluck(:seat_id)
    bus.seats.where.not(id: seat_ids_booked)
  end

  def self.check_booked(seat_id,bus_id,date)
    result = Reservation.where(seat_id: seat_id).where(date: date).where(bus_id: bus_id)
    result.blank? 
  end

  def self.create_reservations(user_id, bus_id, seat_ids, date)
    return false if seat_ids.blank?

    reservations = seat_ids.map do |seat_id|
      next unless Reservation.check_booked(seat_id, bus_id, date)
      Reservation.new(user_id: user_id, bus_id: bus_id, seat_id: seat_id, date: date)
    end.compact

    Reservation.transaction do
      Reservation.import(reservations) # Using 'activerecord-import' gem
    end
    true
  end
end
