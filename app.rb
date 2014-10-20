require 'sinatra'
require 'mongo'
require 'mongo_mapper'
require 'uri'
require 'logbert'
require 'json'
require './actions/data_manupulation.rb'

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
	DataMassager.which_type(json).to_json
end

get '/events' do
	from = params[:from] 
	to = params[:to]
	events = DataMassager.events(from, to)
	events.to_json
end

get '/summary' do
	from = params[:from] 
	to = params[:to]
	by = params[:by]
	DataMassager.get_summary(from, to, by)
end

