class CreateGameTeams < ActiveRecord::Migration[5.2]
  def change
    create_table :game_teams do |t|
      t.integer :game_id
      t.integer :team_id
      t.timestamps
    end
  end
end
