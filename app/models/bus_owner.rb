class BusOwner < User
  has_many :buses, dependent: :destroy
end
  