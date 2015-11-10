class Question < ActiveRecord::Base
  validates :title, presence: true
  validates :body, presence: true

  has_many :answers, dependent: :destroy
end
