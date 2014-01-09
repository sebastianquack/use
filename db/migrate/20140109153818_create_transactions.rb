class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.integer :transaction_type_id
      t.integer :seller_id
      t.integer :buyer_id
      t.float :price
      t.integer :amount
      t.integer :stock_id

      t.timestamps
    end
  end
end
