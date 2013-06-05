#calculate_punctuation_tweets.rb
require 'rubygems'
require './lib/database/redis_db.rb'
require './lib/model/feeling.rb'
require './lib/score.rb'
require './lib/database/postgresql_db.rb'
require 'json'
require 'date'

# @author Daniel Machado Fernandez / Natalia Garcia Menendez
# @version 1.0
#
# Calculates the tweet ranking by days
class CalculatePunctuationTweets

	# @!attribute psql
	# @return [PostgresqlDB] PostgreSQL connection
	:psql

	def initialize

		@psql = PostgresqlDB.new
		@psql.connect_database
	end

	# Calculate the tweets score of TEST and stores it on Postgre
	#
	# @param filename [String] name of the file to parse
	def calculate filename
		puts 'Extract Tweets from TEST'
		scores = Score.new
		
		f1 = File.open(filename, 'r') 

		line = f1.gets
		pos = 1
		fecha = nil
		puntTotalOld = 0
		puntTotalNew = 0
		total = 0
		until line == nil	
			if(pos%5 == 0)
				partes = line.split(/\t/)
				tweet = partes[2]
				if(tweet!= nil and tweet.length < 150)
					dateTime = partes[0]
					dateTime = dateTime.split("T")
					date = dateTime[0].split("-")
					puts "DATE: " + date.to_s
					puts pos
					date = Date.new(date[0].to_i, date[1].to_i, date[2].to_i)
					if(fecha == nil)
						fecha = date
					end
					if(fecha != date)
						mediaOld = puntTotalOld / total
						mediaNew = puntTotalNew / total
						puts "Creating a new feeling"
						feeling = Feeling.new
						feeling.puntOld = mediaOld
						feeling.puntNew = mediaNew
						feeling.date = fecha
						feeling.save
						puts "Day changed"

						total = 0
						puntTotalOld = 0
						puntTotalNew = 0
						fecha = date

					end
					punts = scores.score tweet
					total = total + 1
					puntTotalNew = puntTotalNew + punts[1]
					puntTotalOld = puntTotalOld + punts[0]

				end
			
			end
			pos = pos + 1
			line = f1.gets
			
		end
		f1.close

	end

end