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
    click_on 'Add file'

    attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"

    click_on 'Create'

    within '.answers' do
      expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
    end
  end

  scenario 'User adds two files when answer on question', js: true do
    fill_in 'Your answer', with: 'Test answer body'

    click_on 'Add file'
    click_on 'Add file'

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
      click_link 'Edit answer'
      fill_in 'Answer', with: 'Edit answer'

      click_link 'Add file'
      attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"

      click_on 'Save answer'

      expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
    end
  end
end