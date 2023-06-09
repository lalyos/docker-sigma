

## Start lunch container

```
docker run -d \
  -p 8081:80 \
  web:v3 nginx -g 'daemon off;'
```

## Build docker image from GIT

```
docker build \
  -t web:lalyos \
  https://github.com/lalyos/docker-sigma.git#master
```

use this image:
```
docker run -dP \
  -e TITLE="Afternoon coffebreak for $USER" \
  web:lalyos
```

```
imgtest() { 
    docker build -t web:lalyos https://github.com/lalyos/docker-sigma.git#master;
    docker run -dP -e TITLE="Afternoon coffebreak for $USER" web:lalyos
}
```

## Hint

```
hint() { 
    latest=$(
        curl -s -H "Authorization: Bearer $GH_TOKEN" \
        https://api.github.com/gists/2aa74872779de2747c1328599524c4e9/commits \
        | jq .[0].version -r
    );
    curl -s -H "Authorization: Bearer $GH_TOKEN" \
    https://gist.githubusercontent.com/lalyos/2aa74872779de2747c1328599524c4e9/raw/${latest}/.history \
    | tail -${1:-1}
}

lazy() { 
    hint > ~/.hint
    source ~/.hint
}
```
