require_relative 'acceptance_helper'
 
 feature 'Voting for question', %q{
   In order to vote for question
   As an authorized user
   I want to be able to vote for question
 } do
 
   given(:user) { create :user }
   given(:question) { create :question, user: user }
   given(:question_second) { create :question }
 
   scenario 'Unauthenticated user try to vote for question', js: true  do
    visit question_path question_second
       
    within '.question-votes' do
      expect(page).to_not have_link 'Reset'
      expect(page).to_not have_link 'Up'
      expect(page).to_not have_link 'Down'
    end
  end

   describe 'Authenticated user try to vote for question', js: true  do
    before do
      sign_in user
    end

    scenario 'sees links for voting question', js: true do
      visit question_path question_second
      
      within '.question-votes' do
        expect(page).to_not have_link 'Reset'
        expect(page).to have_link 'Up'
        expect(page).to have_link 'Down'
      end
    end

    scenario 'Vote for question', js: true do
      visit question_path question_second

      within '.question-votes' do
        click_on 'Up'
        expect(page).to have_link 'Reset'
        expect(page).to have_content '1'
      end
  end

  scenario 'Vote for yours question', js: true do
      visit question_path question

      within '.question-votes' do
        expect(page).to_not have_link 'Reset'
        expect(page).to_not have_link 'Up'
        expect(page).to_not have_link 'Down'
      end
  end 

  scenario 'Reset vote', js: true do
      visit question_path question_second

      within '.question-votes' do
        click_on 'Up'
        expect(page).to have_content '0'
        expect(page).to have_link 'Reset'

        click_on 'Reset'
        expect(page).to have_content '0'
        expect(page).to_not have_link 'Reset'
      end
    end
  end
 end