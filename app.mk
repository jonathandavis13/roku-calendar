#########################################################################
# Roku Application Makefile include
#########################################################################

ROKU_DEV_TARGET ?= 192.168.86.47
ROKU_DEV_USERNAME ?= rokudev
ROKU_DEV_PASSWORD ?= 0000

# Use absolute paths to be safe
BASE_DIR = $(CURDIR)
ZIPREL = $(BASE_DIR)/zips
PKGREL = $(BASE_DIR)/packages

CURL = curl --anyauth -u $(ROKU_DEV_USERNAME):$(ROKU_DEV_PASSWORD)

.PHONY: all $(APPNAME) install remove

$(APPNAME): $(APPDEPS)
	@echo "*** Creating $(APPNAME).zip ***"
	@mkdir -p $(ZIPREL)
	@rm -f $(ZIPREL)/$(APPNAME).zip
	
	@echo "  >> creating application zip"
	@# Zip PNGs without compression
	@zip -0 -r "$(ZIPREL)/$(APPNAME).zip" . -i "*.png" $(ZIP_EXCLUDE) > /dev/null
	@# Zip everything else with compression
	@zip -9 -r "$(ZIPREL)/$(APPNAME).zip" . -x "*~" -x "*.png" -x "Makefile" -x "app.mk" -x "zips/*" -x "packages/*" -x "manifest.template" $(ZIP_EXCLUDE) > /dev/null
	@echo "*** developer zip $(APPNAME) complete ***"

install: $(APPNAME)
	@echo "Installing $(APPNAME).zip to $(ROKU_DEV_TARGET)"
	@$(CURL) -f -S -F "mysubmit=Install" -F "archive=@$(ZIPREL)/$(APPNAME).zip" -F "passwd=" http://$(ROKU_DEV_TARGET)/plugin_install | grep -i "font color" | sed "s/<font color=\"red\">//" || echo "Installation failed. Check if Roku is in developer mode and IP is correct."

remove:
	@echo "Removing $(APPNAME) from host $(ROKU_DEV_TARGET)"
	@$(CURL) -s -S -F "mysubmit=Delete" -F "archive=" -F "passwd=" http://$(ROKU_DEV_TARGET)/plugin_install | grep -i "font color" | sed "s/<font color=\"red\">//"
