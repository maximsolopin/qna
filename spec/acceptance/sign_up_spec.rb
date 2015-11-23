require_relative 'acceptance_helper'

feature 'User sign up', %q{
  In order to be able to ask a questions and answer on question
  As an User
  I want to be able to sign up
} do

  scenario 'Sign up with valid attributes' do
    visit root_path
    expect(page).to have_link_or_button('Sign up')

    visit new_user_registration_path

    fill_in 'Display Name', with: 'Test user'
    fill_in 'Email', with: 'test@test.com'
    fill_in 'Password', with: '12345678'
    fill_in 'Password confirmation', with: '12345678'

    click_button 'Sign up'

    expect(page).to_not have_link_or_button('Sign up')
    expect(page).to have_content 'Welcome! You have signed up successfully.'
    expect(current_path).to eq root_path
  end

  scenario 'Sign up with invalid attributes' do
    visit new_user_registration_path

    fill_in 'Display Name', with: 'Test user'
    fill_in 'Email', with: 'testtest.com'
    fill_in 'Password', with: '12345678'
    fill_in 'Password confirmation', with: '123456'

    click_button 'Sign up'

    expect(page).to have_content 'Email is invalid'
    expect(current_path).to eq user_registration_path
  end

end
