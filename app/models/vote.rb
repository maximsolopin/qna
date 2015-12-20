class Vote < ActiveRecord::Base
  belongs_to :user
  belongs_to :votable, polymorphic: true

  validates :value, presence: true
  validates :user_id, presence: true, uniqueness: { scope: [:votable_type, :votable_id] }
end