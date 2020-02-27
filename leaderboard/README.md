# Configuring Pipelines

To push and pull from the private repo using pipelines. You need to add a secret to the `pipeline` service account of the namespace.

```yaml
---
apiVersion: v1
kind: Secret
metadata:
  name: leaderboard-git
  annotations:
    tekton.dev/git-0: https://github.com
type: kubernetes.io/basic-auth
stringData:
  username: <your git user id>
  password: <your git personal access token>
---
apiVersion: v1
kind: Secret
metadata:
  name: leaderboard-quay
  annotations:
    tekton.dev/docker-0: https://quay.io/v2
type: kubernetes.io/basic-auth
stringData:
  username: <your quay user id>
  password: <your quay password>
```

Once you put the secret run the make command from the root.

## Ref

- https://help.github.com/en/github/authenticating-to-github/creating-a-personal-access-token-for-the-command-line

- https://github.com/tektoncd/pipeline/blob/master/docs/auth.md