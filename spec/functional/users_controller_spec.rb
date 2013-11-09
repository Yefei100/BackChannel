require 'spec_helper'
describe User do
  it "creates a user" do
    expect do
      User.create(email_address: 'hehe@gmail.com', name: 'hehe',  password: 'xyz')
    end.to change(User, :count).by(1)
  end
end
