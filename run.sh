#!/bin/bash

if [[ "$1" = "start" ]]; then
	docker-compose --project-name i-maintenance up
fi