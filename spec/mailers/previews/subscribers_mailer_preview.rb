# Preview all emails at http://localhost:3000/rails/mailers/subscribers_mailer
class SubscribersMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/subscribers_mailer/question_notifier
  def question_notifier
    SubscribersMailer.question_notifier
  end

end
