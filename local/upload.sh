hugo
rm -r ../remote/public/
cp -a public/ ../remote/public/
rsync -rav public/ d0zingcat@play.d0zingcat.xyz:/home/d0zingcat/nginx/public
rm -r public/

