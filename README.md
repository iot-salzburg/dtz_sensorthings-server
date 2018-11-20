# sensorthings-server

Central management server utilising the SensorThings API standard.


## Usage:

### Testing:

```bash
docker-compose up --build
```

### Deployment:

```bash
./start_gost.sh
./show_gost.sh
./stop_gost.sh
```

The service will be deployed on node il071 only and can be reached with:

http://192.168.48.71:8082 or 
http://192.168.48.71:8082/v1.0/Datastreams

