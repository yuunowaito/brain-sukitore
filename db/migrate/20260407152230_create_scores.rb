class CreateScores < ActiveRecord::Migration[7.2]
  def change
    create_table :scores do |t|
      t.references :user, null: false, foreign_key: true
      t.references :game_type, null: false, foreign_key: true
      t.integer :score, null: false
      t.date :played_on, null: false

      t.timestamps
    end

    add_index :scores, [ :user_id, :game_type_id, :played_on ]
  end
end
