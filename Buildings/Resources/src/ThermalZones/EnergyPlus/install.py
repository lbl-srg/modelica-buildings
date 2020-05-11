#!/usr/bin/env python3
#######################################################
# Script the installs spawn, which generates
# an FMU with the EnergyPlus envelope model
#######################################################
import os

import tarfile
import urllib.request, urllib.parse, urllib.error
import shutil

src="https://spawn.s3.amazonaws.com/latest/Spawn-latest-Linux.tar.gz"

file_path = os.path.dirname(os.path.realpath(__file__))
des_dir=os.path.abspath(os.path.join(file_path, "..", "..", "..", "..", "Resources", "bin", "spawn-linux64"))
tar_fil="spawn.tar.gz"

# Download the file
urllib.request.urlretrieve(src, tar_fil)

# Find the name of the spawn executable
fil_dic = {"bin/spawn": "", "README.md": "", "lib/libepfmi.so": "", "etc/Energy+.idd": ""}

tar = tarfile.open(tar_fil)
for key in fil_dic:
    found = False
    for nam in tar.getnames():
#    print nam
        if nam.endswith(key):
            fil_dic[key] = nam
            found = True
    if not found:
        raise IOError("Failed to find '{}'".format(key))


# Extract and move the files
for key in fil_dic:
    tar.extract(fil_dic[key], path=".")

    des_fil=os.path.join(des_dir, key)

    # Create the target directory
    try:
        os.stat(os.path.dirname(des_fil))
    except:
        os.makedirs(os.path.dirname(des_fil))

#    print("Renaming {} to {}".format(fil_dic[key], des_fil))
    os.rename(fil_dic[key], des_fil)
    print(("Wrote {}".format(des_fil)))

# Delete the created empty directories
top = fil_dic["README.md"].split(os.path.sep)[0]
for root, dirs, files in os.walk(top, topdown=False):
    for name in dirs:
        os.rmdir(os.path.join(root, name))
os.rmdir(top)
# Delete the tar.gz file
os.remove(tar_fil)
