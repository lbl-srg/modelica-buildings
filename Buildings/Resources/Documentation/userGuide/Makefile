# Makefile for Sphinx documentation
#

SHELL := /bin/bash

# You can set these variables from the command line.
SPHINXOPTS    =
SPHINXBUILD   = sphinx-build
PAPER         =
BUILDDIR      = build

#PYTHONPATH=`pwd`/..

# Internal variables.
PAPEROPT_a4     = -D latex_paper_size=a4
PAPEROPT_letter = -D latex_paper_size=letter
ALLSPHINXOPTS   = -d $(BUILDDIR)/doctrees $(PAPEROPT_$(PAPER)) $(SPHINXOPTS) source

.PHONY: help clean html dirhtml pickle json htmlhelp qthelp latex changes linkcheck doctest

help:
	@echo "Please use \`make <target>' where <target> is one of"
	@echo "  html      to make standalone HTML files"
	@echo "  dirhtml   to make HTML files named index.html in directories"
	@echo "  pickle    to make pickle files"
	@echo "  json      to make JSON files"
	@echo "  htmlhelp  to make HTML files and a HTML help project"
	@echo "  qthelp    to make HTML files and a qthelp project"
	@echo "  latex     to make LaTeX files, you can set PAPER=a4 or PAPER=letter"
	@echo "  changes   to make an overview of all changed/added/deprecated items"
	@echo "  linkcheck to check all external links for integrity"
	@echo "  doctest   to run all doctests embedded in the documentation (if enabled)"

clean:
	@echo "Cleaning build directory in `pwd`"
	-rm -rf $(BUILDDIR)/*

html:
	@echo "Running sphinx in `pwd`"
	$(SPHINXBUILD) -b html $(ALLSPHINXOPTS) $(BUILDDIR)/html
	@echo
	@echo "Build finished. The HTML pages are in $(BUILDDIR)/html."

regressiontest: clean
	@echo "Verify whether all files compile and no uncommitted changes exist"
	@rm -rf virEnv
	python -m venv virEnv
	source virEnv/bin/activate
	pip install -r requirements.txt --no-deps
	$(SPHINXBUILD) -b html $(ALLSPHINXOPTS) $(BUILDDIR)/html
	rm -rf virEnv
	git diff --exit-code .

dirhtml:
	$(SPHINXBUILD) -b dirhtml $(ALLSPHINXOPTS) $(BUILDDIR)/dirhtml
	@echo
	@echo "Build finished. The HTML pages are in $(BUILDDIR)/dirhtml."

pickle:
	$(SPHINXBUILD) -b pickle $(ALLSPHINXOPTS) $(BUILDDIR)/pickle
	@echo
	@echo "Build finished; now you can process the pickle files."

json:
	$(SPHINXBUILD) -b json $(ALLSPHINXOPTS) $(BUILDDIR)/json
	@echo
	@echo "Build finished; now you can process the JSON files."

htmlhelp:
	$(SPHINXBUILD) -b htmlhelp $(ALLSPHINXOPTS) $(BUILDDIR)/htmlhelp
	@echo
	@echo "Build finished; now you can run HTML Help Workshop with the" \
	      ".hhp project file in $(BUILDDIR)/htmlhelp."

qthelp:
	$(SPHINXBUILD) -b qthelp $(ALLSPHINXOPTS) $(BUILDDIR)/qthelp
	@echo
	@echo "Build finished; now you can run "qcollectiongenerator" with the" \
	      ".qhcp project file in $(BUILDDIR)/qthelp, like this:"
	@echo "# qcollectiongenerator $(BUILDDIR)/qthelp/BuildingsPy.qhcp"
	@echo "To view the help file:"
	@echo "# assistant -collectionFile $(BUILDDIR)/qthelp/BuildingsPy.qhc"

latex:
	$(SPHINXBUILD) -b latex $(ALLSPHINXOPTS) $(BUILDDIR)/latex
	@echo
	@echo "Build finished; the LaTeX files are in $(BUILDDIR)/latex."
	@echo "Run \`make all-pdf' or \`make all-ps' in that directory to" \
	      "run these through (pdf)latex."

odt:
	mkdir -p build/odt
	touch /tmp/tmpUserGuide.rst
	cat source/gettingStarted.rst > /tmp/tmpUserGuide.rst
	cat source/bestPractice.rst >> /tmp/tmpUserGuide.rst
	cat source/workArounds.rst >> /tmp/tmpUserGuide.rst
	cat source/prePostProcessing.rst >> /tmp/tmpUserGuide.rst
	cat source/development.rst >> /tmp/tmpUserGuide.rst
	cat source/help.rst >> /tmp/tmpUserGuide.rst
	cat source/glossary.rst >> /tmp/tmpUserGuide.rst
	cat source/acknowledgments.rst >> /tmp/tmpUserGuide.rst
	sed -e 's/.. highlight:: rest//g' -i /tmp/tmpUserGuide.rst
	sed -e 's/.. code-block:: modelica/.. code-block::/g'  -i /tmp/tmpUserGuide.rst
	rst2odt /tmp/tmpUserGuide.rst build/odt/userGuide.odt

changes:
	$(SPHINXBUILD) -b changes $(ALLSPHINXOPTS) $(BUILDDIR)/changes
	@echo
	@echo "The overview file is in $(BUILDDIR)/changes."

linkcheck:
	$(SPHINXBUILD) -b linkcheck $(ALLSPHINXOPTS) $(BUILDDIR)/linkcheck
	@echo
	@echo "Link check complete; look for any errors in the above output " \
	      "or in $(BUILDDIR)/linkcheck/output.txt."

doctest:
	$(SPHINXBUILD) -b doctest $(ALLSPHINXOPTS) $(BUILDDIR)/doctest
	@echo "Testing of doctests in the sources finished, look at the " \
	      "results in $(BUILDDIR)/doctest/output.txt."

dist:	html, linkcheck, copytowww

copytowww:
	rsync --delete --links --archive \
	  --recursive --backup --update \
	  --rsh=ssh --compress --times --checksum --verbose \
	  --exclude "*~" \
	  --exclude ".DS_Store" \
	  build/html/* gundog.lbl.gov:/usr/local/www/simulationresearch/modelica/userGuide/
