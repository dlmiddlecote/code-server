.PHONY: build push

build:
	sudo docker build -t dlmiddlecote/code-server:${VERSION} .

push: build
	sudo docker push dlmiddlecote/code-server:${VERSION}