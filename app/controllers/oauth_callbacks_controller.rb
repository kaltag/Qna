# frozen_string_literal: true

class OauthCallbacksController < Devise::OmniauthCallbacksController
  def github
    auth_user('Github')
  end

  def vkontakte
    auth_user('Vkontakte')
  end

  private

  def auth_user(provider)
    @user = AuthorizationService.new(request.env['omniauth.auth']).call

    if @user&.persisted?
      if @user.confirmation_token
        redirect_to confirm_email_new_user_path(@user)
      else
        sign_in_and_redirect @user, event: :authentication
        set_flash_message(:notice, :success, kind: provider) if is_navigational_format?
      end
    else
      redirect_to root_path, alert: 'Something went wrong'
    end
  end
end
