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

  it_behaves_like 'Attachable'
  it_behaves_like 'Commentable'

  let(:user) { create(:user) }
  subject { build(:question, user: user) }

  it 'subscribe after question created' do
    expect(subject).to receive(:subscribe_author)
    subject.save!
  end
end
