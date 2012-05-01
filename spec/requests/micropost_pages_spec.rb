require 'spec_helper'

describe "MicropostPages" do
 subject { page }

 let(:user){FactoryGirl.create(:user)}
 before{ sign_in user}

 describe "micropost creation" do
 	before {visit root_path}

 	describe "with invalid information" do
 		it "should not create a micropost" do
 			expect {click_button "Post"}.should_not change(Micropost, :count)
 		end

 		describe "error messages" do
 			before {click_button "Post"}
 			it {should have_content('error')}
 		end
 	end

 	describe "with valid information" do
 		before{fill_in 'micropost_content', with: "Lorem ipsum"}
 		it "should create a micropost" do
 			expect {click_button "Post"}.should change(Micropost, :count).by(1)
            
 			should have_content(:count)
 		end
 	end
 end

 describe "micropost destruction" do
    before { FactoryGirl.create(:micropost, user: user) }

    describe "as correct user" do
      before { visit root_path }

      it "should delete a micropost" do
        expect { click_link "delete" }.should change(Micropost, :count).by(-1)
      end
    end

    describe  "should not delete" do
      let(:other_user){FactoryGirl.create(:user)}
      before do
        10.times do
          FactoryGirl.create(:micropost, user: other_user)
        end
        visit user_path(other_user)
      end
            
      it {should_not have_link('delete')}
    end
  end


   describe"pagination" do
      before(:all) { 50.times {FactoryGirl.create(:micropost, user: user)}}
      after(:all) {Micropost.delete_all}
      it{should have_link('Next')}
      its(:html) {should  match('>2</a>')}

      let(:first_page)  { Micropost.paginate(page: 1) }
      let(:second_page) { Micropost.paginate(page: 2) }

      

      it "should list each user" do
      user.microposts.each do |mp|
        page.should have_selector('li', text: mp.content )
      end
      end
      
      it "should list the first page of users" do
        first_page.each do |mp|
          page.should have_selector('li', text: mp.content)
        end
      end

      it "should not list the second page of users" do
        second_page.each do |mp|
          page.should have_selector('li', text: mp.content)
        end
      end

      describe "showing the second page" do
        before {visit user_path(user,page: 2)}
        it "should list the second page of users" do
          second_page.each do |mp|
            page.should have_selector('li', text: mp.content)
          end
          page.should have_link('Previous')
        end
      end
    end
end
