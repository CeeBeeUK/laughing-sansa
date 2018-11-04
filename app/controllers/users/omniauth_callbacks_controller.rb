module Users
  class OmniauthCallbacksController < Devise::OmniauthCallbacksController
    def google_oauth2
      @user = User.find_for_google_oauth2(oauth_request, current_user)
      return unless @user.persisted?

      flash[:notice] = I18n.t 'devise.omniauth_callbacks.success', kind: 'Google'
      sign_in_and_redirect @user, event: :authentication
    end

    def oauth_request
      request.env['omniauth.auth']
    end
  end
end
