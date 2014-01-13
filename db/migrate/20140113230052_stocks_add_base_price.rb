class StocksAddBasePrice < ActiveRecord::Migration
  def change
    add_column :stocks, :base_price, :float, :default => 0
  end
end
