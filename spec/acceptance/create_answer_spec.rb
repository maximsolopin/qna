require 'rails_helper'

feature 'Create answer', %q{
  In order to create answer
  As an authencticated user
  I want to be able to answer to question
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question) }

  scenario 'Authencticated user create answer' do
    sign_in(user)
    visit question_path question
    expect(current_path).to eq question_path(question)

    click_on "Create answer"

    fill_in 'Body', with: 'Test answer body'
    click_on 'Create'

    expect(page).to have_content 'Test answer'
  end

end
