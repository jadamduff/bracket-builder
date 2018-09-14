class User < ActiveRecord::Base
  has_secure_password
  has_many :friendships
  has_many :friends, through: :friendships
  has_many :friend_requests
  has_many :user_brackets
  has_many :brackets, through: :user_brackets
  has_many :teams
end
