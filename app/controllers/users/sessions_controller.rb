class Users::SessionsController < Devise::SessionsController

  def new
    super
  end
    
  def otp_verification
    sign_out(current_user) if current_user
    @email = params[:user][:email] 
    @user = User.find_by(email: @email)
    @remember_me = params[:user][:remember_me] 

    if @user && @user.valid_password?(params[:user][:password])
      @user.generate_and_send_otp
      flash[:notice] = 'A new OTP has been sent to your email.'
    else
      flash[:alert] = 'Invalid email or password!'
      redirect_to new_user_session_path
    end
  end

  def resend_otp
    email = params[:email]
    user = User.find_by(email: email)
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
    @email = params[:email]
    user = User.find_by(email: @email)
    remember_me = params[:remember_me]
    if user && user.valid_otp?(params[:otp])
      user.update!(remember_me: remember_me)
      sign_in(:user, user)
      if user.admin?
        redirect_to admin_show_path(user.id), notice: 'Admin logged in successfully!'
      else 
        redirect_to user_path(user.id), notice: 'Logged in successfully!'
      end
    else
      flash.now[:alert] = 'Invalid email or OTP.'
      render :otp_verification , status: :unprocessable_entity
    end
  end

  def after_sign_in_path_for(resource)
    unless resource.admin?
      user_path(resource) 
    else
      admin_show_path(current_user&.id)
    end
  end

  def configure_sign_in_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:otp,:email,:password,:remember_me])
  end
end





  # def resend_otp
  #   email = params[:email]
  #   user = User.find_by(email: email)
  #   if user
  #     user.generate_and_send_otp
  #     flash.now[:notice] = 'OTP resended, check your mail!.'
  #     render :otp_verification, status: :ok
  #   else
  #     flash[:alert] = 'Invalid email address.'
  #     redirect_to root_path
  #   end
  # end


