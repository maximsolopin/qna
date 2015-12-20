module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :destroy
  end

  def vote_up
    set_vote(1)
  end

  def vote_down
    set_vote(-1)
  end

  def vote_reset
    reset_vote
  end

  private

  def set_vote(value)
    vote = votes.find_or_create_by(user: current_user)
    vote.set_vote(value)
  end

  def reset_vote
    vote = votes.find_by(user: current_user)
    vote.reset_vote
  end

end