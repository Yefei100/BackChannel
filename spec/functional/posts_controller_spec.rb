require 'spec_helper'
#require_relative '../../app/controllers/posts_controller'
describe Post do
  it "should create" do
    expect do
      user=User.create(email_address: 'hehehe@gmail.com', name: 'hehe', password: 'hehe')
      category=Category.create( name: 'Test')
      post=Post.create(category_id:1,user_id:user.id,category_id:category.id,content:'nice to see u',title:"hi")
    end.to change(Post, :count).by(0)
  end
end