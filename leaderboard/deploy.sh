#!/usr/bin/env bash

set -eu 

set -o pipefail

printf "\n\n######## leaderboard/deploy ########\n"

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
PROJECT=${LEADERBOARD_NAMESPACE:-leaderboard}
KAFKA_NAMESPACE=${KAFKA_NAMESPACE:-kafka-demo}
QUAY_ORG=${QUAY_ORG:-redhatdemo}

if [[ "${REDEPLOY}" = "false" ]]; then
  printf "\n\n######## leaderboard::deploy::  Install ########\n"

  $DIR/installer installCatalogSources

  $DIR/installer createProjects

  $DIR/installer createTopics

  $DIR/installer installPipelines

  $DIR/installer installPotgresql

  $DIR/installer installLeaderboard
else
  printf "\n\n######## leaderboard::deploy:: Skip resource creation ########\n"
fi

$DIR/installer installLeaderboard
$DIR/installer deployLeaderboard