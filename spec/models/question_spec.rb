require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should validate_presence_of :title }
  it { should validate_presence_of :body }
  it { should validate_presence_of :user_id }

  it { should belong_to(:user) }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:attachments).dependent(:destroy) }
  it { should have_many(:votes).dependent(:destroy) }
  it { should have_many(:subscriptions).dependent(:destroy) }
  it { should have_many(:subscribers).through(:subscriptions).class_name('User').dependent(:destroy) }

  it_behaves_like 'Attachable'
  it_behaves_like 'Commentable'

  let(:user) { create(:user) }
  subject { build(:question, user: user) }
  let!(:question) { create(:question) }

  it 'subscribe after question created' do
    expect(subject).to receive(:subscribe).with(user)
    subject.save!
  end

  context 'subscribe' do
    it 'tries to subscribe' do
      expect { question.subscribe(user) }.to change(question.subscribers, :count).by(1)
    end

    it 'tries to subscribe twice' do
      question.subscribe user
    expect { question.subscribe(user) }.to_not change(question.subscribers, :count)
    end
  end

  context 'unsubscribe' do
    it 'tries to unsubscribe' do
      question.subscribe user
      expect { question.unsubscribe(user) }.to change(question.subscribers, :count).by(-1)
    end

    it 'tries to unsubscribe if not subsribed yet' do
      expect { question.unsubscribe(user) }.to_not change(question.subscribers, :count)
    end
  end
end
