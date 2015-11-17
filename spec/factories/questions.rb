FactoryGirl.define do
  factory :question do
    user
    title  { |n| "My question title#{n}" }
    sequence(:body)  { |n| "My question body#{n}" }
  end

  factory :invalid_question, class: "Question" do
    user
    title nil
    body nil
  end
end
