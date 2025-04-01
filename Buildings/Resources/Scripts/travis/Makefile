############################################################
# Makefile for the regression tests that are run on travis
############################################################
# $(TRAVIS_BUILD_DIR) is /home/travis/build/lbl-srg/modelica-buildings
# Set it to top-level directory of the Buildings library if not set. (This is used for local testing.)
TRAVIS_BUILD_DIR ?= $(shell dirname \
  $(shell dirname \
  $(shell dirname \
  $(shell dirname \
  $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))))))
ROOT = $(TRAVIS_BUILD_DIR)

# Command to run Dymola tests. This is stored as a variable
# so it can be tried once more if it fails.
CMD = "(cd $(ROOT)/Buildings && \
	  export PYTHONPATH=$(TRAVIS_BUILD_DIR)/Buildings/Resources/Python-Sources && \
	  export BUILDINGSPY_SKIP_STATISTICS_VERIFICATION='$(BUILDINGSPY_SKIP_STATISTICS_VERIFICATION)' && \
	  python3 ../bin/runUnitTests.py --batch --single-package $(PACKAGE) --tool dymola -n $(NPROC))"

# Test whether all EnergyPlus validation files are up to date.
# This targets searches all files `run.sh` and executes them.
# The target below excludes run.sh in ThermalZones as they are using a more recent
# version of EnergyPlus that has not yet been released.
test-energyplus-validations:
	@echo "*********************************************************"
	@echo "*********************************************************"
	@echo "*** Testing idf files for $(ENERGYPLUS_23_1_0)"
	@export PATH=$(ROOT)/$(ENERGYPLUS_23_1_0):$(PATH); \
	 find $(ROOT)/Buildings/Resources/Data/Fluid -name run.sh | xargs -I {} sh -c \
	  'cd `dirname {}` && \
	   echo "*********************************************************" && \
	   echo "*** Testing `pwd`/run.sh" && \
	   ./run.sh'
	@echo "*********************************************************"
	@echo "*** Testing idf files for $(ENERGYPLUS_9_6_0)"
	@export PATH=$(ROOT)/$(ENERGYPLUS_9_6_0):$(PATH); \
	 find $(ROOT)/Buildings/Resources/Data/Obsolete/ThermalZones/EnergyPlus_9_6_0 -name run.sh | xargs -I {} sh -c \
	  'cd `dirname {}` && \
	   echo "*********************************************************" && \
	   echo "*** Testing `pwd`/run.sh" && \
	   ./run.sh'
	@echo "*** Verify that all files in repository are up to date"
	git diff --exit-code $(ROOT)/Buildings/Resources/Data
	@echo "    Target $@ successful."

test-cdl-conformance:
	(cd $(ROOT) && \
	 echo "*********************************************************" && \
	 echo "*** Running modelica-json" && \
	 export MODELICAPATH=`pwd` && \
	 node $(MODELICA_JSON_HOME)/app.js -f Buildings/Controls/OBC -o json -m modelica -d out --strict true && \
	 rm -rf out)
	@echo "    Target $@ successful."

test-bestest:
	@echo "*** Check if BESTEST results are up to date"
	(cd  $(ROOT)/Buildings && \
	  rm -rf Resources/Data/BoundaryConditions/Validation/BESTEST/results && \
	  python3 Resources/Data/BoundaryConditions/Validation/BESTEST/generateResults.py -c )
	git status --porcelain $(ROOT)/Buildings/Resources/Data/BoundaryConditions/Validation/BESTEST
	git diff --exit-code $(ROOT)/Buildings/Resources/Data/BoundaryConditions/Validation/BESTEST
	@echo "    Target $@ successful."

test-optimica-spawn-fmu:
	@echo "*** Check if Spawn is portable to another location in the file system."
	@(cd  $(ROOT) && \
	  python3 Buildings/Resources/Scripts/travis/pyfmi/runSpawnFromOtherDirectory.py )
	@echo "    Target $@ successful."

