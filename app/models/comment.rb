class Comment < ActiveRecord::Base
  belongs_to :commentable, polymorphic: true, touch: true
  belongs_to :user

  validates :body, presence: true
  validates :user_id, presence: true

  default_scope { order('created_at') }
end