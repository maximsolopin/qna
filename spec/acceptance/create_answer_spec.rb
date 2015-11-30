require_relative 'acceptance_helper'

feature 'Create answer', %q{
  In order to create answer
  As an authencticated user
  I want to be able to answer to question
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question) }

  scenario 'Authencticated user create answer', js: true do
    sign_in(user)
    visit question_path question
    expect(current_path).to eq question_path(question)

    fill_in 'Your answer', with: 'Test answer body'
    click_on 'Create'

    within '.answers' do
      expect(page).to have_content 'Test answer'
    end
  end

  scenario 'Authencticated user try to create answer', js: true do
    sign_in(user)
    visit question_path question
    expect(current_path).to eq question_path(question)

    click_on 'Create'

    expect(page).to have_content "Body can't be blank"
  end

  scenario 'Non-authencticated user ties create answer', js: true do
    visit question_path question
    expect(current_path).to eq question_path(question)

    expect(page).to_not have_content 'Create Answer'

    # click_on "Create"
    # expect(page).to have_content 'You need to sign in or sign up before continuing.'
    # expect(current_path).to eq new_user_session_path
  end
end
