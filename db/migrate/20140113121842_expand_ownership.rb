class ExpandOwnership < ActiveRecord::Migration
  def change
      add_column :ownerships, :profit, :float
      add_column :ownerships, :avg_price, :float
  end
end
