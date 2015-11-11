class Question < ActiveRecord::Base
  has_many :answers, dependent: :destroy

  validates :title, presence: true
  validates :body, presence: true
end
