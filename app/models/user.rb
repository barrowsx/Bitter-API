class User < ApplicationRecord
  has_secure_password
  has_many :posts, dependent: :destroy
  has_many :likes
  has_many :active_relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  has_many :passive_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships

  def follow(other_user)
    following << other_user
  end

  def unfollow(other_user)
    following.delete(other_user)
  end

  def following?(other_user)
    following.include?(other_user)
  end

  def like(post)
    arr = likes.map do |like|
      like.post
    end
    if arr.include?(post)
      like_to_delete = Like.find_or_create_by(user_id: self.id, post_id: post.id)
      likes.destroy(like_to_delete.id)
    else
      if self.id == post.user.id
        
      else
        new_like = Like.create(user_id: self.id, post_id: post.id)
        likes << new_like
      end
    end
  end
end
