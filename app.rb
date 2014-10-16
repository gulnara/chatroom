require 'sinatra'
require 'mongo'
require 'mongo_mapper'
require 'uri'
require 'json'

mongo_url = ENV['MONGOHQ_URL'] || 'mongodb://localhost/dbname'
 
MongoMapper.connection = Mongo::Connection.from_uri mongo_url
MongoMapper.database = URI.parse(mongo_url).path.gsub(/^\//, '') #Extracts 'dbname' from the uri
require './models/vault'

LOG = Logbert[self]

post '/parse' do
	content_type :json
  register(params).to_json
end

def which_type(event)
	if event[:type] == "enter" or type == "leave"
		enter_leave(event)
	elsif event[:type] == "comment"
		comment(event)
	elsif event[:type] == "highfive"
		high_five(event)
	else
		LOG.error "Oh oh, this is an indentified event!"
		raise "Oh oh, this is an indentified event!"
	end
end	

def enter_leave(event)
	event = Vault.new(:date => event["date"], :user => event["user"], :type => event["type"])
	event.save
end

def comment(event)
	event = Comments.new(:date => event["date"], :user => event["user"], :type => event["type"], :message => event["message"])
	event.save
end

def high_five(event)
	event = HighFives.new(:date => event["date"], :user => event["user"], :type => event["type"], :otheruser => event["otheruser"])
	event.save
end
