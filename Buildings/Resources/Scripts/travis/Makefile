ROOT = ../../../..

test-documentation:
	(cd $(ROOT)/Buildings; ../bin/runUnitTests.py --validate-html-only)
	(cd $(ROOT)/Buildings/Resources/Documentation/userGuide; make regressiontest)

test-dymola:
	(cd $(ROOT)/Buildings && travis_wait 70 python ../bin/runUnitTests.py $(PACKAGE))
