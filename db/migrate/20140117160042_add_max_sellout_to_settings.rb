class AddMaxSelloutToSettings < ActiveRecord::Migration
  def change
    add_column :settings, :max_sellout, :integer
  end
end
