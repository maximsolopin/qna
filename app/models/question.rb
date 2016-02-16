class Question < ActiveRecord::Base
  include Attachable
  include Votable
  include Commentable

  has_many :answers, dependent: :destroy
  belongs_to :user

  has_many :subscriptions, dependent: :destroy
  has_many :subscribers, through: :subscriptions, class_name: 'User', dependent: :destroy

  scope :last_day_questions, -> { where(created_at: 1.day.ago.all_day) }

  validates :title, presence: true
  validates :body, presence: true
  validates :user_id, presence: true

  after_create :subscribe_author

  def subscribe(user)
    subscribers << user unless subscribed?(user)
  end
  
  def unsubscribe(user)
    subscribers.delete(user) if subscribed?(user)
  end
  
  def subscribed?(user)
    subscribers.include? user
  end

  private

  def subscribe_author
    subscribe(user)
  end
end
