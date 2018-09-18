class AddChampNameAndRunnerUpNameToBrackets < ActiveRecord::Migration[5.2]
  def change
    add_column :brackets, :champ_name, :string
    add_column :brackets, :runner_up_name, :string
  end
end
