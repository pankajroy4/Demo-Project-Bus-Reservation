class User < ApplicationRecord

       devise :database_authenticatable, :registerable,
              :recoverable, :rememberable, :validatable
              
       has_many :reservations ,dependent: :destroy
       # has_one_attached :profile_pic
              
end
