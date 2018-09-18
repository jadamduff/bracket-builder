TODO:
  1. Put owner tag on profile, user/view, and bracket/view
  2. Create an edit page and controller method that cycles through the teams of round 1 to determine if they have changed and creates a new team if they have, before deleting the teams that the new teams replaced. It then cycles through all other games, clearing the team ids. It also clears the bracket's winner and runner_up. The page has a shuffle button that doesn't change anything except the order of teams. A Delete button deletes the entire bracket and all rounds/games/teams. Buttons: Save, Shuffle, Cancel, Delete
  3. Put links on all user names.
  4. Make sure that all pages and actions have the right permissions.
  5. Create 12 seed users, including 'adam'.


User
  t.string :username
  t.string :email
  t.string :password_digest
  t.timestamps

  has_many :friends, through: :friendships
  has_many :pending_friends, through: :friend_requests
  has_many :brackets, through: :user_brackets
  has_many :teams

FriendRequest
  t.integer :user_id
  t.integer :pending_friend_id
  t.timestamps

  belongs_to :user
  belongs_to :pending_friend, :class_name => "User"

Friendship
  t.integer :user_id
  t.integer :friend_id
  t.timestamps

  belongs_to :user
  belongs_to :friend, :class_name => "User"

UserBrackets
  t.integer :user_id
  t.integer :bracket_id

  belongs_to :user
  belongs_to :bracket

Bracket
  t.string :title
  t.integer :owner_id
  t.string :champ
  t.timestamps

  has_many :rounds
  has_many :teams
  has_many :users, through: :user_brackets

Round
  t.integer :number
  t.integer :bracket_id
  t.timestamps

  belongs_to :bracket
  has_many :games

Game
  t.integer :winner_id
  t.integer :loser_id
  t.integer :round_id
  t.timestamps

  belongs_to :round
  has_many :teams

GameTeams
  t.integer :game_id
  t.integer :team_id

  belongs_to :game
  belongs_to :team

Team
  t.string :name
  t.integer :user_id
  t.integer :bracket_id

  belongs_to :user
  belongs_to :bracket

# bracket-builder
This is a web app that allows users to create brackets and add their friends.
