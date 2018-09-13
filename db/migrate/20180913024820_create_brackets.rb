class CreateBrackets < ActiveRecord::Migration[5.2]
  def change
    create_table :brackets do |t|
      t.string :title
      t.integer :owner_id
      t.integer :champ_id
      t.integer :runnder_up_id
      t.timestamps
    end
  end
end
