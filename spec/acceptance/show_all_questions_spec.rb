require 'rails_helper'

feature 'Show questions', %q{
  In order to view all questions
  As all users
  I want to view list of all questions
} do

  given!(:questions) { create_list(:question, 2) }

  scenario 'All users can view questions' do
    visit questions_path

    questions.each do |question|
      expect(page).to have_content question.title
    end
  end
end
