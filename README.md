TODO:
  1. update rest of bracket if winner changes
  2. update bracket header with winner and runner-up when they are selected.


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
