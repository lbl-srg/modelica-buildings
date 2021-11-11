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
	@find $(ROOT)/Buildings/Resources/Data -name run.sh | xargs -I {} sh -c \
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

test-bestest:
	@echo "*** Check if BESTEST results are up to date"
	(cd  $(ROOT)/Buildings && \
	  rm -rf Resources/Data/BoundaryConditions/Validation/BESTEST/results && \
	  python3 Resources/Data/BoundaryConditions/Validation/BESTEST/generateResults.py -c )
	git status --porcelain $(ROOT)/Buildings/Resources/Data/BoundaryConditions/Validation/BESTEST
	git diff --exit-code $(ROOT)/Buildings/Resources/Data/BoundaryConditions/Validation/BESTEST

test-optimica-spawn-fmu:
	@echo "*** Check if Spawn is portable to another location in the file system"
	(cd  $(ROOT) && \
	  python3 Buildings/Resources/Scripts/travis/pyfmi/runSpawnFromOtherDirectory.py)

test-spawn-portability-dymola: test-spawn-portability-success test-spawn-portability-failure

test-spawn-portability-omc: test-spawn-portability-omc-success

test-spawn-portability-dymola-success:
	@echo "*** Check if for Dymola, Spawn works if the root folder is not Buildings"
	$(eval TMP := $(shell mktemp --suffix=-LBL-Buildings -d))
	@mkdir -p $(TMP)
	@cp -rp $(ROOT)/Buildings $(TMP)/
	@mv $(TMP)/Buildings $(TMP)/Buildings\ 8.0.0
	@cp $(ROOT)/Buildings/Resources/Scripts/travis/SpawnTest.mo $(TMP)
	@(cd  $(TMP) && \
	  echo "simulateModel(\"SpawnTest\", stopTime=432000, method=\"Cvode\", tolerance=1e-06);" > run.mos && \
	  echo "exit()" >> run.mos && \
	  rm -f dslog.txt && \
	  dymola run.mos)
	@cd $(TMP) && grep -q "Integration terminated successfully" dslog.txt
	@rm -rf $(TMP)

test-spawn-portability-dymola-failure:
	@echo "*** Check if for Dymola, Spawn properly fails if the root folder contains a string"
	$(eval TMP := $(shell mktemp --suffix=-LBL-Buildings -d))
	$(eval TMPDIR := $(TMP)/dir\ with\ spaces)
	@mkdir -p $(TMPDIR)
	@cp -rp $(ROOT)/Buildings $(TMPDIR)/
	@mv $(TMPDIR)/Buildings $(TMPDIR)/Buildings\ 8.0.0
	@cp $(ROOT)/Buildings/Resources/Scripts/travis/SpawnTest.mo $(TMP)
	@(cd  $(TMPDIR) && \
	  echo "simulateModel(\"SpawnTest\", stopTime=432000, method=\"Cvode\", tolerance=1e-06);" > run.mos && \
	  echo "exit()" >> run.mos && \
	  rm -f dslog.txt && \
	  dymola run.mos)
	@cd $(TMPDIR) && grep -q "To use EnergyPlus, the Modelica Buildings Library must be installed in a directory that has no spaces." dslog.txt
	@rm -rf $(TMPDIR)

test-spawn-portability-omc-success:
	@echo "*** Check if for OpenModelica, Spawn works with OpenModelica if the root folder is not Buildings"
	$(eval TMP := $(shell mktemp --suffix=-LBL-Buildings -d))
	@mkdir -p $(TMP)
	@cp -rp $(ROOT)/Buildings $(TMP)/
	mv $(TMP)/Buildings $(TMP)/Buildings\ 8.0.0
	cp $(ROOT)/Buildings/Resources/Scripts/travis/SpawnTest.mo $(TMP)
	@(cd  $(TMP) && \
	  echo "clearCommandLineOptions();\n" \
	"setCommandLineOptions(\"--matchingAlgorithm=PFPlusExt -d=initialization,NLSanalyticJacobian,newInst\");\n" \
	"setCommandLineOptions(\"+d=nogen,initialization,backenddaeinfo,discreteinfo,stateselection\");\n" \
	"setCommandLineOptions(\"--simCodeTarget=C\");\n" \
	"setCommandLineOptions(\"--target=gcc\");\n" \
	"setCompiler(\"clang\");\n" \
	"setCXXCompiler(\"clang++\");\n" \
	"setCommandLineOptions(\"+ignoreCommandLineOptionsAnnotation=false\");\n" \
	"setCommandLineOptions(\"+ignoreSimulationFlagsAnnotation=false\");\n" \
	"setCommandLineOptions(\"-d=nfAPI\");\n" \
	"setCommandLineOptions(\"--newBackend\");\n" \
	"loadModel(Modelica, {\"3.2.3\"});\n" \
        "loadFile(\"Buildings 8.0.0/package.mo\");\n" \
	"loadFile(\"SpawnTest.mo\");\n" \
	"simulate(SpawnTest);\n" \
        "getErrorString();" > openmod.mos )
	(cd $(TMP) && export OPENMODELICALIBRARY=$(TMP):/usr/lib/omlibrary && omc openmod.mos)
	@cd $(TMP) && grep -q "The simulation finished successfully." SpawnTest.log
	@rm -rf $(TMP)

test-omc:
	(cd $(ROOT) && \
	  $(TRAVIS_BUILD_DIR)/Buildings/Resources/Scripts/travis/omc/testOpenModelica.sh)

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
