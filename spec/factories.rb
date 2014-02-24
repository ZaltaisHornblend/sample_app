FactoryGirl.define do
  factory :user do
	sequence(:name)  { |n| "Sorcier #{n}" }
    sequence(:email) { |n| "sorcier_#{n}@example.com"}
    password "poudlard"
    password_confirmation "poudlard"
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
    
    factory :admin do
      admin true
    end
  end
  
  factory :micropost do
    content "Lorem ipsum"
    user
  end
  
end
