class Answer < ActiveRecord::Base
  include Attachable
  include Votable
  include Commentable

  belongs_to :question, touch: true
  belongs_to :user

  validates :body, presence: true
  validates :user_id, presence: true
  validates :question_id, presence: true

  default_scope { order('best desc','created_at') }

  after_save :notify_subscribers

  def set_best
    Answer.transaction do
      question.answers.update_all(best: false)
      update!(best: true)
    end
  end

  def notify_subscribers
    NotifyUsersJob.perform_later(question)
  end
end
