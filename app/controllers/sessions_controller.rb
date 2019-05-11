class SessionsController < ApplicationController

  def new
    @session = Session.new
  end

  def create
    @session = Session.new(session_params)

    if (user = User.find_by(handle: @session.handle))
      if user.failed_logins_count > 2
        flash[:error] = t(".we_locked_account")

        render :new, status: :unprocessable_entity
      elsif user.password == @session.password
        session[:user_id] = user.id

        user.update(failed_logins_count: 0) if user.failed_logins_count == 0

        flash[:notice] = t(".successful_login")

        redirect_to pages_home_path
      else
        user.increment!(:failed_logins_count)

        if user.failed_logins_count > 2
          flash[:error] = t(".we_locked_account")

          render :new, status: :unprocessable_entity
        else
          if user.failed_logins_count == 0
            flash[:error] = t(".user_not_found")
          else
            flash[:error] = t(".we_will_lock_account")
          end

          render :new, status: :unprocessable_entity
        end
      end
    else
      flash[:error] = t(".user_not_found")

      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    session.delete(:user_id)

    flash[:notice] = t(".successfully_loged_out")

    redirect_to pages_home_path
  end

  private

  def session_params
    params.require(:session).permit(:handle, :password)
  end
end
