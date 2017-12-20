Best Practice
=============

This section explains to library users best practice in creating new system models. The selected topics are based on problems that are often observed with new users of Modelica. Experienced users of Modelica may skip this section.

Organization of packages
------------------------

When developing models, one should distinguish between a library which contains widely applicable models, such as the `Buildings` library, and an application-specific model which may be created for a specific building and is of limited use for other applications.
It is recommended that users store application-specific models outside of the `Buildings` library. This will allow users to replace the `Buildings` library with a new version without having to change the application-specific model.
If during the course of the development of application-specific models, some models turn out to be of interest for other applications, then they can be contributed to the development of the `Buildings` library, as described in the section :ref:`Development`.


Building large system models
----------------------------

When creating a large system model, it is typically easier to build the system model through the composition of subsystem models that can be tested in isolation. For example, the package `Buildings.Examples.ChillerPlant.BaseClasses.Controls.Examples <http://simulationresearch.lbl.gov/modelica/releases/latest/help/Buildings_Examples_ChillerPlant_BaseClasses_Controls_Examples.html#Buildings.Examples.ChillerPlant.BaseClasses.Controls.Examples>`_
contains small test models that are used to test individual components in the large system model `Buildings.Examples.ChillerPlant <http://simulationresearch.lbl.gov/modelica/releases/latest/help/Buildings_Examples_ChillerPlant.html#Buildings.Examples.ChillerPlant>`_.
Creating small test models typically saves time as the proper response of controls, and the proper operation of subsystems, can be tested in isolation of complex system-interactions that are often present in large models.


Propagating parameters and media packages
--------------------------------------------

Consider a model with a pump ``pum`` and a mass flow sensor ``sen``.
Suppose that both models have a parameter ``m_flow_nominal`` for the nominal mass flow rate that needs to be set to the same value.
Rather than setting these parameters individually to a numeric value, it is recommended to propagate the parameter to the top-level of the model. Thus, instead of using the declaration

.. code-block:: modelica

   Pump pum(m_flow_nominal=0.1) "Pump";
   TemperatureSensor sen(m_flow_nominal=0.1) "Sensor";

we recommend to use

.. code-block:: modelica

   Modelica.SIunits.MassFlowRate m_flow_nominal = 0.1
                                 "Nominal mass flow rate";
   Pump pum(m_flow_nominal=m_flow_nominal) "Pump";
   TemperatureSensor sen(m_flow_nominal=m_flow_nominal) "Sensor";

This allows to change the value of ``m_flow_nominal`` at one location, and then have the value be propagated to all models that reference it. The effort for the additional declaration typically pays off as changes to the model are easier and more robust.

Propagating parameters and packages is particularly important for medium definitions. This allows the user to change the medium declaration at one location and then have it propagated to all models that reference it. This can be done by using the declaration

.. code-block:: modelica

   replaceable package Medium = Modelica.Media.Interfaces.PartialMedium
     "Medium model for air" annotation (choicesAllMatching=true);

Here, the optional annotation ``annotation (choicesAllMatching=true)`` is added which causes a GUI to show a drop-down menu with all medium models that extend from ``Modelica.Media.Interfaces.PartialMedium``.

If the above sensor requires a medium model, which is likely the case, its declaration would be


.. code-block:: modelica

   TemperatureSensor sen(redeclare package Medium = Medium,
                         m_flow_nominal=m_flow_nominal) "Sensor";

At the top-level of a system-model, one would set the ``Medium`` package to an actual media, such as by using

.. code-block:: modelica

   package Medium = Buildings.Media.PerfectGases.MoistAir "Medium model";
   TemperatureSensor sen(redeclare package Medium = Medium,
                         m_flow_nominal=m_flow_nominal) "Sensor";


Thermo-fluid systems
--------------------

In this section, we describe best practices that are specific to the modeling of thermo-fluid systems.

Overdetermined initialization problem and inconsistent equations
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

We will now explain how state variables, such as temperature and pressure, can be initialized.

Consider a model consisting of a mass flow source ``Modelica.Fluid.Sources.MassFlowSource_T``, a fluid volume ``Buildings.Fluid.MixingVolumes.MixingVolume`` and
a fixed boundary condition ``Buildings.Fluid.Sources.FixedBoundary``, connected in series as shown in the figure below. Note that the instance ``bou`` implements an equation that sets the medium pressure at its port, i.e., the port pressure ``bou.ports.p`` is fixed.

.. figure:: img/MixingVolumeInitialization.png
   :scale: 100%

   Schematic diagram of a flow source, a fluid volume, and a pressure source.

The volume allows configuring balance equations for energy and mass in four different ways.
Let :math:`p(\cdot)` be the pressure of the volume,
:math:`p_0` be the parameter for the initial pressure,
:math:`m(\cdot)` be the mass contained in the volume,
:math:`\dot m_i(\cdot)` be the mass flow rate across the i-th fluid port of the volume,
:math:`N \in \mathbb N` be the number of fluid ports, and
:math:`t_0` be the initial time.
Then, the equations for the mass balance of the fluid volume can be configured as shown in the table below.

