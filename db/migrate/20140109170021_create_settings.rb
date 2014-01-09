class CreateSettings < ActiveRecord::Migration
  def change
    create_table :settings do |t|
      t.float :exchange_rate
      t.float :base_balance

      t.timestamps
    end
  end
end
