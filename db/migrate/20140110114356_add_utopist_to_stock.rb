class AddUtopistToStock < ActiveRecord::Migration
  def change
    add_column :stocks, :utopist_id, :integer
  end
end
