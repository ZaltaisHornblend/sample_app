FactoryGirl.define do
  factory :user do
    name     "Trinity"
    email    "trinity@sion.com"
    password "matrix"
    password_confirmation "matrix"
    birthday 1980-03-24
    user_weight 90
    ideal_weight 78.2
    do_sport true
    want_do_sport false
    #user_cv "testCV.pdf"
    #user_cv_file_name "testCV.pdf"
    #user_cv_content_type "application/pdf"
    #user_cv_file_size 14000
    user_height 185
  end
end
