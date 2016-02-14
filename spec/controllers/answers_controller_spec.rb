require 'rails_helper'

describe AnswersController do
  let(:user) { create(:user) }
  let(:user_second) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:answer) { create(:answer, question: question, user: @user) }
  let(:answer_second) { create(:answer, question: question, user: user_second) }
  let(:answer_third) { create(:answer, question: question, user: @user) }

  sign_in_user

  describe 'POST #create' do
    context 'with valid attributes' do
      subject { post :create, answer: attributes_for(:answer), question_id: question, format: :js }

      it 'saves the new answer in the database' do
        expect { subject }.to change(Answer, :count).by(1)
      end

      it 'answer should be added to question' do
        expect { subject }.to change(question.answers, :count).by(1)
      end

      it 'render create template' do
        subject
        expect(response).to render_template :create
      end

      it_behaves_like 'Publishable' do
        let(:channel) { "/questions/#{question.id}/answers" }
      end
    end

    context 'with invalid attributes' do
      subject { post :create, answer: attributes_for(:invalid_answer), question_id: question, format: :js }

      it 'does not save the answer in the database' do
        expect { subject }.to_not change(Answer, :count)
      end

      it 'render create template' do
        subject
        expect(response).to render_template :create
      end
    end
  end

  describe 'PATCH #update' do
    context 'valid attributes' do
      subject { patch :update, id: answer, answer: { body: 'new body' }, question_id: question, format: :js }

      before { subject }

      it 'assigns the requested answer to @answer' do
        expect(assigns(:answer)).to eq answer
      end

      it 'change answer attributes' do
        answer.reload
        expect(answer.body).to eq 'new body'
      end

      it 'change not yours answer attributes' do
        patch :update, id: answer_second, answer: { body: 'new body' }, question_id: question, format: :js
        answer.reload
        expect(answer_second.body).to_not eq 'new body'
      end

      it 'render update template' do
        expect(response).to render_template :update
      end
    end

    context 'invalid attributes' do
      subject { patch :update, id: answer, answer: { body: nil }, question_id: question, format: :js }

      before { subject }

      it 'does not change answer attributes' do
        answer.reload
        expect(answer.body).to eq answer.body
      end

      it 'render update template' do
        expect(response).to render_template :update
      end
    end

    context 'different user' do
      before { patch :update, id: answer_second, answer: attributes_for(:answer), question_id: question, format: :js }

      it 'does not change answer attributes' do
        answer.reload
        expect(answer.body).to eq answer.body
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'valid user' do
      subject { delete :destroy, id: answer, question_id: question, format: :js }

      before  { answer }

      it 'deletes answer' do
        expect { subject }.to change(Answer, :count).by(-1)
      end

      it 'render template destroy' do
        subject
        expect(response).to render_template :destroy
      end
    end

    context 'invalid user' do
      subject { delete :destroy, id: answer_second, question_id: question, format: :js }

      before { answer_second }

      it 'deletes answer' do
        expect { subject }.to change(Answer, :count).by(0)
      end

      it 'has a 200 status code' do
        expect(response.status).to eq(200)
      end
    end
  end

  describe 'PATCH #set_best' do
    subject { patch :set_best, question_id: question, id: answer, format: :js  }

    before { subject }

    it 'assigns answer to @answer' do
      expect(assigns(:answer)).to eq answer
    end
    
    it 'the best answer should be one' do
      patch :set_best, id: answer_third, question_id: question, format: :js
      answer_third.reload

      expect(answer_third.best).to eq true
      expect(answer.best).to eq false
    end

    it 'render set_best template' do
      expect(response).to render_template :set_best
    end
  end

  it_behaves_like 'Votable', Answer
end
