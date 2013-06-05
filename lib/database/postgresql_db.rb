#postgresql_db.rb
require 'rubygems'
require 'active_record'
require 'yaml'

# @author Daniel Machado Fernandez / Natalia Garcia Menendez
# @version 1.0
# 
# Manages the connection with the PostgreSQL DB
class PostgresqlDB
	
	# @!attribute db
	# @return [Postgresql] An instance from a PostgreSQL DB with the pg gem
	attr_accessor :db

	FEELING_SCORES = "feeling_scores"


	# Connects to a PostgreSQL database with the configuration defined in database.yml
	def connect_database

		@db = YAML::load(File.open('./database.yml'))
		ActiveRecord::Base.establish_connection(@db)

	end

end