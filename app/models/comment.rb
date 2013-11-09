class Comment < ActiveRecord::Base
  attr_accessible :content, :title, :post_id, :user_id, :vote_number
  belongs_to :post
  belongs_to :user
  has_many :votes

  validates :content, :presence => true
  validates :title, :presence => true
  validates :post_id, :presence => true
  validates :user, :presence => true

end
