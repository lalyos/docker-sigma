
## Build teh python version

```
docker build -t web:py flask/
```


## Start flask app by hand:
```
docker run -d \
  -p 5000 \
  -w /work \
  web:py \
    flask run --host=0.0.0.0
```