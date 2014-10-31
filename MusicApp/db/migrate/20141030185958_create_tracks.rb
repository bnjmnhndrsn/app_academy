class CreateTracks < ActiveRecord::Migration
  def change
    create_table :tracks do |t|
      t.string :name, null: false
      t.integer :album_id, null: false
      t.string :track_type
      t.text :lyrics

      t.timestamps
    end
  end
end
