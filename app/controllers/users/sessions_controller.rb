class Users::SessionsController < Devise::SessionsController

  def new
    super
  end
    
  def otp_verification
    sign_out(current_user) if current_user
    @user = User.find_by(email: params[:user][:email])
    @email = params[:user][:email] 
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
    user = User.find_by(email: params[:email])
    if user
      user.generate_and_send_otp
      flash.now[:alert] = 'OTP resended, check your mail!.'
      render :otp_verification
    else
      flash.now[:alert] = 'Invalid email address.'
      redirect_to root_path, alert: "Something wrong!"
    end
  end

  def create
    user = User.find_by(email: params[:email])
    remember_me = params[:remember_me]
    if user && user.valid_otp?(params[:otp])
      user.update!(remember_me: remember_me)
      sign_in(user)
      redirect_to user_path(user.id), notice: 'Logged in successfully!'
    else
      flash.now[:alert] = 'Invalid email or OTP.'
      render :otp_verification
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



