class CreateMarketSessions < ActiveRecord::Migration
  def change
    create_table :market_sessions do |t|
      t.integer :duration
      t.integer :max_survivors

      t.timestamps
    end
  end
end
