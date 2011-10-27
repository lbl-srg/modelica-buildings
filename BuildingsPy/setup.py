import os
from setuptools import setup

def read(fname):
    return open(os.path.join(os.path.dirname(__file__), fname)).read()

setup(
    name = "buildingspy",
    version = "1.0.0",
    author = "Michael Wetter",
    author_email = "mwetter@lbl.gov",
    description = ("Package for running and post-processing models from the Modelica Buildings library"),
    long_description = read('README'),
    license = "3-clause BSD",
    keywords = "modelica dymola openmodelica mat",
    url = "http://simulationresearch.lbl.gov/modelica/",
    packages = ['development', 
                'examples', 
                'io', 
                'simulate', 
                'thirdParty',
                'thirdParty.dymat',
                'thirdparty.dymat.DyMat',
                'thirdparty.dymat.DyMat.Plot',
                'thirdparty.dymat.DyMat.Export'],
    classifiers = [
        "Development Status :: 1.0",
        "Environment :: Console",
        "License :: 3-clause BSD License",
        "Programming Language :: Python :: 2.7",
        "Intended Audience :: End Users/Desktop",
        "Intended Audience :: Science/Research",
        "Topic :: Scientific/Engineering",
        "Topic :: Utilities"
    ],
)
