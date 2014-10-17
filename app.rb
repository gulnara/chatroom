require 'sinatra'
require 'mongo'
require 'mongo_mapper'
require 'uri'
require 'logbert'
require 'json'

mongo_url = ENV['MONGOHQ_URL'] || 'mongodb://localhost/dbname'
 
MongoMapper.connection = Mongo::Connection.from_uri mongo_url
MongoMapper.database = URI.parse(mongo_url).path.gsub(/^\//, '') #Extracts 'dbname' from the uri
require './models/vault'

Logbert.root.handlers << Logbert::Handlers::StreamHandler.new
LOG = Logbert[self]

post '/event' do
	LOG.info params
	content_type :json
	json = JSON.parse(request.body.read)
	which_type(json).to_json
end

get '/events?from=:from&to=:to' do
	from = params[:from] 
	to = params[:to]
	get_events(from, to)
end

def get_events(from, to)
	events = Vault.all
	all_events = []
	events.each do |e|
		if e.date >= from or e.date <= to
			all_events << e
		end
	end
	return all_events
end

get '/summary?from=:from&to=to&by=:by' do
	from = params[:from] 
	to = params[:to]
	by = params[:by]
	get_summary(from, to, by)
end

def get_summary(from, to, by)
	events = Vault.all
	all_events = []
	new_from = parse_date(from, by)
	new_to = parse_date(to, by)
	events.each do |e|
		if e.date >= new_from or e.date <= new_to
			all_events << e
		end
	end
	return all_events
end

def parse_date(date,by)
	if by == "minute"

	elsif by == "hour"

	elsif by == "hour"

	else
		LOG.error "Please specify the timeframe as : minute, hour or day"
		raise "Please specify the timeframe as : minute, hour or day"
	end

end


def which_type(event)

	LOG.info "here is my event #{event}"
	if event["type"] == "enter" or event["type"] == "leave"
		enter_leave(event)
	elsif event["type"] == "comment"
		comment(event)
	elsif event["type"] == "highfive"
		high_five(event)
	else
		LOG.error "Oh oh, this is an unidentified event! #{event}"
		raise "Oh oh, this is an unidentified event! #{event}"
	end
end	

def enter_leave(event)
	event = Vault.new(:date => Time.new(event["date"]), :user => event["user"], :type => event["type"])
	event.save
end

def comment(event)
	event = Comments.new(:date => Time.new(event["date"]), :user => event["user"], :type => event["type"], :message => event["message"])
	event.save
end

def high_five(event)
	event = HighFives.new(:date => Time.new(event["date"]), :user => event["user"], :type => event["type"], :otheruser => event["otheruser"])
	event.save
end
