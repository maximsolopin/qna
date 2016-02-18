class Question < ActiveRecord::Base
  include Attachable
  include Votable
  include Commentable

  has_many :answers, dependent: :destroy
  belongs_to :user

  has_many :subscriptions, dependent: :destroy
  # has_many :subscribers, through: :subscriptions, class_name: 'User', dependent: :destroy

  scope :last_day_questions, -> { where(created_at: 1.day.ago.all_day) }

  validates :title, presence: true
  validates :body, presence: true
  validates :user_id, presence: true

  after_create :subscribe_author
  
  def subscribed?(user)
    !!self.subscriptions.where(user_id: user.id).first
  end

  private

  def subscribe_author
    self.subscriptions.create(user: user)
  end
end
