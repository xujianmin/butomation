FactoryBot.define do
  factory :subordination do
    association :user
    association :virtual_user
  end
end
