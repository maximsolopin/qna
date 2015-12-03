require_relative 'acceptance_helper'

feature 'Delete answer', %q{
  In order to be able to delete answer
  As an authencticated user
  I want to be able to delete answer
} do

  given(:first_user) { create(:user) }
  given(:second_user) { create(:user) }

  given(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, user: first_user) }

  scenario 'User can delete your answer', js: true do
    sign_in(first_user)
    visit question_path(question)

    find(:css, 'i.fa.fa-pencil').click

    expect(page).to_not have_content "MyStringAnswer"
  end

  scenario 'Different user can\'t delete answer', js: true do
    sign_in(second_user)
    visit question_path(question)

    expect(page).not_to have_selector("Delete answer")
  end

  scenario 'Different user can\'t delete answer', js: true do
    sign_in(second_user)
    visit question_path(question)

    expect(page).not_to have_selector("Delete answer")
  end

  scenario 'Non-authencticated user ties delete answer', js: true do
    visit question_path(question)
    expect(page).not_to have_selector("Delete answer")
  end
end

