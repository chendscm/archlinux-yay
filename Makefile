BASEDIR := $(shell pwd)

build: 
	cd $(BASEDIR)
	sudo docker build -t chendscm/archlinux-yay .

build-noCache:
	cd $(BASEDIR)
	sudo docker build --no-cache -t chendscm/archlinux-yay .

.PHONY: build build-noCache
