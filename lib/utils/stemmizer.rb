#stemmizer.rb
require 'rubygems'
require 'lingua/stemmer'

# @author Daniel Machado Fernandez / Natalia Garcia Menendez
# @version 1.0
#
# Calculate the stems from a word
class Stemmizer

	# Calculates the stems from a word based on a language
	#
	# @param word [String] word to be stemmized
	# @param lang [String] language (es,en)
	#
	# @return [String] of stems retrieved from the word
	def stemmize word, lang

		stemmer = Lingua::Stemmer.new(:language => lang)
		stemmer.stem(word)

	end

end