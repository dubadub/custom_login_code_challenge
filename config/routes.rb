Rails.application.routes.draw do
  resource :session, only: [:new, :create, :destroy]
  get "pages/home"

  root "pages#home"
end
