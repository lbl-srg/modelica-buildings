#!/usr/bin/env python3
#######################################################
# Script that installs the binaries that are
# used by Spawn.
#######################################################
import subprocess
import argparse
import os

if __name__ == '__main__':

  # Configure the argument parser
  parser = argparse.ArgumentParser(
      description='Install and updates files used by Spawn.',
      allow_abbrev=False)

  parser.add_argument("--binaries-for-os-only",
                      action="store_true",
                      help="Only install binaries needed for the current operating system.")

  # Parse the arguments
  args = parser.parse_args()
  
  # Check if subprocess should be invoked with executable 'python' or 'python3', because install.py is assuming we are using Python 3 to work properly.
  # We do this because executable 'python' might be of version 2, while 'python3' is of version 3 (assuming it exists).
  executable_name = 'python'
  cmd = [executable_name, '-c', 'import sys; print(sys.version_info.major)']
  try:
    python_major_version = subprocess.run(cmd, shell=False, stdout = subprocess.PIPE).stdout.decode().strip()
  except FileNotFoundError:
    # Test executable 'python3' before we decide to exit with an error
    python_major_version = None
    pass
  executable = executable_name if python_major_version == '3' else None
  if python_major_version != '3': # check executable 'python3', if not found we will exit with a formatted error.
    try:
      executable_name = 'python3'
      cmd = [executable_name, '-c', 'import sys; print(sys.version_info.major)']
      python_major_version = subprocess.run(cmd, shell=False, stdout = subprocess.PIPE).stdout.decode().strip()
      executable = executable_name if python_major_version == '3' else None
    except FileNotFoundError as e:
      msg = "Searched for executable of name '{}' since 'python' is not a valid version, but no executable of name '{}' found.".format(
        executable_name,
        executable_name
      )
      raise OSError(msg) from e
  
  if executable is None:
    raise OSError("A Python installation of at least version 3 is required to run this script. Executable 'python' nor 'python3' is pointing to a valid version.")

  proc = [executable, os.path.join(os.path.dirname(os.path.realpath(__file__)), "EnergyPlus_9_6_0", "install.py")] 

  if args.binaries_for_os_only:
    proc += ["--binaries-for-os-only"]

  subprocess.run(proc, shell=False)
