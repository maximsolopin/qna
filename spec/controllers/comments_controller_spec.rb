require 'rails_helper'

describe CommentsController do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:answer) { create(:answer, question: question, user: @user) }
  let(:comment) { create(:comment) }

  sign_in_user

  describe 'POST #create' do
    context 'with valid attributes' do
      it "saves the new answer's commment in the database" do
        expect { post :create, answer_id: answer, comment: attributes_for(:comment), format: :js }.to change(answer.comments, :count).by(1)
      end

      it "saves the new question's commment in the database" do
        expect { post :create, question_id: question, comment: attributes_for(:comment), format: :js }.to change(question.comments, :count).by(1)
      end
    end

    context 'with invalid attributes' do
      it 'does not save the comment in the database' do
        expect { post :create, answer_id: answer, comment: attributes_for(:invalid_comment), format: :js }.to_not change(Comment, :count)
      end
    end
  end
end
