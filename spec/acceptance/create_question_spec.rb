require_relative 'acceptance_helper'

feature 'Create question', %q{
  In order to get answer from community
  As an authencticated user
  I want to be able to ask questions
} do

  given(:user) { create(:user) }

  scenario 'Authencticated user create question' do
    sign_in(user)

    visit questions_path
    click_on 'Ask Question'
    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'Test body'
    click_on 'Create'

    expect(page).to have_content 'Your question successfully created'
    expect(page).to have_content 'Test question'
    expect(page).to have_content 'Test body'
  end

  scenario 'Non-authencticated user ties create question' do
    visit questions_path
    click_on 'Ask Question'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
