FactoryBot.define do
  factory :sites_pokermon, class: 'Sites::Pokermon' do
    nickname { "MyString" }
    kana { "MyString" }
    registry_cellphone { "MyString" }
    registry_postcode { "MyString" }
    registry_fandi { "MyString" }
    reg_password { "MyString" }
  end
end
