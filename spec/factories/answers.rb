FactoryGirl.define do
  factory :answer do
    user
    question
    sequence(:body) { |n| "My answer body #{n}" }
  end

  factory :invalid_answer, class: "Answer"  do
    user
    question
    body ""
  end
end
