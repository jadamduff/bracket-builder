class RemoveChampIdAndRunnerUpId < ActiveRecord::Migration[5.2]
  def change
    remove_column :brackets, :champ_id
    remove_column :brackets, :runnder_up_id
  end
end
