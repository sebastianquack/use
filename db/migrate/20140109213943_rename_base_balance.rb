class RenameBaseBalance < ActiveRecord::Migration
  def change
    rename_column :settings, :base_balance, :base_cash_in
  end
end
