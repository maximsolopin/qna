FactoryGirl.define do
  factory :answer do
    user
    question
    body "MyStringAnswer"
  end

  factory :invalid_answer, class: "Answer"  do
    user
    question
    body ""
  end
end
