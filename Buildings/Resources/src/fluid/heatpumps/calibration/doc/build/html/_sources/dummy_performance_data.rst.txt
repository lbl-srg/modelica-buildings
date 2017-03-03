.. dummy_performance_data:

Generate performance data from heat pump model
==============================================

This example demonstrates the use of the :doc:`heat pump <heatpumps>` module
to calculate the heat pump heating capacity and power input. For a given set
of parameters, the heating capacity and power input is calculated for various
combinations of inlet water temperatures and mass flow rates at the evaporator
and condenser inlets.

Results from the heat pump model are saved into the file
`Buildings/Resources/src/fluid/heatpumps/calibration/Examples/somePerformanceData.txt`.

The following script can be found in
`Buildings/Resources/src/fluid/heatpumps/calibration/Examples/example_calibration.py`:

.. literalinclude:: ../../Examples/dummy_performance_data.py
   :language: python
   :linenos:
