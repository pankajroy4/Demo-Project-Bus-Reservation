class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :validatable, :confirmable
  validates :name, presence: true
  has_many :reservations, dependent: :destroy
  enum user_type: { admin: 0, bus_owner: 1, user: 2 }

  def generate_otp
    self.otp = "%06d" % rand(10 ** 6)
    self.otp_sent_at = Time.now
    self.save!
    self.otp
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

  def generate_and_send_otp
    otp = generate_otp
    update(otp: otp)
    OtpVerification.otp_verification(self, otp).deliver_now
  end
end
