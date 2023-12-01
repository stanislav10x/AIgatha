class GameController < ApplicationController
  def inputs
    @game_id = rand(10000..1000000)
    render(:template => "game_templates/inputs")
  end

  def new_game
    render(:template => "game_templates/new_game")
  end

  def question_one
    @selected_option = params.fetch("action")
    redirect_to("/100")
  end
end
