class UserRegistrationsController < ApplicationController
  allow_unauthenticated_access
  rate_limit to: 10, within: 3.minutes, only: :create, with: -> { redirect_to new_user_registration_url, alert: "Try again later." }

  def new
  end

  def create
    if user = User.create(params.permit(:username, :password))
      start_new_session_for user
      redirect_to after_authentication_url
    else
      redirect_to new_user_registration_path, alert: "Try another email address or password."
    end
  end
end
