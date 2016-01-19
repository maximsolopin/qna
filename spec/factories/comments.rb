FactoryGirl.define do
  factory :comment do
    user
    sequence(:body)  { |n| "My comment body#{n}" }
  end

  factory :invalid_comment, class: "Comment" do
    user
    body nil
  end
end
