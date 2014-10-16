curl -X POST -H 'Content-Type: application/json' -d '{"date": "2014­02­28T13:00Z", "user": "Alice", "type": "enter"}' http://localhost:4567/event

curl -X POST -H 'Content-Type: application/json' -d '{"date": "2014­02­28T13:01Z", "user": "Alice", "type": "comment",
"message": "hello, this is a sample message"}' http://localhost:4567/event

curl -X POST -H 'Content-Type: application/json' -d '{"date": "2014­02­28T13:02Z", "user": "Alice", "type": "highfive",
"otheruser": "Bob"}' http://localhost:4567/event

curl -X POST -H 'Content-Type: application/json' -d '{"date": "2014­02­28T13:03Z", "user": "Alice", "type": "leave"}' http://localhost:4567/event