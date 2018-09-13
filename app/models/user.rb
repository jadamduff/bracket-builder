class User < ActiveRecord::Base
  has_many :friends, through: :friendships
  has_many :pending_friends, through: :friend_requests
  has_many :brackets, through: :user_brackets
  has_many :teams
end
