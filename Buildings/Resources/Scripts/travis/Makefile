ROOT = ../../../..

test-documentation:
	(cd $(ROOT)/Buildings; ../bin/runUnitTests.py --validate-html-only)
	(cd $(ROOT)/Buildings/Resources/Documentation/userGuide; make regressiontest)
