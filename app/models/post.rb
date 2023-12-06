# == Schema Information
#
# Table name: posts
#
#  id          :integer          not null, primary key
#  body        :text
#  gpt_created :boolean
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  game_id     :integer
#
class Post < ApplicationRecord
  #validates :body, length: { maximum: 10000, message: "10000 characthers max"}
end
