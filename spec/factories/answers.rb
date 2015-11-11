FactoryGirl.define do
  factory :answer do
    question
    body "MyString"
  end

  factory :invalid_answer, class: "Answer"  do
    question
    body ""
  end
end
