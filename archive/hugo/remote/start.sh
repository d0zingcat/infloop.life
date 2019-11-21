#!/bin/bash
docker run -d -v /home/d0zingcat/blog/nginx.conf:/etc/nginx/nginx.conf -v /home/d0zingcat/blog/data/blog.d0zingcat.xyz.key:/var/www/https/blog.d0zingcat.xyz/blog.d0zingcat.xyz.key -v /home/d0zingcat/blog/data/blog.d0zingcat.xyz.crt:/var/www/https/blog.d0zingcat.xyz/blog.d0zingcat.xyz.crt -v /home/d0zingcat/blog/public:/var/www/blog.d0zingcat.xyz/ -p 80:80 -p 443:443 nginx
