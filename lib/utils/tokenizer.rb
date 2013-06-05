#tokenizer.rb
require 'rubygems'
require 'tokenizer'

# @author Daniel Machado Fernandez / Natalia Garcia Menendez
# @version 1.0
#
# Tokenizes a text and delete the punctuation signs and downcases it
class Splitter

	# Splits the text
	#
	# @param text [String] text to tokenize
	#
	# @return [Array] of words extracted from the original text
	def split text
		
		tk = Tokenizer::Tokenizer.new
		text.delete! ':()[].,;!¡¿?"'
		text.downcase!
		tokens = tk.tokenize text

	end

end