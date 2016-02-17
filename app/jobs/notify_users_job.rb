class NotifyUsersJob < ActiveJob::Base
  queue_as :default

  def perform(question)
    question.subscriptions.find_each do |s|
      SubscribersMailer.question_notifier(s.user, question).deliver_later
    end
  end
end