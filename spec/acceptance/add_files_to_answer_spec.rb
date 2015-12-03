require_relative 'acceptance_helper'

feature 'Add files to answer', %q{
  In order to illustrate my answer
  As an answer's author
  I'd like to be able to attach files
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, user: user) }

  background do
    sign_in(user)
    visit question_path(question)
  end

  scenario 'User adds file when answer on question', js: true do
    fill_in 'Your answer', with: 'Test answer body'

    find(:css, 'i.fa.fa-plus').click

    all("input[type='file']").first.set("#{Rails.root}/spec/spec_helper.rb")

    click_on 'Create'

    within '.answers' do
      expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
    end
  end

  scenario 'User adds two files when answer on question', js: true do
    fill_in 'Your answer', with: 'Test answer body'

    find(:css, 'i.fa.fa-plus').click
    find(:css, 'i.fa.fa-plus').click

    all("input[type='file']").first.set("#{Rails.root}/spec/spec_helper.rb")
    all("input[type='file']").last.set("#{Rails.root}/spec/rails_helper.rb")

    click_on 'Create'

    within '.answers' do
      expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
      expect(page).to have_link 'rails_helper.rb', href: '/uploads/attachment/file/2/rails_helper.rb'
    end
  end

  scenario 'User adds file when edit answer', js: true do
    within "#answer-id-#{answer.id}" do
      find(:css, 'i.fa.fa-pencil').click
    end

    within "#edit-answer-#{answer.id}" do
      fill_in 'answer_body', with: 'Edit answer'
      find(:css, 'i.fa.fa-plus').click
      all("input[type='file']").first.set("#{Rails.root}/spec/spec_helper.rb")

      find(:css, 'i.fa.fa-floppy-o').click
    end

    within "#answer-id-#{answer.id}" do
      expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
    end
  end
end