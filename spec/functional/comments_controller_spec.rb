require 'spec_helper'
describe Comment do
  it "should create" do
    expect do
      c=Comment.create(content: 'working!!',title: 'haha!')
    end.to change(Comment, :count).by(1)
  end
end