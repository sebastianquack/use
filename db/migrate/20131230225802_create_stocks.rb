class CreateStocks < ActiveRecord::Migration
  def change
    create_table :stocks do |t|
      t.string :name
      t.string :symbol
      t.text :description
      t.string :utopist
      t.boolean :active

      t.timestamps
    end
  end
end
