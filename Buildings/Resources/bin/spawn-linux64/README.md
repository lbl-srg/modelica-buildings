# Spawn 

_Version: 0.0.1_

_Build: 46d0591508_


This is the spawn executable. 
The primary purpose is currently to create an FMU given an EnergyPlus idf file.

## Development Builds

The latest development builds are available at the following locations.

* [Linux](https://spawn.s3.amazonaws.com/latest/Spawn-latest-Linux.tar.gz).
* [Mac](https://spawn.s3.amazonaws.com/latest/Spawn-latest-Darwin.tar.gz).
* [Windows](https://spawn.s3.amazonaws.com/latest/Spawn-latest-win64.zip).

## Compiling from source

Dependencies are the same as for EnergyPlus https://github.com/NREL/EnergyPlus/wiki/BuildingEnergyPlus.
Ensure that your system has been setup the same as it would be for compiling EnergyPlus, but with one addition,

```shell
pip install conan
```

Then follow the normal cmake build process.

```shell
git clone --recurse-submodules https://gitlab.com/kylebenne/spawn.git 
mkdir build
cd build
cmake ../
make -j
```

## Example Usage

Create a fmu. The .spawn file defines the resources that will be compiled into an EnergyPlus based FMU. 
The most important items are epw and idf files.


```shell
./build/cli/spawn -c examples/RefBldgSmallOfficeNew2004_Chicago/RefBldgSmallOfficeNew2004_Chicago.spawn

```

The resulting fmu will be located in examples/RefBldgSmallOfficeNew2004_Chicago/MyBuilding.fmu,
and may be tested with pyfmi or other fmu simulation tools.

## Data Exchange Variables

The variables exposed through the FMU are documented here:
https://lbl-srg.github.io/soep/softwareArchitecture.html#coupling-of-envelope-model,
however check the modelDescription.xml contained in the generated fmu because
some variables may not be implemented yet.

