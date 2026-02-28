PREFIXBIN=~/.local/bin
SHAREDIR=~/.local/share
NAME=minivi

install: install-data install-bin

install-data:
	install -d $(SHAREDIR)/applications
	install -d $(SHAREDIR)/icons/hicolor/128x128/apps
	install -d $(PREFIXBIN)
	cp -a res/$(NAME).desktop $(SHAREDIR)/applications
	cp -a src/$(NAME).png $(SHAREDIR)/icons/hicolor/128x128/apps

install-bin:
	install -Dm755 src/$(NAME) $(PREFIXBIN)/$(NAME)
	
build:
	lazbuild src/minivi.lpi

