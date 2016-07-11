build:
	jekyll build

preview:
	open http://127.0.0.1:4000/
	jekyll serve --watch

publish:
	git push
	open http://nosamanuel.github.io/

install:
	gem install jekyll -v 2.5.3
