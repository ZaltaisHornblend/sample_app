# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  name            :string(255)
#  email           :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  password_digest :string(255)
#  birthday        :date
#

class User < ActiveRecord::Base
  before_save { email.downcase! }
  attr_accessible :email, :name, :password, :password_confirmation, :birthday, :user_weight, :ideal_weight, 
					:do_sport, :want_do_sport, :user_cv, :user_cv_file_name, :user_cv_content_type, :user_cv_file_size,
					:user_height

  validates :name,  presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },
					uniqueness: { case_sensitive: false }
  has_secure_password
  validates :password, length: { minimum: 6 }
  
  validates :birthday, presence: true
  
  validates :user_weight, presence: true, numericality: true, :numericality => { :greater_than => 0} 
  validates :ideal_weight, presence: true, numericality: true, :numericality => { :less_than => :user_weight, :greater_than => 0}
  
  validates :do_sport, inclusion: { in: [true, false] }
  
  has_attached_file :user_cv
  validates_attachment_content_type :user_cv, :content_type => ['application/pdf']
  
  validates :user_height, presence: true, numericality: { only_integer: true }

end
