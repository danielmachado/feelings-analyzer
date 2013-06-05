#extract_tweets_words.rb
require './lib/database/redis_db.rb'
require './lib/utils/tokenizer.rb'

# @author Daniel Machado Fernandez / Natalia Garcia Menendez
# @version 1.0
#
# Extract tweets which contains a sad or happy icons to retrieve a new lexic
class ExtractTweetsWords

	# @!attribute numHappy
	# @return [Integer] number of Happy tweets
	attr_accessor :numHappy 

	# @!attribute numSad
	# @return [Integer] number of Sad tweets
	attr_accessor :numSad

	# @!attribute con
	# @return [RedisDB] connection
	:con

	def initialize
		@numSad = 0
		@numHappy = 0
		@con = RedisDB.new
		@con.connect_database RedisDB::TWEETS
	end

	# Extracts from TRAIN and retrieve words while counting
	def extract

		puts 'Extract Tweets Words by TRAIN'
		size = @con.size RedisDB::TRAIN
		size.times do |i|
			t = @con.get_tweet RedisDB::TRAIN
			puts i.to_s
			if(t.include?":)") 
				@numHappy = @numHappy + 1
				puts "HAPPY"
				s = Splitter.new
				words = s.split(t)
				save_words(RedisDB::HAPPY, words)
			end
			if(t.include?":(") 
				@numSad = @numSad + 1
				puts "SAD"
				s = Splitter.new
				words = s.split(t)
				save_words(RedisDB::SAD, words)
			end	
			
		end
		puts 'END Extract Tweets Words by TRAIN'

	end

	# Save words in redis DB by position
	#
	# @param key [Integer] position
	# @param words [String] text to save
	def save_words key, words

		words.each do |w|
			if(@con.exist_word?(key, w))
				punt = @con.get_word(key, w) 
				@con.save_word(key, w, (punt.to_i + 1))
			else
				@con.save_word(key, w, 1)
			end
		end
	end

	# Delete words in redis DB by position
	#
	# @param key [Integer] position
	def delete_words key
		words = @con.get_keys key

		words.each do |w|
			punt = @con.get_word key, w 
			punt = punt.to_i
			if(punt == 1 or punt == 2)
				@con.remove_key key, w
				puts w + ": " + punt.to_s
			end
		end
	end


end