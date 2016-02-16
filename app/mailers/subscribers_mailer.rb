class SubscribersMailer < ApplicationMailer
  def question_notifier(user, question)
    @greeting = "Hello #{user.display_name}"
    @question = question

    mail to: user.email, subject: "New answer's notifier"
  end
end
