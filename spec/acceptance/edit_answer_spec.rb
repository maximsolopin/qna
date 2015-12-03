require_relative 'acceptance_helper'

feature 'Answer editing', %q{
  In order to fix mistake
  As an author of answer
  I'd like to be able to edit my answer
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create :answer, question: question }

  scenario 'Unauthenticated user try to edit question' do
    visit question_path(question)

    expect(page).to_not have_css 'i.fa.fa-pencil'
  end

  scenario "Authenticated user try to edit other user's question" do
    sign_in user
    visit question_path(question)

    within '.answers' do
      expect(page).to_not have_css 'i.fa.fa-pencil'
    end
  end


  describe 'Authenticated user' do
    given!(:answer) { create(:answer, user: user, question: question) }
    before do
      sign_in user
      visit question_path(question)
    end

    scenario 'sees link to Edit answer' do
      within '.answers' do
        expect(page).to have_css 'i.fa.fa-pencil'
      end
    end

    scenario 'try to edit his answer', js: true do
      within ".answers #answer-id-#{answer.id}" do
        find(:css, 'i.fa.fa-pencil').click
      end

      within "#edit-answer-#{answer.id}" do
        fill_in 'answer_body', with: 'edited answer'
        find(:css, 'i.fa.fa-floppy-o').click
      end

      within ".answers #answer-id-#{answer.id}" do
        expect(page).to_not have_content answer.body
        expect(page).to have_content 'edited answer'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'try to edit his answer with invalid attributes', js: true do
      within ".answers #answer-id-#{answer.id}" do
        find(:css, 'i.fa.fa-pencil').click
      end

      within "#edit-answer-#{answer.id}" do
        fill_in 'answer_body', with: ''
        find(:css, 'i.fa.fa-floppy-o').click
      end

      expect(page).to have_content "Body can't be blank"
    end

  end
end