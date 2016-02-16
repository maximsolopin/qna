require 'rails_helper'

RSpec.describe NotifyUsersJob, type: :job do
  let(:user) { create_list(:user) }
  let(:question) { create :question }

  it 'sends notification for question' do
    question.subscribers.each { |user| expect(SubscribersMailer).to receive(:question_notifier).with(user, question).and_call_original }
    NotifyUsersJob.perform_now(question)
  end
end