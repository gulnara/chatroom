require 'mongo'
require 'mongo_mapper'

class Vault
	include MongoMapper::Document
	key :date, 			Time,		:required => true
	key :user, 			String,	:required => true
	key :type, 			String,	:required => true
end

class Comments < Vault
	key :message, 	String,	:required => true
end

class HighFives < Vault
	key :otheruser, String,	:required => true
end