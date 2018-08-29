CALDOC=doc
CALCOD=PythonModel

.PHONY: doc clean

doc:
	(cd $(CALDOC); make html linkcheck)

pep8:
	pep8 Examples/*.py \
	PythonModel/*.py

doctest:
	(cd $(CALCOD); \
	python -m doctest \
	calibrate.py \
	compressors.py \
	fluids.py \
	heatexchangers.py \
	heatpumps.py \
	refrigerants.py)

clean-doc:
	(cd $(CALDOC); make clean)

clean: clean-doc
