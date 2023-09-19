
class OtpVerification < ApplicationMailer
  def otp_verification(record, otp)
    @user= record
    @otp = otp
    mail(to: @user.email, subject: 'Your OTP for Login')
  end
end