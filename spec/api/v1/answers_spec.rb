require 'rails_helper'

describe 'Answers API' do
  let!(:question) { create :question }

  describe 'GET /index' do
    it_behaves_like 'API Authenticable'

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:answers) { create_list(:answer, 2, question: question) }
      let(:answer) { answer = answers.first }

      before { get "/api/v1/questions/#{question.id}/answers", format: :json, access_token: access_token.token }

      it_behaves_like 'API success response'

      it 'returns list of answers' do
        expect(response.body).to have_json_size(2).at_path("answers")
      end

      %w(id body created_at updated_at question_id user_id best).each do |attr|
        it "answer object contains #{attr}" do
          expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("answers/0/#{attr}")
        end
      end
    end

    def do_request(options = {})
      get "/api/v1/questions/#{question.id}/answers", { format: :json }.merge(options)
    end
  end

  describe 'GET /show' do
    let!(:answer) { create :answer, question: question }
    let!(:comment) { create :comment, commentable: answer }
    let!(:attachment) { create :attachment, attachable: answer }

    it_behaves_like 'API Authenticable'

    context 'authorized' do
      let(:user) { create :user }
      let(:access_token) { create :access_token, resource_owner_id: user.id }

      before { get "/api/v1/questions/#{question.id}/answers/#{answer.id}", format: :json, access_token: access_token.token }

      it_behaves_like 'API success response'

      it 'returns answer' do
        expect(response.body).to have_json_size(1)
      end

      %w(id body created_at updated_at question_id user_id best).each do |attr|
        it "answer object contains #{attr}" do
          expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("answer/#{attr}")
        end
      end

      context 'comments' do
        it 'included in answer object' do
        expect(response.body).to have_json_size(1).at_path('answer/comments')
        end

        %w(id body created_at updated_at user_id).each do |attr|
          it "contains #{attr}" do
            expect(response.body).to be_json_eql(comment.send(attr.to_sym).to_json).at_path("answer/comments/0/#{attr}")
          end
        end
      end

      context 'attachments' do
        it 'included in answer object' do
        expect(response.body).to have_json_size(1).at_path('answer/attachments')
        end

        it 'contains url' do
          expect(response.body).to be_json_eql(attachment.file.url.to_json).at_path('answer/attachments/0/url')
        end
      end
    end

    def do_request(options = {})
      get "/api/v1/questions/#{question.id}/answers/#{answer.id}", { format: :json }.merge(options)
    end
  end

  describe 'POST /create' do
    it_behaves_like 'API Authenticable'

    context 'authorized' do
      let(:user) { create :user }
      let(:access_token) { create :access_token, resource_owner_id: user.id }

      context 'with valid attributes' do
        it 'returns 200 status code' do
          post "/api/v1/questions/#{question.id}/answers", format: :json, access_token: access_token.token, answer: attributes_for(:answer)
          expect(response).to be_success
        end

        it 'change answer count' do
          expect { post "/api/v1/questions/#{question.id}/answers", format: :json, access_token: access_token.token, answer: attributes_for(:answer) }.to change(question.answers, :count).by(1)
        end

        it 'user has an answer' do
          expect { post "/api/v1/questions/#{question.id}/answers", format: :json, access_token: access_token.token, answer: attributes_for(:answer) }.to change(user.answers, :count).by(1)
        end
      end

      context 'with invalid attributes' do
        it 'returns 422 status' do
            post "/api/v1/questions/#{question.id}/answers",format: :json, access_token: access_token.token, answer: attributes_for(:invalid_answer)
            expect(response.status).to eql 422
        end

        it 'doesn\'t change answer count' do
          expect { post "/api/v1/questions/#{question.id}/answers", format: :json, access_token: access_token.token, answer: attributes_for(:invalid_answer) }.to_not change(Answer, :count)
        end
      end
    end

    def do_request(options = {})
      get "/api/v1/questions/#{question.id}/answers", { format: :json }.merge(options)
    end
  end
end