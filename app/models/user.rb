require 'digest/sha1'
class User < ActiveRecord::Base
  attr_accessible :email_address, :hashed_password, :name, :salt, :password, :password_confirmation, :isadmin, :issuperadmin

  has_many :posts
  has_many :votes

  validates_presence_of :name
  validates_uniqueness_of :name

  validates_presence_of :email_address
  validates_uniqueness_of :email_address

  validates_confirmation_of :password

  validate :password_non_blank

  def self.authenticate(name, password)
    user = self.find_by_name(name)
    if user
      expected_password = encrypted_password(password, user.salt)
      if user.hashed_password != expected_password
        user = nil
      end
    end
    user
  end

  def destroy_related_Post_Reply_Vote(d_user_id)
    # the owner of the posts, replies, and votes
    owner = User.find_by_id(d_user_id)
    related_posts = Post.find_all_by_user_id(d_user_id)
    related_posts.each{ |post|
      Comment.find_all_by_post_id(post.id).each{ |comment|
        Vote.find_all_by_comment_id(comment.id).each{ |vote|
          vote.destroy
        }
        comment.destroy
      }
      post.destroy
    }
    related_comments = Comment.find_all_by_user_id(d_user_id)
    related_comments.each{ |comment|
      Vote.find_all_by_comment_id(comment.id).each{ |vote|
        vote.destroy
      }
      comment.destroy
    }
    related_votes = Vote.find_all_by_user_id(d_user_id)
    related_votes.each{ |vote| vote.destroy }
  end


  # 'password' is a virtual attribute

  def password
    @password
  end
  def password=(pwd)
    @password = pwd
    return if pwd.blank?
    create_new_salt
    self.hashed_password = User.encrypted_password(self.password, self.salt)
  end

  private
  def password_non_blank
    errors.add(:password, "Missing password") if hashed_password.blank?
  end
  def create_new_salt
    self.salt = self.object_id.to_s + rand.to_s
    puts salt
    puts self.salt
  end
  def self.encrypted_password(password, salt)
    string_to_hash = password + "233333" + salt
    puts string_to_hash
    puts salt
    Digest::SHA1.hexdigest(string_to_hash)
  end


end
