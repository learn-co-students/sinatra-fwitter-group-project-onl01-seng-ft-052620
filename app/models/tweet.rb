class Tweet < ActiveRecord::Base
  belongs_to :user

  validates :content, length: {maximum: 280, minimum: 1}
end
