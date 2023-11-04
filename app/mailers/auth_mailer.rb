# frozen_string_literal: true

class AuthMailer < ApplicationMailer
  default from: 'notifications@example.com'

  def confirm_email
    @user = params[:user]
    mail(to: @user.email, subject: 'Email confirmation')
  end
end
