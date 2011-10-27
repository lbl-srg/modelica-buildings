BPDIR=buildingspy
BPDOC=doc

.PHONY: doc clean

doc:
	(cd $(BPDOC); make html linkcheck)

dist:	clean doc
	python setup.py bdist_egg
	@echo "Source distribution is in directory dist"

clean-dist:
	rm -rf build
	rm -rf buildingspy.egg-info
	rm -rf buildingspy-*
	rm -rf dist

clean-doc:
	(cd $(BPDOC); make clean)

clean: clean-doc clean-dist