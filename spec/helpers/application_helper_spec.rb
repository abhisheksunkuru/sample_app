require 'spec_helper'
require 'factory_girl_rails'


describe ApplicationHelper do
  describe "full_title" do
    it "should include the page name" do
      full_title("foo").should=~ /foo/
    end

    it "should include the base name" do
      full_title("foo").should=~ /^Ruby on Rails Tutorial Sample App/
    end

    it "should not include a bar for hokme page" do
      full_title("").should_not=~ /\|/
    end
  end
end
