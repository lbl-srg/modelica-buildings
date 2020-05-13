.. _Development:

Development
===========

This section describes the development of the `Buildings` library.
The development of the library is conducted at https://github.com/lbl-srg/modelica-buildings

Contributing
------------

Contributions of new models and suggestions for how to improve the library are
welcome.
Contributions are ideally made by first opening an issue at https://github.com/lbl-srg/modelica-buildings
and by providing a pull request with the new code.



.. _sec_dev_gui_con:

Guidelines for contributions
----------------------------

Models that are contributed need to adhere to the following guidelines, as this is needed to integrate them in the library, make them accessible to users and further maintain them:

 * They should be of general interest to other users and well documented and tested.
 * They need to follow the coding conventions described in

   - the `Buildings library user guide <https://simulationresearch.lbl.gov/modelica/releases/latest/help/Buildings_UsersGuide.html#Buildings.UsersGuide.Conventions>`_,
   - the `Modelica Standard Library user guide <https://simulationresearch.lbl.gov/modelica/releases/msl/3.2/help/Modelica_UsersGuide_Conventions.html#Modelica.UsersGuide.Conventions>`_, and
   - the `Buildings library style guide <https://github.com/lbl-srg/modelica-buildings/wiki/Style-Guide>`_.

 * They need to be made available under the `Modelica Buildings Library license <https://simulationresearch.lbl.gov/modelica/releases/latest/help/Buildings_UsersGuide.html#Buildings.UsersGuide.License>`_.
 * For models of thermofluid flow components, they need to be based on the base classes in
   `Buildings.Fluid.Interfaces <https://simulationresearch.lbl.gov/modelica/releases/latest/help/Buildings_Fluid_Interfaces.html>`_,
   which are described in the `user guide <https://simulationresearch.lbl.gov/modelica/releases/latest/help/Buildings_Fluid_Interfaces_UsersGuide.html#Buildings.Fluid.Interfaces.UsersGuide>`_ of this package.
   Otherwise, it becomes difficult to ensure that the implementation is numerically robust.




Adding a new class
------------------

Adding a new class, such as a model or a function, is usually easiest by extending, or copying and modifying, an existing class.
In many cases, the similar component already exists.
In this situation, it is recommended to copy and modify a similar component.
If both components share a significant amount of similar code, then a base class should be introduced that implements the common code.
See for example `Buildings.Fluid.Sensors.BaseClasses.PartialAbsoluteSensor <https://simulationresearch.lbl.gov/modelica/releases/latest/help/Buildings_Fluid_Sensors_BaseClasses.html#Buildings.Fluid.Sensors.BaseClasses.PartialAbsoluteSensor>`_ which is shared by all sensors with one fluid port in the package
`Buildings.Fluid.Sensors <https://simulationresearch.lbl.gov/modelica/releases/latest/help/Buildings_Fluid_Sensors.html#Buildings.Fluid.Sensors>`_.

The next sections give guidance that is specific to the implementation of thermofluid flow devices, pressure drop models and control sequences.

Thermofluid flow device
~~~~~~~~~~~~~~~~~~~~~~~

To add a component of a thermofluid flow device, the package
`Buildings.Fluid.Interface <https://simulationresearch.lbl.gov/modelica/releases/latest/help/Buildings_Fluid_Interfaces.html>`_  contains basic classes that can be extended.
See `Buildings.Fluid.Interface.UsersGuide <https://simulationresearch.lbl.gov/modelica/releases/latest/help/Buildings_Fluid_Interfaces_UsersGuide.html#Buildings.Fluid.Interfaces.UsersGuide>`_ for a description of these classes.
Alternatively, simple models such as the models below may be used as a starting point for implementing new models for thermofluid flow devices:

`Buildings.Fluid.HeatExchangers.HeaterCooler_u <https://simulationresearch.lbl.gov/modelica/releases/latest/help/Buildings_Fluid_HeatExchangers.html#Buildings.Fluid.HeatExchangers.HeaterCooler_u>`_
  For a device that adds heat to a fluid stream.

`Buildings.Fluid.Humidifiers.Humidifier_u <https://simulationresearch.lbl.gov/modelica/releases/latest/help/Buildings_Fluid_Humidifiers.html#Buildings.Fluid.Humidifiers.Humidifier_u>`_
  For a device that adds humidity to a fluid stream.

`Buildings.Fluid.Chillers.Carnot_y <https://simulationresearch.lbl.gov/modelica/releases/latest/help/Buildings_Fluid_Chillers.html#Buildings.Fluid.Chillers.Carnot_y>`_
  For a device that exchanges heat between two fluid streams.

`Buildings.Fluid.MassExchangers.ConstantEffectiveness <https://simulationresearch.lbl.gov/modelica/releases/latest/help/Buildings_Fluid_MassExchangers.html#Buildings.Fluid.MassExchangers.ConstantEffectiveness>`_
  For a device that exchanges heat and humidity between two fluid streams.

.. _fig_merkel:

.. figure:: img/Merkel.png
   :scale: 10%

   Schematic diagram of the cooling tower model based on the Merkel theory.

If models involve complex calculations, then these models are generally easiest to understand
for users if these calculations are in a separate block that then interfaces to the fluid flow model
using the above basic class. An example is the model `Buildings.Fluid.HeatExchangers.CoolingTowers.Merkel`
that will be released with Buildings 6.0.0.
:numref:`fig_merkel` shows the schematic diagram of the model. The block `per` in the figure implements the
thermodynamic calculations. The model shows that the cooling tower performance only depends on
the control signal `y`, the air inlet temperature `TAir`, the water inlet temperature `TWatIn` and the
water mass flow rate `mWat_flow`.



Pressure drop
~~~~~~~~~~~~~

When implementing equations for pressure drop, it is recommended
to expand the base class
`Buildings.Fluid.BaseClasses.PartialResistance <https://simulationresearch.lbl.gov/modelica/releases/latest/help/Buildings_Fluid_BaseClasses.html#Buildings.Fluid.BaseClasses.PartialResistance>`_.
Models should allow computing the flow resistance as a quadratic function
with regularization near zero as implemented in
`Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_dp <https://simulationresearch.lbl.gov/modelica/releases/latest/help/Buildings_Fluid_BaseClasses_FlowModels.html#Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_dp>`_ and in
`Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_m_flow <https://simulationresearch.lbl.gov/modelica/releases/latest/help/Buildings_Fluid_BaseClasses_FlowModels.html#Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_m_flow>`_.
The governing equation is

.. math::

   k = \frac{\dot m}{\sqrt{\Delta p}}

with regularization near zero to avoid that the limit
:math:`{d \dot m}/{d \Delta p}` tends to infinity as :math:`\dot m \to 0`,
as this can cause Newton-based solvers to stall.
For fixed flow resistances, :math:`k` is typically computed based on nominal
conditions such as :math:`k = \dot m_0/\sqrt{\Delta p_0}`,
where :math:`\dot m_0` is equal to the parameter ``m_flow_nominal`` and
:math:`\Delta p_0` is equal to the parameter ``dp_nominal.``

All pressure drop models should also provide a parameter that allows replacing
the equation by a linear model of the form

.. math::

   \dot m \, \dot m_0 = \bar k^2 \, \Delta p

.. note::

   Equations for pressure drop are implemented as a function of mass flow rate
   and not volume flow rate. For some models, this allows decoupling
   the mass flow balance from the energy balance.
   Otherwise, computing the mass flow distribution would require knowledge
   of the density, which may depend on temperature, and temperature is only
   known after solving the energy balance.

When implementing the pressure drop model, also provide means to

1. use homotopy, which should be used by default, and
2. disable the pressure-drop model.

Disabling the pressure-drop model allows, for example, a user to
set in a series connection of a heating coil and a cooling coil
the pressure drop of the heating coil to zero, and
to lump the pressure drop of the heating coil into the pressure drop model
of the cooling coil.
This often reduces the size of the system of nonlinear equations.


Control Sequences using the Control Description Language
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

To implement reusable control sequences, such as done within
the `OpenBuildingControl <https://obc.lbl.gov>`_ project, the
sequences need to comply with the
`specification of the Control Description Language <https://obc.lbl.gov/specification/cdl.html>`_.

The following rules need to be followed, in addition to the guidelines described in :numref:`sec_dev_gui_con`.


#. The naming of parameters, inputs, outputs and instances must follow the naming
   conventions in
   `Buildings.UsersGuide.Conventions <https://simulationresearch.lbl.gov/modelica/releases/latest/help/Buildings_UsersGuide.html#Buildings.UsersGuide.Conventions>`_.

#. Each block must have an ``info`` section that explains its functionality.
   In this ``info`` section, names of ``parameters``, ``inputs`` and ``outputs``
   need to be referenced using the html ``<code>...</code>`` element.
   In the ``info`` section, units need to be provided in SI units, or in dual units. For SI units,
   use Kelvin for temperature *differences* and degree Celsius for actual temperatures.

#. Parameters that can be grouped together, such as parameters relating to temperature setpoints
   or to the configuration of the trim and respond logic, should be grouped together with the
   ``Dialog(group=STRING))`` annotation. See for example
   `G36_PR1.TerminalUnits.Controller <https://github.com/lbl-srg/modelica-buildings/blob/94d5919dbe1b2f2e317e7b69800f3b3ad07be930/Buildings/Controls/OBC/ASHRAE/G36_PR1/TerminalUnits/Controller.mo>`_.
   Do not use ``Dialog(tab=STRING))``, unless the parameter is declared with a default value
   and this parameter and its value is of no interest to typical users.

#. Each block must have a ``defaultComponentName`` annotation.