+--------------------------+--------------------------------+--------------------------------+---------------------------------------------+
| Parameter                | Initialization problem         | Initialization problem         | Equation used during time stepping          |
+--------------------------+--------------------------------+--------------------------------+---------------------------------------------+
| ``massDynamics``         | if :math:`\rho = \rho(p)`      | if :math:`\rho \not = \rho(p)` |                                             |
+==========================+================================+================================+=============================================+
|``DynamicsFreeInitial``   | Unspecified                    | Unspecified                    | :math:`dm(t)/dt = \sum_{i=1}^N \dot m_i(t)` |
+--------------------------+--------------------------------+--------------------------------+---------------------------------------------+
|``FixedInitial``          | :math:`p(t_0)=p_0`             | Unspecified                    | :math:`dm(t)/dt = \sum_{i=1}^N \dot m_i(t)` |
+--------------------------+--------------------------------+--------------------------------+---------------------------------------------+
|``SteadyStateInitial``    | :math:`dp(t_0)/dt = 0`         | Unspecified                    | :math:`dm(t)/dt = \sum_{i=1}^N \dot m_i(t)` |
+--------------------------+--------------------------------+--------------------------------+---------------------------------------------+
|``SteadyState``           | Unspecified                    | Unspecified                    | :math:`0 =  \sum_{i=1}^N \dot m_i(t)`       |
+--------------------------+--------------------------------+--------------------------------+---------------------------------------------+

*Unspecified* means that no equation is declared for the initial value
:math:`p(t_0)`. In this situation, there can be two cases:

1. If a system model sets the pressure in the above model
   ``vol.p=vol.ports.p=bou.ports.p`` due to the connection
   between them, then
   :math:`p(t_0)` of the volume is equal to ``bou.ports.p``.
2. If a system model does not set the pressure (i.e., if ``vol`` and ``bou``
   are not connected to each other), then the pressure starts
   at the value ``p(start=Medium.p_default)``, where ``Medium`` is the
   name of the instance of the medium model.

Since the model ``Buildings.Fluid.Sources.FixedBoundary`` fixes the pressure at its port, the initial conditions :math:`p(t_0)=p_0` and :math:`dp(t_0)/dt = 0` lead to an overspecified system for the model shown above. To avoid such situation, use different initial conditions, or add a flow resistance between the mixing volume and the pressure source. The flow resistance introduces an equation that relates the pressure of the mixing volume and the pressure source as a function of the mass flow rate, thereby removing the inconsistency.

.. warning::

   The setting ``FixedInitial`` should be used with caution: Since the pressure dynamics is fast, this setting
   can lead to very fast transients when the simulation starts. Such transients can cause numerical problems
   for differential equation solvers.

Similarly, for the energy balance,
let :math:`U(\cdot)` be the energy stored in the volume,
:math:`T(\cdot)` be the temperature of the volume,
:math:`m_i(\cdot)` be the mass flow rate that carries the specific enthalpy per unit mass
:math:`h_i(\cdot)` across the i-th fluid connector of the volume, and let
:math:`Q(\cdot)` be the heat flow at the heat port of the volume.
Then, the energy balance can be configured as shown in the table below.

+------------------------+-----------------------------------------+-------------------------------------------------------------------+
| Parameter              | Initialization problem                  | Equation used during time stepping                                |
| ``energyDynamics``     |                                         |                                                                   |
+========================+=========================================+===================================================================+
|``DynamicsFreeInitial`` |  Unspecified                            | :math:`dU(t)/dt = \sum_{i=1}^N \dot m_i(t) \, h_i(t) + \dot Q(t)` |
+------------------------+-----------------------------------------+-------------------------------------------------------------------+
|``FixedInitial``        |  :math:`T(t_0)=T_0`                     | :math:`dU(t)/dt = \sum_{i=1}^N \dot m_i(t) \, h_i(t) + \dot Q(t)` |
+------------------------+-----------------------------------------+-------------------------------------------------------------------+
|``SteadyStateInitial``  |  :math:`dT(t_0)/dt = 0`                 | :math:`dU(t)/dt = \sum_{i=1}^N \dot m_i(t) \, h_i(t) + \dot Q(t)` |
+------------------------+-----------------------------------------+-------------------------------------------------------------------+
|``SteadyState``         |  Unspecified                            | :math:`0 = \sum_{i=1}^N \dot m_i(t) \, h_i(t) + \dot Q(t)`        |
+------------------------+-----------------------------------------+-------------------------------------------------------------------+

*Unspecified* means that no equation is declared for
:math:`T(t_0)`. In this situation, there can be two cases:

1. If a system model sets the temperature (i.e. if in the model
   the heat port of ``vol`` is connected to a fixed temperature),
   then
   :math:`T(t_0)` of the volume would be equal to the temperature connected
   to this port.
