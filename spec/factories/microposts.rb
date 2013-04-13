
FactoryGirl.define do
  factory :sachin, :class => Micropost do
    content "MyString"
    user_id 1
  end
end