require 'rails_helper'

feature 'Delete question', %q{
  In order to be able to delete question
  As an authencticated user
  I want to be able to delete question
} do

  given(:first_user) { create(:user) }
  given(:second_user) { create(:user) }

  given!(:question) { create(:question, user: first_user) }

  scenario 'User can delete your question' do
    sign_in(first_user)
    visit question_path(question)

    click_on "Delete question"

    expect(page).to have_content "Question deleted"
    expect(page).not_to have_content question.title
  end

  scenario 'Different user can\'t delete question' do
    sign_in(second_user)
    visit question_path(question)

    expect(page).not_to have_selector("input[type=submit][value='Delete question']")
  end

  scenario 'Non-authencticated user ties delete question' do
    visit question_path(question)
    expect(page).not_to have_selector("Delete question")
  end
end
