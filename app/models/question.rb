class Question < ActiveRecord::Base
  include Attachable
  include Votable

  has_many :answers, dependent: :destroy
  belongs_to :user

  validates :title, presence: true
  validates :body, presence: true
  validates :user_id, presence: true
end
