#!/usr/bin/env python3
# -*- coding: utf-8 -*-
##############################################################
# Script that tests exporting Spawn and running it using pyfmi
##############################################################

import os
import shutil

def _create_worDir():
    """ Create working directory
    """
    import os
    import tempfile
    import getpass
    worDir = os.path.join(tempfile.mkdtemp(
        prefix='tmp-modelica-buidings-spawn-test' + getpass.getuser()))
    print(f"Created temporary directory {worDir}")
    return worDir

def printZipContent(zipFile):
    from zipfile import ZipFile
    with ZipFile(zipFile, 'r') as zipObj:
        # Get list of files names in zip
        listOfiles = zipObj.namelist()
        # Iterate over the list of file names in given list & print them
        print(f"Content of {zipFile}")
        for elem in listOfiles:
            print(f"  {elem}")

def simulate():
    import subprocess

    def print_output(typ, stream):
        print(f"{typ}: {stream}")

    process = subprocess.Popen(
        ['jm_ipython.sh', 'simulate.py'],
        stdout = subprocess.PIPE,
        stderr = subprocess.PIPE)
    try:
        stdout, stderr = process.communicate(timeout=10)
    except subprocess.TimeoutExpired:
        process.kill()
        stdout, stderr = process.communicate()
        print(f"stdout: {stdout}")
        print(f"stderr: {stderr}")
        raise
    if process.returncode is not 0:
        print_output("stdout", stdout)
        print_output("stderr", stderr)
        raise RuntimeError("Failed to simulate fmu.")
#    print(f"stdout: {stdout}")
#    print(f"stderr: {stderr}")

from buildingspy.simulate.Optimica import Simulator
#model = "Buildings.ThermalZones.EnergyPlus.Examples.SingleFamilyHouse.Unconditioned"
model = "Buildings.Controls.Continuous.Examples.LimPID"
fmu = model.replace('.', '_') + ".fmu"
s=Simulator(model)
s.translate()

printZipContent(fmu)

worDir = _create_worDir()
shutil.move(fmu, worDir)
os.chdir(worDir)

with open("simulate.py", 'w') as f:
    f.write(f"""
from pyfmi import load_fmu
mod = load_fmu("{fmu}")
mod.simulate()
""")

simulate()

