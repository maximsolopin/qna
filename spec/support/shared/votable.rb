shared_examples_for 'Votable' do |subject|
  let(:user) { create(:user) }
  let(:object) { create(subject.to_s.underscore.to_sym, user: user) }
  let(:object_second) { create(subject.to_s.underscore.to_sym) }

  before { sign_in user }

  describe 'patch #vote_up' do
    it "can vote for #{subject}" do
      expect { patch :vote_up, id: object_second, format: :json }.to change(object_second.votes, :count)
      expect(object_second.votes.rating).to eq 1
      expect(response).to render_template :vote
    end

    it "vote for yours #{subject}" do
      expect { patch :vote_up, id: object, format: :json }.to_not change(object.votes, :count)
    end
  end

  describe 'patch #vote_down' do
    it "can vote for #{subject}" do
      expect { patch :vote_down, question_id: question, id: object_second, format: :json }.to change(object_second.votes, :count)
      expect(object_second.votes.rating).to eq -1
      expect(response).to render_template :vote
    end

    it "vote for yours #{subject}" do
      expect { patch :vote_down, id: object, format: :json }.to_not change(object.votes, :count)
    end
  end

  describe 'patch #vote_reset' do
    it "can reset votes for #{subject}" do
      patch :vote_up, question_id: question, id: object_second, format: :json
      expect { patch :vote_reset, question_id: question, id: object_second, format: :json }.to change(object_second.votes, :count)
      expect(object_second.votes.rating).to eq 0
      expect(response).to render_template :vote
    end
  end
end