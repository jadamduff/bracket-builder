class UserBracket < ActiveRecord::Base
  belongs_to :user
  belongs_to :bracket
end
