#!/usr/bin/env bash
echo "Printing 'docker service ls | grep gost':"
docker service ls | grep gost
echo ""
echo "Printing 'docker stack ps gost':"
docker stack ps gost
