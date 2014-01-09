class CreateTransactionTypes < ActiveRecord::Migration
  def change
    create_table :transaction_types do |t|
      t.boolean :available
      t.string :name

      t.timestamps
    end
  end
end
