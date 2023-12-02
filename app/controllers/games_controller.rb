class GamesController < ApplicationController
  def index
    matching_games = Game.all

    @list_of_games = matching_games.order({ :created_at => :desc })

    render({ :template => "games/index" })
  end

  def show
    the_id = params.fetch("path_id")

    matching_games = Game.where({ :id => the_id })

    @the_game = matching_games.at(0)

    matching_posts = Post.all

    @list_of_posts = matching_posts.order({ :created_at => :asc })

    render({ :template => "games/show" })
  end

  def create
    the_game = Game.new
    the_game.author_id = current_user.id
    the_game.title = params.fetch("query_title")
    the_game.setting = params.fetch("query_setting")
    the_game.difficulty = params.fetch("query_difficulty")

    if the_game.valid?
      the_game.save
      redirect_to("/games/#{the_game.id}", { :notice => "Game created successfully." })
    else
      redirect_to("/games", { :alert => the_game.errors.full_messages.to_sentence })
    end
  end

  def destroy
    the_id = params.fetch("path_id")
    the_game = Game.where({ :id => the_id }).at(0)

    the_game.destroy

    redirect_to("/games", { :notice => "Game deleted successfully."} )
  end
end
