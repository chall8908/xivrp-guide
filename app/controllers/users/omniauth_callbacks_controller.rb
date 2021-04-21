class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  skip_before_action :verify_authenticity_token, only: :discord

  def discord
    @user = User.from_omniauth(request.env['omniauth.auth'])

    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:success, :success, kind: 'Discord') if is_navigational_format?
    else
      session['devise.discord_data'] = request.env['omniauth.auth']
      redirect_to new_user_session_url
    end
  end
end
