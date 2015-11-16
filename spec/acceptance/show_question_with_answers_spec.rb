require 'rails_helper'

feature 'View question with answers', %q{
  In order to view question with all answers
  As all users
  I want to view question with answers
} do

  given!(:question) { create(:question) }
  given!(:answers) { create_list(:answer, 2, question: question) }

  scenario 'All users can view question with answers' do
    visit question_path question

    expect(current_path).to eq question_path(question)

    expect(page).to have_content 'MyString'
    expect(page).to have_content 'MyText'

    answers.each do |a|
      expect(page).to have_content a.body
    end

  end
end
