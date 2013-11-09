require 'spec_helper'
describe Vote do
  it "start" do
    expect(Vote.count).to eq 3
  end
end