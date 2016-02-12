shared_examples_for 'Votable' do |subject|
  let(:object) { create subject.to_s.underscore.to_sym  }
  let(:user) { create :user }

  describe 'voting' do
    it 'vote_up' do
      object.vote_up(user)
      expect(object.votes.rating).to eq 1
    end

    it 'vote_down' do
      object.vote_down(user)
      expect(object.votes.rating).to eq -1
    end

    it 'vote_reset' do
      object.vote_up(user)
      expect(object.votes.rating).to eq 1
      object.vote_reset(user)
      expect(object.votes.rating).to eq 0
    end

    it 'cant vote twice' do
      object.vote_up(user)
      expect(object.votes.rating).to eq 1
      object.vote_up(user)
      expect(object.votes.rating).to eq 1
    end
  end
end