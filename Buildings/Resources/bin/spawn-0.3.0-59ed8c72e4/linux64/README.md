# Spawn 
Spawn is a software package for performing co-simulations involving EnergyPlus and Modelica.
The primary interface to spawn is the command line interface, `spawn`,
which provides the following capabilities in one self contained executable software tool.

1. A Modelica compiler toolchain for compiling Modelica source to Functional Mockup Unit (FMU) format
2. A method for simulating a Functional Mockup Unit
3. A method for exporting EnergyPlus models to FMU format

Additionally, the Spawn package bundles the Modelica Standard Library and the Modelica Buildings Library (MBL),
and the built in compiler is preconfigured to utilize these libraries. The Buildings Library now includes 
custom models for interfacing seemlessly with EnergyPlus, without leaving the Modelica environment.
Spawn's capability to export EnergyPlus models to FMU format is used behind the scenes to enable communication,
between Modelica and EnergyPlus, however the necessary complexity is abstracted to create a user friendly environment.

The Spawn installation package is fully self contained, and there are no external third party dependencies.
Together the capabilities in this package, provide a single integrated environment for performing hybrid Modelica 
and EnergyPlus simulations.

## Installation
Binary packages for Ubuntu Linux 18.04 are published on GitHub, https://github.com/NREL/Spawn/releases.
Extract the package to a location of your choosing and optionally put the `bin/spawn` executable in your system path.

Additional computer platforms, including versions of Mac OS and Windows will be supported in future releases.

## Example Usage
Detailed help is built into the command line program `spawn --help`.

* Compile a Modelica model to FMU format. Models contained with the Modelica Buildings Library and
the Modelica Standard Library are included and available to the compiler by default.

```shell
spawn modelica --create-fmu Buildings.Examples.Tutorial.Boiler.System1

```
* Compile a Modelica model, which internally leverages EnergyPlus.

```shell
spawn modelica --create-fmu Buildings.ThermalZones.EnergyPlus.Validation.ThermalZone.OneZoneOneYear

```
* Compile a Modelica model using user defined libraries.

```shell
spawn modelica --modelica-path /sim/mixed_loads --create-fmu mixed_loads.Districts.DistrictEnergySystem

```
* After generating a Functional Mockup Unit, run a simulation. Results will be generated to the file `Buildings_Controls_OBC_CDL_Continuous_Validation_Line.csv`.
```shell
spawn fmu --simulate Buildings_Controls_OBC_CDL_Continuous_Validation_Line.fmu --start 0.0 --stop 3600 --step 0.01

```

## Compiling from source
* Install EnergyPlus dependencies according to https://github.com/NREL/EnergyPlus/wiki/BuildingEnergyPlus
* Ensure that your system has been setup the same as it would be for compiling EnergyPlus, but with a few additions,
* Install clang development libraries. One Linux this would be...

```shell
apt install libllvm10 llvm-10-dev clang-10 libclang-10-dev liblld-10-dev liblld-10-dev gfortran
```

```shell
pip install conan
```

* If neccessary add variables to locate llvm and clang. (not required for apt-get installed linux packages)

```shell
export LLVM_DIR=/path/to/llvm/
export Clang_DIR=/path/to/clang/
```

* Install Graal from https://github.com/graalvm/graalvm-ce-builds/releases. Spawn requires the java11 "ce" package, which is the community open source version.
Extract the graal tarball and include the bin directory in the system path. After installing graal the "native-image" utility must be installed separately according to the directions here https://www.graalvm.org/reference-manual/native-image/#install-native-image.

```shell
gu install native-image
```

* Then follow the normal cmake build process.

```shell
git clone --recurse-submodules https://github.com/NREL/spawn.git
cd spawn
mkdir build
cd build
cmake ../
make -j
```

