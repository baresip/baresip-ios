#
# Makefile
#
# Copyright (C) 2010 - 2016 Creytiv.com
#


BUILD_DIR	:= build
CONTRIB_DIR	:= contrib
BARESIP_SRC	:= baresip-0.6.0.tar.gz
LIBREM_SRC	:= rem-0.6.0.tar.gz
LIBRE_SRC	:= re-0.6.0.tar.gz


include mk/contrib.mk


all:	contrib


clean:
	@rm -rf $(BUILD_DIR) $(CONTRIB_DIR)


fetch:
	@curl -LO http://www.creytiv.com/pub/$(BARESIP_SRC)
	@curl -LO http://www.creytiv.com/pub/$(LIBREM_SRC)
	@curl -LO http://www.creytiv.com/pub/$(LIBRE_SRC)


unpack:
	@mkdir -p baresip && tar -xzf $(BARESIP_SRC) -C baresip --strip-components=1
	@mkdir -p rem && tar -xzf $(LIBREM_SRC) -C rem --strip-components=1
	@mkdir -p re && tar -xzf $(LIBRE_SRC) -C re --strip-components=1
