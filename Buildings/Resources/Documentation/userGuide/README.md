# Modelica Buildings Library User Guide

This directory contains the Modelica Buildings Library User Guide.

To see the user guide, open `build/html/index.html` with any web browser.

The source files are in `source`. To translate the user guide, run
```
make build html
```

To get the same configuration as is used during development, run
```
python -m venv virEnv
source virEnv/bin/activate
pip install -r requirements.txt --no-deps
make build
deactivate
rm -rf virEnv
```