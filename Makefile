PATH := ./node_modules/.bin:${PATH}

.PHONY : init clean-docs clean build test dist publish

init:
	npm install

clean:
	rm -rf js/

build: clean
	coffee -o js/ -c coffee/
	echo "#!/usr/bin/env node" | cat - js/hgrpull.js > /tmp/hgrpull.js
	mv /tmp/hgrpull.js js/hgrpull.js
	chmod a+x js/hgrpull.js

dist: clean init build

publish: dist
	npm publish
