class BusOwners::SessionsController < Devise::SessionsController

  before_action :configure_sign_in_params, only: [:create]

  def new
    super
  end
    
  def otp_verification
    # fail
    sign_out(active_user) if active_user
    @user = BusOwner.find_by(email: params[:bus_owner][:email])
    @email = params[:bus_owner][:email] 
    @remember_me = params[:bus_owner][:remember_me] 

    if @user && @user.valid_password?(params[:bus_owner][:password])
      @user.generate_and_send_otp
      flash[:notice] = 'A new OTP has been sent to your email.'
    else
      flash[:alert] = 'Invalid email or password!'
      redirect_to new_bus_owner_session_path
    end
  end

  def resend_otp
    email = params[:email]
    user = BusOwner.find_by(email: email)
    if user
      user.generate_and_send_otp
      flash.now[:notice] = 'OTP resended, check your mail!'
      respond_to do |format|
        format.html {render :otp_verification, status: :ok}
        format.turbo_stream {	flash.now[:notice] = 'OTP resended, check your mail please!.'}
      end
    else
      redirect_to root_path, alert: 'Invalid email address.'
    end
  end

  def create
    user = BusOwner.find_by(email: params[:email])
    remember_me = params[:remember_me]
    if user && user.valid_otp?(params[:otp])
      user.update!(remember_me: remember_me)
      sign_in(:bus_owner, user)
      redirect_to bus_owner_path(user.id), notice: 'Logged in successfully!'
    else
      flash.now[:alert] = 'Invalid email or OTP.'
      render :otp_verification, status: :unprocessable_entity
    end
  end
  
  def configure_sign_in_params
    devise_parameter_sanitizer.permit(:sign_in, keys: [:otp])
  end

  def after_sign_in_path_for(resource)
    bus_owner_path(resource)
  end
end


 # def resend_otp
  #   user = BusOwner.find_by(email: params[:email])
  #   if user
  #     user.generate_and_send_otp
  #     flash.now[:alert] = 'OTP resended, check your mail!.'
  #     render :otp_verification
  #   else
  #     flash.now[:alert] = 'Invalid email address.'
  #     redirect_to root_path, alert: "Something wrong!"
  #   end
  # end