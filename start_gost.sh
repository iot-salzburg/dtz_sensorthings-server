#!/usr/bin/env bash
docker-compose build
docker-compose push  || true
docker stack deploy --compose-file docker-compose.yml gost

# NB: gost-db volume is kept persistent in swarm node, use following commands for backup & delete:
# $ ssh SWARM_NODE docker ps' # get gost-db container-id
# $ ssh -t SWARM_NODE docker exec -ti <container-id> pg_dumpall -U postgres gost > pg_dumpl.sql
# $ ssh SWARM_NODE docker volume rm gost_postgis
