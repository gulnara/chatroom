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
Logbert.root.handlers << Logbert::Handlers::StreamHandler.for_path("logbert.log")
Logbert.root.level = :info
LOG = Logbert[self]

post '/event' do
	LOG.info params
	content_type :json
	json = JSON.parse(request.body.read)
	which_type(json).to_json
end

get '/events' do
	from = params[:from] 
	to = params[:to]
	get_events(from, to)
end

def get_events(from, to)
	events = Vault.all
	new_from = parse_date(from)
	new_to = parse_date(to)
	all_events = []
	events.each do |e|
		date = e["date"]
		if date >= new_from and date <= new_to
			event = e.attributes
			all_events << event.reject{|k,v| k == "_type" or k =="_id" }.to_json
		else
			LOG.info "No events were found"
		end
	end
	return all_events
end

def parse_date(date)
	date = Time.strptime(date, "%Y-%m-%dT%H:%M:%S%z")
	return date
end

get '/summary' do
	from = params[:from] 
	to = params[:to]
	by = params[:by]
	get_summary(from, to, by)
end

def get_summary(from, to, by)
	events = Vault.all
	all_events = []
	if by == "minute"
		events.each do |e|
			time = trim_minute(e["date"])
			add_event(time, new_from, new_to, all_events)
		end
	elsif by == "hour"
		events.each do |e|
			time = trim_hour(e["date"])
			add_event(time, new_from, new_to, all_events)
		end
	elsif by == "day"
		events.each do |e|
			time = trim_day(e["date"])
			add_event(time, new_from, new_to, all_events)
		end
	else
		LOG.error "Please specify the timeframe as : minute, hour or day"
		raise "Please specify the timeframe as : minute, hour or day"
	end

	return all_events

end

def count(events)
	enters = events.select{|a| a["type"]=="enter"}.count
	leaves = events.select{|a| a["type"]=="leave"}.count
	comments = events.select{|a| a["type"]=="comment"}.count
	highfives = events.select{|a| a["type"]=="highfive"}.count
end

def summary(from, to, by)
	events = get_summary(from, to, by)
	

def add_event(time, new_from, new_to, all_events)
	if time >= new_from or time <= new_to
		event = e.attributes
		all_events << event.reject{|k,v| k == "_type" or k =="_id" }.to_json
	end
end	

def trim_minute(time)
	p_time = parse(time)
	t_time = p_time.strftime("%Y-%m-%dT%H:%M%Z")
	new_time = Time.strptime(t_time, "%Y-%m-%dT%H:%M%Z")
end

def trim_hour(time)
	p_time = parse(time)
	t_time = p_time.strftime("%Y-%m-%dT%H%Z")
	new_time = Time.strptime(t_time, "%Y-%m-%dT%H%Z")
end

def trim_date(time)
	p_time = parse(time)
	t_time = p_time.strftime("%Y-%m-%d")
	new_time = Time.strptime(t_time, "%Y-%m-%d")
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
	event = Vault.new(:date => Time.strptime(event["date"], "%Y-%m-%dT%H:%M:%S%z"), :user => event["user"], :type => event["type"])
	event.save
end

def comment(event)
	event = Comments.new(:date => Time.strptime(event["date"], "%Y-%m-%dT%H:%M:%S%z"), :user => event["user"], :type => event["type"], :message => event["message"])
	event.save
end

def high_five(event)
	event = HighFives.new(:date => Time.strptime(event["date"], "%Y-%m-%dT%H:%M:%S%z"), :user => event["user"], :type => event["type"], :otheruser => event["otheruser"])
	event.save
end
