#!/bin/bash

cat > /var/www/html/index.html <<EOF
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Document</title>
</head>
<body>
    <h1>${TITLE}</h1>
    todo ...
</body>
</html>
EOF

nginx -g "daemon off;"