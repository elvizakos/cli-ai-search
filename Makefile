PACKAGE_NAME:=cli-ai-search
VERSION:=0.5.1
PACKAGE_REV:=1
#PACKAGE_ARCH:=noarch
PACKAGE_ARCH:=all
PACKAGE_MAINTAINER:="ELVIZakos <elvizakos@yahoo.gr>"
PACKAGE_SUMMARY:="Semantic search"
PACKAGE_DESCRIPTION:="Script for semantic search."
#PACKAGE_LICENSE:=GPLv3+
PACKAGE_PRIORITY:=optional
PACKAGE_SECTION:=accesories
DEPENDENCIES:=coreutils, curl, jq, gawk, findutils, ocrmypdf, tesseract-ocr, pandoc, sqlite3, inotify-tools, ollama
PACKAGE_FILE_NAME:=$(PACKAGE_NAME)-$(VERSION)-$(PACKAGE_REV)_$(PACKAGE_ARCH)
PACKAGE_DIR:=/tmp/$(PACKAGE_FILE_NAME)

.PHONY: install remove install-user remove-user purge-user purge deb clean deb_scripts deb_manpage deb_application test

# Create temporary dir for building package
$(PACKAGE_DIR):
	mkdir $@

# Install app for current user only
install-user:
	cp -r ./cli-ai-search $(HOME)/.local/bin/cli-ai-search
	sed -i -re 's/%%VERSION%%/$(VERSION)/g' $(HOME)/.local/bin/cli-ai-search
	chmod +x $(HOME)/.local/bin/cli-ai-search
	$(HOME)/.local/bin/cli-ai-search build
#	cp -r ./cli-ai-search.man $(HOME)/.local/share/man/man1/cli-ai-search.1
#	sed -i -re "s/%%VERSION%%/$(VERSION)/g" $(HOME)/.local/share/man/man1/cli-ai-search.1

# Uninstall app if was installed for current user only but keep data
remove-user:
	rm -f $(HOME)/.local/bin/cli-ai-search
#	rm -f $(HOME)/.local/share/man/man1/cli-ai-search.1.gz

# Uninstall app if was installed for current user only
purge-user:
	rm -f $(HOME)/.local/bin/cli-ai-search
	rm -f $(HOME)/.local/share/man/man1/cli-ai-search.1.gz
	rm -f "$(HOME)/.local/share/cli-ai-search"

# Install app
install: $(PACKAGE_DIR)
	cp -r ./cli-ai-search $(PACKAGE_DIR)/cli-ai-search
	sed -i -re 's/%%VERSION%%/$(VERSION)/g' $(PACKAGE_DIR)/cli-ai-search
	install -Dm755 $(PACKAGE_DIR)/cli-ai-search /usr/local/bin/cli-ai-search

	cp -r ./cli-ai-search.man $(PACKAGE_DIR)/cli-ai-search.1
	sed -i -re "s/%%VERSION%%/$(VERSION)/g" $(PACKAGE_DIR)/cli-ai-search.1
	gzip -f $(PACKAGE_DIR)/cli-ai-search.1
	install -Dm644 cli-ai-search.1.gz /usr/share/man/man1/cli-ai-search.1.gz

# Uninstall app but keep data
remove:
	rm -f /usr/local/bin/cli-ai-search
	rm -f /usr/share/man/man1/cli-ai-search.1.gz

# Uninstall app and remove data
purge:
	rm -f /usr/local/bin/cli-ai-search
	rm -f /usr/share/man/man1/cli-ai-search.1.gz
	@for i in $(shell ls /home/); do [ -d "/home/$$i/.config/cli-ai-search/" ] && rm -f "/home/$$i/.config/cli-ai-search/"; done

# Create deb package
deb: $(PACKAGE_DIR) deb_manpage deb_scripts deb_application
	sed -r "s/%%VERSION%%/$(VERSION)/g; s/%%DEPENDENCIES%%/$(DEPENDENCIES)/g; s/%%PACKAGE_NAME%%/$(PACKAGE_NAME)/g; s/%%PACKAGE_ARCH%%/$(PACKAGE_ARCH)/g; s/%%PACKAGE_MAINTAINER%%/$(PACKAGE_MAINTAINER)/g; s/%%PACKAGE_PRIORITY%%/$(PACKAGE_PRIORITY)/g; s/%%PACKAGE_SECTION%%/$(PACKAGE_SECTION)/g; s/%%PACKAGE_DESCRIPTION%%/$(PACKAGE_DESCRIPTION)/g;  s/%%PACKAGE_SIZE%%/$(shell echo " ( $(shell stat --printf="%s" $(PACKAGE_DIR)/usr/share/man/man1/cli-ai-search.1.gz) +  $(shell stat --printf="%s" "$(PACKAGE_DIR)/usr/local/bin/cli-ai-search") ) / 1000" | bc )/g" ./src/deb/control > $(PACKAGE_DIR)/DEBIAN/control
	dpkg-deb --build --root-owner-group $(PACKAGE_DIR)
	mv -f $(PACKAGE_DIR).deb ./

# Clean temporary data
clean: $(PACKAGE_DIR)
	rm -f -r $(PACKAGE_DIR)

deb_scripts: $(PACKAGE_DIR)
	mkdir -p $(PACKAGE_DIR)/DEBIAN
	[ -f "./deb/postrm" ] && {
		cp ./deb/postrm $(PACKAGE_DIR)/DEBIAN/postrm
		chmod 0755 $(PACKAGE_DIR)/DEBIAN/postrm
	}

#deb_manpage: $(PACKAGE_DIR)
#	mkdir -p $(PACKAGE_DIR)/usr/share/man/man1
#	sed -r "s/%%VERSION%%/$(VERSION)/" ./cli-ai-search.man > $(PACKAGE_DIR)/usr/share/man/man1/cli-ai-search.1
#	gzip -f $(PACKAGE_DIR)/usr/share/man/man1/cli-ai-search.1

deb_application: $(PACKAGE_DIR)
	mkdir -p $(PACKAGE_DIR)/usr/local/bin
	sed -r "s/%%VERSION%%/$(VERSION)/" ./cli-ai-search > $(PACKAGE_DIR)/usr/local/bin/cli-ai-search
