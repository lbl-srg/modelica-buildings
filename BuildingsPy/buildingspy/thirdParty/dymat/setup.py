import os
from distutils.core import setup

def read(fname):
    return open(os.path.join(os.path.dirname(__file__), fname)).read()

setup(
    name = "DyMat",
    version = "0.3",
    author = "Joerg Raedler",
    author_email = "joerg@j-raedler.de",
    description = ("a package for reading and processing the result files of Dymola and OpenModelica"),
    license = "BSD",
    keywords = "modelica dymola openmodelica mat",
    url = "http://www.j-raedler.de/projects/DyMat/",
    packages = ['DyMat', 'DyMat.Export', 'DyMat.Plot'],
    scripts = ['scripts/DyMatExport'],
    long_description = read('README.txt'),
    classifiers = [
        "Development Status :: 4 - Beta",
        "Environment :: Console",
        "License :: OSI Approved :: BSD License",
        "Programming Language :: Python :: 2.7",
        "Intended Audience :: Science/Research",
        "Topic :: Scientific/Engineering",
        "Topic :: Utilities"
    ],
)
