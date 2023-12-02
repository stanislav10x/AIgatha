# == Schema Information
#
# Table name: games
#
#  id                :integer          not null, primary key
#  difficulty        :string
#  number_of_queries :integer
#  setting           :string
#  title             :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  author_id         :integer
#
class Game < ApplicationRecord
end
