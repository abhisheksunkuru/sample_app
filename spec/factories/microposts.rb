# Read about factories at https://github.com/thoughtbot/factory_girl


FactoryGirl.define do
  factory :sachin, :class => Micropost do
    content "MyString"
    user_id 1
  end
end
