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
  end


  def destroy
    the_id = params.fetch("path_id")
    the_post = Post.where({ :id => the_id }).at(0)

    the_post.destroy

    redirect_to("/posts", { :notice => "Post deleted successfully."} )
  end
end
