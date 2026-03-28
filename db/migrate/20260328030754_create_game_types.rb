class CreateGameTypes < ActiveRecord::Migration[7.2]
  def change
    create_table :game_types do |t|
      t.string :name, null: false, index: { unique: true }
      t.string :display_name, null: false
      t.text :description

      t.timestamps
    end
  end
end
