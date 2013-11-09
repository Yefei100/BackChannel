require 'spec_helper'
describe Comment do
  it "should require all fields" do
    r = Comment.new
    r.should be_an_instance_of Comment
  end
end

describe Comment do
  it "should have comment" do
    r = Comment.new
    r.content="Testing comment"
    r.content.should eq('Testing comment')
  end


end

describe Comment do
  it "should have comment" do
    r = Comment.new
    r.title="Testing"
    r.title.should eq('Testing')
  end


end

