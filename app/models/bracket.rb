class Bracket < ActiveRecord::Base
  has_many :rounds
  has_many :teams
  has_many :users, through: :user_brackets
end
