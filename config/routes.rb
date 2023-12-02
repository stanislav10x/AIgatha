Rails.application.routes.draw do
  # Routes for the Post resource:

  # CREATE
  post("/:game_id_path/insert_post", { :controller => "posts", :action => "create" })
          
  # READ
  #get("/posts", { :controller => "posts", :action => "index" })
    
  # UPDATE
  
  #post("/modify_post/:path_id", { :controller => "posts", :action => "update" })
  
  # DELETE
  get("/delete_post/:path_id", { :controller => "posts", :action => "destroy" })

  #------------------------------

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

  get("/", { :controller => "games", :action => "index" })
end
