#!/usr/bin/env python3
##########################################################################
# Script to simulate Modelica models with JModelica.
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
import matplotlib.pyplot as plt

debug_solver = False
model="Buildings.Controls.OBC.CDL.Continuous.Validation.LimPID"
# Overwrite model with command line argument if specified
if len(sys.argv) > 1:
  # If the argument is a file, then parse it to a model name
  if os.path.isfile(sys.argv[1]):
    model = sys.argv[1].replace(os.path.sep, '.')[:-3]
  else:
    model=sys.argv[1]


print("*** Compiling {}".format(model))
# Increase memory
pymodelica.environ['JVM_ARGS'] = '-Xmx4096m'


sys.stdout.flush()

######################################################################
# Compile fmu
fmu_name = compile_fmu(model,
                       version="2.0",
                       compiler_log_level='warning', #'info', 'warning',
                       compiler_options = {"generate_html_diagnostics" : False,
                                           "nle_solver_tol_factor": 1e-2}) # 1e-2 is the default

######################################################################
# Load model
mod = load_fmu(fmu_name, log_level=3)
mod.set_max_log_size(2073741824) # = 2*1024^3 (about 2GB)
######################################################################
# Retrieve and set solver options
x_nominal = mod.nominal_continuous_states
opts = mod.simulate_options() #Retrieve the default options

opts['solver'] = 'CVode' #'Radau5ODE' #CVode
opts['ncp'] = 500

if opts['solver'].lower() == 'cvode':
  # Set user-specified tolerance if it is smaller than the tolerance in the .mo file
  rtol = 1.0e-6
  x_nominal = mod.nominal_continuous_states

  if len(x_nominal) > 0:
    atol = rtol*x_nominal
  else:
    atol = rtol

  opts['CVode_options'] = {
    'external_event_detection': False,
    'maxh': (mod.get_default_experiment_stop_time()-mod.get_default_experiment_stop_time())/float(opts['ncp']),
    'iter': 'Newton',
    'discr': 'BDF',
    'rtol': rtol,
    'atol': atol,
    'store_event_points': True # True is default, set to false if many events
    }
  if debug_solver:
    opts['CVode_options']['clock_step'] = True

if debug_solver:
  opts["logging"] = True #<- Turn on solver debug logging
  mod.set("_log_level", 9)

######################################################################
# Simulate
res = mod.simulate(options=opts)
#        logging.error(traceback.format_exc())

##plt.plot(res['time'], res['zon.TAir']-273.15)
##plt.xlabel('time in [s]')
##plt.ylabel('TAir [degC]')
##plt.grid()
##plt.show()
##plt.savefig("plot.pdf")

######################################################################
# Copy style sheets.
# This is a hack to get the css and js files to render the html diagnostics.
htm_dir = os.path.splitext(os.path.basename(fmu_name))[0] + "_html_diagnostics"
if os.path.exists(htm_dir):
    for fil in ["scripts.js", "style.css", "zepto.min.js"]:
        src = os.path.join(".jmodelica_html", fil)
        if os.path.exists(src):
            des = os.path.join(htm_dir, fil)
            shutil.copyfile(src, des)

######################################################################
# Get debugging information
if debug_solver:
  #Load the debug information
  from pyfmi.debug import CVodeDebugInformation
  debug = CVodeDebugInformation(model.replace(".", "_")+"_debug.txt")

  ### Below are options to plot the order, error and step-size evolution.
  ### The error methos also take a threshold and a region if you want to
  ### limit the plot to a certain interval.


  if opts['solver'].lower() == 'cvode':
    #Plot wall-clock time versus model time
    debug.plot_cumulative_time_elapsed()
    #Plot only the region 0.8 - 1.0 seconds and only state variables with an error greater than 0.01 (for any point in that region)
#    debug.plot_error(region=[0.8,1.0], threshold=0.01)


  #Plot order evolution
  debug.plot_order()

  #Plot error evolution
  debug.plot_error() #Note see also the arguments to the method

  #Plot the used step-size
  debug.plot_step_size()

  #See also debug?
