#!/usr/bin/env python3
# -*- coding: utf-8 -*-
##############################################################
# Script that tests exporting Spawn and running without use
# of the binary files of the Buildings library.
#
# Note that this file runs OCT from a local installation.
# Running OCT from a docker with this script is not supported.
##############################################################

import os
import shutil

def _create_worDir():
    """ Create working directory
    """
    import os
    import tempfile
    import getpass
    import shutil

    worDir = os.path.abspath(os.path.join(os.path.curdir, "tmp-runSpawnFromOtherDirectory"))
    if os.path.exists(worDir):
        shutil.rmtree(worDir)

    if "MODELICAPATH" in os.environ.keys():
        os.environ["MODELICAPATH"] = os.environ["MODELICAPATH"] + ":" + worDir
    else:
        os.environ["MODELICAPATH"] = worDir

    os.mkdir(worDir)
#    print(f"Created temporary directory {worDir}")
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

def simulate(expectToFail):
    """ Simulate the model.

        If `expectedToFail = False` and the simulation fails, or
        if `expectedToFail = True` and the simulation succeeds, the
        function raises `RuntimeError`. Otherwise it return without error.
    """
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
        print_output("stdout", stdout)
        print_output("stderr", stderr)
        raise
    if (process.returncode != 0) and (not expectToFail):
        print_output("stdout", stdout)
        print_output("stderr", stderr)
        raise RuntimeError("Failed to simulate fmu, but expected successful simulation.")
    if (process.returncode == 0) and expectToFail:
        print_output("stdout", stdout)
        print_output("stderr", stderr)
        raise RuntimeError("Simulation was successful, but it was expected to fail.")


def run_test(pathVariable):
    # List of files to be moved
    fileMoves = [
        {"src": os.path.abspath(os.path.join("Buildings", "Resources", "bin", "spawn-0.5.0-c10e8c6d7e", "linux64")),
         "des": "my-bin"},
        {"src": os.path.abspath(os.path.join("Buildings", "Resources", "weatherdata")),
         "des": "some_weather_directory_that_the_fmu_does_not_know_about"},
        {"src": os.path.abspath(os.path.join("Buildings", "Resources", "Data", "ThermalZones", "EnergyPlus_9_6_0")),
         "des": "some_idf_directory_that_the_fmu_does_not_know_about"},
    ]

    curDir = os.path.abspath(os.curdir)
    worDir = _create_worDir()
    shutil.copy(fmu, worDir)
    os.chdir(worDir)

    # Move the files, to emulate a local installation (for the binary files)
    # and to hide the weather and idf files so the fmu cannot find it in the local installation
    for pair in fileMoves:
        shutil.move(pair['src'], pair['des'])

    # Write the simulate script
    with open("simulate.py", 'w') as f:
        f.write(f"""from pyfmi import load_fmu
mod = load_fmu("{fmu}")
mod.simulate()
""")
    retVal = 0
    oldVar = None
    try:
        if pathVariable is not None:
            if pathVariable in os.environ.keys():
                oldVar = os.environ[pathVariable]
            if oldVar is None:
                os.environ[pathVariable]=os.path.abspath(os.path.join("my-bin", "bin"))
            else:
                os.environ[pathVariable]=oldVar + ":" + os.path.abspath(os.path.join("my-bin", "bin"))
        simulate(pathVariable is None)
    except BaseException as err:
        print("Error: {0}.\n*** Note that this script does not work if the OPTIMICA simulation is run in a docker".format(err))
        retVal = 1
    finally:
        # Restore the original version of the Buildings library
        for pair in fileMoves:
            shutil.move(pair['des'], pair['src'])

        # Change back to the original directory
        os.chdir(curDir)

        # Reset the environment variable
        if oldVar is not None:
            os.environ[pathVariable] = oldVar
        return retVal


if __name__ == "__main__":

    from buildingspy.simulate.Optimica import Simulator
    import sys
    model = "Buildings.ThermalZones.EnergyPlus_9_6_0.Examples.SingleFamilyHouse.Unconditioned"
    #model = "Buildings.Controls.Continuous.Examples.LimPID"
    fmu = model.replace('.', '_') + ".fmu"
    s=Simulator(model)
    s.translate()

#    printZipContent(fmu)

    args = ["SPAWNPATH", "PATH", None]
    for arg in args:
        retVal = run_test(arg)
        if retVal != 0:
            sys.exit(1)
    sys.exit(0)




