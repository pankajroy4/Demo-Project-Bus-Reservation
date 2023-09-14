
class BusOwner < User
  has_many :buses, class_name: 'Bus', foreign_key: 'bus_owner_id', dependent: :destroy
  default_scope { where( user_type: User.user_types['bus_owner'] ) }
end
