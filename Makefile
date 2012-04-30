#
# Makefile
#
# Copyright (C) 2010 - 2012 Creytiv.com
#


BUILD_DIR	:= build
CONTRIB_DIR	:= contrib


include mk/contrib.mk


all:	contrib


clean:
	@rm -rf $(BUILD_DIR) $(CONTRIB_DIR)
