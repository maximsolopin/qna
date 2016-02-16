require_relative 'acceptance_helper'

feature 'Subscribe to the question', %q{
   In order to subscribe to the questions
   As an authenticated user
   I'd to be able to subscribe to the question
 } do

  given(:user) { create(:user) }
  given(:question) { create (:question) }

  scenario 'Unauthenticated user try to subscribe to the question'  do
    visit question_path(question)

    expect(page).to_not have_link 'Subscribe'
  end

  describe 'Authenticated user' do
    scenario 'User try to subscribe to the question' do
      sign_in(user)
      visit question_path(question)

      click_on 'Subscribe'

      expect(page).to_not have_link 'Subscribe'
      expect(page).to have_link 'Unsubscribe'
    end

    scenario 'User try to unsubscribe from the question' do
        sign_in user
        visit question_path question

        click_on 'Subscribe'
        click_on 'Unsubscribe'

        expect(page).to have_link 'Subscribe'
        expect(page).to_not have_link 'Unsubscribe'
    end
  end
end