2. If a system model does not set the temperature, then the temperature starts
   at the value ``T(start=Medium.T_default)``, where ``Medium`` is the
   medium model.


.. note::

   1. Selecting ``SteadyState`` for the energy balance and
      *not* ``SteadyState`` for the mass balance
      can lead to inconsistent equations. The model will check for this situation
      and stop the translation with an error message.
      To see why the equations are inconsistent,
      consider a volume with two fluid ports
      and no heat port. Then, it is possible
      that :math:`\dot m_1(t) \not = 0` and :math:`\dot m_2(t) = 0`,
      since :math:`dm(t)/dt =  \dot m_1(t) + \dot m_2(t)`.
      However, the energy balance equation is
      :math:`0 = \sum_{i=1}^2 \dot m_i(t) \, h_i(t) + \dot Q(t)`,
      with :math:`\dot Q(t) = 0` because there is no heat port.
      Therefore, we obtain :math:`0 = \dot m_1(t) \, h_1(t)`,
      which is inconsistent.
   2. Unlike the case with the pressure initialization, the temperature in
      the model ``bou`` does not lead to ``vol.T = bou.T`` at initial time,
      because physics allows the temperatures in ``bou`` and ``vol`` to
      be different.


The equations for the mass fraction dynamics (such as the
water vapor concentration),
and the trace substance dynamics (such as carbon dioxide concentration),
are similar to the energy equations.

Let
:math:`X(\cdot)` be the mass of the species in the volume,
:math:`m(t_0)` be the initial mass of the volume,
:math:`x_0` be the user-selected species concentration in the volume,
:math:`x_i(\cdot)` be the species concentration at the i-th fluid port, and
:math:`\dot X(\cdot)` be the species added from the outside, for example the water vapor added by a humidifier.
Then, the substance dynamics can be configured as shown in the table below.

+------------------------+-----------------------------------------+--------------------------------------------------------------------+
| Parameter              | Initialization problem                  | Equation used during time stepping                                 |
| ``massDynamics``       |                                         |                                                                    |
+========================+=========================================+====================================================================+
|``DynamicsFreeInitial`` |  Unspecified                            | :math:`dX(t)/dt = \sum_{i=1}^N  \dot m_i(t) \, x_i(t) + \dot X(t)` |
+------------------------+-----------------------------------------+--------------------------------------------------------------------+
|``FixedInitial``        |  :math:`X(t_0)= m(t_0) \, x_0`          | :math:`dX(t)/dt = \sum_{i=1}^N  \dot m_i(t) \, x_i(t) + \dot X(t)` |
+------------------------+-----------------------------------------+--------------------------------------------------------------------+
|``SteadyStateInitial``  |  :math:`dX(t_0)/dt = 0`                 | :math:`dX(t)/dt = \sum_{i=1}^N  \dot m_i(t) \, x_i(t) + \dot X(t)` |
+------------------------+-----------------------------------------+--------------------------------------------------------------------+
|``SteadyState``         |  Unspecified                            | :math:`0 = \sum_{i=1}^N  \dot m_i(t) \, x_i(t) + \dot X(t)`        |
+------------------------+-----------------------------------------+--------------------------------------------------------------------+

The equations for the trace substance dynamics are identical to the equations for the substance dynamics, if
:math:`X(\cdot), \, \dot X(\cdot)` and :math:`x_i(\cdot)` are replaced with
:math:`C(\cdot), \, \dot C(\cdot)` and :math:`c_i(\cdot)`, where
:math:`C(\cdot)` is the mass of the trace substances in the volume,
:math:`c_i(\cdot)` is the trace substance concentration at the i-th fluid port and
:math:`\dot C(\cdot)` is the trace substance mass flow rate added from the outside.
Therefore, energy, mass fraction and trace substances have identical equations and configurations.


Modeling of fluid junctions
~~~~~~~~~~~~~~~~~~~~~~~~~~~
In Modelica, connecting fluid ports as shown below leads to ideal mixing at the junction.
In some situation, such as the configuration below, connecting multiple connectors to a fluid port represents the physical phenomena that was intended to model.

.. figure:: img/fluidJunctionMixing.png
   :scale: 100%

   Connection of three components without explicitly introducing a mixer or splitter model.

However, in more complex flow configurations, one may want to explicitly control what branches of a piping or duct network mix. This may be achieved by using an instance of the model
`PressureDrop <http://simulationresearch.lbl.gov/modelica/releases/latest/help/Buildings_Fluid_FixedResistances.html#Buildings.Fluid.FixedResistances.PressureDrop>`_ as shown in the left figure below, which is the test model
`BoilerPolynomialClosedLoop <http://simulationresearch.lbl.gov/modelica/releases/latest/help/Buildings_Fluid_Boilers_Examples.html#Buildings.Fluid.Boilers.Examples.BoilerPolynomialClosedLoop>`_

.. figure:: img/fluidJunctionMixingSplitter.png

   Correct (left) and wrong (right) connection of components with use of a mixer or splitter model.

