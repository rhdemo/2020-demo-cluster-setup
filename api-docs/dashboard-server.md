# Dashboard JSON

## Dashboard UI -> Dashboard Server

### Client Initialization `init`

Dashboard UI -> Dashboard Server initialization
Server responds with `clusters`

```json
{
  "type": "init"
}
```

### Clusters  `Clusters`
Dashboard Server -> Dashboard UI sends player state.
Server has received `init`
Server pushes on a timer
```json
{
  "type": "clusters",
  "clusters": [
    {
      "id": "wc1",
      "name": "West Coast 1",
      "status": "up",
      "traffic": [
        { 
          "to": "ec2",
          "throughput": 1234
        },
        { 
          "to": "sing3",
          "throughput": 4567
        }
      ]     
    },
    {
      "id": "ec2",
      "name": "East Coast 2",
      "status": "up",
      "traffic": [
        { 
          "to": "wc1",
          "throughput": 1234
        },
        { 
          "to": "sing3",
          "throughput": 4567
        }
      ]     
    },
    {
      "id": "sing3",
      "name": "Singapore 3",
      "status": "up",
      "traffic": [
        { 
          "to": "wc1",
          "throughput": 1234
        },
        { 
          "to": "ec2",
          "throughput": 4567
        }
      ]     
    }
    //... all clusters ...
  ]
}
```
