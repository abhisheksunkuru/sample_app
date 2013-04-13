require 'spec_helper'

describe MicropostsController do

  describe "GET 'index'" do
    it "returns http success" do
      visit root_path
      response.should be_success
    end
  end

  describe "GET 'create'" do
    it "returns http success" do
      visit home_path
      response.should be_success
    end
  end

  describe "GET 'destroy'" do
    it "returns http success" do
      visit root_path
      response.should be_success
    end
  end

end