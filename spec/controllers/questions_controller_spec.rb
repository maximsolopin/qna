require 'rails_helper'

describe QuestionsController do
  let(:user) { create(:user) }
  let(:user_second) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:question_second) { create(:question, user: user_second) }

  sign_in_user
  before { question.update!(user: @user) }

  describe 'GET #index' do
    let(:questions) { create_list(:question, 2, user: user) }

    before { get :index }

    it 'populates an array of all questions' do
      expect(assigns(:questions)).to match_array(Question.all)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    before { get :show, id: question }

    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    before { get :new }

    it 'assigns a new Question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'GET #edit' do
    before { get :edit, id: question }

    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'renders edit view' do
      expect(response).to render_template :edit
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      subject { post :create, question: attributes_for(:question) }

      it 'saves the new question in the database' do
        expect { subject }.to change(Question, :count).by(1)
      end

      it 'redirects to show view' do
        subject
        expect(response).to redirect_to question_path(assigns(:question))
      end

      it_behaves_like 'Publishable' do
        let(:channel) { '/questions' }
      end
    end

    context 'with invalid attributes' do
      it 'does not save the question in the database' do
        expect { post :create, question: attributes_for(:invalid_question) }.to_not change(Question, :count)
      end

      it 're-renders new view' do
        post :create, question: attributes_for(:invalid_question)
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do
    context 'valid attributes' do
      it 'assigns the requested question to @question' do
        patch :update, id: question, question: attributes_for(:question)
        expect(assigns(:question)).to eq question
      end

      it 'change question attributes' do
        patch :update, id: question, question: { title: 'new title', body: 'new body' }
        question.reload
        expect(question.title).to eq 'new title'
        expect(question.body).to eq 'new body'
      end

      it 'redirects to the updated question' do
        patch :update, id: question, question: attributes_for(:question)
        expect(response).to redirect_to question
      end
    end

    context 'invalid attributes' do
      before { patch :update, id: question, question: { title: 'new title', body: nil } }

      it 'does not change question attributes' do
        question.reload
        expect(question.title).to_not eq 'new title'
        expect(question.body).to_not eq nil
      end

      it 're-renders edit view' do
        expect(response).to render_template :edit
      end
    end

    context 'invalid user' do
      before { patch :update, id: question_second, question: attributes_for(:question) }

      it 'does not change question attributes' do
        question.reload
        expect(question.title).to_not eq 'new title'
        expect(question.body).to_not eq nil
      end

      it 'has not success status code' do
        expect(response).not_to be_success
      end
    end
  end

  describe 'DELETE #destroy' do
    before { question }

    it 'deletes yours own question' do
      expect { delete :destroy, id: question }.to change(Question, :count).by(-1)
    end

    context 'deletes not your question' do
      let!(:another_question) { create(:question, user: user) }

      it 'should not destroy question' do
        expect{ delete :destroy, id: another_question }.to_not change(Question, :count)
      end
    end

    it 'redirect to index view' do
      delete :destroy, id: question
      expect(response).to redirect_to questions_path
    end
  end

  describe 'patch #vote_up' do
    let(:question) { create(:question, user: @user) }
    let(:question_second) { create(:question, user: user_second) }
    
    it 'can vote for answer' do
       expect { patch :vote_up, id: question_second, format: :json }.to change(question_second.votes, :count)
       expect(question_second.votes.rating).to eq 1
       expect(response).to render_template :vote
    end

    it 'vote for yours answer' do
       expect { patch :vote_up, id: question, format: :json }.to_not change(question.votes, :count)
    end
  end

  describe 'patch #vote_down' do
    let(:question) { create(:question, user: @user) }
    let(:question_second) { create(:question, user: user_second) }
    
    it 'can vote for answer' do
       expect { patch :vote_down, id: question_second, format: :json }.to change(question_second.votes, :count)
       expect(question_second.votes.rating).to eq -1
       expect(response).to render_template :vote
    end

    it 'vote for yours answer' do
       expect { patch :vote_down, id: question, format: :json }.to_not change(question.votes, :count)
    end
  end

  describe 'patch #vote_reset' do
    let(:question) { create(:question, user: @user) }
    let(:question_second) { create(:question, user: user_second) }
    
    it 'can reset votes for answer' do
       patch :vote_up, id: question_second, format: :json
       expect { patch :vote_reset, id: question_second, format: :json }.to change(question_second.votes, :count)
       expect(question_second.votes.rating).to eq 0
       expect(response).to render_template :vote
    end
  end
end
