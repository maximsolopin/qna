module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :destroy
  end

  def vote_up(user)
    set_vote(1, user)
  end

  def vote_down(user)
    set_vote(-1, user)
  end

  def vote_reset(user)
    reset_vote(user)
  end

  def user_voted?(user)
    puts votes.find_by(user: user) ? true : false
    votes.find_by(user: user) ? true : false
  end

  private

  def set_vote(value, user)
    vote = votes.find_or_create_by(user: user)
    vote.set_vote(value)
  end

  def reset_vote(user)
    vote = votes.find_by(user: user)
    vote.reset_vote unless vote.nil?
  end
end