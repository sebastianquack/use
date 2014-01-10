class RenameUtopistName < ActiveRecord::Migration
  def change
    rename_column :stocks, :utopist, :utopist_name
  end
end
