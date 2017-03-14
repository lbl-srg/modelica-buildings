.. example_calibration:

Calibrate heat pump model from performance data
===============================================

This example demonstrates the use of the :doc:`calibrate <calibrate>` module
to obtain parameters of the heat pump model. Data is loaded from a performance
file generated in the
:doc:`performance data generation example <dummy_performance_data>`.
Once heat pump parameters are identified, the results are verified
by running the model in Dymola.

The following script can be found in
`Buildings/Resources/src/fluid/heatpumps/calibration/Examples/example_calibration.py`:

.. literalinclude:: ../../Examples/example_calibration.py
   :language: python
   :linenos:

The scripts generates the following figures:

.. figure:: _figures/calibration_guess_parameters.png
    :width: 600px

    Comparison between the performance data and the model predicted
    (from Python) heating capacities and power input using the initial
    guess parameters.

.. figure:: _figures/calibration_final_parameters.png
    :width: 600px

    Comparison between the performance data and the model predicted
    (from Dymola) heating capacities and power input using the
    calibrated parameters.

The following record is generated for use in Modelica:

.. literalinclude:: ../../Examples/SomeManufacturer_ABC060_70kW_4_0COP_R410A.mo
   :language: modelica
   :linenos:
