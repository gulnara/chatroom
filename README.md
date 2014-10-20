In order to create dummy data run:

ruby dummy_data.rb

To get a list of events from 2014-01-01T00:00:00Z to 2014-03-28T13:01:00Z :

curl http://localhost:4567/events?from=2014-01-01T00:00:00Z&to=2014-03-28T13:01:00Z

To get a list of events from 2014-01-01T00:00:00Z to 2014-03-28T13:01:00Z rounded to a minute:

curl http://localhost:4567/summary?from=2014-01-01T00:00:00Z&to=2014-02-28T13:01:00Z&by=minute

To get a list of events from 2014-01-01T00:00:00Z to 2014-03-28T13:01:00Z rounded to an hour:

curl http://localhost:4567/summary?from=2014-01-01T00:00:00Z&to=2014-02-28T13:01:00Z&by=hour

To get a list of events from 2014-01-01T00:00:00Z to 2014-03-28T13:01:00Z rounded to a day:

curl http://localhost:4567/summary?from=2014-01-01T00:00:00Z&to=2014-02-28T13:01:00Z&by=day