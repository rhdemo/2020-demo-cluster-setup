# JSON spec

### POST /scores

#### Request Body:
```json
{
  "game": {
    "id": "new-game-1582582052",
    "state": "active",
    "configuration": {}
  },
  "player": {
    "id": "Luminous Quester",
    "username": "Luminous Quester",
    "score": 95
  },
  "item": {
    "id": 1,
    "price": [
      8,
      ".",
      5,
      5
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
    ]
  },
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
      "result": null
    },
    {
      "format": "number"
    }
  ],
  "pointsAvailable": 100
}
```

#### Response Body
```json
{
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
      "format": "number"
    }
  ],
  "pointsAvailable": 95,
  "points": 0,
  "correct": false,
  "cluster": "US West 1"
}
```

### Scoring Kafka Message
Scoring Server -> Kafka mirrored to HQ
```json
{
  "game": {
    "id": "new-game-1582548335",
    "state": "active",
    "date": "2020-02-24T12:45:35.000Z",
    "configuration": {}
  },
  "player": {
    "id": "Forest Master",
    "username": "Forest Master",
    "score": 0
  },
  "item": {
    "id": 0,
    "name": "Dollar bill",
    "price": [
      1,
      ".",
      0,
      0
    ]
  },
  "transaction": {
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
        "format": "number"
      }
    ],
    "pointsAvailable": 95,
    "points": 0,
    "correct": false,
    "cluster": "US West 1"
  }
}
```