test-openmodelica-cdl:
	@echo "*** Running result verification of CDL with OpenModelica."
	(cd $(ROOT)/Buildings && \
	  export PYTHONPATH=$(TRAVIS_BUILD_DIR)/Buildings/Resources/Python-Sources && \
	  python3 ../bin/runUnitTests.py --batch --single-package Buildings.Controls.OBC.CDL --tool openmodelica)
	@echo "    Target $@ successful."


test-openmodelica-spawn-spaces: test-openmodelica-spawn-spaces-success test-openmodelica-spawn-spaces-failure

test-openmodelica-spawn-spaces-success:
	@echo "*** Check if for OpenModelica, Spawn works with OpenModelica if the root folder is not Buildings."
	@$(eval TMP := $(shell mktemp --suffix=-LBL-Buildings -d))
	@mkdir -p $(TMP)
	@chmod a+rwx $(TMP)
	@cp -rp $(ROOT)/Buildings $(TMP)/
	@mv $(TMP)/Buildings $(TMP)/Buildings\ 12.0.0
	@cp $(ROOT)/Buildings/Resources/Scripts/travis/SpawnTest.mo $(TMP)
	@(cd  $(TMP) && \
	  echo "clearCommandLineOptions();\n" \
    "setCommandLineOptions(\"-d=nogen\");\n" \
	"setCommandLineOptions(\"-d=initialization\");\n" \
	"setCommandLineOptions(\"-d=backenddaeinfo\");\n" \
	"setCommandLineOptions(\"-d=discreteinfo\");\n" \
	"setCommandLineOptions(\"-d=stateselection\");\n" \
	"setCommandLineOptions(\"-d=execstat\");\n" \
	"setMatchingAlgorithm(\"PFPlusExt\");\n" \
	"setIndexReductionMethod(\"dynamicStateSelection\");\n" \
	"loadModel(Modelica, {\"4.0.0\"});\n" \
	"loadFile(\"Buildings 12.0.0/package.mo\");\n" \
	"loadFile(\"SpawnTest.mo\");\n" \
	"simulate(SpawnTest);\n" \
	"getErrorString();" > openmod.mos )
	@(cd $(TMP) && omc openmod.mos > /dev/null )
	@cd $(TMP) && sudo grep -q "The simulation finished successfully." SpawnTest.log
	@sudo rm -rf $(TMP)
	@echo "    Target $@ successful."

test-openmodelica-spawn-spaces-failure:
	@echo "*** Check if for OpenModelica, Spawn properly fails if the root folder contains a space."
	$(eval TMP1 := $(shell mktemp --suffix=-LBL-Buildings -d))
	@chmod a+rwx $(TMP1)
	$(eval TMP := $(TMP1)/dir\ with\ spaces)
	@mkdir -p $(TMP)
	@chmod a+rwx $(TMP)
	@cp -rp $(ROOT)/Buildings $(TMP)/
	@mv $(TMP)/Buildings $(TMP)/Buildings\ 12.0.0
	@cp $(ROOT)/Buildings/Resources/Scripts/travis/SpawnTest.mo $(TMP)
	@(cd  $(TMP) && \
	  echo "clearCommandLineOptions();\n" \
    "setCommandLineOptions(\"-d=nogen\");\n" \
	"setCommandLineOptions(\"-d=initialization\");\n" \
	"setCommandLineOptions(\"-d=backenddaeinfo\");\n" \
	"setCommandLineOptions(\"-d=discreteinfo\");\n" \
	"setCommandLineOptions(\"-d=stateselection\");\n" \
	"setCommandLineOptions(\"-d=execstat\");\n" \
	"setMatchingAlgorithm(\"PFPlusExt\");\n" \
	"setIndexReductionMethod(\"dynamicStateSelection\");\n" \
	"loadModel(Modelica, {\"4.0.0\"});\n" \
	"loadFile(\"Buildings 12.0.0/package.mo\");\n" \
	"loadFile(\"SpawnTest.mo\");\n" \
	"simulate(SpawnTest);\n" \
	"getErrorString();" > openmod.mos )
	@(cd $(TMP) && omc openmod.mos > /dev/null )
	@cd $(TMP) && sudo grep -q "To run a simulation with EnergyPlus coupling, the working directory must not have spaces." SpawnTest.log
	@sudo rm -rf $(TMP)
	@echo "    Target $@ successful."

