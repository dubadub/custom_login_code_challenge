class ApplicationController < ActionController::Base

  # when code base is bigger, these methods will go to a separate concern,
  # at that stage it's easier for reader to have it here

  def login!(user_id)
    session[:user_id] = user_id
  end

  def logout!
     session.delete(:user_id)
  end

  private

  def check_if_logged_in!
    return if session[:user_id]

    flash[:error] = t("sessions.session_required")

    redirect_to new_session_path
  end

end
