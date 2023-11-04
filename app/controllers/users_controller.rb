# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :load_user, only: %i[confirm_email_new confirm_email_create]

  def confirm_email_create
    if @user.update(email: params[:email])
      AuthMailer.with(user: @user).confirm_email.deliver_now
    else
      render 'users/confirm_email_new'
    end
  end

  def confirm_email
    user = User.find_by(confirmation_token: params[:token])
    if user
      user.update(confirmation_token: nil)
      sign_in(user)
      redirect_to root_path, notice: 'Email confirmed successfully'
    else
      redirect_to root_path unless user
    end
  end

  private

  def load_user
    @user = User.find(params[:id])
  end
end
