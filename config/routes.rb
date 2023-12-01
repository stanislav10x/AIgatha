Rails.application.routes.draw do
  devise_for :users

  # Routes for the Game resource:

  # CREATE
  post("/insert_game", { :controller => "games", :action => "create" })
          
  # READ
  get("/games", { :controller => "games", :action => "index" })
  
  get("/games/:path_id", { :controller => "games", :action => "show" })
  
  # UPDATE
  
  post("/modify_game/:path_id", { :controller => "games", :action => "update" })
  
  # DELETE
  get("/delete_game/:path_id", { :controller => "games", :action => "destroy" })

  #------------------------------

  get("/", {:controller => "game", :action => "inputs"})
  get("/games/:game_id", {:controller => "game", :action => "new_game"})
  post("/submit_form", {:controller => "game", :action => "question_one"})
end
