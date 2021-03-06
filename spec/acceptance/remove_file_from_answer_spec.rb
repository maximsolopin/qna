require_relative 'acceptance_helper'

feature 'Remove files from answer', %q{
  In order to delete files
  As answer's author
  I'd like to be able to remove files
} do

  given(:user) { create(:user) }
  given(:user_second) { create(:user) }
  given(:question) { create(:question) }
  given(:answer) { create(:answer, question: question, user: user) }
  given!(:attachment) { create(:attachment, attachable: answer) }

  scenario 'Author try to remove file from answer', js: true do
    sign_in(user)
    visit question_path(question)

    within '.answers' do
      find(:css, 'i.fa.fa-pencil').click

      check "remove_attachment_#{attachment.id}"
      find(:css, 'i.fa.fa-floppy-o').click
    end

    expect(page).to_not have_content attachment.file.identifier
  end

  scenario 'Different user tries to remove file from answer', js: true do
    sign_in(user_second)
    visit question_path(question)

    expect(page).to_not have_css 'i.fa.fa-pencil'
    expect(page).to_not have_selector "remove_attachment_#{attachment.id}"
  end
end 
