class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def github
    auth = request.env["omniauth.auth"]
    user = User.from_github_oauth auth
    sign_in_and_redirect user, event: :authenticate
  end
end
