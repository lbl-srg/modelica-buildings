############################################################
# Makefile for the regression tests that are run on travis
############################################################
ROOT = ../../../..

test-documentation:
	(cd $(ROOT)/Buildings; ../bin/runUnitTests.py --validate-html-only)
	(cd $(ROOT)/Buildings/Resources/Documentation/userGuide; make regressiontest)
	(cd $(ROOT)/Buildings/Resources/src/fluid/heatpumps/calibration/doc; make regressiontest)

test-dymola:
	(cd $(ROOT)/Buildings && python ../bin/runUnitTests.py --single-package $(PACKAGE))
