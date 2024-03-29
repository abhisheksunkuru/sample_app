require 'spec_helper'

describe User do

  before { @user = User.new(:name => "Example User", :email => "usr@example.com",
             :password => 'foobar', :password_confirmation => 'foobar')}
  subject{@user}

  it{should respond_to(:name)}
  it{should respond_to(:email)}
  it{should respond_to(:password_digest)}
  it{should respond_to(:password)}
  it{should respond_to(:remember_token)}
  it{should respond_to(:password_confirmation)}
  it{should respond_to(:authenticate)}
  it{should respond_to(:microposts)}
  it{should respond_to(:feed)}
  it{should respond_to(:relationships)}
  it{should respond_to(:followed_users)}
  it{should respond_to(:following?)}
  it{should respond_to(:follow!)}
  it{should respond_to(:reverse_relationships)}
  it{should respond_to(:followers)}

  it{should be_valid}




  describe "when name is not present" do
    before{@user.name = " "}
    it { should_not be_valid }

  end

  describe "when email is not present" do
    before{@user.email=" " }
    it {should_not be_valid}
  end

  describe "when name is too long" do
    before{@user.name= "a"*51}
    it {should_not be_valid}
  end

  describe "when email format is invalid" do
    it "should be in valid " do
       addresses = %w[user@foo,com user_at_foo.org example.user@foo.]
       addresses.each do |invalid_adress|
         @user.email = invalid_adress
         @user.should_not be_valid
       end
    end
  end

  describe "when email format is valid" do
    it "should be valid" do
      addresses = %w[user@foo.com A_USER@f.b.org frst.lst@foo.jp a+b@baz.cn]
      addresses.each do |valid_adress|
        @user.email = valid_adress
        @user.should be_valid
      end
    end
  end

  describe "when email address alredy present" do
    before{user_with_same_mail= @user.dup
      user_with_same_mail=@user.email.upcase
      #user_with_same_mail.save
    }

    it{should be_valid}
  end

  describe "when password is not present" do
    before {@user.password = @user.password_confirmation= " "}
    it {should_not be_valid}
  end

  describe "when password doesnot match confirmation" do
    before{@user.password_confirmation ="mismatch"}
    it{should_not be_valid}
  end

  describe "when password confirmation is nil" do
    before{@user.password_confirmation=nil}
    it {should_not be_valid}
  end

  describe "return value of authenticate method" do
    before { @user.save }
    let(:found_user){User.find_by_email(@user.email) }

    describe "with valid password" do
      it{should == found_user.authenticate(@user.password)}
    end

    describe "with invalid password" do
      let(:user_for_invalid_password){found_user.authenticate("invalid")}
      it{should_not == user_for_invalid_password}
      specify{user_for_invalid_password.should be_false}
    end
  end

  describe "when password is too short" do
    before{@user.password=@user.password_confirmation="a"*5}
    it {should be_invalid}
  end

  describe "remember_token" do
   before{@user.save}
   its(:remember_token){should_not be_blank}
  end


  it {should respond_to(:admin)}
  it {should respond_to(:authenticate)}

  it {should be_valid}
  it {should_not be_admin}

  describe "with admin attribute set to 'true'" do
    before{ @user.toggle!(:admin)}
    it {should be_admin}
  end

  describe "micropost associations" do
    before {@user.save}
    let!(:older_micropost) do
      FactoryGirl.create(:micropost, user: @user, created_at: 1.day.ago )
    end
    let!(:newer_micropost) do
      FactoryGirl.create(:micropost, user: @user, created_at: 1.hour.ago )
    end

    it "should have the right microposts in the right order" do
      @user.microposts.should == [newer_micropost, older_micropost]
    end

    it "should destroy associated microposts" do

      microposts = @user.microposts
      @user.destroy

      microposts.each do |micropost|
        Micropost.find_by_id(micropost.id).should be_nil
      end
    end

    describe "status" do
      let(:unfollowed_post) do
        FactoryGirl.create(:micropost, user: FactoryGirl.create(:user))
      end
      let(:followed_user) { FactoryGirl.create(:user) }

      before do
        @user.follow!(followed_user)
        3.times { followed_user.microposts.create!(content: "Lorem ipsum") }
      end

      its(:feed) { should include(newer_micropost) }
      its(:feed) { should include(older_micropost) }
      its(:feed) { should_not include(unfollowed_post) }
      its(:feed) do
        followed_user.microposts.each do |micropost|
          should include(micropost)
        end
      end
    end
  end

  describe "following" do
    let(:other_user){FactoryGirl.create(:user)}
    before do
      @user.save
      @user.follow!(other_user)
    end
    it {should be_following(other_user)}
    its(:followed_users){ should include(other_user)}

    describe "followed user" do
      subject { other_user}
      its(:followers) {should include(@user)}
    end
  end

end


