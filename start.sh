#!/bin/bash

cat > /var/www/html/index.html <<EOF
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Document</title>
</head>
<body bgcolor="${COLOR:=gray}">
    <h1>${TITLE:=Welcome}</h1>
    ${BODY:=Please use TITLE/COLOR/BODY envs}
</body>
</html>
EOF

exec nginx -g "daemon off;"