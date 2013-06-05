#score.rb
require './lib/utils/stemmizer.rb'
require './lib/utils/tokenizer.rb'

# @author Daniel Machado Fernandez / Natalia Garcia Menendez
# @version 1.0
#
# Calculates the score for a tweet
class Score

	# Calculates the score for a tweet
	#
	# @param text [String] the tweet
	#
	# @return [Array] in the first position, the CSV score and in the second position, the learned Tweet score
	def score text

		sp = Splitter.new
		tokens = sp.split text

		totalNew = 0
		totalOld = 0
		numWordsNew = 0
		numWordsOld = 0
		st = Stemmizer.new
		rd = RedisDB.new
		rd.connect_database 'stems'

		tokens.each do |token|
			
			stem = st.stemmize token, 'es'

			if (rd.exist_word? 'es', stem)
				punt = (rd.get_word 'es', stem).to_f
				if(punt < 3 or punt > 7)
					totalOld += punt
					numWordsOld += 1
				end
			end

			if (rd.exist_word? 'stems_new_lex', stem)
				punt = (rd.get_word 'stems_new_lex', stem).to_f
				if(punt <3 or punt >7)
					totalNew += punt
					numWordsNew += 1
				end
			end
	
		end

		if(numWordsNew!=0)
			totalNew = totalNew/numWordsNew
		end
		if(numWordsOld!=0)
			totalOld = totalOld/numWordsOld
		end

		a = [totalOld,totalNew]

	end

end