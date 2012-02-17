Work-Arounds
============

This section describes work-arounds that often help if there are problems during the model translation, initialization or simulation.

Avoiding step changes
---------------------

All flow machines (fans and pumps) have a boolean parameter
``filteredSpeed``, and all actuators have a boolean parameter
``filteredOpening``.
If set to ``true``, which is the default setting, then the control input signal is sent to 
a :term:`2nd order low pass filter` that changes a step signal to a smooth signal.
This typically improves the robustness of the simulation.

To see the effect of the filter, consider the model below 
in which ``fanS`` is configured with
``filteredSpeed=false``, and ``fanC`` is configured with
``filteredSpeed=true``.
Both fans are connected to a step input signal.
The configuration of ``fanS`` causes the fan speed to instantly change from 0 to 1. In large system models, this can lead to high computing time or to convergence problems. The ``fanC`` avoids this problem because the speed of the fan varies continuously, thereby making it easier for the solver to compute a solution. In this model, we set the parameter
``raiseTime=30`` seconds.

.. _FigureFilteredResponse:

.. figure:: img/fanStepSchematics.png
   
   Schematic diagram of fans that are configured with ``filterSpeed=false`` (``fanS``) and ``filterSpeed=true`` (``fanC``).

.. figure:: img/fanStepResponse.png
   
   Mass flow rate of the two fans for a step input signal at 0 seconds.


For fans and pumps, the dynamics introduced by the filter can be thought of as approximating the rotational inertia of the fan rotor and the inertia of the fluid in the duct or piping network.
The default value is ``raiseTime=30`` seconds.

For actuators, the rise time approximates the travel time of the valve lift.
The default value is ``raiseTime=120`` seconds.

.. note:: When changing ``filteredSpeed`` (or ``filteredOpening``),
          or when changing the value of ``riseTime``, the dynamic
          response of the closed loop control changes. Therefore,
          control gains may need to be retuned to ensure satisfactory
          closed loop control performance.

For further information, see the 
`User's Guide <http://simulationresearch.lbl.gov/modelica/releases/latest/help/Buildings_Fluid_Movers_UsersGuide.html>`_ of the flow machines, and the 
`User's Guide <http://simulationresearch.lbl.gov/modelica/releases/latest/help/Buildings_Fluid_Actuators_UsersGuide.html>`_
of the actuators.


Breaking algebraic loops
------------------------
In fluid flow systems, flow junctions where mass flow rates separate and mix can couple non-linear systems of equations. This leads to larger systems of coupled equations that need to be solved, which often causes larger computing time and can sometimes cause convergence problems.
To decouple these systems of equations, the model of a flow splitter or mixer (model `Buildings.Fluid.FixedResistances.SplitterFixedResistanceDpM <http://simulationresearch.lbl.gov/modelica/releases/latest/help/Buildings_Fluid_FixedResistances.html#Buildings.Fluid.FixedResistances.SplitterFixedResistanceDpM>`_), or in models for fans or pumps (such as the model `Buildings.Fluid.Movers.FlowMachine_y <http://simulationresearch.lbl.gov/modelica/releases/latest/help/Buildings_Fluid_Movers.html#Buildings.Fluid.Movers.FlowMachine_y>`_), the parameter ``dynamicBalance`` can be set to ``true``. This adds a control volume at the fluid junction that can decouple the system of equations.


Prescribed mass flow rate
-------------------------
For some system models, the mass flow rate can be prescribed by using an idealized pump or fan (model `Buildings.Fluid.Movers.FlowMachine_m_flow <http://simulationresearch.lbl.gov/modelica/releases/latest/help/Buildings_Fluid_Movers.html#Buildings.Fluid.Movers.FlowMachine_m_flow>`_) or a source element that outputs the required mass flow rate (such as the model `Buildings.Fluid.Sources.MassFlowSource_T <http://simulationresearch.lbl.gov/modelica/releases/latest/help/Buildings_Fluid_Sources.html#Buildings.Fluid.Sources.MassFlowSource_T>`_). Using these models avoids having to compute the intersection of the fan curve and the flow resistance. In some situations, this can lead to faster and more robust simulation.


Avoiding overspecified initialization problems
----------------------------------------------

If in thermofluid flow systems, Dymola fails to translate a model with the error message::

   Error: The initialization problem is overspecified for variables 
   of element type Real
   The initial equation
   ...
   refers to variables, which are all knowns.
   To correct it you can remove this equation.

then the initialization problem is overspecified. To avoid this, set

.. code-block:: modelica

   energyDynamics = Modelica.Fluid.Types.Dynamics.DynamicsFreeInitial;
   massDynamics = Modelica.Fluid.Types.Dynamics.DynamicsFreeInitial;

in the instances of the components that contain fluid volumes.
See also the section :ref:`ThermalExpansionOfWater`.
