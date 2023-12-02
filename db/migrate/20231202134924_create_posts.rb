class CreatePosts < ActiveRecord::Migration[7.0]
  def change
    create_table :posts do |t|
      t.integer :game_id
      t.boolean :gpt_created
      t.text :body

      t.timestamps
    end
  end
end
