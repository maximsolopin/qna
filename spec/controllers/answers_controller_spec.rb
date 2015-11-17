require 'rails_helper'

describe AnswersController do
  let(:user) { create(:user) }
  let(:user_second) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:answer) { create(:answer, question: question, user: @user) }
  let(:answer_second) { create(:answer, question: question, user: user_second) }

  sign_in_user

  describe 'GET #new' do
    before { get :new, question_id: question }

    it 'assigns a new Answer to @answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'GET #edit' do
    before { get :edit, id: answer, question_id: question }

    it 'assigns the requested answer to @answer' do
      expect(assigns(:answer)).to eq answer
    end

    it 'renders edit view' do
      expect(response).to render_template :edit
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      before { post :create, answer: attributes_for(:answer), question_id: question }

      it 'saves the new answer in the database' do
        expect { post :create, answer: attributes_for(:answer), question_id: question }.to change(Answer, :count).by(1)
      end

      it 'answer should be added to question' do
        expect { post :create, answer: attributes_for(:answer), question_id: question }.to change(question.answers, :count).by(1)
      end

      it 'redirects to question show view' do
        expect(response).to redirect_to question_path(question)
      end
    end

    context 'with invalid attributes' do
      it 'does not save the answer in the database' do
        expect { post :create, answer: attributes_for(:invalid_answer), question_id: question }.to_not change(Answer, :count)
      end

      it 're-renders new view' do
        post :create, answer: attributes_for(:invalid_answer), question_id: question
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do
    context 'valid attributes' do
      it 'assigns the requested answer to @answer' do
        patch :update, id: answer, answer: attributes_for(:answer), question_id: question
        expect(assigns(:answer)).to eq answer
      end

      it 'change answer attributes' do
        patch :update, id: answer, answer: { body: 'new body' }, question_id: question
        answer.reload
        expect(answer.body).to eq 'new body'
      end

      it 'change not yours answer attributes' do
        patch :update, id: answer, answer: { body: 'new body' }, question_id: question
        answer.reload
        expect(answer.body).to eq 'new body'
      end

      it 'redirects to the updated answer' do
        patch :update, id: answer, answer: attributes_for(:answer), question_id: question
        expect(response).to redirect_to question
      end
    end

    context 'invalid attributes' do
      before { patch :update, id: answer, answer: { body: nil }, question_id: question }

      it 'does not change answer attributes' do
        answer.reload
        expect(answer.body).to eq answer.body
      end

      it 're-renders edit view' do
        expect(response).to render_template :edit
      end
    end

    context 'different user' do
      before { patch :update, id: answer_second, answer: attributes_for(:answer), question_id: question }

      it 'does not change answer attributes' do
        answer.reload
        expect(answer.body).to eq answer.body
      end

      it 'redirects to question show view' do
        expect(response).to redirect_to question_path(question)
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'valid user' do
      before { answer }

      it 'deletes answer' do
        expect { delete :destroy, id: answer, question_id: question }.to change(Answer, :count).by(-1)
      end

      it 'redirect to index view' do
        delete :destroy, id: answer, question_id: question
        expect(response).to redirect_to question
      end
    end

    context 'invalid user' do
      before { answer_second }

      it 'deletes answer' do
        expect { delete :destroy, id: answer_second, question_id: question }.to change(Answer, :count).by(0)
      end

      it 'has a 200 status code' do
        expect(response.status).to eq(200)
      end
    end
  end
end
