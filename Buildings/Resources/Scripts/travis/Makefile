############################################################
# Makefile for the regression tests that are run on travis
############################################################
# $(TRAVIS_BUILD_DIR) is /home/travis/build/lbl-srg/modelica-buildings
ROOT = $(TRAVIS_BUILD_DIR)

# Test whether all EnergyPlus validation files are up to date.
# This targets searches all files `run.sh` and executes them.
# The target below excludes run.sh in ThermalZones as they are using a more recent
# version of EnergyPlus that has not yet been released.
test-energyplus-validations:
	@find $(ROOT)/Buildings/Resources/Data -type d \( -name ThermalZones \) -prune -false -o -name run.sh | xargs -I {} sh -c \
	  'cd `dirname {}` && \
	   echo "*********************************************************" && \
	   echo "*** Testing `pwd`/run.sh" && \
	   ./run.sh'
	@echo "*** Verify that all files in repository are up to date"
	git diff --exit-code $(ROOT)/Buildings/Resources/Data

test-cdl-conformance:
	(cd $(ROOT) && \
	 echo "*********************************************************" && \
	 echo "*** Running modelica-json" && \
	 export MODELICAPATH=`pwd` && \
	 node $(MODELICA_JSON_HOME)/app.js -f Buildings/Controls/OBC -o json -m modelica -d out --strict true && \
	 rm -rf out)

test-omc:
	(cd $(ROOT) && $(TRAVIS_BUILD_DIR)/Buildings/Resources/Scripts/travis/omc/testOpenModelica.sh)

test-dymola:
	(cd $(ROOT)/Buildings && \
	  export PYTHONPATH=$(TRAVIS_BUILD_DIR)/Buildings/Resources/Python-Sources && \
	  python3 ../bin/runUnitTests.py --batch --single-package $(PACKAGE) --tool dymola)

test-optimica:
	(cd $(ROOT)/Buildings && \
	  export PYTHONPATH=$(TRAVIS_BUILD_DIR)/Buildings/Resources/Python-Sources && \
	  python3 ../bin/runUnitTests.py --batch --single-package $(PACKAGE) --tool optimica --skip-verification)

test-jmodelica:
	(cd $(ROOT)/Buildings && \
	  export PYTHONPATH=$(TRAVIS_BUILD_DIR)/Buildings/Resources/Python-Sources && \
	  python3 ../bin/runUnitTests.py --batch --single-package $(PACKAGE) --tool jmodelica --skip-verification)
