class Round < ActiveRecord::Base
  belongs_to :bracket
  has_many :games
end
