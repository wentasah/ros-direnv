PREFIX=/usr/local

all:

install:
# Install everything to share/ros-direnv as ros-direnv-setup expects
# all files in the same directory.
	install -d $(DESTDIR)$(PREFIX)/share/ros-direnv
	install -m644 direnv-lib.sh $(DESTDIR)$(PREFIX)/share/ros-direnv
	install -m755 ros-direnv-setup $(DESTDIR)$(PREFIX)/share/ros-direnv
	install -m755 ros-build-wrapper $(DESTDIR)$(PREFIX)/share/ros-direnv

	install -d $(DESTDIR)$(PREFIX)/bin
	ln -sfr $(DESTDIR)$(PREFIX)/share/ros-direnv/ros-direnv-setup $(DESTDIR)$(PREFIX)/bin
