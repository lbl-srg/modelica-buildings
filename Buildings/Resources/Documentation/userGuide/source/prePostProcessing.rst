Pre- and Post-Processing
========================

The Modelica language specification does not specify a scripting language for simulating models, and it does not standardize the file format of the result file.
To provide scripts that automate simulation of models and post-processing of results, LBNL created the `BuildingsPy <https://simulationresearch.lbl.gov/modelica/buildingspy/>`_ Python library.
This library can be used

 * to run Modelica simulations using Dymola, OpenModelica or OPTIMICA,
 * to process ``*.mat`` output files that were generated by these programs, and
 * to run unit tests as part of the library development.

See the separate documentation at https://simulationresearch.lbl.gov/modelica/buildingspy/ for information on how to use this library.

In addition, Dymola provides MATLAB scripts that can be used to process ``*.mat`` output files that were generated by Dymola. See the Dymola documentation for how to use these scripts.

To optimize cost functions that are computed by Dymola, OpenModelica or OPTIMICA,
the `GenOpt <https://simulationresearch.lbl.gov/GO/>`_ optimization program can be used.
See GenOpt's directory ``example/dymola`` for examples that use Dymola to compute the cost function in an optimal control problem.
