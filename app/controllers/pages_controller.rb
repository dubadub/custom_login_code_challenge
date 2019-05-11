class PagesController < ApplicationController

  before_action :check_if_logged_in!

  def home
  end
end
