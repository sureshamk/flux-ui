#!/bin/sh
sed -i "s,</head>,<script>window.BASE_API = '$BASE_API';</script></head>," /usr/share/nginx/html/index.html

echo "configured"  $BASE_API
