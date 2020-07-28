SHELL = /bin/sh
# Makefile for updating all java code and docs
# Wangda Zuo (WZuo@lbl.gov), Michael Wetter (MWetter@lbl.gov)  July 14, 2010

all: clean
	make -C src all > /dev/null
	@echo "==== Code and doc update finished."
doc: cleandoc
	make -C src doc > /dev/null
	@echo "==== Doc update finished."
clean:
	make -C src clean > /dev/null
	@echo "==== Code and doc output deleted."
cleandoc:
	make -C src cleandoc > /dev/null
	@echo "==== Doc output deleted."
