# Modelica Buildings library

[![Build Status](https://travis-ci.com/lbl-srg/modelica-buildings.svg?branch=master)](https://travis-ci.com/lbl-srg/modelica-buildings)

This is the development site for the Modelica _Buildings_ library and its user guide.

Stable releases including all previous releases are available from the main project site
at http://simulationresearch.lbl.gov/modelica.

Instructions for developers are available on the [wiki](https://github.com/lbl-srg/modelica-buildings/wiki).

## Library description

The Modelica Buildings library is a free open-source library with dynamic simulation models for building energy and control systems. The library contains models for

- HVAC systems,
- energy storage,
- controls, including a reference implementation of ASHRAE Standard 231P,
- heat transfer among rooms and the outside, either
  - natively in Modelica with a detailed or a reduced order model, or
  - integrated run-time coupling with EnergyPlus, aka, Spawn of EnergyPlus
- multizone airflow, including natural ventilation and contaminant transport,
- single-zone computational fluid dynamics coupled to heat transfer and HVAC systems,
- data-driven load prediction for demand response applications, and
- electrical DC and AC systems with two- or three-phases that can be balanced and unbalanced.


The main project site is http://simulationresearch.lbl.gov/modelica.

## Current release

Download [Buildings Library 9.1.1 (2023-09-05)](https://github.com/lbl-srg/modelica-buildings/releases/download/v9.1.1/Buildings-v9.1.1.zip)

## License

The Modelica _Buildings_ Library is available under a 3-clause BSD-license.
See [Modelica Buildings Library license](https://htmlpreview.github.io/?https://github.com/lbl-srg/modelica-buildings/blob/master/Buildings/legal.html).

Python modules are available under a 3-clause BSD-license. See [BuildingsPy license](http://simulationresearch.lbl.gov/modelica/buildingspy/legal.html).

## Development and contribution
You may report any issues with using the [Issues](https://github.com/lbl-srg/modelica-buildings/issues) button.

Contributions in the form of [Pull Requests](https://github.com/lbl-srg/modelica-buildings/pulls) are always welcome.
Prior to issuing a pull request, make sure your code follows the [style guide and coding conventions](https://github.com/lbl-srg/modelica-buildings/wiki/Style-Guide).

## Building binaries

The distribution at https://simulationresearch.lbl.gov/modelica/download.html
contains all binaries.

Developers may build the binaries as follows.

### Spawn of EnergyPlus

The Buildings library already contains the compiled binaries that are needed to link to EnergyPlus.

To rebuild the Spawn of EnergyPlus binaries, CMake is required. The binaries
consist of the fmi-library, and a library that connects Modelica to EnergyPlus.

To build the fmi-library, which is only needed if https://github.com/modelon-community/fmi-library is updated, run
```
cd Buildings/Resources/src/fmi-library
rm -rf build && mkdir build && \
  cd build && cmake .. && cmake --build . && \
  cd .. && rm -rf build
```

To build the Modelica to EnergyPlus library, run
```
cd modelica-buildings
rm -rf build && mkdir build && cd build && \
  cmake ../ && cmake --build . --target install && \
  cd .. && rm -rf build
```

To install the EnergyPlus binaries for the Spawn interface for the current operating system, run
```
Buildings/Resources/src/ThermalZones/install.py --binaries-for-os-only
```
To install the binaries for all operating systems, omit the flag `--binaries-for-os-only`

## Citation

To cite the library, use

Michael Wetter, Wangda Zuo, Thierry S. Nouidui and Xiufeng Pang.
Modelica Buildings library.
_Journal of Building Performance Simulation_, 7(4):253-270, 2014.

```
@Article{WetterZuoNouiduiPang2014,
  author  =  {Michael Wetter and Wangda Zuo and Thierry S. Nouidui and Xiufeng Pang},
  title   =  {Modelica {Buildings} library},
  journal =  {Journal of Building Performance Simulation},
  volume  =  {7},
  number  =  {4},
  pages   =  {253--270},
  year    =  {2014},
  doi     =  {10.1080/19401493.2013.765506},
  url     = "https://doi.org/10.1080/19401493.2013.765506"
}

```