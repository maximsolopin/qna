FactoryGirl.define do
  factory :attachment do
    file File.open(File.join(Rails.root, "/spec/spec_helper.rb"))
  end
end
