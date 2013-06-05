#calculate_score.rb

# @author Daniel Machado Fernandez / Natalia Garcia Menendez
# @version 1.0
#
# Calculates the puntuation for a tweet
class CalculateScore

	# @!attribute con
	# @return [RedisDB] connection
	:con

	def initialize
		@con = RedisDB.new
		@con.connect_database RedisDB::TWEETS
	end

	# Calculate relative frecuencies from a tweet
	#
	# @param key [String] key from the database
	# @param numTotal [Integer] total de palabras
	def calculate_relatives_frecuencies key, numTotal

		puts "CALCULATE RELATIVES FRECUENCIES"

		words = @con.get_keys key

		words.each do |w|
			punt = @con.get_word key, w
			puntRel = punt.to_f / numTotal
			if(key.eql? RedisDB::HAPPY)
				puts key + "- " + w + ": " + puntRel.to_s
				@con.save_word RedisDB::REL_HAPPY, w, puntRel
			else
				puts key + "- " + w + ": " + puntRel.to_s
				@con.save_word RedisDB::REL_SAD, w, puntRel
			end
		end

	end

	# Calculate the limit scores for a tweet
	#
	# @param key [String] key database of feeling we want to calculate
	# @parm noKey [String] key database of feeling we DONT want to calculate
	# @param num [Integer] 1 (Happy feeling) | -1 (Sad feeling)
	def calculate_limit_scores key, noKey, num

		puts "CALCULATE LIMIT SCORES"

		words = @con.get_keys key

		words.each do |w|
			puntKey = @con.get_word key, w
			puntNoKey = @con.get_word noKey, w
			if(puntNoKey == nil)
				puntNoKey = 0.0
			end

			puntNoKey = puntNoKey.to_f
			puntKey = puntKey.to_f
			puntLimit = num * (([puntKey, puntNoKey].max + puntKey)/([puntKey,puntNoKey].max + puntNoKey) -1)

			if(key.eql? RedisDB::REL_HAPPY)
				puts key + "- " + w + ": " + puntLimit.to_s
				@con.save_word RedisDB::LIMIT_HAPPY, w, puntLimit
				@con.save_word RedisDB::LIMIT_SAD, w, 0.5
			else
				puts key + "- " + w + ": " + puntLimit.to_s
				@con.save_word RedisDB::LIMIT_SAD, w, puntLimit
				if(!@con.exist_word? RedisDB::LIMIT_HAPPY, w)
					@con.save_word RedisDB::LIMIT_HAPPY, w, -0.5
				end
			end
		end

	end

	# Calculates the combinate score with the data retrieved
	def calculate_combinate_score 

		puts "CALCULATE COMBINATE SCORE"

		words = @con.get_keys RedisDB::LIMIT_HAPPY

		words.each do |w|
			puntH = @con.get_word RedisDB::LIMIT_HAPPY, w
			puntS = @con.get_word RedisDB::LIMIT_SAD, w

			puntH = puntH.to_f
			puntS = puntS.to_f
			
			if(puntH.abs > puntS.abs)
				@con.save_word RedisDB::COMBINATE, w, puntH
			else 
				@con.save_word RedisDB::COMBINATE, w, puntS
			end
		end

	end

	# Obtains the final score to punctuate the tweets with the new lexic
	def calculate_final 

		words = @con.get_keys RedisDB::COMBINATE

		words.each do |w|
			punt = @con.get_word RedisDB::COMBINATE, w
			puntF = 5 * punt.to_f + 5
			@con.save_word RedisDB::SCORE_FINAL, w, puntF
			puts w + "," + puntF.to_s

		end

	end


end