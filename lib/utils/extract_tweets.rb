#extract_tweets.rb
require 'rubygems'
require './lib/database/redis_db.rb'
require 'json'

# @author Daniel Machado Fernandez / Natalia Garcia Menendez
# @version 1.0
# 
# Extract tweets from the corpus and stores it on a DB
class ExtractTweets

	# Extracts line by line from file to a Redis databse
	#
	# @param filename [String] name of the file to parse
	def extract filename

		con = RedisDB.new
		con.connect_database RedisDB::TWEETS

		f1 = File.open(filename, 'r') 

		linea = f1.gets
		puts 'Extracts Tweets and save in BD'
		pos = 1
		until linea == nil	
			if(pos%5 != 0)
				partes = linea.split(/\t/)
				tweet = partes[2]
				con.save_tweet RedisDB::TRAIN, tweet
			end
			puts pos.to_s
			pos = pos + 1
			linea = f1.gets
			
		end
		f1.close
		puts 'FINALIZE Extracts Tweets and save in BD'

	end

end