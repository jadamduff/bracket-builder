class Game < ActiveRecord::Base
  belongs_to :round
  has_many :teams
end
