class CreateGames < ActiveRecord::Migration[7.0]
  def change
    create_table :games do |t|
      t.integer :author_id
      t.string :title
      t.string :setting
      t.string :difficulty

      t.timestamps
    end
  end
end
