#encoding: utf-8
require 'spec_helper'

describe "Static pages" do

  subject { page }

  shared_examples_for "all static pages" do
    it { should have_selector('h1', text: heading) }
    it { should have_title(full_title(page_title)) }
  end

  describe "Page d'accueil" do
    before { visit root_path }
    let(:heading)    { 'Nationale Quidditch Association' }
    let(:page_title) { '' }

    it_should_behave_like "all static pages"
    it { should_not have_title('| Accueil') }
    
    describe "for signed-in users" do
      let(:user) { FactoryGirl.create(:user) }
      before do
        FactoryGirl.create(:micropost, user: user, content: "Lorem ipsum")
        FactoryGirl.create(:micropost, user: user, content: "Dolor sit amet")
        sign_in user
        visit root_path
      end

      it "should render the user's feed" do
        user.feed.each do |item|
          expect(page).to have_selector("li##{item.id}", text: item.content)
        end
      end
    end
  end

  describe "Help page" do
    before { visit help_path }

    let(:heading)    { 'Aide' }
    let(:page_title) { 'Aide' }

    it_should_behave_like "all static pages"
  end

  describe "About page" do
    before { visit about_path }

    let(:heading)    { 'A Propos' }
    let(:page_title) { 'A Propos' }
    
    it_should_behave_like "all static pages"
  end

  describe "Store page" do
    before { visit store_path }
    
    let(:heading)    { 'Store' }
    let(:page_title) { 'Store' }
    
    it_should_behave_like "all static pages"
  end
  
  describe "Contact page" do
    before { visit contact_path }
    
    let(:heading)    { 'Contact' }
    let(:page_title) { 'Contact' }
    
    it_should_behave_like "all static pages"
  end
  
  it "should have the right links on the layout" do
    visit root_path
    click_link "A Propos"
    expect(page).to have_title(full_title('A Propos'))
    click_link "Store"
    expect(page).to have_title(full_title('Store'))
    click_link "Aide"
    expect(page).to have_title(full_title('Aide'))
    click_link "Contact"
    expect(page).to have_title(full_title('Contact'))
    click_link "Accueil"
    click_link "S'inscrire maintenant !"
    expect(page).to have_title(full_title("Inscription"))
    click_link "IQA"
    expect(page).to have_title(full_title(''))
  end
end
