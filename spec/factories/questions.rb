FactoryGirl.define do
  sequence :body do |n|
    "My question body#{n}"
  end

  factory :question do
    user
    title  { |n| "My question title#{n}" }
    body
  end

  factory :invalid_question, class: "Question" do
    user
    title nil
    body nil
  end
end
