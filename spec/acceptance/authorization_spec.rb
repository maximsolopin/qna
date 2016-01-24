require_relative 'acceptance_helper'

feature 'Authorization by oauth provider', %q{
  In order to authorize by oauth provider
  As an user of oauth provider
  I'd like to be able to sign in
} do

  before do
     OmniAuth.config.test_mode = true
     visit new_user_registration_path
  end

  describe 'Sign in with valid credentials' do
    scenario 'Sign in with facebook' do
      mock_auth_hash(:facebook)

      click_on 'Sign in with Facebook'

      expect(page).to have_content 'Successfully authenticated from Facebook account.'
    end

    scenario 'Sign in with twitter' do
      mock_auth_hash(:twitter)

      click_on 'Sign in with Twitter'

      expect(page).to have_content 'You should add your email'

      fill_in 'auth[info][email]', with: 'test@test.com'
      click_on 'Add email'

      expect(page).to have_content 'Successfully authenticated from Twitter account.'
    end
  end

  describe 'Sign in with invalid credentials' do
    scenario 'Sign in with facebook' do
      OmniAuth.config.mock_auth[:facebook] = :invalid_credentials

      click_on 'Sign in with Facebook'

      expect(page).to have_content 'Could not authenticate you from Facebook because "Invalid credentials"'
    end

    scenario 'Sign in with twitter' do
      OmniAuth.config.mock_auth[:twitter] = :invalid_credentials

      click_on 'Sign in with Twitter'

      expect(page).to have_content 'Could not authenticate you from Twitter because "Invalid credentials"'
    end
  end
end