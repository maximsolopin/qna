require 'rails_helper'

RSpec.describe Subscription, type: :model do
  it { should validate_presence_of :question_id }
  it { should validate_presence_of :user_id }

  it { should belong_to :question }
  it { should belong_to :user }

  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  subject { create(:subscription, user: user, question: question) }

  context 'subscribe' do
    it 'tries to subscribe' do
      expect { subject }.to change(question.subscriptions, :count).by(1)
    end

    it 'tries to subscribe twice' do
      subject
      expect { subject }.to_not change(question.subscriptions, :count)
    end
  end

  context 'unsubscribe' do
    it 'tries to unsubscribe' do
      subject
      expect { subject.destroy! }.to change(question.subscriptions, :count).by(-1)
    end

    it 'tries to unsubscribe if not subsribed yet' do
      expect { subject.destroy! }.to_not change(question.subscriptions, :count)
    end
  end
end
