FactoryBot.define do
  factory :attendance do
    user { nil }
    lottery { nil }
    virtual_users_count { 1 }
    joined_at { "2025-06-25 10:43:15" }
    status { "MyString" }
  end
end
