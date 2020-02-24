# Game Server JSON

## Phone UI -> Phone Server

### Client Initialization `init`

Phone UI -> Phone Server initialization
Server responds with `player-configuration`

```json
{
  "type": "init"
}
```

### User help `help`

Phone UI -> Phone Server help request
Server responds with `player-configuration`
```json
{
  "type": "help"
}
```

### Create Guess `guess`

Phone UI -> Phone Server initialization
```json
{
  "type": "guess",
  "itemId": 1,
  "playerId": "Luminous Quester",
  "gameId": "new-game-1582582052",
  "choices": [
    5,
    4,
    null,
    null,
    7,
    8
  ],
  "answers": [
    {
      "format": "number",
      "number": 8,
      "from": 2,
      "result": "correct"
    },
    {
      "format": "decimal"
    },
    {
      "format": "number",
      "number": 4,
      "from": 1,
      "result": "incorrect"
    },
    {
      "format": "number",
      "number": 5,
      "from": 3,
      "result": null
    }
  ]
}
```

## Phone Server -> Phone UI

### Heartbeat  `heartbeat`
Phone Server -> Phone UI sends player state.
Server has received `init` or `guess`
Server pushes on a timer
```json
{
  "type": "heartbeat",
  "game": {
    "id": "new-game-1581679350",
    "state": "active"
  }
}
```

### Player state  `player`
Phone Server -> Phone UI sends player state.
Server has received `init` or `guess`
```json
{
  "type": "player-configuration",
  "player": {
    "id": "Luminous Quester",
    "username": "Luminous Quester",
    "avatar": {},
    "gameId": "new-game-1582582052",
    "score": 95,
    "scoreCluster": "US West 2",
    "lastRound": {
      "itemId": 0,
      "choices": [
        9,
        null,
        null,
        5,
        null,
        1
      ],
      "answers": [
        {
          "format": "number",
          "number": 1,
          "from": 1,
          "result": "correct"
        },
        {
          "format": "decimal"
        },
        {
          "format": "number",
          "number": 0,
          "from": 4,
          "result": "correct"
        },
        {
          "format": "number",
          "number": 0,
          "from": 2,
          "result": "correct"
        }
      ],
      "image": "/static/images/0.jpg",
      "points": 0
    },
    "currentRound": {
      "itemId": 1,
      "choices": [
        5,
        4,
        null,
        null,
        7,
        8
      ],
      "answers": [
        {
          "format": "number",
          "number": 8,
          "from": 2,
          "result": "correct"
        },
        {
          "format": "decimal"
        },
        {
          "format": "number",
          "number": 4,
          "from": 1,
          "result": "incorrect"
        },
        {
          "format": "number",
          "number": 5,
          "from": 3,
          "result": "correct"
        }
      ],
      "image": "/static/images/1.jpg",
      "points": 95
    }
  },
  "game": {
    "id": "new-game-1582582052",
    "state": "active",
    "date": "2020-02-24T22:07:32.000Z",
    "configuration": {}
  }
}
```
