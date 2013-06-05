#redis_db.rb
require 'rubygems'
require 'redis'

# @author Daniel Machado Fernandez / Natalia Garcia Menendez
# @version 1.0
#
# Manages the connection with the Redis DB
class RedisDB
	
	# @!attribute db
	# @return [Redis] An instance from a Redis DB with the redis gem
	# @see http://rubydoc.info/gems/redis/3.0.4/frames
	attr_accessor :db

	TWEETS = "tweets"
	HAPPY = "happy"
	SAD = "sad"
	TRAIN = "train"
	REL_SAD = "relativeSad"
	REL_HAPPY = "relativeHappy"
	LIMIT_HAPPY = "limitScoreHappy"
	LIMIT_SAD = "limitScoreSad"
	COMBINATE = "combinate"
	SCORE_FINAL = "scoreFinal"


	# Connects to a Redis database
	#
	# @param db_name [String] database to connect
	def connect_database db_name

		@db = Redis.new

		@db = Redis.connect(
			:db => db_name,
			:host => "127.0.0.1",
			:port => 6379
			)
		
	end

	# Obtains a word from a concrete hash
	#
	# @param key [String] name of the hash
	# @param word [String] key of the hash
	#
	# @return [String] the score previously saved
	def get_word key, word
		@db.hget key, word
	end

	# Saves a score under a key in a concrete hash
	#
	# @param key [String] name of the hash
	# @param word [String] key of the hash
	# @param score [Float] score of the word
	def save_word key, word, score
		@db.hset key, word, score
	end

	# Stores a text in a List
	#
	# @param key [String] name of the list
	# @param tweet [String] data to store in the list
	def save_tweet key, tweet
		@db.rpush key, tweet
	end

	# Number of elements which the list contains
	#
	# @param key [String] name of the list
	#
	# @return [Integer] number of elements
	def size key
		@db.llen key
	end

	# Obtain a text previously saved
	#
	# @param key [String] name of the list
	# @param index [Integer] position of the list
	#
	# @return [String] the text previously saved
	def get_tweet key
		@db.rpop key
	end 

	# Clear a hash
	#
	# @param key [String] key of the hash to be deleted
	def clean key
		@db.del key
	end

	# Checks if a word was saved in the hash
	#
	# @param key [String] name of the hash
	# @param word [String] key of the hash
	#
	# @return [Boolean] true if exists, false if doesn't
	def exist_word? key, word
		@db.hexists key, word
	end

	# Obtains all keys in the hash
	#
	# @param hash [String] name of the hash
	#
	# @return [Array] with the stored keys
	def get_keys hash
		@db.hkeys hash
	end

	# Removes a key under a hash
	#
	# @param hash [String] name of the hash
	# @param key [String] key to delete
	def remove_key hash, key
		@db.hdel hash,key
	end

end