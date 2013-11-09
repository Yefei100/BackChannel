class Vote < ActiveRecord::Base
  attr_accessible :post_id,:user_id, :comment_id

  belongs_to :user
  belongs_to :comment
  belongs_to :post


  # validates :user, :presence => true
end
