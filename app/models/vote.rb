class Vote < ActiveRecord::Base
  belongs_to :user
  belongs_to :votable, polymorphic: true

  validates :value, presence: true
  validates :votable_id, presence: true
  validates :user_id, presence: true, uniqueness: { scope: [:votable_type, :votable_id] }

  def set_vote(value)
    self.value = value
    save
  end

  def reset_vote
    self.destroy
  end

  def self.rating
    sum(:value)
  end
end