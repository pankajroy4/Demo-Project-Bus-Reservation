
class ApprovalEmailsJob < ApplicationJob
  queue_as :default

  def perform(user)
    BusApprovalMailer.approval_email(user).deliver
  end
end