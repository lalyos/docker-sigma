

## first play

```
docker run -d \
  --name mydb \
  -e POSTGRES_PASSWORD=secret  \
  postgres
```

play around
```
docker exec -it mydb psql -U postgres
## cretae table ...
## insert ...
## select ...
```

delete the container
```
docker rm -f mydb
```

## restart db

```
VOL_ID=$(docker volume ls -q | head -1)

docker run -d \
  --name mydb \
  -e POSTGRES_PASSWORD=secret  \
  -v ${VOL_ID}:/var/lib/postgresql/data \
  postgres
```

## Use name volumes

```
docker run -d \
  --name mydb \
  -e POSTGRES_PASSWORD=secret \
  -v $PWD/sql:/docker-entrypoint-initdb.d \
  -v vipdb:/var/lib/postgresql/data \
  postgres
```


## adminer

```
docker run -d -p 8080:8080 adminer
```
open: http://localhost:8080/?pgsql=172.17.0.2&username=postgres&db=postgres&ns=public&select=vip



## helper
```
alias vip="docker exec -it mydb psql -U postgres -c 'select * from vip'"
```