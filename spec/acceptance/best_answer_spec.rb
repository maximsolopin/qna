require_relative 'acceptance_helper'

feature 'Set best answer', %q{
  In order to set best answer
  As an author of question
  I want to set best answer of my answer
} do

  given!(:user) { create(:user) }
  given!(:second_user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, user: user, question: question) }
  given!(:answer_second) { create(:answer, user: user, question: question) }

  scenario 'Unauthenticated user try to set best answer', js: true  do
    visit question_path(question)

    within '.answers' do
      expect(page).to_not have_css 'i.fa.fa-thumbs-o-up'
    end
  end

  scenario 'Different user try to set best answer', js: true do
    sign_in second_user
    visit question_path(question)

    expect(page).to_not have_css 'i.fa.fa-thumbs-o-up'
  end

  describe 'Authenticated user', js: true  do
    before do
      sign_in user
      visit question_path(question)
    end

    scenario 'sees link to Best answer', js: true do
      within '.answers' do
        expect(page).to have_css 'i.fa.fa-thumbs-o-up'
      end
    end

    scenario 'try to set best answer to his question', js: true do

      within ".answers #answer-id-#{answer.id}" do
        find(:css, 'i.fa.fa-thumbs-o-up').click
        expect(page).to_not have_css 'i.fa.fa-thumbs-o-up'
      end

      within ".answers #answer-id-#{answer_second.id}" do
        find(:css, 'i.fa.fa-thumbs-o-up').click
      end

      within ".answers #answer-id-#{answer.id}" do
        expect(page).to have_css 'i.fa.fa-thumbs-o-up'
      end
    end

    scenario 'best answer first on page', js: true do

      within ".answers #answer-id-#{answer.id}" do
        find(:css, 'i.fa.fa-thumbs-o-up').click
      end

      within('.answers .panel:first-child div:last-child p:first-child') do
        expect(page).to have_content answer.body
      end

      within ".answers #answer-id-#{answer_second.id}" do
        find(:css, 'i.fa.fa-thumbs-o-up').click
      end

      within('.answers .panel:first-child div:last-child p:first-child') do
        expect(page).to have_content answer_second.body
      end
    end
  end
end