# JSON spec

### Reset Game AMQP Message
mc/game
```json
{
  "body": {
    "type": "reset-game",
    "game": {
      "id": "da7d1fd0-22a8-4ce4-b33c-3bfd98c18190",
      "state": "lobby",
      "date": "2020-03-16T02:51:17.239Z",
      "configuration": {}
    }
  }
}
```

### Update Game AMQP Message
mc/game
```json
{
  "body": {
    "type": "game",
    "game": {
      "id": "da7d1fd0-22a8-4ce4-b33c-3bfd98c18190",
      "state": "active",
      "date": "2020-03-16T02:51:17.239Z",
      "configuration": {}
    }
  }
}
```