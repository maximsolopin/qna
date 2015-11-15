require 'rails_helper'

feature 'Delete question or answer', %q{
  In order to be able to delete question or answer
  As an authencticated user
  I want to be able to delete question or answer
} do

  given(:first_user) { create(:user) }
  given(:second_user) { create(:user) }

  given!(:question) { create(:question, user: first_user) }
  given!(:answer) { create(:answer, user: first_user, question: question) }

  scenario 'User can delete your question' do
    sign_in(first_user)
    visit question_path(question)

    click_on "Delete question"

    expect(page).to have_content "Question deleted"
  end

  scenario 'Different user can\'t delete question' do
    sign_in(second_user)
    visit question_path(question)

    click_on "Delete question"

    expect(page).to have_content "Permision denied"
  end

  scenario 'User can delete your answer' do
    sign_in(first_user)
    visit question_path(question)

    click_on "Delete answer"

    expect(page).to have_content "Answer deleted"
  end

  scenario 'Different user can\'t delete answer' do
    sign_in(second_user)
    visit question_path(question)

    click_on "Delete answer"

    expect(page).to have_content "Permision denied"
  end
end
