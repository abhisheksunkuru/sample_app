require 'spec_helper'

describe Relationship do
  let(:follower){FactoryGirl.create(:user)}
  let(:followed){FactoryGirl.create(:user)}
  let(:relationship) do
  	follower.relationships.create(followed_id: followed.id)
  end

  subject{relationship}
  it {should be_valid}

  describe "accesible attributes" do
  	it "should not allow access to follower_id" do
  		expect do
          Relationship.new(follower_id: follower.id)
  		end.should raise_error(ActiveModel::MassAssignmentSecurity::Error)	
  	end
  end

  describe "describe follower method" do
  	before { relationship.save }
    it {should respond_to(:follower)}
    it {should respond_to(:followed)}
    its(:follower){should == follower}
    its(:followed){should == followed}
  end
  

  describe "when followed id is not present" do
  	before{relationship.followed_id = nil}
  	it {should_not be_valid}
  end

  describe "when follower id is not present " do
  	before{ relationship.follower_id = nil}
  	it {should_not be_valid}
  end	
 
end
