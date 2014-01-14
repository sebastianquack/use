class CreateOwnerships < ActiveRecord::Migration
  def change
    create_table :ownerships do |t|
      t.integer :stock_id
      t.integer :user_id
      t.integer :amount
      t.float :investment

      t.timestamps
    end
  end
end
