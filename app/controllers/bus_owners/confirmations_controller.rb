# frozen_string_literal: true

class BusOwners::ConfirmationsController < Devise::ConfirmationsController

  def otp_verification
    @token = params[:confirmation_token]
    @user = BusOwner.find_by(confirmation_token: @token)
  end

  # GET /resource/confirmation?confirmation_token=abcdef
  def show
    params[:confirmation_token] = params[:bus_owner][:confirmation_token]
    @token = params[:confirmation_token]
    @user = BusOwner.find_by(confirmation_token: @token)
    if @user&.valid_otp?(params[:bus_owner][:otp])
      super
    else
      flash.now[:alert] = 'Invalid OTP'
      render :otp_verification, status: :unprocessable_entity
    end
  end

  # GET /resource/confirmation/new
  # def new
  #   super
  # end

  # POST /resource/confirmation
  # def create
  #   super
  # end

  # protected

  # The path used after resending confirmation instructions.
  # def after_resending_confirmation_instructions_path_for(resource_name)
  #   super(resource_name)
  # end

  # The path used after confirmation.
  # def after_confirmation_path_for(resource_name, resource)
  #   super(resource_name, resource)
  # end
end
