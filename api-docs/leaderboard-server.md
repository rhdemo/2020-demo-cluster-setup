# Leaderboard JSON

## Leaderboard UI -> Leaderboard Server

### Client Initialization `init`

Leaderboard UI -> Leaderboard Server initialization
Server responds with `leaderboard`

```json
{
  "type": "init"
}
```

### Leaderboard  `leaderboard`
Leaderboard Server -> Leaderboard UI sends leaderboard state.
Server has received `init`
Server pushes on a timer
```json
{
  "type": "leaderboard",
  "leaders": [
    {
      "player": "Unique Name 1",
      "score": 100,
      "achievements":  {}
    }
    //... 20 total ...
  ]
}
```
