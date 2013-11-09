class Post < ActiveRecord::Base
  attr_accessible :content, :title, :category_id,:user_id, :post_vote_count, :total_vote_count, :last_update_time, :tag_list
  has_many :taggings
  has_many :tags, through: :taggings

  def self.tagged_with(name)
    Tag.find_by_name!(name).posts
  end

  def self.tag_counts
    Tag.select("tags.id, tags.name,count(taggings.tag_id) as count").
        joins(:taggings).group("taggings.tag_id, tags.id, tags.name")
  end

  def tag_list
    tags.map(&:name).join(", ")
  end

  def tag_list=(names)
    self.tags = names.split(",").map do |n|
      Tag.where(name: n.strip).first_or_create!
    end
  end
  attr_accessor :score
  belongs_to :category
  belongs_to :user
  has_many :comments
  has_many :votes

  validates :content, :presence => true
  validates :title, :presence => true
  validates :category, :presence => true
  validates :user, :presence => true
end
