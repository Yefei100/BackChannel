require 'spec_helper'
describe Post do
  it "start" do
    expect(Post.count).to eq 2
  end
end