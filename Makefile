all: git

git:
	git add .
	git commit -m "$m"
	git push

clean:
	hexo clean

view:
	hexo s -g
