class BusApprovalMailer < ApplicationMailer
  def approval_email(user)
    @user = user
    mail to: @user.bus_owner.email, subject: "Bus approval Email!!"
  end
end
