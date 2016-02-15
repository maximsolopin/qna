class Question < ActiveRecord::Base
  include Attachable
  include Votable
  include Commentable

  has_many :answers, dependent: :destroy
  belongs_to :user

  scope :last_day_questions, -> { where(created_at: 1.day.ago.all_day) }

  validates :title, presence: true
  validates :body, presence: true
  validates :user_id, presence: true
end