In the figure on the left, the mixing points have been correctly defined by use of the three-way model that mixes or splits flow. By setting the nominal pressure drop of the mixer or splitter model to zero, the mixer or splitter model can be simplified so that no equation for the flow resistance is introduced. In addition, in the branch of the splitter that connects to the valve, a pressure drop can be modelled, which then affects the valve authority.
However, in the figure on the right, the flow that leaves port A is mixing at port B with the return from the volume ``vol``, and then it flows to port C. Thus, the valve is exposed to the wrong temperature.


Use of sensors in fluid flow systems
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
When selecting a sensor model, a distinction needs to be made whether the measured quantity depends on the direction of the flow or not. If the quantity depends on the flow direction, such as temperature or relative humidity, then sensors with two ports from the
`Buildings.Fluid.Sensors <http://simulationresearch.lbl.gov/modelica/releases/latest/help/Buildings_Fluid_Sensors.html#Buildings.Fluid.Sensors>`_ library should be used. These sensors have a more efficient implementation than sensors with one port for situations where the flow reverses its direction.
The proper use sensors is described in the
`User's Guide <http://simulationresearch.lbl.gov/modelica/releases/latest/help/Buildings_Fluid_Sensors_UsersGuide.html>`_ of the
`Buildings.Fluid.Sensors <http://simulationresearch.lbl.gov/modelica/releases/latest/help/Buildings_Fluid_Sensors.html#Buildings.Fluid.Sensors>`_ package.


.. _ReferencePressureIncompressibleFluids:

Reference pressure for incompressible fluids such as water
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This section explains how to set a reference pressure for incompressible fluids. For fluids that model density as a function of temperature, the section also shows how to account for the thermal expansion of the fluid.

Consider the flow circuit shown below that consists of a pump or fan, a flow resistance and a volume.

.. figure:: img/flowCircuitNoExpansion.png
   :scale: 60%

   Schematic diagram of a flow circuit without means
   to set a reference pressure, or to account for
   thermal expansion of the fluid.

When this model is used with a medium model that models
:term:`compressible flow`, such as
the medium model `Buildings.Media.Air <http://simulationresearch.lbl.gov/modelica/releases/latest/help/Buildings_Media_Air.html#Buildings.Media.Air>`_,
then the model is well defined because the gas medium implements the
equation :math:`p=\rho \, R \, T`,
where :math:`p` is the static pressure, :math:`\rho` is the mass density,
:math:`R` is the gas constant and :math:`T` is the absolute temperature.

However, when the medium model is changed to a model that models
:term:`incompressible flow`, such as
`Buildings.Media.Water <http://simulationresearch.lbl.gov/modelica/releases/latest/help/Buildings_Media_Water.html#Buildings.Media.Water>`_,
then the density is constant. Consequently, there is no equation that
can be used to compute the pressure based on the volume.
In this situation, attempting to translate the model leads, in Dymola, to the following error message:

.. code-block:: none

   The DAE has 151 scalar unknowns and 151 scalar equations.
   Error: The model FlowCircuit is structurally singular.
   The problem is structurally singular for the element type Real.
   The number of scalar Real unknown elements are 58.
   The number of scalar Real equation elements are 58.

Similarly, if the medium model `Buildings.Media.Specialized.Water.TemperatureDependentDensity <http://simulationresearch.lbl.gov/modelica/releases/latest/help/Buildings_Media_Specialized_Water_TemperatureDependentDensity.html#Buildings.Media.Specialized.Water.TemperatureDependentDensity>`_,
which models density as a function of pressure and enthalpy, is used, then
the model is well-defined, but the pressure increases the longer the pump runs.
The reason is that the pump adds heat to the water. When the water temperature
increases from :math:`20^\circ \mathrm C` to :math:`40^\circ \mathrm C`,
the pressure increases from :math:`1 \, \mathrm{bars}` to :math:`150 \, \mathrm{bars}`.

To avoid this singularity or increase in pressure,
use a model that imposes a pressure source and that accounts for the expansion of the fluid.
For example, use
`Buildings.Fluid.Storage.ExpansionVessel <http://simulationresearch.lbl.gov/modelica/releases/latest/help/Buildings_Fluid_Storage.html#Buildings.Fluid.Storage.ExpansionVessel>`_
to form the system model shown below.

.. figure:: img/flowCircuitWithExpansionVessel.png
   :scale: 60%

   Schematic diagram of a flow circuit with expansion vessel that
   adds a pressure source and accounts for the thermal expansion
   of the medium.

