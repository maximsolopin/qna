FactoryGirl.define do
  sequence :body do |n|
    "MyStringAnswer#{n}"
  end

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
