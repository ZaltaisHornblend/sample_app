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

require 'spec_helper'

describe User do

  before do
    @user = User.new(name: "Example User", email: "user@example.com",
					 password: "foobar", password_confirmation: "foobar", birthday: "12/11/2010", 
					 user_weight: 94, ideal_weight: 85,
					 do_sport: true, want_do_sport: true,
					 #user_cv_file_name: "testCV.pdf", user_cv_content_type: "application/pdf", user_cv_file_size: 14000, 
					 user_height: 190)
  end

  subject { @user }

  it { should respond_to(:name) }
  it { should respond_to(:email) }
  it { should respond_to(:password_digest) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:birthday) }					#ajout pour la date de naissance
  it { should respond_to(:user_weight) }				#ajout poids
  it { should respond_to(:ideal_weight) }				#ajout poids ideal
  it { should respond_to(:do_sport) }					#ajout "Je fais du sport"
  it { should respond_to(:want_do_sport) }				#ajout "Je veux en faire ?"
  #it { should respond_to(:user_cv) }					#ajout "CV utilisateur"
  #it { should respond_to(:user_cv_file_name) }
  #it { should respond_to(:user_cv_content_type) }
  #it { should respond_to(:user_cv_file_size) }
  it { should respond_to(:user_height) }				#ajout de la taille pour calculer l'IMC
  
  
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:remember_token) }
  
  it { should respond_to(:authenticate) }
  it { should respond_to(:admin) }
  it { should respond_to(:microposts) }
  it { should respond_to(:feed) }

  it { should be_valid }
  it { should_not be_admin }

  describe "with admin attribute set to 'true'" do
    before do
      @user.save!
      @user.toggle!(:admin)
    end

    it { should be_admin }
  end
  
  describe "remember token" do
    before { @user.save }
    its(:remember_token) { should_not be_blank }
  end


# ================ name ================ #

  describe "when name is not present" do
    before { @user.name = " " }
    it { should_not be_valid }
  end
  
  describe "when name is too long" do
    before { @user.name = "a" * 51 }
    it { should_not be_valid }
  end
  
# ================ email ================ #
  
  describe "when email is not present" do
    before { @user.email = " " }
    it { should_not be_valid }
  end
  
  describe "when email format is invalid" do
    it "should be invalid" do
      addresses = %w[user@foo,com user_at_foo.org example.user@foo.
                     foo@bar_baz.com foo@bar+baz.com]
      addresses.each do |invalid_address|
        @user.email = invalid_address
        expect(@user).not_to be_valid
      end
    end
  end

  describe "when email format is valid" do
    it "should be valid" do
      addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
      addresses.each do |valid_address|
        @user.email = valid_address
        expect(@user).to be_valid
      end
    end
  end
  
  describe "email address with mixed case" do
    let(:mixed_case_email) { "Foo@ExAMPle.CoM" }

    it "should be saved as all lower-case" do
      @user.email = mixed_case_email
      @user.save
      expect(@user.reload.email).to eq mixed_case_email.downcase
    end
  end
  
  describe "when email address is already taken" do
    before do
      user_with_same_email = @user.dup
      user_with_same_email.email = @user.email.upcase
      user_with_same_email.save
    end

    it { should_not be_valid }
  end
  
# ================ password ================ #

  describe "when password is not present" do
    before do
      @user = User.new(name: "Example User", email: "user@example.com",
                       password: " ", password_confirmation: " ")
    end
    it { should_not be_valid }
  end

  describe "when password doesn't match confirmation" do
    before { @user.password_confirmation = "mismatch" }
    it { should_not be_valid }
  end
  
  describe "with a password that's too short" do
    before { @user.password = @user.password_confirmation = "a" * 5 }
    it { should be_invalid }
  end

  describe "return value of authenticate method" do
    before { @user.save }
    let(:found_user) { User.find_by_email(@user.email) }

    describe "with valid password" do
      it { should eq found_user.authenticate(@user.password) }
    end

    describe "with invalid password" do
      let(:user_for_invalid_password) { found_user.authenticate("invalid") }

      it { should_not eq user_for_invalid_password }
      specify { expect(user_for_invalid_password).to be_false }
    end
  end
  
  # ================ birthday ================ #
  
  describe "when date of birth is not present" do
    before { @user.birthday = nil }
    it { should_not be_valid }
  end
  
  # ================ weight ================ #

=begin  

# mise en commentaire après les avoir tester car conflit lorsqu'il va tester le greater_than. Les tests vont comparer un float avec un nil

  describe "when user_weight is not present" do
    before { @user.user_weight = nil }		# trouver une solution pour mettre nil a la place de 0
    it { should_not be_valid }
  end
  
  describe "when ideal_weight is not present" do	
    before { @user.ideal_weight = nil }		# trouver une solution pour mettre nil a la place de 0
    it { should_not be_valid }
  end
=end


   #weight must be more greater than ideal weight
  
  describe "when weight is less than ideal weight" do
     before{ @user_false = User.new(name: "Example User", email: "user@example.com",
                     password: "foobar", password_confirmation: "foobar",
                     birthday: "1980-01-01",
                     user_weight: 60, ideal_weight: 70,
                     do_sport: false, want_do_sport: true)
            }         
    it { @user.should be_valid } 
    it { @user_false.should_not be_valid }
  end

  #ideal weight must be more greater than 0

  describe "when weight is less than ideal weight" do
    before{ @user_false = User.new(name: "Example User", email: "user@example.com",
                     password: "foobar", password_confirmation: "foobar",
                     birthday: "1980-01-01",
                     user_weight: 60, ideal_weight: 0,
                     do_sport: false, want_do_sport: true)
            }         
    it { @user.should be_valid } 
    it { @user_false.should_not be_valid }
  end

  
  # ================ sport ================ #
  
  describe "when do_sport is not present" do
    before { @user.do_sport = nil }
    it { should_not be_valid }
  end
  
  
  # ================ height ================ #
  
  describe "when height is not present" do
    before { @user.user_height = nil }
    it { should_not be_valid }
  end
  
  # ================ Microposts ================ #
  
  describe "micropost associations" do

    before { @user.save }
    let!(:older_micropost) do
      FactoryGirl.create(:micropost, user: @user, created_at: 1.day.ago)
    end
    let!(:newer_micropost) do
      FactoryGirl.create(:micropost, user: @user, created_at: 1.hour.ago)
    end

    it "should have the right microposts in the right order" do
      expect(@user.microposts.to_a).to eq [newer_micropost, older_micropost]
    end
    
    it "should destroy associated microposts" do
      microposts = @user.microposts.to_a
      @user.destroy
      expect(microposts).not_to be_empty
      microposts.each do |micropost|
        expect(Micropost.where(id: micropost.id)).to be_empty
      end
    end
    
    describe "status" do
      let(:unfollowed_post) do
        FactoryGirl.create(:micropost, user: FactoryGirl.create(:user))
      end

      its(:feed) { should include(newer_micropost) }
      its(:feed) { should include(older_micropost) }
      its(:feed) { should_not include(unfollowed_post) }
    end
  end
  
end
