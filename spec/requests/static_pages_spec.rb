require 'spec_helper'

describe "StaticPages" do
   
  subject{page}

  shared_examples_for "all static pages" do
    it{should have_selector('h1', :text => heading)}
    it{should have_selector('title', :text => full_title(page_title))}
  end


  describe "Home page" do
     before{visit home_path}
  
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      
      let(:heading){ 'Sample App' }

      let(:page_title){ '' }

    it_should_behave_like "all static pages"
    it {should_not have_selector 'title', :text => '| Home'}
  	

    describe "for signed in users" do
      let(:user) {FactoryGirl.create(:user)}
      before do
        FactoryGirl.create(:micropost, user: user, content: "Lorem ipsum")
        FactoryGirl.create(:micropost, user: user, content: "Dolar sit amet")
        sign_in user
        visit root_path
      end

      it "should render the users feed" do
        user.feed.each do |item|
          page.should have_selector("li##{item.id}",text: item.content)
        end  
      end
    end       
            
  end

  describe "Help page" do
    before{visit help_path}
  	
  	  		let(:heading){ 'Help' }
          let(:page_title){ "Help" }
     it_should_behave_like "all static pages"

     it {should have_selector 'title', :text => '| Help'}
      
  	
  end

  describe "About page" do
    before{visit about_path}
  	
  	let(:heading){ 'About Us' }
  	
  	let(:page_title){"About Us"}

    it_should_behave_like "all static pages"
    it {should have_selector 'title', :text => '| About Us'}
  		
  end

  describe "Contact page" do
    before{visit contact_path}
    let(:heading){ 'Contact'}
    let(:page_title){"Contact"}
    
    it_should_behave_like "all static pages"
    it {should have_selector 'title', :text => '| Contact'}
    
  end

    it "should have right links on the layout" do
      visit home_path
      click_link "About"
      page.should have_selector 'title', :text => full_title('About Us')

      click_link "help"
      page.should have_selector 'title', :text => full_title('Help')

      click_link "contact"
      page.should have_selector 'title', :text => full_title('Contact')

      click_link "Home"
      page.should have_selector  'title', :text => full_title('')

      click_link "SignUp Now"
      page.should have_selector 'title', :text => full_title('signup')
    end
end
