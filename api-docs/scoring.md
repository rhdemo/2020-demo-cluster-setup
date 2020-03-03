# JSON spec

### POST /scores

#### Request Body:
```json
{
  "game": {
    "id": "new-game-1583157438",
    "state": "active",
    "date": "2020-03-02T13:57:18.000Z",
    "configuration": {}
  },
  "player": {
    "id": "Emerald Wanderer",
    "username": "Emerald Wanderer",
    "avatar": {
      "body": 1,
      "eyes": 3,
      "mouth": 0,
      "ears": 2,
      "nose": 1,
      "color": 3
    },
    "gameId": "new-game-1583157438",
    "score": 0,
    "right": 2,
    "wrong": 1,
    "lastRound": null,
    "currentRound": {
      "itemId": 0,
      "choices": [
        9,
        null,
        null,
        5,
        0,
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
          "number": 5,
          "from": 3,
          "result": "incorrect"
        },
        {
          "format": "number",
          "number": 0,
          "from": 2,
          "result": "correct"
        }
      ],
      "image": "/static/images/0.jpg",
      "points": 95,
      "correct": false
    },
    "creationServer": "SFO",
    "gameServer": "SFO",
    "scoringServer": "NY"
  },
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
      "result": null
    },
    {
      "format": "number",
      "number": 0,
      "from": 2,
      "result": "correct"
    }
  ]
}
```

#### Response Body
```json
{
  "player": {
    "id": "Emerald Wanderer",
    "username": "Emerald Wanderer",
    "avatar": {
      "body": 1,
      "eyes": 3,
      "mouth": 0,
      "ears": 2,
      "nose": 1,
      "color": 3
    },
    "gameId": "new-game-1583157438",
    "creationServer": "SFO",
    "gameServer": "SFO",
    "scoringServer": "NY",
    "score": 95,
    "right": 3,
    "wrong": 1,
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
      "points": 95,
      "correct": true
    },
    "currentRound": {
      "itemId": 1,
      "choices": [
        5,
        4,
        8,
        5,
        7,
        8
      ],
      "answers": [
        {
          "format": "number"
        },
        {
          "format": "decimal"
        },
        {
          "format": "number"
        },
        {
          "format": "number"
        }
      ],
      "image": "/static/images/1.jpg",
      "points": 100,
      "correct": false
    }
  }
}
```

### Scoring Kafka Message
Scoring Server -> Kafka mirrored to HQ
```json
{
  "player": {
    "gameId": "new-game-1583157438",
    "id": "Emerald Wanderer",
    "username": "Emerald Wanderer",
    "score": 95,
    "right": 3,
    "wrong": 1,
    "avatar": {
      "body": 1,
      "eyes": 3,
      "mouth": 0,
      "ears": 2,
      "nose": 1,
      "color": 3
    },
    "creationServer": "SFO",
    "gameServer": "NY",
    "scoringServer": "NY"
  }
}
```
