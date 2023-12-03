class GamesController < ApplicationController

  def index
    matching_games = Game.all.where(:author_id => current_user.id)

    @list_of_games = matching_games.order({ :created_at => :desc })

    render({ :template => "games/index" })
  end

  def show
    the_id = params.fetch("path_id")

    matching_games = Game.where({ :id => the_id })

    @the_game = matching_games.at(0)

    matching_posts = Post.all.where(:game_id => @the_game.id).offset(0) # change to 1 when the time is right

    @list_of_posts = matching_posts.order({ :created_at => :asc })

   #client = OpenAI::Client.new
    #@response = client.chat(
     # parameters: {
      #  model: "gpt-3.5-turbo",
      #  messages: [{ role: "user", content: "Hello!"}],
      #  temperature: 0.7,
      #},
    #)
     # response.fetch("choices").at(0).fetch("message").fetch("content")

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

      #add the first API post

      prompt = Post.new
      prompt.game_id = the_game.id
      prompt.gpt_created = true
      prompt.body = "Tell me a joke" # insert prompt here
      prompt.save

      redirect_to("/games/#{the_game.id}", { :notice => "Game created successfully." })
    else
      redirect_to("/games", { :alert => the_game.errors.full_messages.to_sentence })
    end
  end

  def destroy
    the_id = params.fetch("path_id")
    the_game = Game.where({ :id => the_id }).at(0)
    the_posts = Post.where({:game_id => the_id})

    the_posts.destroy_all
    the_game.destroy

    redirect_to("/games", { :notice => "Game deleted successfully."} )
  end
end
