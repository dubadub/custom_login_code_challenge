class SessionsController < ApplicationController

  def new
    @session = Session.new
  end

  def create
    @session = Session.new(session_params)

    if @session.save
      login!(@session.user_id)

      flash[:notice] = t(".successful_login")

      redirect_to pages_home_path
    else
      flash[:error] = @session.errors.full_messages.join(". ")

      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    logout!

    flash[:notice] = t(".successfully_logged_out")

    redirect_to pages_home_path
  end

  private

  def session_params
    params.require(:session).permit(:handle, :password)
  end
end
