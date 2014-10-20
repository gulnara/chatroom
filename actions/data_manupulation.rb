require 'json'

module DataMassager

	# Gets list of events from and to specified dates.
	def self.events(from, to)
		get_events(from, to)
	end

	def self.get_events(from, to)
		events = Vault.all
		new_from = parse_date(from)
		new_to = parse_date(to)
		all_events = []
		events.each do |e|
			date = e["date"]
			if date >= new_from and date <= new_to
				event = e.attributes
				all_events << event.reject{|k,v| k == "_type" or k =="_id" }
			else
				LOG.info "No events were found"
			end
		end
		return all_events
	end

	# Formats the date for data processing.
	def self.parse_date(date)
		date = Time.strptime(date, "%Y-%m-%dT%H:%M:%S%z")
		return date
	end

	# Gets summary of the events from and to date by a specified timeframe
	def self.get_summary(from, to, by)
		events = get_events(from, to)
		if by == "minute"
			n_events = events.each{|e| e["date"] = trim_minute(e["date"])}
		elsif by == "hour"
			n_events = events.each{|e| e["date"] = trim_hour(e["date"])}
		elsif by == "day"
			n_events = events.each{|e| e["date"] = trim_date(e["date"])}
		else
			LOG.error "Please specify the timeframe as : minute, hour or day"
			raise "Please specify the timeframe as : minute, hour or day"
		end
		date_map = {}
		n_events.each do |e|
			date_map[e["date"]] ||= []
			date_map[e["date"]] << e
		end
		new_map = {}
		date_map.each do |d, e|
			new_map[d] = count_events(e)
		end
		return new_map.to_json
	end

	def self.count_events(map)
		counts = {}
		map.each do |e|
			counts[e["type"]] ||=0
			counts[e["type"]] += 1
		end
		return counts
	end

	def self.trim_minute(time)
		t_time = time.strftime("%Y-%m-%dT%H:%M%Z")
		new_time = Time.strptime(t_time, "%Y-%m-%dT%H:%M%Z")
	end

	def self.trim_hour(time)
		t_time = time.strftime("%Y-%m-%dT%H%Z")
		new_time = Time.strptime(t_time, "%Y-%m-%dT%H%Z")
	end

	def self.trim_date(time)
		t_time = time.strftime("%Y-%m-%d")
		new_time = Time.strptime(t_time, "%Y-%m-%d")
	end

	# The methods bellow allow the user to create events in the database.
	# Identifies the type of the event.
	def self.which_type(event)

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

	# Creates event when user either enters or leaves the chatroom.
	def self.enter_leave(event)
		event = Vault.new(:date => Time.strptime(event["date"], "%Y-%m-%dT%H:%M:%S%z"), :user => event["user"], :type => event["type"])
		event.save
	end

	# Creates event when user posts a comment.
	def self.comment(event)
		event = Comments.new(:date => Time.strptime(event["date"], "%Y-%m-%dT%H:%M:%S%z"), :user => event["user"], :type => event["type"], :message => event["message"])
		event.save
	end

	# Creates event when user high fives the other user.
	def self.high_five(event)
		event = HighFives.new(:date => Time.strptime(event["date"], "%Y-%m-%dT%H:%M:%S%z"), :user => event["user"], :type => event["type"], :otheruser => event["otheruser"])
		event.save
	end
	
end