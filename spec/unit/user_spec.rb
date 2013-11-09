require 'spec_helper'
describe User do
  it "should require all fields" do
    r = User.new
    r.should be_an_instance_of User
  end
end