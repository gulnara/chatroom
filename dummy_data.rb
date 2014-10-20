require 'rest_client'

#Post some dummy data
RestClient.post 'http://localhost:4567/event', {"date" => "2014-02-28T13:10:00Z", "user" => "Alice", "type" => "enter"}.to_json, :content_type => :json, :accept => :json 
RestClient.post 'http://localhost:4567/event', {"date" => "2014-04-28T13:12:00Z", "user" => "Kate", "type" => "enter"}.to_json, :content_type => :json, :accept => :json 
RestClient.post 'http://localhost:4567/event', {"date" => "2014-02-28T12:00:00Z", "user" => "Jack", "type" => "enter"}.to_json, :content_type => :json, :accept => :json 
RestClient.post 'http://localhost:4567/event', {"date" => "2014-04-28T12:07:00Z", "user" => "Max", "type" => "enter"}.to_json, :content_type => :json, :accept => :json 
RestClient.post 'http://localhost:4567/event', {"date" => "2014-02-28T13:12:00Z", "user" => "Peter", "type" => "enter"}.to_json, :content_type => :json, :accept => :json 
RestClient.post 'http://localhost:4567/event', {"date" => "2014-02-28T14:10:00Z", "user" => "Alice", "type" => "leave"}.to_json, :content_type => :json, :accept => :json 
RestClient.post 'http://localhost:4567/event', {"date" => "2014-02-28T14:12:00Z", "user" => "Kate", "type" => "leave"}.to_json, :content_type => :json, :accept => :json 
RestClient.post 'http://localhost:4567/event', {"date" => "2014-02-28T13:11:00Z", "user" => "Jack", "type" => "leave"}.to_json, :content_type => :json, :accept => :json 
RestClient.post 'http://localhost:4567/event', {"date" => "2014-02-28T13:12:00Z", "user" => "Max", "type" => "leave"}.to_json, :content_type => :json, :accept => :json 
RestClient.post 'http://localhost:4567/event', {"date" => "2014-02-28T13:12:00Z", "user" => "Alice", "type" => "comment", "message" => "hello, this is a sample message"}.to_json, :content_type => :json, :accept => :json 
RestClient.post 'http://localhost:4567/event', {"date" => "2014-02-28T13:12:00Z", "user" => "Kate", "type" => "comment", "message" => "hello, this is a sample message"}.to_json, :content_type => :json, :accept => :json 
RestClient.post 'http://localhost:4567/event', {"date" => "2014-02-28T13:10:00Z", "user" => "Alice", "type" => "comment", "message" => "hello, this is a sample message"}.to_json, :content_type => :json, :accept => :json 
RestClient.post 'http://localhost:4567/event', {"date" => "2014-02-28T13:11:00Z", "user" => "Alice", "type" => "comment", "message" => "hello, this is a sample message"}.to_json, :content_type => :json, :accept => :json 
RestClient.post 'http://localhost:4567/event', {"date" => "2014-02-28T13:13:00Z", "user" => "Alice", "type" => "highfive", "otheruser" => "Kate"}.to_json, :content_type => :json, :accept => :json 
RestClient.post 'http://localhost:4567/event', {"date" => "2014-02-28T13:14:00Z", "user" => "Alice", "type" => "highfive", "otheruser" => "Peter"}.to_json, :content_type => :json, :accept => :json 

