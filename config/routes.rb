Rails.application.routes.draw do

  get("/", {:controller => "game", :action => "inputs"})
  get("/games/:game_id", {:controller => "game", :action => "new_game"})
  post("/submit_form", {:controller => "game", :action => "question_one"})
end
