#!/usr/bin/env bash

set -eu 

set -o pipefail

printf "\n\n######## leaderboard/deploy ########\n"

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
PROJECT=${LEADERBOARD_NAMESPACE:-leaderboard}
KAFKA_NAMESPACE=${KAFKA_NAMESPACE:-kafka-demo}
QUAY_ORG=${QUAY_ORG:-redhatdemo}

$DIR/installer createProjects
$DIR/installer createTopics
$DIR/installer installLeaderboardAPI
$DIR/installer deployLeaderboardAPI
$DIR/installer installLeaderboard
$DIR/installer deployLeaderboard