Alternatively, you may use
`Buildings.Fluid.Sources.FixedBoundary <http://simulationresearch.lbl.gov/modelica/releases/latest/help/Buildings_Fluid_Sources.html#Buildings.Fluid.Sources.FixedBoundary>`_, which sets the pressure to a constant value
and adds or removes fluid as needed to maintain the pressure.
The model `Buildings.Fluid.Sources.FixedBoundary <http://simulationresearch.lbl.gov/modelica/releases/latest/help/Buildings_Fluid_Sources.html#Buildings.Fluid.Sources.FixedBoundary>`_ usually leads to simpler equations than
`Buildings.Fluid.Storage.ExpansionVessel <http://simulationresearch.lbl.gov/modelica/releases/latest/help/Buildings_Fluid_Storage.html#Buildings.Fluid.Storage.ExpansionVessel>`_.
Note that the medium that flows out of the fluid port of
`Buildings.Fluid.Sources.FixedBoundary <http://simulationresearch.lbl.gov/modelica/releases/latest/help/Buildings_Fluid_Sources.html#Buildings.Fluid.Sources.FixedBoundary>`_
is at a fixed temperature, while the model
`Buildings.Fluid.Storage.ExpansionVessel <http://simulationresearch.lbl.gov/modelica/releases/latest/help/Buildings_Fluid_Storage.html#Buildings.Fluid.Storage.ExpansionVessel>`_ conserves energy.
However, since the thermal expansion of the fluid is usually small, this effect can be neglected in most building HVAC applications.

.. figure:: img/flowCircuitWithBoundary.png
   :scale: 60%

   Schematic diagram of a flow circuit with a boundary model that adds
   a fixed pressure source and accounts for any thermal expansion
   of the medium.


.. note::

   In each water circuit, there must be one, and only one, instance of
   `Buildings.Fluid.Storage.ExpansionVessel
   <http://simulationresearch.lbl.gov/modelica/releases/latest/help/Buildings_Fluid_Storage.html#Buildings.Fluid.Storage.ExpansionVessel>`_,
   or instance of
   `Buildings.Fluid.Sources.FixedBoundary
   <http://simulationresearch.lbl.gov/modelica/releases/latest/help/Buildings_Fluid_Sources.html#Buildings.Fluid.Sources.FixedBoundary>`_.
   If there is no such device, then the absolute pressure
   may not be defined, or it may raise to an unrealistically large
   value if the medium density changes.
   If there is more than one such device, then there are multiple
   points in the system that set the reference static pressure.
   This will affect the distribution of the mass flow rate.


Nominal Values
~~~~~~~~~~~~~~

Most components have a parameters for the nominal operating conditions.
These parameters have names that end in ``_nominal`` and they should be set to the values that
the component typically
has if it is operated at full load or design conditions. Depending on the model, these
parameters are used differently, and the respective model documentation or code
should be consulted for details. However, the table below shows typical use of
parameters in various model to help the user understand how they are used.


+---------------------+---------------------------+--------------------------------------------------------------------------+
| Parameter           | Model                     | Functionality                                                            |
+=====================+===========================+==========================================================================+
| ``m_flow_nominal``  | | Flow resistance models. | These parameters may be used to define a point on the flow rate          |
| ``dp_nominal``      |                           | versus pressure drop curve. For other mass flow rates, the pressure drop |
|                     |                           | is typically adjusted using similarity laws.                             |
|                     |                           | See PressureDrop_.                                                       |
+---------------------+---------------------------+--------------------------------------------------------------------------+
| ``m_flow_nominal``  | | Sensors.                | Some of these models set ``m_flow_small=1E-4*abs(m_flow_nominal)``       |
| ``m_flow_small``    | | Volumes.                | as the default value. Then, m_flow_small is used to regularize, or       |
|                     | | Heat exchangers.        | replace, equations when the mass flow rate is smaller than               |
|                     |                           | ``m_flow_small`` in magnitude. This is needed to improve the numerical   |
|                     |                           | properties of the model. The error in the results is negligible for      |
|                     |                           | typical applications, because at flow rates below 0.01% from the         |
|                     |                           | design flow rate, most model assumptions are not applicable              |
|                     |                           | anyways, and the HVAC system is not operated in this region.             |
|                     |                           | Modelica simulates in the continuous-time domain, thus                   |
|                     |                           | such small flow rates can occur, and therefore models are                |
|                     |                           | implemented in such a way that they are numerically well-behaved         |
|                     |                           | for zero or near-zero flow rates.                                        |
+---------------------+---------------------------+--------------------------------------------------------------------------+
| ``tau``             | | Sensors.                | Because Modelica simulates in the continuous-time domain, dynamic        |
| ``m_flow_nominal``  | | Volumes.                | models are in general numerically more efficient than steady-state       |
|                     | | Heat exchangers.        | models. However, dynamic models require product data that are generally  |
|                     | | Chillers.               | not published by manufacturers. Examples include the volume of fluid     |
|                     |                           | that is contained in a device, and the weight of heat exchangers.        |
|                     |                           | In addition, other effects such as transport delays in pipes and heat    |
|                     |                           | exchangers of a chiller are generally unknown and require detailed       |
|                     |                           | geometry that is typically not available during the design stage.        |
|                     |                           |                                                                          |
|                     |                           | To circumvent this problem, many models take as a parameter              |
|                     |                           | the time constant ``tau`` and lump all its thermal mass                  |
|                     |                           | into a fluid volume. The time constant ``tau`` can be understood         |
|                     |                           | as the time constant that one would observe if the input to              |
|                     |                           | the component has a step change, and the mass flow rate of the           |
|                     |                           | component is equal to ``m_flow_nominal``. Using these two values         |
|                     |                           | and the fluid density ``rho``, components adjust their fluid volume      |
|                     |                           | ``V=m_flow_nominal tau/rho`` because having such a volume                |
|                     |                           | gives the specified time response. For most components,                  |
|                     |                           | engineering experience can be used to estimate a                         |
|                     |                           | reasonable value for ``tau``, and where generally applicable values      |
|                     |                           | can be used, components already set a default value for ``tau.``         |
|                     |                           | See for example WetCoilDiscretized_.                                     |
+---------------------+---------------------------+--------------------------------------------------------------------------+






