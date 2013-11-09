require 'spec_helper'
describe Category do
  it "should create" do
    expect do
      c= Category.create(name:'Test')
    end.to change(Category, :count).by(1)
  end
end

