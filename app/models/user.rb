#encoding: utf-8
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
  has_many :microposts, dependent: :destroy
  before_save { email.downcase! }
  before_create :create_remember_token
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
  
  def User.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def User.encrypt(token)
    Digest::SHA1.hexdigest(token.to_s)
  end
  
  def feed
    # This is preliminary. See "Following users" for the full implementation.
    Micropost.where("user_id = ?", id)
    
    #version allèger
    #microposts
  end
  
  def IMC 
	$imc=(user_weight/((user_height.to_f*user_height.to_f)/10000)).round(2); 
	if $imc < 18.5 
		return $imc.to_s + " Maigreur" 
	elsif $imc < 25 
		return $imc.to_s + " Bonne santé" 
	elsif $imc <= 30 
		return $imc.to_s + " Surpoids" 
	elsif $imc <= 35 
		return $imc.to_s + " Obésité" 
	elsif $imc > 40 
		return $imc.to_s + " Obésité sévère" 
	else 
		return "Erreur" 
	end 
  end
  
  def IMC_ideal
	$imc=(ideal_weight/((user_height.to_f*user_height.to_f)/10000)).round(2); 
	if $imc < 18.5 
		return $imc.to_s + " Maigreur" 
	elsif $imc < 25 
		return $imc.to_s + " Bonne santé" 
	elsif $imc <= 30 
		return $imc.to_s + " Surpoids" 
	elsif $imc <= 35 
		return $imc.to_s + " Obésité" 
	elsif $imc > 40 
		return $imc.to_s + " Obésité sévère" 
	else 
		return "Erreur" 
	end 
  end
  
  def AGE 
	if Date.today.month >= birthday.month && Date.today.day >= birthday.day && Date.today.year >= birthday.year 
		return Date.today.year-birthday.year 
	else 
		return Date.today.year-birthday.year-1 
	end 
  end

  private

    def create_remember_token
      self.remember_token = User.encrypt(User.new_remember_token)
    end

end