test-dymola-spawn-spaces:
	@echo "*** Check if for Dymola, Spawn works if the root folder is not Buildings."
	@$(eval TMP := $(shell mktemp --suffix=-LBL-Buildings -d))
	@mkdir -p $(TMP)
	@cp -rp $(ROOT)/Buildings $(TMP)/
	@mv $(TMP)/Buildings $(TMP)/Buildings\ 12.0.0
	@cp $(ROOT)/Buildings/Resources/Scripts/travis/SpawnTest.mo $(TMP)
	@(cd  $(TMP) && \
	  echo "simulateModel(\"SpawnTest\", stopTime=432000, method=\"Cvode\", tolerance=1e-06);" > run.mos && \
	  echo "exit()" >> run.mos && \
	  rm -f dslog.txt && \
	  dymola run.mos /nowindow)
	@cd $(TMP) && grep -q "Integration terminated successfully" dslog.txt
	@rm -rf $(TMP)
	@echo "    Target $@ successful."

# Skip verification of translation statistics of certain models, see
# https://github.com/lbl-srg/BuildingsPy/issues/441
define buiPyMod
Buildings.Examples.VAVReheat.ASHRAE2006, \
Buildings.Examples.VAVReheat.Validation.Guideline36SteadyState, \
Buildings.Examples.VAVReheat.Validation.TraceSubstance, \
Buildings.Examples.VAVReheat.Guideline36, \
Buildings.ThermalZones.EnergyPlus.Examples.SmallOffice.ASHRAE2006Spring, \
Buildings.ThermalZones.EnergyPlus.Examples.SmallOffice.Guideline36Winter, \
Buildings.ThermalZones.EnergyPlus.Examples.SmallOffice.ASHRAE2006Winter, \
Buildings.ThermalZones.EnergyPlus.Examples.SmallOffice.Guideline36Spring, \
Buildings.ThermalZones.EnergyPlus.Examples.SmallOffice.Guideline36Summer, \
Buildings.ThermalZones.EnergyPlus.Examples.SmallOffice.ASHRAE2006Summer

endef


test-dymola:
	$(eval BUILDINGSPY_SKIP_STATISTICS_VERIFICATION := $(buiPyMod))
	@eval $(CMD) || \
	if [ $$? <> 0 ]; then \
	  eval $(CMD); \
	fi
	@echo "    Target $@ successful."

test-openmodelica:
	(cd $(ROOT)/Buildings && \
	  export PYTHONPATH=$(TRAVIS_BUILD_DIR)/Buildings/Resources/Python-Sources && \
	  python3 ../bin/runUnitTests.py --batch --single-package $(PACKAGE) --tool openmodelica --skip-verification -n $(NPROC))
	@echo "    Target $@ successful."

test-optimica:
	(cd $(ROOT)/Buildings && \
	  export PYTHONPATH=$(TRAVIS_BUILD_DIR)/Buildings/Resources/Python-Sources && \
	  python3 ../bin/runUnitTests.py --batch --single-package $(PACKAGE) --tool optimica --skip-verification -n $(NPROC))
	@echo "    Target $@ successful."

test-templates-dymola:
	(cd $(ROOT)/Buildings && ../Buildings/Resources/Scripts/travis/templates/checkandrun.sh --checksum --tool Dymola --cover 0.3)
	@echo "    Target $@ successful."

test-templates-optimica:
	(cd $(ROOT)/Buildings && ../Buildings/Resources/Scripts/travis/templates/checkandrun.sh --checksum --tool Optimica --cover 0.3)
	@echo "    Target $@ successful."
