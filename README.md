# sensorthings-server

Central management server utilising the SensorThings API standard.


## Usage:

### Testing:

```bash
docker-compose up --build
```

Check if the following page is available: (status_code=20X)

http://192.168.48.71:8082/v1.0/Datastreams


### Deployment:

```bash
./start_gost.sh
./show_gost.sh
./stop_gost.sh
```

The service will be deployed on a worker node in the il07X swarm using the shared glusterFS directory `/mnt/glusterfs/dtz/gost/postgresql/` and is available under:

http://192.168.48.71:8082 or 
http://192.168.48.71:8082/v1.0/Datastreams

