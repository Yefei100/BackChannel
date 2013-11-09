require 'spec_helper'
describe Category do
  it "should require all fields" do
    r = Category.new
    r.should be_an_instance_of Category
  end
end

describe "CategoryName" do
  it "should have name" do
    r=Category.new
    r.name='Project'
    r.name.should eq('Project')
  end
end

