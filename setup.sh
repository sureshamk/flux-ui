#!/bin/sh
sed -i "s,</head>,<script>window.BASE_API = '$BASE_API';</script></head>," /usr/share/nginx/html/index.html

echo "configured"  $BASE_API
echo "seting nginx " $END_POINT
esh -o /etc/nginx/conf.d/default.conf /nginx.conf.esh api=$END_POINT
echo "seting nginx done"
