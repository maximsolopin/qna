class Subscription < ActiveRecord::Base
  belongs_to :subscription, class_name: 'Question', foreign_key: 'question_id'
  belongs_to :subscribers, class_name: 'User', foreign_key: 'user_id'

  validates :subscription, :subscribers, presence: true
end
