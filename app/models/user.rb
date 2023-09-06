class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :validatable

  has_many :reservations ,dependent: :destroy

  enum user_type: { admin: 0, bus_owner: 1, user: 2 }        
end
