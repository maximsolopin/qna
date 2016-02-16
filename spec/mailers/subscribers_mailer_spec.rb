require "rails_helper"

RSpec.describe SubscribersMailer, type: :mailer do
  describe "question_notifier" do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let(:answer) { create(:answer, question: question, user: user) }
    let(:mail) { SubscribersMailer.question_notifier(user, question) }

    it "renders the headers" do
      expect(mail.subject).to eq("New answer's notifier")
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hello #{user.display_name}")
      expect(mail.body.encoded).to match(question.title)
    end
  end

end
