require 'spec_helper'
require_relative '../../app/controllers/votes_controller'
describe Vote do
  it "should create" do
    expect do
      user=User.create(email_address: 'hehehe@gmail.com', name: 'hehe', password: 'xyz')
      category=Category.create( name: 'Test')
      post=Post.create(category_id:1,user_id:user.id,category_id:category.id,content:'nice to see u',title:"hi")
      vote=Vote.create(post_id: post.id, user_id: user.id)
    end.to change(Vote, :count).by(1)
  end
end