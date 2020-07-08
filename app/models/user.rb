class User < ActiveRecord::Base

  has_secure_password
  has_many :tweets

   validates :email, uniqueness: true, presence: true


  def slug()
    subs = {
        ',' => '',
        "'" => '',
        ' ' => '-',
        '.' => ''
    }
    self.username.downcase.gsub(/\W/,subs)
  end

  def self.find_by_slug(slug)
    self.all.find do |obj|
        obj.slug == slug
    end
  end

end
