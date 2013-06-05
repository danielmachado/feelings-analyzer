#feeling.rb
require 'rubygems'
require 'active_record'
require 'json'

# @author Daniel Machado Fernandez / Natalia Garcia Menendez
# version 1.0
# 
# Model of the application
class Feeling < ActiveRecord::Base

	# puntOld is the score from a Tweet rated by Warrimer's lexic
	# puntNew is the score from a Tweet rated by New Lexic
	# date is the date of the tweet
	attr_accessible :puntOld, :puntNew, :date

end