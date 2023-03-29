##########################################################################
# Script to generate an FMU for model-exhange with JModelica.
#
##########################################################################
# Import the function for compilation of models and the load_fmu method

from pymodelica import compile_fmu
import traceback
import logging

from pyfmi import load_fmu
import pymodelica

import os
import shutil
import sys
import zipfile
#    import matplotlib.pyplot as plt

debug_solver = False
models=["Zones1", "Zones3"]
# Overwrite models with command line argument if specified
if len(sys.argv) > 1:
  # If the argument is a file, then parse it to a model name
  if os.path.isfile(sys.argv[1]):
    models = sys.argv[1].replace(os.path.sep, '.')[:-3]
  else:
    models = sys.argv[1]

# Increase memory
pymodelica.environ['JVM_ARGS'] = '-Xmx4096m'

for model in models:
  print("*** Compiling {}".format(model))
  sys.stdout.flush()

  ######################################################################
  # Compile fmu
  # OCT r28242 ignores MODELICAPATH and instead needs to have it set through a function argument.
  if 'MODELICAPATH' in os.environ:
    modelicapath=os.environ['MODELICAPATH']
    del os.environ['MODELICAPATH']
  else:
    modelicapath=os.path.abspath('.')

  fmu_name = compile_fmu(model,
                         version="2.0",
                         modelicapath=".",
                         compiler_log_level='warning',
                         compiler_options = {"generate_html_diagnostics" : False})

  # Add binaries for https://github.com/lbl-srg/modelica-buildings/issues/3292
  with zipfile.ZipFile(fmu_name, mode="a") as archive:
    target="/binaries/linux64"
    for fil in [
      "/lib/x86_64-linux-gnu/libc.so.6",
      "/lib/x86_64-linux-gnu/libm.so.6",
      "/lib/x86_64-linux-gnu/libgfortran.so.5",
      "/lib/x86_64-linux-gnu/libgcc_s.so.1",
      "/lib/x86_64-linux-gnu/libquadmath.so.0"]:
      archive.write(fil, os.path.join(target, os.path.split(fil)[-1]))
