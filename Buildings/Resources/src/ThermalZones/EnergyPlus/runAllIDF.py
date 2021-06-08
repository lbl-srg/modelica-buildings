#!/usr/bin/env python3
##########################################################################
# Script to simulate Modelica models with JModelica.
# Run this script from the directory that contains Buildings, such as
# jm_ipython.sh Buildings/Resources/src/ThermalZones/EnergyPlus/runAllIDF.py
#
##########################################################################
# Import the function for compilation of models and the load_fmu method

import os
import shutil
import sys
import glob
from pathlib import Path

TMP_DIR="tmp-runAllIDF"

def _simulate(case):
  """
  Simulate the idf file with name idf_name in Spawn, and return true if successfull, or false otherwise
  """
  from buildingspy.io.outputfile import Reader
  import subprocess

  idf_name = case['idf']
  tmp_dir = os.path.join(TMP_DIR, f"{idf_name.name}")

  idf_full_name = os.path.abspath(os.path.join(tmp_dir, idf_name.name))

  # Create working directory
  if os.path.exists(tmp_dir):
    shutil.rmtree(tmp_dir)
  os.mkdir(tmp_dir)

  # Copy file
  shutil.copyfile(idf_name, idf_full_name)


#  print("*********************************************************************")
#  print(f"*** Running {idf_full_name}")
  # Add one more leading slash if it is an absolute path
  mo_name = "TestModel"

  modifier = f"""(
    building(
      idfName=Modelica.Utilities.Files.loadResource(
        \"file:///{idf_full_name}\")))"""
  model = f"Buildings.ThermalZones.EnergyPlus.Validation.OutputVariable.OneEnvironmentOutputVariable{modifier}"
  mo_text = f"""
  model {mo_name}
    extends {model};
    annotation(
      experiment(
        StopTime=86400,
        Tolerance=1e-06));
  end {mo_name};
  """
  with open(os.path.join(tmp_dir, f"{mo_name}.mo"), "w") as m:
    m.write(mo_text)

  cmd = ["jm_ipython.sh", os.path.join("..", "..", "jmodelica.py"), f"{mo_name}.mo"]
  #print(f"Executing {cmd}")

  def _run(cmd, timeout_sec, cwd, modelica_path):
    from subprocess import Popen, PIPE
    my_env = os.environ.copy()
    my_env["MODELICAPATH"] = modelica_path
    proc = Popen(cmd, stdout=PIPE, stderr=PIPE, cwd=cwd, env=my_env)
    try:
      proc.wait(timeout=timeout_sec)
    except:
      print(f"*** Killing process for {idf_name}")
      proc.kill()

  _run(cmd, timeout_sec=60, cwd = tmp_dir, modelica_path=os.getcwd())


  resultFile = os.path.join(tmp_dir, f"{mo_name}_result.mat")
  logFile = os.path.join(tmp_dir, f"{mo_name}_log.txt")

  # Process output
  if os.path.isfile(logFile):
    #print(f"Reading {logFile}")
    with open(logFile, encoding='ISO-8859-1') as f:
      con = f.read()
      if 'Fatal from EnergyPlus' in con and 'ModelicaError' in con:
        case['result'] = 'Fatal from EnergyPlus'
        return case

  # No fatal error. Check if final time is reached.
  if os.path.isfile(resultFile):
    # Read result file
    try:
      res=Reader(resultFile, "dymola")
      #print(res.varNames())
      (t, TEnePlu) = res.values('TEnePlu.y')
      tMax=max(t)
      #print(f"*** Final time = {tMax}")
      if abs(tMax - 86400.0) < 0.1:
        case['result'] = "Success"
        # In case of success, delete the temporary directory
        shutil.rmtree(tmp_dir)
      else:
        case['result'] = "Error: Did not reach final time"
    except ValueError as e:
      msg = f"Error: ValueError when reading {resultFile}: {e}"
      print(msg)
      case['result'] = msg
  else:
    msg = f"Error: Result file {resultFile} does not exist"
    print(f"*** {msg}")
    case['result'] = msg

  return case


if __name__ == '__main__':
  import sys
  import multiprocessing
  import shutil

  # Delete temporary directory
  if os.path.exists(TMP_DIR):
    shutil.rmtree(TMP_DIR)
  os.mkdir(TMP_DIR)

  # Build a list of all idf files.
  cases = list()
#  exa_bui = os.path.join("Buildings", "Resources", "Data", "ThermalZones", "EnergyPlus")
  exa_ep = os.path.join("/usr", "local", "EnergyPlus-9-5-0", "ExampleFiles")
  for search_path in [exa_ep]:
    for path in Path(search_path).rglob('*.idf'):
      cases.append({"idf": path.absolute(), "result": "Error"})

  # pool object with number of element
  pool = multiprocessing.Pool(processes=40)
  results = pool.map(_simulate, cases)

  nSuc = 0
  nFat = 0
  nErr = 0
  for ent in results:
    result = ent['result']
    idf = ent['idf']
    if "Success" in result:
      print(f"Success:          {idf}")
      nSuc += 1
    elif "Fatal from EnergyPlus" in result:
      print(f"Fatal:            {idf}")
      nFat += 1
    else:
      print(f"Nonhandled error: {idf}: {result}")
      nErr += 1

  print(f"Number of successful simulation: {nSuc}")
  print(f"Number of fatal error messages : {nFat}")
  print(f"Number of nonhandled errors    : {nErr}")
