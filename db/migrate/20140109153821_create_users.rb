class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.float :balance
      t.string :type
      t.integer :status

      t.timestamps
    end
  end
end
