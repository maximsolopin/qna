require 'rails_helper'

RSpec.describe Vote, type: :model do
  let(:object) { create :answer }
  let(:user) { create :user }

  it { should belong_to(:user) }
  it { should belong_to(:votable) }

  it { should validate_presence_of :user_id }
  it { should validate_presence_of :votable_id }
  it { should validate_presence_of :value }

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