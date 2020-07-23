class User < ActiveRecord::Base
  validates :username, presence: true
  validates :email, presence: true
  has_secure_password
  has_many :tweets

  def self.find_by_slug(slug)
    self.all.find{ |user| user.slug == slug }
  end 

  def slug 
    self.username.downcase.split(" ").join("-")
  end 

  def owns_tweet?(tweet)
    self.tweets.include?(tweet)
  end 
  
end
