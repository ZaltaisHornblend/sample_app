FactoryGirl.define do
  factory :user do
    name     "Trinity"
    email    "trinity@sion.com"
    password "matrix"
    password_confirmation "matrix"
  end
end
