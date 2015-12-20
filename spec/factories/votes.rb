FactoryGirl.define do
   factory :vote do
     user
     association :voteable
     value 0
   end
 end