class AddNumberOfQueriestoGames < ActiveRecord::Migration[7.0]
  def change
    add_column :games, :number_of_queries, :integer
  end
end
