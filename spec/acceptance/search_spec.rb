require_relative 'acceptance_helper'
require_relative 'sphinx_helper'

feature 'Search', %q{
   In order to be able to find anything
   As an user
   I want to search
  } do

  given!(:user) { create :user, display_name: 'Test dude' }
  given!(:answer) { create :answer, body: 'London is the capital of Great Britain' }
  given!(:question) { create :question, title: 'How do u do?' }
  given!(:comment) { create :comment, body: 'What do u mean?', commentable: question }

  before do
    index
    visit root_path
  end

  scenario 'User try to find users', js: true do
    fill_in 'query', with: 'dude'
    select 'Users', from: 'condition'
    click_on 'Search'

    expect(page).to have_content user.display_name
  end

  scenario 'User try to find answers', js: true do
    fill_in 'query', with: 'London'
    select('Answers', from: 'condition')
    click_on 'Search'

    expect(page).to have_content answer.body.truncate(30)
  end

  scenario 'User try to find questions', js: true do
    fill_in 'query', with: 'How'
    select('Questions', from: 'condition')
    click_on 'Search'

    expect(page).to have_content question.title
  end

  scenario 'User try to find comment', js: true do
    fill_in 'query', with: 'mean'
    select('Comments', from: 'condition')
    click_on 'Search'

    expect(page).to have_content comment.body.truncate(30)
  end

  scenario 'User try to find something', js: true do
    fill_in 'query', with: 'Britain'
    select('Everywhere', from: 'condition')
    click_on 'Search'

    expect(page).to have_content answer.body.truncate(30)
  end
end