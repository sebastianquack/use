class AddCacheFieldsUsersStocks < ActiveRecord::Migration
  def change
      add_column :stocks, :investment, :float
      add_column :users, :cash_in, :float
      add_column :users, :profit, :float
      add_column :users, :investment, :float
  end
end