Start values of iteration variables
-----------------------------------

When computing numerical solutions to systems of nonlinear equations, a Newton-based solver is typically used. Such solvers have a higher success of convergence if good start values are provided for the iteration variables. In Dymola, to see what start values are used, one can enter on the simulation tab the command

.. code-block:: none

   Advanced.LogStartValuesForIterationVariables = true;

Then, when a model is translated, for example using

.. code-block:: none

   translateModel("Buildings.Fluid.Boilers.Examples.BoilerPolynomialClosedLoop");

an output of the form

.. code-block:: none

   Start values for iteration variables:
    val.res1.dp(start = 3000.0)
    val.res3.dp(start = 3000.0)

is produced. This shows the iteration variables and their start values. These start values can be overwritten in the model.


Avoiding events
---------------

In Modelica, the time integration is halted whenever a Real elementary
operation such as :math:`x>y`, where :math:`x` and :math:`y` are variables of type ``Real``,
changes its value. In this situation,
an event occurs and the solver determines a small interval in time in which
the relation changes its value. Determining this time interval
often requires an iterative solution, which can significantly
increase the computing time if the iteration require
the evaluation of a large system of equations.
An example where such an event occurs is the relation

.. code-block:: modelica

		if port_a.m_flow > 0 then
		  T_in = port_a.T;
		else
		  T_in = port_b.T;
		end if;

or, equivalently,

.. code-block:: modelica

		T_in = if port_a.m_flow > 0 then port_a.T else port_b.T;

When simulating a model that contains such code, a time integrator
will iterate to find the time instant where ``port_a.m_flow`` crosses zero.
If the modeling assumptions allow approximating this equation in
a neighborhood around ``port_a.m_flow=0``, then replacing this equation
with an approximation that does not require an event iteration can
reduce computing time. For example, the above equation could be
approximated as

.. code-block:: modelica

		T = Modelica.Fluid.Utilities.regStep(
		  port_a.m_flow, T_a_inflow, T_b_inflow,
		  m_flow_nominal*1E-4);


where ``m_flow_nominal`` is a parameter that is set to a value that
is close to the mass flow rate that the model has at full load.
If the magnitude of the flow rate is larger than 1E-4 times the
typical flow rate, the approximate equation is the same as the exact equation,
and below that value, an approximation is used. However, for such small
flow rates, not much energy is transported and hence the error introduced
by the approximation is generally negligible.


In some cases, adding dynamics to the model can further improve
the computing time, because the return value of the function
`Modelica.Fluid.Utilities.regStep() <http://simulationresearch.lbl.gov/modelica/releases/msl/3.2/help/Modelica_Fluid_Utilities.html#Modelica.Fluid.Utilities.regStep>`_
above can change abruptly if its argument ``port_a.m_flow`` oscillates in the range of
``+/- 1E-4*m_flow_nominal``,
for example due to :term:`numerical noise`.
Adding dynamics may be achieved using a formulation such as

.. code-block:: modelica

		TMed = Modelica.Fluid.Utilities.regStep(
		  port_a.m_flow, T_a_inflow, T_b_inflow,
		  m_flow_nominal*1E-4);
		der(T)=(TMed-T)/tau;

where ``tau``>0 is a time constant. See, for example,
`Buildings.Fluid.Sensors.TemperatureTwoPort <http://simulationresearch.lbl.gov/modelica/releases/latest/help/Buildings_Fluid_Sensors.html#Buildings.Fluid.Sensors.TemperatureTwoPort>`_
for a robust implementation.

.. note::
   In the package `Buildings.Utilities.Math <http://simulationresearch.lbl.gov/modelica/releases/latest/help/Buildings_Utilities_Math.html#Buildings.Utilities.Math>`_
   the functions and blocks whose names start with ``smooth`` can be used to avoid events.

Controls
--------

