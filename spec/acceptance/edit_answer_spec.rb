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

    expect(page).to_not have_link 'Edit answer'
  end

  scenario "Authenticated user try to edit other user's question" do
    sign_in user
    visit question_path(question)

    within '.answers' do
      expect(page).to_not have_link 'Edit answer'
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
        expect(page).to have_link 'Edit answer'
      end
    end

    scenario 'try to edit his answer', js: true do
      within '.answers' do
        click_on 'Edit answer'
        fill_in 'Answer', with: 'edited answer'
        click_on 'Save answer'

        expect(page).to_not have_content answer.body
        expect(page).to have_content 'edited answer'
        expect(page).to_not have_selector 'textarea'

      end
    end

    scenario 'try to edit his answer with invalid attributes', js: true do
      click_on 'Edit answer'
      within '.answers' do
        fill_in 'Answer', with: ''
        click_on 'Save answer'

        expect(page).to have_content answer.body
      end
      expect(page).to have_content "Body can't be blank"
    end

  end
end