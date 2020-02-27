# Configuring Pipelines

To push and pull from the private repo using pipelines. You need to add a [secret]( https://github.com/tektoncd/pipeline/blob/master/docs/auth.md) to the `pipeline` service account of the namespace.

The deployment expects the following variable to be available before deploying:

| Variable Name         | Description                                                                                                                                                                                  |
| --------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| LEADERBOARD_NAMESPACE | The OpenShift project where the leaderboard services will be deployed                                                                                                                        |
| QUAY_ORG              | The Quay repo org name                                                                                                                                                                       |
| GITHUB_USERNAME       | The Github user name to pull the sources from private repo                                                                                                                                   |
| GITHUB_PAT            | The Github [Personal Access Token](https://help.github.com/en/github/authenticating-to-github/creating-a-personal-access-token-for-the-command-line) to authenticate the     GITHUB_USERNAME |
| QUAY_USERNAME         | The Quay.io user Name                                                                                                                                                                        |
| QUAY_PASSWORD         | The Quay.io user password                                                                                                                                                                    |
| MAVEN_MIRROR_URL      | The Maven mirror to use to make builds faster                                                                                                                                                |

Once you put the secret run the make command from the root.

## Ref

- 

-