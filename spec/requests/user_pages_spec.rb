#encoding: utf-8

require 'spec_helper'

describe "User pages" do

  subject { page }
  
  describe "index" do
  
    let(:user) { FactoryGirl.create(:user) }
    before(:each) do
      sign_in user
      visit users_path
    end

    it { should have_title('Membres NQA') }
    it { should have_content('Membres NQA') }
    
    describe "pagination" do

      before(:all) { 30.times { FactoryGirl.create(:user) } }
      after(:all)  { User.delete_all }

      it { should have_selector('div.pagination') }

      it "should list each user" do
        User.paginate(page: 1).each do |user|
          expect(page).to have_selector('li', text: user.name)
        end
      end
    end
    
    describe "delete links" do

      it { should_not have_link('delete') }

      describe "as an admin user" do
        let(:admin) { FactoryGirl.create(:admin) }
        before do
          sign_in admin
          visit users_path
        end

        it { should have_link('delete', href: user_path(User.first)) }
        it "should be able to delete another user" do
          expect do
            click_link('delete', match: :first)
          end.to change(User, :count).by(-1)
        end
        it { should_not have_link('delete', href: user_path(admin)) }
      end
    end
  end

  describe "signup page" do
    before { visit signup_path }

    it { should have_content('Inscription') }
    it { should have_title(full_title('Inscription')) }
    
    let(:submit) { "Create my account" }

    describe "with invalid information" do
      it "should not create a user" do
        expect { click_button submit }.not_to change(User, :count)
      end
      
      describe "after submission" do
        before { click_button submit }

        it { should have_title('Inscription') }
        it { should have_content('error') }
      end
      
    end

    describe "with valid information" do
      before do
        fill_in "Nom",         with: "Example User"
        fill_in "email",        with: "user@example.com"
        fill_in "Mot de passe",     with: "foobar"
        fill_in "Confirmation", with: "foobar"
        select "1980", 			from: "user[birthday(1i)]"
        select "April", 		from: "user[birthday(2i)]"
        select "24", 			from: "user[birthday(3i)]"
        fill_in "Poids",		with: 90.5
        fill_in "Poids idéal",	with: 78
        
        #Sports
        choose "Oui, je suis sportif"
        choose "Non, je ne suis pas sportif" 
        
        #Wants to do sport
        choose "Oui, j'ai toujours voulu ressember à un athlète"
        choose "Non, je préfère les jeux vidéo!"
        
        #fill_in "Pour le dépôt d'un CV en pdf",     with: "testCV.pdf"
        #fill_in "Confirmation", with: "foobar"
        
        fill_in "Taille (en cm)", with: 184
           
      end

      it "should create a user" do
        expect { click_button submit }.to change(User, :count).by(1)
      end
      
      describe "after saving the user" do
        before { click_button submit }
        let(:user) { User.find_by_email('user@example.com') }
        
		it { should have_link('Déconnexion') }
        it { should have_title(user.name) }
        it { should have_selector('div.alert.alert-success', text: 'Welcome') }
      end
      
    end
  end
  
  describe "profile page" do
    let(:user) { FactoryGirl.create(:user) }
    let!(:m1) { FactoryGirl.create(:micropost, user: user, content: "Foo") }
    let!(:m2) { FactoryGirl.create(:micropost, user: user, content: "Bar") }

    before { visit user_path(user) }

    it { should have_content(user.name) }
    it { should have_title(user.name) }

    describe "microposts" do
      it { should have_content(m1.content) }
      it { should have_content(m2.content) }
      it { should have_content(user.microposts.count) }
    end
  end
  
  describe "edit" do
    let(:user) { FactoryGirl.create(:user) }
    before do
      sign_in user
      visit edit_user_path(user)
    end

    describe "page" do
      it { should have_content("Editer votre profil") }
      it { should have_title("Modifier utilisateur") }
      it { should have_link('modifier', href: 'http://gravatar.com/emails') }
    end

    describe "with invalid information" do
      before { click_button "Enregistrer" }

      it { should have_content('error') }
    end
    
    describe "with valid information" do
      let(:new_name)  { "New Name" }
      let(:new_email) { "new@example.com" }
      before do
        fill_in "Nom",             with: new_name
        fill_in "Email",            with: new_email
        fill_in "Mot de passe",         with: user.password
        fill_in "Confirmez mot de passe", with: user.password
        click_button "Enregistrer"
      end

      it { should have_title(new_name) }
      it { should have_selector('div.alert.alert-success') }
      it { should have_link('Déconnexion', href: signout_path) }
      specify { expect(user.reload.name).to  eq new_name }
      specify { expect(user.reload.email).to eq new_email }
    end
    
  end
  
end
