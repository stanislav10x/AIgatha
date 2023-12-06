class LeaderboardController < ApplicationController
  def show
    completed_games = Game.where(:status => "solved").order({ :number_of_queries => :asc })
    @array_of_winning_users = Array.new

    completed_games.each do |a_game|
      winning_username = User.where(:id => a_game.author_id).first.username
      if @array_of_winning_users.index(winning_username) == nil
       @array_of_winning_users.push(winning_username)
      end
    end

    render({ :template => "leaderboard/show" })
  end
end
