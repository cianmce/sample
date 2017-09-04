namespace :encrypt_column do
  desc "Encrypts columns"
  task :up => :environment do
    ActiveRecord::Base.record_timestamps = false
    original_column = "p12"
    encrypted_column = "secure_p12"

    Game.find_each(batch_size: 50) do |game|
      puts game.id
      sleep 5 if game.id % 100 == 0
      break if game.id % 5 == 0

      game.secure_p12 = game.p12
      game.save!
    end
  end
end
