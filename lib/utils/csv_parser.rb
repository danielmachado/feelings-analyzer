#csv_parser.rb
require 'rubygems'
require './lib/utils/stemmizer.rb'
require './lib/database/redis_db.rb'
require 'csv'

# @author Daniel Machado Fernandez / Natalia Garcia Menendez
# @version 1.0
#
# Parses a Comma Separated Values File and stemmizes its content, finally the result will be saved on a Redis database
class CSVParser 

	# Parses a CSV file
	#
	# @param filename [String] name of the file to parse
	def parse filename

		@stemmizer = Stemmizer.new

		index_en = Hash.new
		index_es = Hash.new

		con = RedisDB.new
		con.connect_database 'stems'

		CSV.foreach(filename) do |row|

			stem_en = @stemmizer.stemmize row[1],'en'
			stem_es = @stemmizer.stemmize row[2],'es'

			if(index_en.has_key? stem_en)

				index_en[stem_en] = (index_en[stem_en].to_f + row[3].to_f).to_f/2
				con.save_word 'en', stem_en, ((index_en[stem_en].to_f + row[3].to_f).to_f/2)
				puts(stem_en + ': ' + index_en[stem_en].to_s)

			else

				index_en[stem_en] = row[3].to_f
				con.save_word 'en', stem_en , row[3].to_f
				puts(stem_en + ': ' + index_en[stem_en].to_s)
				
			end

			if(index_es.has_key? stem_es)

				index_es[stem_es] = (index_es[stem_es].to_f + row[3].to_f).to_f/2
				con.save_word 'es', stem_es, ((index_es[stem_es].to_f + row[3].to_f).to_f/2)
				puts(stem_es + ': ' + index_es[stem_es].to_s)

			else

				index_es[stem_es] = row[3].to_f
				con.save_word 'es', stem_es , row[3].to_f
				puts(stem_es + ': ' + index_es[stem_es].to_s)

			end

		end

	end

	# Parses a CSV file with the new lex
	#
	# @param filename [String] name of the file to parse
	def parse_new_lex filename

		@stemmizer = Stemmizer.new

		index_es = Hash.new

		con = RedisDB.new
		con.connect_database 'stems'

		CSV.foreach(filename) do |row|

			stem_es = @stemmizer.stemmize row[0],'es'

			if(index_es.has_key? stem_es)

				index_es[stem_es] = (index_es[stem_es].to_f + row[1].to_f).to_f/2
				con.save_word 'stems_new_lex', stem_es, ((index_es[stem_es].to_f + row[1].to_f).to_f/2)
				puts(stem_es + ': ' + index_es[stem_es].to_s)

			else

				index_es[stem_es] = row[1].to_f
				con.save_word 'stems_new_lex', stem_es , row[1].to_f
				puts(stem_es + ': ' + index_es[stem_es].to_s)

			end

		end

	end

end