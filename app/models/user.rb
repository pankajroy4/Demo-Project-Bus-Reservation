class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :validatable, :confirmable

  has_many :reservations ,dependent: :destroy
  enum user_type: { admin: 0, bus_owner: 1, user: 2 }   

  require 'rotp'

  def generate_otp
    self.otp = '%06d' % rand(10**6)
    self.otp_sent_at = Time.now
    save!
    return self.otp
  end

  def valid_otp?(otp)
    return false if otp.blank? || otp_sent_at.nil?

    otp_age = Time.now - otp_sent_at
    return false if otp_age > 5.minutes

    otp == self.otp
  end

  def send_confirmation_instructions
    generate_otp
    UserMailer.custom_confirmation_instructions(self, confirmation_token, otp: otp).deliver_now
  end

  def self.send_otp(user)
    user.otp = '%06d' % rand(10**6)
    user.otp_sent_at = Time.now
    user.save!
    user
  end

  def generate_and_send_otp
    otp = generate_otp 
    update(otp: otp)
    OtpVerification.otp_verification(self, otp).deliver_now
  end
end




  # require 'attr_encrypted' 
  # attr_accessor :otp, :otp_sent_at
  # attr_encrypted :otp_secret, key: ENV['ENCRYPTION_KEY'] 

  # def generate_otp
  #   self.otp_secret = ROTP::Base32.random_base32
  #   totp = ROTP::TOTP.new(otp_secret)
  #   self.otp = totp.now
  # end

  # def valid_otp?(otp)
  #   return false if otp_secret.blank?
  #   otp_validator = ROTP::TOTP.new(otp_secret)
  #   otp_validator.verify(otp)
  # end

  # def active_for_authentication? 
  #   super && approved? 
  # end 

  # def inactive_message 
  #   approved? ? super : :not_approved
  # end