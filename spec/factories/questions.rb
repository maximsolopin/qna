FactoryGirl.define do
  sequence :title do |n|
    "MyString#{n}"
  end

  factory :question do
    user
    title
    body "MyText"
  end

  factory :invalid_question, class: "Question" do
    user
    title nil
    body nil
  end
end
