This directory contains FMUs that are precompiled for Linux 64bit.
They are used in the examples in
Buildings.ThermalZones.EnergyPlus*.BaseClasses.Validation

To generate the FMUs, run

$ jm_ipython.sh jmodelica.py Zones1.mo
$ jm_ipython.sh jmodelica.py Zones3.mo

This will generate the files Zones1.fmu and Zones3.fmu.
Note that the file Zones3.fmu can also be used for the example
Buildings.ThermalZones.EnergyPlus.BaseClasses.Validation.FMUZoneAdapterZones2