.. figure:: img/controlHysteresis.png
   :scale: 100%

   Schematic diagram of a controller that switches a coil on and off.
   In the top configuration, the hysteresis avoids numerical problems
   (and short-cycling) if the control input remains close to the
   set point. The bottom configuration can cause the integration to
   stall if the input signal to the threshold block is the solution
   of an iterative solver and remains around 293.15 Kelvin.

When implementing an on/off controller, always use a controller with
hysteresis such as shown in the top configuration of the model above.
If no hysteresis is used, then numerical problems can occur if the
variable that is input to the controller depends on a variable
that is computed by an iterative algorithm.
Examples of a iterative algorithms are nonlinear equation solvers
or time integration algorithms with variable step size (such as
the radau and dassl solver in Dymola).
The problem is caused as follows:
Let :math:`T(t) \in \Re` be the input into a controller, such as
a room air temperature.
If :math:`T(t)` is the state variable computed by solving a differential equation,
or if :math:`T(t)` depends on a variable that needs to be solved for iteratively,
then :math:`T(t)` can only be approximated by some approximation
:math:`T^*(\epsilon, t)`, where
:math:`\epsilon` is the solver tolerance. Even if the system is at
an equilibrium, the solver can cause the value of :math:`T^*(\epsilon, t)`
to slightly change from one iteration to another. Hence,
:math:`T^*(\epsilon, t)` can exhibit what is called numerical noise.
Now, if :math:`T^*(\epsilon, t)` is used to switch a heater on and off
whenever it crosses at set point temperature, and if
:math:`T(t)` happens to be at an equilibrium near the set point temperature,
then the heater can switch on and off rapidly due to the numerical noise.
This can cause the time integration to stall.

To illustrate this problem, try to simulate

.. code-block:: modelica

  model Unstable
    Real x(start=0.1);
  equation
    der(x) = if x > 0 then -1 else 1;
  end Unstable;

In Dymola 2013, as expected the model stalls at :math:`t=0.1`
because the ``if-then-else`` construct triggers an event iteration whenever
:math:`x` crosses zero.

.. warning::

   Never use an inequality comparison without a
   hysteresis or a time delay if the variable that is used in the
   inequality test

   * is computed using an :term:`iterative solver`, or
   * is obtained from a measurement and hence can contain measurement
     noise.

   See :ref:`sec-example-event-debugging` for what can happen in
   such tests.

.. _sec-example-event-debugging:

Examples for how to debug and correct slow simulations
------------------------------------------------------

State events
~~~~~~~~~~~~

This section shows how a simulation that stalls due to events can be debugged
to find the root cause, and then corrected.
While the details may differ from one tool to another, the principle is the same.
In our situation, we attempted to simulate ``Buildings.Examples.DualFanDualDuct``
for one year in Dymola 2016 FD01 using the model from Buildings version 3.0.0.
We run

.. code-block:: modelica

   simulateModel("Buildings.Examples.DualFanDualDuct.ClosedLoop",
                  stopTime=31536000, method="radau",
                  tolerance=1e-06, resultFile="DualFanDualDuctClosedLoop");

and plotted the computing time and the number of events. Around :math:`t=0.95e7` seconds,
there was a spike as shown in the figure below.

.. figure:: img/DualFanDualDuct-cpu-events.*
   :scale: 60%

   Computing time and number of events.

As the number of events increased drastically, we enabled in Dymola in
`Simulation -> Setup`, under the tab `Debug` the entry `Events during simulation`
and simulated the model from
:math:`t=0.9e7` to :math:`t=1.0e7` seconds. It turned out that setting the start time
to :math:`t=0.9e7` seconds was sufficient to reproduce the behavior;
otherwise we would
have had to set it to an earlier time.
Inspecting Dymola's log file ``dslog.txt`` when the simulation stalls shows that its last entries
are

.. code-block:: modelica

   Expression TRet.T > amb.x_pTphi.T became true ( (TRet.T)-(amb.x_pTphi.T) = 2.9441e-08 )
   Iterating to find consistent restart conditions.
         during event at Time :  9267949.854873843
   Expression TRet.T > amb.x_pTphi.T became false ( (TRet.T)-(amb.x_pTphi.T) = -2.94411e-08 )
   Iterating to find consistent restart conditions.
         during event at Time :  9267949.855016639
   Expression TRet.T > amb.x_pTphi.T became true ( (TRet.T)-(amb.x_pTphi.T) = 2.94407e-08 )
   Iterating to find consistent restart conditions.
         during event at Time :  9267949.855208419
   Expression TRet.T > amb.x_pTphi.T became false ( (TRet.T)-(amb.x_pTphi.T) = -2.94406e-08 )
   Iterating to find consistent restart conditions.
         during event at Time :  9267949.855351238

Hence, there is an event every few milliseconds, which explains
why the simulation does not appear to be progessing.
The solver does the right thing, it stops
the integration, handles the event, and restarts the integration, just to encounter
another event a few milliseconds later.
Hence, we go back to our system model and
follow the output signal of ``TRet.T`` of the
return air temperature sensor,
which shows that it is used in the economizer control
to switch the sign of the control gain because the economizer can provide heating or cooling,
depending on the ambient and return air temperature. The problematic model is
shown in the figure below.

