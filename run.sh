#!/bin/bash

if [[ "$1" = "start" ]]; then
	export HOSTNAME=`hostname`
	docker-compose --project-name sensorthingsserver up --build -d --force-recreate
fi