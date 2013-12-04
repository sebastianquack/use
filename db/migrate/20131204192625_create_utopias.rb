class CreateUtopias < ActiveRecord::Migration
  def change
    create_table :utopias do |t|
      t.string :title
      t.text :description
      t.text :realization
      t.text :risks
      t.integer :effect_body
      t.integer :effect_economy
      t.integer :effect_politics
      t.integer :effect_spirituality
      t.integer :effect_technology
      t.integer :effect_environment
      t.integer :effect_fun
      t.string :email

      t.timestamps
    end
  end
end
