#!/usr/bin/env python3
#######################################################
# Script that installs the binaries that are
# used by Spawn.
#######################################################
import subprocess
import os

if __name__ == '__main__':
  subprocess.call(os.path.join(os.path.dirname(os.path.realpath(__file__)), "EnergyPlus_9_6_0", "install.py"))
