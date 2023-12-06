class RemoveNumberOfQueriesFromGames < ActiveRecord::Migration[7.0]
  def change
    remove_column :games, :number_of_queries
  end
end
