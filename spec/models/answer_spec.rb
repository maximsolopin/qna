require 'rails_helper'

RSpec.describe Answer, type: :model do
  let(:user) { create(:user) }
  let(:question) { create(:question) }
  let!(:answers) { create_list(:answer, 3, user: user, question: question) }
  let(:answer) { create(:answer, user: user, question: question, best: false) }

  it { should validate_presence_of :body }
  it { should validate_presence_of :user_id }
  it { should validate_presence_of :question_id }

  it { should belong_to(:user) }
  it { should belong_to(:question) }
  it { should have_many(:votes).dependent(:destroy) }

  describe 'best_answer' do
    it 'should change best attribute' do
      answer.set_best
      answer.reload
      expect(answer.best).to be true
    end

    it 'best answer should be the one' do
      answer.set_best
      answers.each do |answer|
        answer.reload
        expect(answer.best).to_not be true
      end
    end

    it 'best answer should be the first' do
      expect(question.answers.first).to_not eq answer

      answer.set_best
      answer.reload

      expect(question.answers.first).to eq answer
    end
  end

  it 'notify users' do
    expect(NotifyUsersJob).to receive(:perform_later).with(question)
    Answer.create!(attributes_for(:answer).merge(question: question, user: user))
  end

  it_behaves_like 'Attachable'
  it_behaves_like 'Commentable'
end
