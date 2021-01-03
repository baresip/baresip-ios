#
# Makefile
#
# Copyright (C) 2010 - 2016 Alfred E. Heggestad
#


BUILD_DIR	:= build
CONTRIB_DIR	:= contrib

include mk/contrib.mk


all:	contrib


clean:
	@rm -rf $(BUILD_DIR) $(CONTRIB_DIR) \
	@rm -rf baresip rem re


.PHONY: download
download:
	rm -fr baresip re rem
	git clone https://github.com/baresip/baresip.git
	git clone https://github.com/creytiv/rem.git
	git clone https://github.com/baresip/re.git
	patch -d rem -p1 < rem-patch-makefile
