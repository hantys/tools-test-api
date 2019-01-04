FactoryBot.define do
  factory :user do
    email {Faker::Internet.email}
    password {Faker::Internet.password}
    password_confirmation {password}
    # auth_token {Devise.friendly_token}
  end
end