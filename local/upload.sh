hugo
rm -r ../remote/public/
cp -a public/ ../remote/public/
rsync -rav public/ d0zingcat@bwg.d0zingcat.xyz:/home/d0zingcat/blog/public
rm -r public/

