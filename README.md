Chatroom
========

This is a sinatra-based app that would allow to agregate and manupulate events from a "hypothetical" chatroom.


Usage:
------

To create dummy data:

1)run the app:

				ruby app.rb

2) seed data:

				ruby dummy_data.rb

To get a list of events from 2014-01-01T00:00:00Z to 2014-03-28T13:01:00Z :

				curl http://localhost:4567/events?from=2014-01-01T00:00:00Z&to=2014-03-28T13:01:00Z

To get a list of events from 2014-01-01T00:00:00Z to 2014-03-28T13:01:00Z rounded to a minute:

				curl http://localhost:4567/summary?from=2014-01-01T00:00:00Z&to=2014-02-28T13:01:00Z&by=minute

To get a list of events from 2014-01-01T00:00:00Z to 2014-03-28T13:01:00Z rounded to an hour:

				curl http://localhost:4567/summary?from=2014-01-01T00:00:00Z&to=2014-02-28T13:01:00Z&by=hour

To get a list of events from 2014-01-01T00:00:00Z to 2014-03-28T13:01:00Z rounded to a day:

				curl http://localhost:4567/summary?from=2014-01-01T00:00:00Z&to=2014-02-28T13:01:00Z&by=day