.. _fig-dualfan-eco-con-bad:

.. figure:: img/EconomizerTemperatureControl-bad.*
   :scale: 100%

   Block diagram of part of the economizer control that computes the outside air damper
   control signal. This implementation triggers many events.

The events are triggered by the inequality block which changes the control, which then in turn
seems to cause a slight change in the return air temperature, possibly due
to :term:`numerical noise` or maybe because the return fan may change its operating point
as the dampers are adjusted, and hence change the heat
added to the medium. Regardless, this is a bad implementation that also
would cause oscillatory behavior in a real system if the sensor signal had
measurement noise.
Therefore, this equality comparison must be replaced by a block with hysteresis,
which we did as shown in the figure below.
We selected a hysteresis of :math:`0.2` Kelvin, and now the model runs fine
for the whole year.

.. _fig-dualfan-eco-con-revised:

.. figure:: img/EconomizerTemperatureControl-revised.*
   :scale: 100%

   Block diagram of part of the revised economizer control that computes the outside air damper
   control signal.


State variables that dominate the error control
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

In a development version of the model
``Buildings.Examples.DualFanDualDuct.ClosedLoop``
(commit `ef410ee <https://github.com/lbl-srg/modelica-buildings/commit/ef410ee8a5d1816f8b8e171da7743e15caaa3163>`_),
the simulation time was very slow during part of the
simulation, as shown in :numref:`fig-dualfan-filtered-speed`.


.. _fig-dualfan-filtered-speed:

.. figure:: img/DualFanDualDuctWithFilteredSpeed.*
   :scale: 100%

   Computing time and number of events.

The number of state events did not increase in that time interval.
To isolate the problem, we enabled in Dymola under `Simulation -> Setup` the
option to log which states dominate the error (see `Debug` tab).

Running the simulation again gave the following output:

.. code-block:: none

   Integration terminated successfully at T = 1.66e+07
     Limit stepsize, Dominate error, Exceeds 10% of error Component (#number)
         0     1     6 cooCoi.temSen_1.T (#  1)
        36     0   140 cooCoi.temSen_2.T (#  2)
        37     0     0 cooCoi.ele[1].mas.T (#  3)
        45     0     0 cooCoi.ele[2].mas.T (#  4)
        51     0     0 cooCoi.ele[3].mas.T (#  5)
        53     0     0 cooCoi.ele[4].mas.T (#  6)
     13555 13201 19064 fanSupHot.filter.x[1] (#  7)
     11905  2170 12394 fanSupHot.filter.x[2] (#  8)
       400    47   419 fanSupCol.filter.x[1] (#  9)
       420    71   521 fanSupCol.filter.x[2] (# 10)
      5082  2736  6732 fanRet.filter.x[1] (# 11)
      1979    25  4974 fanRet.filter.x[2] (# 12)
        38     0     3 TPreHeaCoi.T (# 13)
        30     0     1 TRet.T (# 14)
        38     0     3 TMix.T (# 15)
        80     0     0 TCoiCoo.T (# 16)
       305    22   275 cor.vavHot.filter.x[1] (# 18)

Hence, the state variables

.. code-block:: none

     13555 13201 19064 fanSupHot.filter.x[1] (#  7)
     11905  2170 12394 fanSupHot.filter.x[2] (#  8)
       400    47   419 fanSupCol.filter.x[1] (#  9)
       420    71   521 fanSupCol.filter.x[2] (# 10)
      5082  2736  6732 fanRet.filter.x[1] (# 11)
      1979    25  4974 fanRet.filter.x[2] (# 12)

limit the step size significantly more often than other variables.
Therefore, we removed these state variables
by setting in the fan models the parameter ``filteredSpeed=false``.
After this change, the model simulates without problems.


Numerical solvers
-----------------
Dymola 2017 is configured to use dassl as a default solver with a tolerance of
1E-4.
We recommend to change this setting to radau with a tolerance of around
1E-6, as this generally leads to faster and more robust
simulation for thermo-fluid flow systems.

Note that this is the error tolerance of the local integration time step.
Most ordinary differential equation solvers only control the local
integration error and not the global integration error.
As a rule of thumb, the global integration error is one
order of magnitude larger than the local integration error.
However, the actual magnitude of the global integration error
depends on the stability of the differential equation.
As an extreme case, if a system is chaotic
and uncontrolled, then the global integration error will grow rapidly.


.. _PressureDrop: http://simulationresearch.lbl.gov/modelica/releases/latest/help/Buildings_Fluid_FixedResistances.html#Buildings.Fluid.FixedResistances.PressureDrop
.. _WetCoilDiscretized: http://simulationresearch.lbl.gov/modelica/releases/latest/help/Buildings_Fluid_HeatExchangers.html#Buildings.Fluid.HeatExchangers.WetCoilDiscretized
