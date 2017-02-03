.. dummy_performance_data:

Generate performance data from heat pump model
==============================================

This example demonstrates the use of the :doc:`heat pump <heatpumps>` module
to calculate the heat pump heating capacity and power input. For a given set
of parameters, the heating capacity and power input is calculated for various
combinations of inlet water temperatures and mass flow rates at the evaporator
and condenser inlets.

Results from the heat pump model are saved into a text file, found in
`Buildings/Resources/Data/Fluid/HeatPumps/Calibration/Examples/somePerformanceData.txt`.

The following script can be found in
`Buildings/Resources/Data/Fluid/HeatPumps/Calibration/Examples/dummy_performance_data.py`:

.. literalinclude:: ../../Examples/dummy_performance_data.py
   :language: python
   :linenos: