class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  before_action :authorization

  def facebook
  end

  def twitter
  end

  def add_email
  end

  private

  def authorization
    auth = request.env['omniauth.auth'] || OmniAuth::AuthHash.new(params[:auth])

    @user = User.find_for_oauth(auth)

    if @user.try(:persisted?)
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: "#{auth.provider.capitalize}") if is_navigational_format?
    elsif auth.present?
      flash[:notice] = 'You should add your email'
      render 'common/add_email', locals: { auth: auth }
    end
  end
end