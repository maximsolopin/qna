class NotifyUsersJob < ActiveJob::Base
  queue_as :default

  def perform(question)
    question.subscribers.each do |user|
      SubscribersMailer.question_notifier(user, question)
    end
  end
end
