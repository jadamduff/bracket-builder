class AddTeamIdsToGames < ActiveRecord::Migration[5.2]
  def change
    add_column :games, :team1_id, :integer
    add_column :games, :team2_id, :integer
  end
end
