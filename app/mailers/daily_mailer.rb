class DailyMailer < ApplicationMailer
  def digest(user)
    @greeting = "Hello #{user.display_name}"
    @questions = Question.last_day_questions

    mail to: user.email, subject: 'Daily digest'
  end
end
