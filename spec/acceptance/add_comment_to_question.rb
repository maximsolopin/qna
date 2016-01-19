feature 'Add comment to question', %q{
   In order to communicate
   As an authencticated user
   I want to be able to add comment to question
} do
  given(:user) { create(:user) }
  given(:question) { create(:question) }

  scenario 'Authencticated user create comment', js: true do
    sign_in(user)

    visit question_path(question)

    fill_in 'Comment', with: 'Test comment'
    click_on 'Add comment'

    expect(page).to have_content 'Test comment'
  end

  scenario 'Non-authencticated user ties create comment' do
    visit question_path(question)

    expect(page).to_not have_content 'Add comment'
  end
end