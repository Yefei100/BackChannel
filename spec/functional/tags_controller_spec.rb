require 'spec_helper'
#require_relative '../../app/controllers/tags_controller'
describe Tag do
  it "should create" do
    expect do
      tag=Tag.create(tag_name: 'BackChannel')
    end.to change(Tag, :count).by(1)
  end
end


