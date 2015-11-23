require_relative 'acceptance_helper'

feature 'User sign out', %q{
  In order to be able to sign out
  As an Signed User
  I want to be able to sign out
} do

  given(:user) { create(:user) }

  scenario 'Signed user sign out' do
    sign_in(user)
    expect(page).to have_link_or_button('Sign out')

    click_on 'Sign out'

    expect(page).to_not have_link_or_button('Sign out')
    expect(page).to have_content 'Signed out successfully.'
    expect(current_path).to eq root_path
  end
end
