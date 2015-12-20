require_relative 'acceptance_helper'
 
 feature 'Voting for answer', %q{
   In order to vote for answer
   As an authorized user
   I want to be able to vote for answer
 } do
 
   given(:user) { create :user }
   given(:answer) { create :answer, user: user }
   given(:answer_second) { create :answer }
 
   scenario 'Unauthenticated user try to vote for answer', js: true  do
    visit question_path answer_second.question
       
    within '.answer-votes' do
      expect(page).to_not have_link 'Reset'
      expect(page).to_not have_link 'Up'
      expect(page).to_not have_link 'Down'
    end
  end

   describe 'Authenticated user try to vote for answer', js: true  do
    before do
      sign_in user
    end

    scenario 'sees links for voting answer', js: true do
      visit question_path answer_second.question
      
      within '.answer-votes' do
        expect(page).to_not have_link 'Reset'
        expect(page).to have_link 'Up'
        expect(page).to have_link 'Down'
      end
    end

    scenario 'Vote for answer', js: true do
      visit question_path answer_second.question

      within '.answer-votes' do
        click_on 'Up'
        expect(page).to have_link 'Reset'
        expect(page).to have_content '1'
      end
  end

  scenario 'Vote for yours answer', js: true do
      visit question_path answer.question

      within '.answer-votes' do
        expect(page).to_not have_link 'Reset'
        expect(page).to_not have_link 'Up'
        expect(page).to_not have_link 'Down'
      end
  end 

  scenario 'Reset vote', js: true do
      visit question_path answer_second.question

      within '.answer-votes' do
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