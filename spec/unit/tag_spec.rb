require 'spec_helper'
describe Tag do
  it "validates tag name" do
    tag=Tag.new
    tag.tag_name='herewego'
    tag.should be_valid

  end
end