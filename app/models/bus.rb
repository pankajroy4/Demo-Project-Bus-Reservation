class Bus < ApplicationRecord
  belongs_to :bus_owner, class_name: "User", foreign_key: "bus_owner_id"
  has_many :reservations, dependent: :destroy
  has_many :seats, dependent: :destroy
  has_one_attached :main_image
  
  after_create :create_seats
  after_update :adjust_seats
  before_destroy :delete_seats

  validates :name, :route, :total_seat, :registration_no, presence: true
  validates :registration_no, uniqueness: {message: "must be unique and govt. verified"}

  scope :approved, -> { where(approved: true) }
  scope :search_by_name_or_route, -> (query) { 
		sanitized_string = sanitize_sql_like(query)
    where("name LIKE ? OR route LIKE ?", "%#{sanitized_string}%", "%#{sanitized_string}%")
  }

  def disapprove!
    update(approved: false)
    reservations.delete_all
  end

  def approve!
    update(approved: true)
  end

  private

  def delete_seats
    Seat.where(bus_id: id).delete_all
  end

  def create_seats(n = 1)
    seats = (n..total_seat).map do |seat|
      Seat.new(bus_id: id, seat_no: seat)
    end

    Seat.transaction do
      Seat.import(seats)
    end
  end

  def adjust_seats
    original_no_of_seat = seats.count
    if total_seat > original_no_of_seat
      create_seats(original_no_of_seat + 1)
    elsif total_seat < original_no_of_seat
      seats.where(bus_id: id).where(" seat_no > ? ", total_seat).destroy_all
    end
  end
end

# NOTE: delete_all method will bypass model validations and callbacks ,So in case ,we do not want to bypass validations and callbacks ,use destroy, like: 
# seats.where(bus_id: id).where("seat_no > ?", total_seat).destroy_all

# Behind the scence for =>  has_one_attached :main_image
    # has_one :main_image_attachment, dependent: :destroy
    # has_one :main_image_blob, through:  :main_image_attachment