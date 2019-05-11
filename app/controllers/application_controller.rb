class ApplicationController < ActionController::Base

  private

  def check_if_logged_in!
    return if session[:user_id]

    flash[:error] = t("sessions.session_required")

    redirect_to new_session_path
  end
end
