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
  validates :body, length: { maximum: 300, message: "300 characthers max"}
end
