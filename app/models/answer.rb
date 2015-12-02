class Answer < ActiveRecord::Base
  belongs_to :question
  belongs_to :user
  has_many :attachments, as: :attachable, dependent: :destroy

  validates :body, presence: true
  validates :user_id, presence: true
  validates :question_id, presence: true

  accepts_nested_attributes_for :attachments

  default_scope { order('best desc','created_at') }

  def set_best
    Answer.transaction do
      question.answers.update_all(best: false)
      update!(best: true)
    end
  end
end