#. To aid readability, the formatting of the Modelica source code file must be consistent with other
   implemented blocks, e.g., use two spaces for indentation (no tabulators),
   assign each parameter value on a new line, list first all parameters, then all inputs, all
   outputs, and finally all instances of other blocks.
   See for example
   `G36_PR1.AHUs.SingleZone.VAV.SetPoints.ExhaustDamper <https://github.com/lbl-srg/modelica-buildings/blob/94d5919dbe1b2f2e317e7b69800f3b3ad07be930/Buildings/Controls/OBC/ASHRAE/G36_PR1/AHUs/SingleZone/VAV/SetPoints/ExhaustDamper.mo>`_.

#. For parameters, where generally valid values can be provided, provide them
   as default values.

#. For PI controllers, normalize the inputs for setpoint and measured value so
   that the control error is of the order of one.
   As control errors for temperature tracking are usually in the order of one,
   these need not be normalized. But for pressure differentials, which can be
   thousands of Pascal, normalization aids in providing reasonable control gains
   and it aids in tuning.

#. Never use an inequality comparison without a hysteresis or a time delay if the variable that is used in the inequality test
   is computed using an iterative solver, or is obtained from a measurement and hence can contain measurement noise.
   An exception is a sampled value because the output of a sampler remains constant until the next sampling instant.
   See :numref:`sec_bes_pra_con`.

#. CDL uses the following units, which also need to be used in controllers, including
   their parameters:

   =======================  =====  ============================
   Physical Quantity        Unit   Note
   =======================  =====  ============================
   Temperature              K      Use `displayUnit=degC`
   Temperature difference   K
   Volume flow rate         m3/s
   Mass flow rate           kg/s
   Pressure                 Pa     Use `displayUnit=bar`
   Pressure differential    Pa
   Relative humidity        1
   Range of control signal  1
   =======================  =====  ============================

   Hence, for example, a controller that takes as an input a temperature and a temperature difference
   and produces as an output a damper position signal, use a declaration such as shown in the code snippet below
   in which graphical annotations are omitted.

   .. code-block:: modelica


    Buildings.Controls.OBC.CDL.Interfaces.RealInput TZon(
      final unit="K",
      displayUnit="degC") "Measured zone air temperature";

    Buildings.Controls.OBC.CDL.Interfaces.RealInput dTSup(
      final unit="K") "Temperature difference supply air minus exhaust air";

    Buildings.Controls.OBC.CDL.Interfaces.RealOutput yDam(
      min=0,
      max=1,
      final unit="1") "Exhaust damper position";

   Here, units are declared as ``final`` to avoid users to be able to change them, as
   a change in unit may cause the control logic to be incorrect.

   Conversion of these units to non-SI units can be done programmatically by tools that
   process CDL.

#. If the block diagram does not fit into the drawing pane, enlarge the drawing pane rather
   than making the blocks smaller.

#. For simple, small controllers, provide a unit test in a ``Validation`` or ``Examples`` package
   that is in the hierarchy one level below the implemented controller.
   See :numref:`sec_val` for unit test implementation.
   Because some control logic errors may only be noticed
   when used in a closed loop test,
   for equipment and system controllers, provide also closed loop examples that test the sequence
   for all modes of operation. If the closed loop examples include HVAC models, then put them
   outside of the ``Buildings.Controls.OBC`` package.
   Make sure sequences are tested for all modes of operation, and as applicable, for winter, shoulder
   and summer days.



.. _sec_val:

Validation
----------

All models that are implemented need to be validated for all
realistic operating modes.
These validations need to be part of the
`unit tests <https://github.com/lbl-srg/modelica-buildings/wiki/Unit-Tests>`_.

Add a couple of sentences that explain to others the intent of the unit test.
For example, an air handler unit controller test could describe
"This model verifies that as the cooling load of the room increases, the controller
first increases the mass flow rate setpoint and then reduces the supply temperature setpoint."

For simple models, the validation can be against analytic solutions.
This is for example done in
`Buildings.Fluid.FixedResistances.PressureDrop <https://simulationresearch.lbl.gov/modelica/releases/latest/help/Buildings_Fluid_FixedResistances_Examples.html#Buildings.Fluid.FixedResistances.Examples.PressureDrop>`_
which uses a regression tests that checks the correct relation between mass flow rate and pressure drop.
For complex thermofluid flow devices, a comparative model validation needs to be done, for example
by comparing the result of the Modelica model against the results from EnergyPlus.
An example is
`Buildings.Fluid.HeatExchangers.CoolingTowers.Validation.MerkelEnergyPlus`.
For such validations, the following files also need to be added to the repository:

 - The EnergyPlus input data file. Please make sure it only requires a weather data file that already exists in the Buildings library.
 - A bash script called `run.sh` that

    1. runs the EnergyPlus model on Linux, and
    2. invokes a Python script that converts the EnergyPlus output file (see next item).

   This file will automatically be
   executed as part of the continuous integration testing.
 - A Python script that converts the EnergyPlus output file to the data file that can
   be read by the Modelica data reader.

See for example `Buildings/Resources/Data/Fluid/HeatExchangers/CoolingTowers/Validation` for an implementation.
