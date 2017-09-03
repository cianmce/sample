class Game < ApplicationRecord
  belongs_to :company
  has_and_belongs_to_many :role
  has_and_belongs_to_many :user
  attr_encrypted :secure_p12, key: 'YWJjZDEyMzRhYmNkYWJjZDEyMzRhYmNkYWJjZDEyMzRhYmNk'


  # https://github.com/attr-encrypted/attr_encrypted
  # ActiveRecord::Base.record_timestamps = false
  # Game.find_each.with_index do |game|
  # Game.all.limit(20).with_index do |game|
  #   game.secure_p12 = game.p12
  #   sleep 5
  #   game.save!
  # end
  # do the updated_at




# ActiveRecord::Base.record_timestamps = false

# start_time = Time.now

# update_games(Game.all)

# games = Game.where("updated_at > ?", start_time)
# # for games being > 0
# # try 20 times then fail and raise

# def update_games(games)
#   games.limit(20).each.with_index do |game|
#     game.secure_p12 = game.p12
#     sleep 5
#     game.save!
#   end
# end





end
