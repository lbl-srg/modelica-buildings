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

  proc=[os.path.join(os.path.dirname(os.path.realpath(__file__)),  "EnergyPlus_9_6_0", "install.py")]

  if args.binaries_for_os_only:
    proc += ["--binaries-for-os-only"]

  subprocess.run(proc, shell=False)
