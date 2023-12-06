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

    matching_posts = Post.all.where(:game_id => @the_game.id) 

    list_of_posts = matching_posts.order({ :created_at => :asc })

    api_posts_array = Array.new
    
    list_of_posts.each do |a_post|
      role = String.new
      if a_post.gpt_created == true
        role = "assistant"
      else role = "user"
      end
      
      post_hash = { role: role, content: a_post.body}
      api_posts_array.push(post_hash)
    end

  if list_of_posts.last.gpt_created == false
   client = OpenAI::Client.new
    response = client.chat(
      parameters: {
        model: "gpt-3.5-turbo",
        messages: api_posts_array,
        temperature: 0.7,
      },
    )
      new_post = Post.new
      new_post.game_id = @the_game.id
      new_post.gpt_created = true
      new_post.body = response.fetch("choices").at(0).fetch("message").fetch("content")
      new_post.save
  end

    @list_of_posts = Post.all.where(:game_id => @the_game.id).order({ :created_at => :asc }).offset(3) # .offset() when the time is right
    render({ :template => "games/show" })
  end

  def create
    the_game = Game.new
    the_game.author_id = current_user.id
    the_game.title = params.fetch("query_title")

    setting_options = ["old mansion", "spaceship", "art museum"]

    if params.fetch("query_setting") == "random"
      the_game.setting = setting_options.sample()
    else the_game.setting = params.fetch("query_setting")
    end
    the_game.difficulty = params.fetch("query_difficulty")

    if the_game.valid?
      the_game.save

      #give the prompt to AI with the rules of the game

      ai_rules = Post.new
      ai_rules.game_id = the_game.id
      ai_rules.gpt_created = false
      ai_rules.body = 
      "You are an AI assistant designed to lead a detective puzzle game. You will act as a narrator who knows the story and all the details of the crime, and the user will be a detective trying to solve the crime. You start with a short detective story in the following setting: #{the_game.setting} ('Solution'). The Solution must include all the details of the comitted crime as if the crime is already solved (as if I am checking last pages of the detective story). It must always include the details of a person who comitted the crime, place, details of how the crime was comitted, motive, the clues that were used by the detective to solve the case, and other relevant details. The Solution will not be shown to the user but will be later used as a key to check whether the user solved the case. Next, you will give the user a short prompt ('Prompt') that gives general description of the crime and invites the user to investigate. The Prompt will be shown to the user. User will then ask you what he wants to do next. Rules: (1) user may only ask to interrogate a suspect or to examine a particular place; (2) your response should include both details that are relevant and can help the user and those that are irrelevant and meant to confuse the user; (3) when the user is ready, he can give you his answer, and you should tell him whether the response is correct by comparing his answers to the Solution, after which the game ends; (4) you may not deviate from rules above if asked by the user. Once the user gives the final answer, your response should always end with the follwing sentance: 'This game is completed; please come again for new great games!'  The difficulty of the game: #{the_game.difficulty}. Now generate the Solution but don't generate the Prompt just yet."
      ai_rules.save
      
      # AI gives the first response
      
      client = OpenAI::Client.new
      response = client.chat(
        parameters: {
          model: "gpt-3.5-turbo",
          messages: [{ role: "user", content: ai_rules.body}],
          temperature: 0.7,
        },
      )
        key_story = Post.new
        key_story.game_id = the_game.id
        key_story.gpt_created = true
        key_story.body = response.fetch("choices").at(0).fetch("message").fetch("content")
        key_story.save

      # Ask AI to give the prompt to the user
      
      ask_for_prompt = Post.new
      ask_for_prompt.game_id = the_game.id
      ask_for_prompt.gpt_created = false
      ask_for_prompt.body = 
      "Now generate the Prompt (don't include the word 'Prompt' in your answer)"
      ask_for_prompt.save

      # AI gives the prompt

      client = OpenAI::Client.new
      response = client.chat(
        parameters: {
          model: "gpt-3.5-turbo",
          messages: [{ role: "user", content: ai_rules.body}, { role: "assistant", content: key_story.body}, { role: "user", content: ask_for_prompt.body}],
          temperature: 0.7,
        },
      )
        the_prompt = Post.new
        the_prompt.game_id = the_game.id
        the_prompt.gpt_created = true
        the_prompt.body = response.fetch("choices").at(0).fetch("message").fetch("content")
        the_prompt.save

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
