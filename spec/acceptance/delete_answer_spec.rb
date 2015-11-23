require_relative 'acceptance_helper'

feature 'Delete answer', %q{
  In order to be able to delete answer
  As an authencticated user
  I want to be able to delete answer
} do

  given(:first_user) { create(:user) }
  given(:second_user) { create(:user) }

  given!(:question) { create(:question, user: first_user) }
  given!(:answer) { create(:answer, user: first_user, question: question) }

  scenario 'User can delete your answer' do
    sign_in(first_user)
    visit question_path(question)

    click_on "Delete answer"

    expect(page).to_not have_content "MyStringAnswer"
    expect(page).to have_content "Answer deleted"
  end

  scenario 'Different user can\'t delete answer' do
    sign_in(second_user)
    visit question_path(question)

    expect(page).not_to have_selector("Delete answer")
  end

  scenario 'Different user can\'t delete answer' do
    sign_in(second_user)
    visit question_path(question)

    expect(page).not_to have_selector("Delete answer")
  end

  scenario 'Non-authencticated user ties delete answer' do
    visit question_path(question)
    expect(page).not_to have_selector("Delete answer")
  end
end

