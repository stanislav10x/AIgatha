class PostsController < ApplicationController


  def create
    the_post = Post.new
    the_post.game_id = params.fetch("game_id_path")
    the_post.gpt_created = false
    the_post.body = params.fetch("query_body")

    if the_post.valid?
      the_post.save
      redirect_to("/games/#{the_post.game_id}", { :notice => "Post created successfully." })
    else
      redirect_to("/games/#{the_post.game_id}", { :alert => the_post.errors.full_messages.to_sentence })
    end

    #api_posts_array = Array.new



    #client = OpenAI::Client.new
    #@response = client.chat(
     # parameters: {
      #  model: "gpt-3.5-turbo",
      #  messages: [{ role: "user", content: "Hello!"}],
      #  temperature: 0.7,
      #},
    #)
     # response.fetch("choices").at(0).fetch("message").fetch("content")





  end

  #def update
  #  the_id = params.fetch("path_id")
  #  the_post = Post.where({ :id => the_id }).at(0)

  #  the_post.game_id = params.fetch("query_game_id")
  #  the_post.gpt_created = params.fetch("query_gpt_created", false)
  #  the_post.body = params.fetch("query_body")

  #  if the_post.valid?
  #    the_post.save
  #    redirect_to("/posts/#{the_post.id}", { :notice => "Post updated successfully."} )
  #  else
  #    redirect_to("/posts/#{the_post.id}", { :alert => the_post.errors.full_messages.to_sentence })
  #  end
  #end

  def destroy
    the_id = params.fetch("path_id")
    the_post = Post.where({ :id => the_id }).at(0)

    the_post.destroy

    redirect_to("/posts", { :notice => "Post deleted successfully."} )
  end
end
