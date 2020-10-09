#!/usr/bin/env python3
#######################################################
# Script the installs spawn, which generates
# an FMU with the EnergyPlus envelope model
#######################################################
import os

from multiprocessing import Pool

import tempfile
import tarfile
import zipfile
import urllib.request, urllib.parse, urllib.error
import shutil

def log(msg):
    print(msg)



def get_distribution(dis):
    file_path = os.path.dirname(os.path.realpath(__file__))
    des_dir=os.path.abspath(os.path.join(file_path, "..", "..", "..", "..", "Resources", "bin", dis['des']))
    tar_fil=os.path.basename(dis['src'])

    # Download the file
    log("Downloading {}".format(dis['src']))
    urllib.request.urlretrieve(dis['src'], tar_fil)

    log("Extracting {}".format(tar_fil))
    if tar_fil.endswith(".zip"):
        # Make a tar.gz out of it.
        with tempfile.TemporaryDirectory(prefix="tmp-Buildings-inst") as zip_dir:
            with zipfile.ZipFile(tar_fil,"r") as zip_ref:
                zip_ref.extractall(zip_dir)
            new_name = tar_fil[:-3] + ".tar.gz"
            with tarfile.open(new_name, 'w') as t:
                t.add(zip_dir)
        os.remove(tar_fil)
        tar_fil = new_name

    tar = tarfile.open(tar_fil)
    for key in dis["files"]:
        found = False
        for nam in tar.getnames():
    #    print nam
            if nam.endswith(key):
                dis["files"][key] = nam
                found = True
        if not found:
            raise IOError("Failed to find '{}'".format(key))


    # Extract and move the files
    for key in dis["files"]:
        tar.extract(dis["files"][key], path=".")

        des_fil=os.path.join(des_dir,  key)

        # Create the target directory
        try:
            os.stat(os.path.dirname(des_fil))
        except:
            os.makedirs(os.path.dirname(des_fil))

    #    print("Renaming {} to {}".format("files"[key], des_fil))
        os.rename(dis["files"][key], des_fil)
        log(("Wrote {} {}".format(dis["files"][key], des_fil)))

    # Delete the created empty directories
    top = dis["files"]["README.md"].split(os.path.sep)[0]
    for root, dirs, files in os.walk(top, topdown=False):
        for name in dirs:
            os.rmdir(os.path.join(root, name))
    os.rmdir(top)
    # Delete the tar.gz file
    os.remove(tar_fil)


if __name__ == "__main__":
    dists = list()
    dists.append(
        {"src": "https://spawn.s3.amazonaws.com/latest/Spawn-latest-Linux.tar.gz",
         "des": "spawn-linux64",
         "files": {
            "bin/spawn" : "",
            "README.md" : "",
            "lib/epfmi.so" : "",
            "etc/Energy+.idd" : ""}
        }
    )
    dists.append(
        {"src": "https://spawn.s3.amazonaws.com/latest/Spawn-latest-win64.zip",
         "des": "spawn-win64",
         "files": {
            "bin/epfmi.dll" : "", # where is spawn.exe?
            "README.md" : "",
            "lib/epfmi.lib" : ""}
            #"etc/Energy+.idd" : ""} # same idd as before?
        }
    )

    p = Pool(2)
    p.map(get_distribution, dists)
