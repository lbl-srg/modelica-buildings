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

Models, blocks and functions that are contributed need to adhere to the following guidelines, as this is needed to integrate them in the library, make them accessible to users and further maintain them:

 * They should be of general interest to other users and well documented and tested.
 * They need to follow the coding conventions described in

   - the `Buildings library user guide <https://simulationresearch.lbl.gov/modelica/releases/v8.0.0/help/Buildings_UsersGuide.html#Buildings.UsersGuide.Conventions>`_ and
   - the `Style Guide` provided in subsections of :numref:`sec_sty_gui`

 * They need to be made available under the `Modelica Buildings Library license <https://simulationresearch.lbl.gov/modelica/releases/v8.0.0/help/Buildings_UsersGuide.html#Buildings.UsersGuide.License>`_.
 * For models of thermofluid flow components, they need to be based on the base classes in
   `Buildings.Fluid.Interfaces <https://simulationresearch.lbl.gov/modelica/releases/v8.0.0/help/Buildings_Fluid_Interfaces.html>`_,
   which are described in the `user guide <https://simulationresearch.lbl.gov/modelica/releases/v8.0.0/help/Buildings_Fluid_Interfaces_UsersGuide.html#Buildings.Fluid.Interfaces.UsersGuide>`_ of this package.
   Otherwise, it becomes difficult to ensure that the implementation is numerically robust.

.. _sec_sty_gui:

Style guide
-----------

General
~~~~~~~

1. Classes declared as ``partial`` and base classes that are not of interest to the user
   should be stored in a subdirectory called ``BaseClasses``.
   Each other class, except for constants, must have an icon.
2. Examples and validation models should be in directories such as ``Valves.Examples`` and
   ``Valves.Validations``. A script for the regression tests must be added as described below.
3. Do not copy sections of code. Use object inheritance.
4. Implement components of fluid flow systems by extending the
   classes in ``Buildings.Fluid.Interfaces``.
5. Use the full package names when instantiating a class.
6. Models, functions and blocks must be implemented as
   one model, function or block per file. An exception are the ``Buildings.Media`` packages.

Type declarations
~~~~~~~~~~~~~~~~~

#. Declare all public parameters before protected ones.
#. Declare variables and final parameters that are not of interest to
   users as protected.
#. Set default parameter values as follows:

   #. If a parameter value can range over a large region, do not provide a
      default value. Examples are nominal mass flow rates.
   #. If a parameter value does not vary significantly but need to be verified
      by the user, provide a default value by using its start attribute.
      For example, for a heat exchanger, use

      .. code-block:: modelica

         parameter Real eps(start=0.8, min=0, max=1, unit="1")
           "Heat exchanger effectiveness";

      Do not use ``parameter Real eps=0.8`` as this can lead to errors
      that are difficult to detect if a modeler forgets to overwrite
      the default value of ``0.8`` with the actual value. The model will simulate,
      but gives wrong results due to unsuited parameter values and there will be no warning.
      On the other hand, using ``parameter Real eps(start=0.8)`` will give a warning
      and hence users can assign better values.

   #. If a parameter value can be precomputed based on other parameters,
      set its value to this equation. For example,

      .. code-block:: modelica

         parameter Medium.MassFlowRate m_flow_small(min=0) = 1E-4*m_flow_nominal
         ...

   #. If a parameter assignment should not be changed by a user,
      use the ``final`` keyword.

#. For parameters and variables, provide values for the ``min`` and
   ``max`` attribute where applicable.
   Be aware, that these bounds are not enforced by the simulator.
   If the ``min`` and ``max`` attribute are set, each violation of these bounds
   during the simulation may raise a warning.

   Simulators may allow to suppress these warnings. In Dymola, violation of
   bounds can be checked using

   .. code-block::

      Advanced.AssertAllInsideMinMax=true;

#. For any variable or parameter that may need to be solved numerically,
   provide a value for the ``start`` and ``nominal`` attribute.
#. Use types from ``Modelica.Units.SI`` where possible,
   except in the package ``Buildings.Controls.OBC`` where the units should be declared
   as shown in :numref:`cod_uni_dec_cdl`.

Equations and algorithms
~~~~~~~~~~~~~~~~~~~~~~~~

#. Avoid events where possible.
#. Only divide by quantities that cannot take on zero. For example, if
   ``x`` may take on zero, use ``y=x``, not ``1=y/x``, as the second
   version indicates to a simulator that it is safe to divide by ``x``.
#. Use the ``assert`` function together with ``"In " + getInstanceName() + ":...``
   to check for invalid values of parameters or variables. For example, use

   .. code-block:: modelica

      assert(phi>=0, "In " + getInstanceName() + ": Relative humidity must not be negative.");

   Note the use of ``getInstanceName()``, which will write the instance name as part of the error message.
   Otherwise, OPTIMICA will not write the instance name.
#. Use either graphical modeling or textual code. When using graphical
   schematic modeling, do not add textual equations. For example, avoid
   the following, as on the graphical editor, the model looks appears
   to be singular:

   .. code-block:: modelica

      model Avoid
        Modelica.Blocks.Continuous.Integrator integrator "Integrator"
          annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
        equation
        integrator.u = 1;
      end Avoid;


#. For computational efficiency, equations shall were possible be
   differentiable and have a continuous first derivative.
#. Avoid equations where the first derivative with respect to another
   variable is zero. For example, avoid

   .. math::

      f(x) = \begin{cases}
        0, & \text{for } x < 0 \\
        x^2, & \text{otherwise.}
          \end{cases}

   because any :math:`x \le 0` is a solution, which
   can cause instability in the solver.
   Note that this problem do not exist for functions that assign a value
   to a constant as these will be evaluated during the model translation.
#. Do not replace an equation by a constant for a single value, unless
   the derivative of the original equation is zero for this value. For
   example, if computing a pressure drop ``dp`` may involve computing a
   long equation, but one knows that the result is always zero if the
   volume flow rate ``V_flow`` is zero, one may be inclined to use a
   construct of the form

   .. code-block:: modelica

      dp = smooth(1, if V_flow == 0 then 0 else f(V_flow));

   The problem with this formulation is that for ``V_flow=0``, the
   derivative is ``dp/dV_flow = 0``. However, the limit ``dp/dV_flow``,
   as ``|V_flow|`` tends to zero, may be non-zero. Hence, the first
   derivative has a discontinuity at ``V_flow=0``, which can cause a
   solver to fail to solve the equation because the ``smooth``
   statement declared that the first derivative exists and is
   continuous.
#. Make sure that the derivatives of equations are bounded on compact
   sets. For example, instead of using ``y=sign(x) * sqrt(abs(x))``,
   approximate the equation with a differentiable function that has a
   finite derivative near zero. Use functions form
   ``Buildings.Utilities.Math`` for this approximation.
#. Whenever possible, a Modelica tool should not have to do numerical
   differentiation. For example, in Dymola, if your model translation
   log shows

   .. code-block::

       Number of numerical Jacobians: 1

   (or any number other than zero), then enter on the command line

   .. code-block::

       Hidden.PrintFailureToDifferentiate = true;


   Next, translate the model again to see what functions cannot be
   differentiated symbolically. Then, implement symbolic derivatives for
   this function.
   See `implementation of function derivatives <https://github.com/lbl-srg/modelica-buildings/wiki/Function-Derivatives>`__.

Functions
~~~~~~~~~

1. Use the ``smoothOrder`` annotation if a function is differentiable.
2. If a function is invertible, also implement its inverse function and
   use the ``inverse`` annotation. See
   ``Buildings.Fluid.BaseClasses.FlowModels`` for an example.
3. If a model allows a linearized implementation of an equation, then
   implement the linearized equation in an ``equation`` section and not
   in the ``algorithm`` section of a ``function``. Otherwise, a symbolic
   processor cannot invert the linear equation, which can lead to
   coupled systems of equations. See
   ``Buildings.Fluid.BaseClasses.FlowModels`` for an example.

Package order
~~~~~~~~~~~~~

1. Packages are first sorted alphabetically by the function
   ``_sort_package_order``. That function is part of BuildingsPy
   and can be invoked as

   .. code-block:: python

      import buildingspy.development.refactor as r
      r.write_package_order(".", True)

2. After alphabetical sorting, the following packages, if they exist,
   are moved to the front:

   .. code-block:: modelica

      Tutorial
      UsersGuide

   and the following packages, if they exist, are moved to the end:

   .. code-block:: modelica

      Data
      Types
      Examples
      Validation
      Benchmarks
      Experimental
      Interfaces
      BaseClasses
      Internal
      Obsolete

   The remaining classes are ordered as follows and inserted between the above list:
   First, models, blocks and records are listed, then functions, and then packages.

Documentation
~~~~~~~~~~~~~

1.  Add a description string to all parameters and variables, including
    protected ones.
2.  Group similar variables using the ``group`` and ``tab`` annotation.
    For example, use

    .. code-block:: modelica

       parameter Modelica.Units.SI.Time tau = 60
         "Time constant at nominal flow"
         annotation (Dialog(group="Nominal condition"));

    or use

    .. code-block:: modelica

       parameter Types.Dynamics substanceDynamics=energyDynamics
         "Formulation of substance balance"
         annotation(Evaluate=true, Dialog(tab = "Assumptions", group="Dynamics"));

3.  Add model documentation to the ``info`` section. This applies to validation tests as well. To document
    equations, use the format

    .. code-block:: html

       <p>
       The polynomial has the form
       </p>
       <p align="center" style="font-style:italic;">
       y = a<sub>1</sub> + a<sub>2</sub> x + a<sub>3</sub> x<sup>2</sup> + ...,
       </p>
       <p>
       where <i>a<sub>1</sub></i> is ...

    To denote time derivatives, such as for mass flow rate,
    use ``<code>m&#775;</code>``.

    To refer to parameters of the model, use the ``<code>...</code>`` section as in

    .. code-block:: html

       To linearize the equation, set <code>linearize=true</code>.

    To format tables, use

    .. code-block:: html

       <p>
       <table summary="summary" border="1" cellspacing="0" cellpadding="2" style="border-collapse:collapse;">
       <tr><th>Header 1</th>       <th>Header 2</th>     </tr>
       <tr><td>Data 1</td>         <td>Data 2</td>       </tr>
       </table>
       </p>

    To include figures, place the figure into a directory in
    ``Buildings/Resources/Images/`` that has the same name as the full
    package. For example, use

    .. code:: html

       </p>
       <p align="center">
       <img alt="Image of ..."
       src="modelica://Buildings/Resources/Images/Fluid/FixedResistances/FixedResistanceDpM.png"/>
       </p>
       <p>


    To create new figures, put the source file for the figure,
    preferably in ``svg`` format, in the same directory as the ``png``
    file. ``svg`` files can be created with https://inkscape.org/, which
    works on any operating system. See for example the file in
    ``Resources/Images/Examples/Tutorial/SpaceCooling/schematics.svg``.
4.  Add author information to the ``revision`` section.
5.  Run a spell check.
6.  Start headings with ``<h4>``.
7.  Add hyperlinks to other models using their full name. For example,
    use

    .. code-block:: html

       See
       <a href="modelica://Buildings.Fluid.Sensors.Density">
       Buildings.Fluid.Sensors.Density</a>.

8.  Add a default component name, such as

    .. code-block:: modelica

       annotation(defaultComponentName="senDen", ...

    to objects that will be used as drag and drop elements, as this
    automatically assigns them this name.
9.  Keep the line length to no more than around 80 characters.
10. For complex packages, provide a User's Guide, and reference the
    User's Guide in ``Buildings.UsersGuide``.
11. Use the string ``fixme`` within development branches to mark passages
    that still need to be revised (e.g., to improve code or to fix bugs).
    Before merging a branch into the master, all ``fixme`` strings must
    be removed. Within the master branch, no ``fixme`` are allowed.
12. A suggested template for the documentation of classes is below.
    Except for the short introduction, the sections are optional.

    .. code-block:: html

       <p>
       A short introduction.
       </p>
       <h4>Main equations</h4>
       <p>
       xxx
       </p>
       <h4>Assumption and limitations</h4>
       <p>
       xxx
       </p>
       <h4>Typical use and important parameters</h4>
       <p>
       xxx
       </p>
       <h4>Options</h4>
       <p>
       xxx
       </p>
       <h4>Dynamics</h4>
       <p>
       Describe which states and dynamics are present in the model
       and which parameters may be used to influence them.
       This need not be added in partial classes.
       </p>
       <h4>Validation</h4>
       <p>
       Describe whether the validation was done using
       analytical validation, comparative model validation
       or empirical validation.
       </p>
       <h4>Implementation</h4>
       <p>
       xxx
       </p>
       <h4>References</h4>
       <p>
       Add references, if applicable.
       </p>

13. Always use lower case html tags.


Adding a new class
------------------

Adding a new class, such as a model or a function, is usually easiest by extending, or copying and modifying, an existing class.
In many cases, the similar component already exists.
In this situation, it is recommended to copy and modify a similar component.
If both components share a significant amount of similar code, then a base class should be introduced that implements the common code.
See for example `Buildings.Fluid.Sensors.BaseClasses.PartialAbsoluteSensor <https://simulationresearch.lbl.gov/modelica/releases/v8.0.0/help/Buildings_Fluid_Sensors_BaseClasses.html#Buildings.Fluid.Sensors.BaseClasses.PartialAbsoluteSensor>`_ which is shared by all sensors with one fluid port in the package
`Buildings.Fluid.Sensors <https://simulationresearch.lbl.gov/modelica/releases/v8.0.0/help/Buildings_Fluid_Sensors.html#Buildings.Fluid.Sensors>`_.

The next sections give guidance that is specific to the implementation of thermofluid flow devices, pressure drop models and control sequences.

Thermofluid flow device
~~~~~~~~~~~~~~~~~~~~~~~

To add a component of a thermofluid flow device, the package
`Buildings.Fluid.Interface <https://simulationresearch.lbl.gov/modelica/releases/v8.0.0/help/Buildings_Fluid_Interfaces.html>`_  contains basic classes that can be extended.
See `Buildings.Fluid.Interface.UsersGuide <https://simulationresearch.lbl.gov/modelica/releases/v8.0.0/help/Buildings_Fluid_Interfaces_UsersGuide.html#Buildings.Fluid.Interfaces.UsersGuide>`_ for a description of these classes.
Alternatively, simple models such as the models below may be used as a starting point for implementing new models for thermofluid flow devices:

`Buildings.Fluid.HeatExchangers.HeaterCooler_u <https://simulationresearch.lbl.gov/modelica/releases/v8.0.0/help/Buildings_Fluid_HeatExchangers.html#Buildings.Fluid.HeatExchangers.HeaterCooler_u>`_
  For a device that adds heat to a fluid stream.

`Buildings.Fluid.Humidifiers.Humidifier_u <https://simulationresearch.lbl.gov/modelica/releases/v8.0.0/help/Buildings_Fluid_Humidifiers.html#Buildings.Fluid.Humidifiers.Humidifier_u>`_
  For a device that adds humidity to a fluid stream.

`Buildings.Fluid.Chillers.Carnot_y <https://simulationresearch.lbl.gov/modelica/releases/v8.0.0/help/Buildings_Fluid_Chillers.html#Buildings.Fluid.Chillers.Carnot_y>`_
  For a device that exchanges heat between two fluid streams.

`Buildings.Fluid.MassExchangers.ConstantEffectiveness <https://simulationresearch.lbl.gov/modelica/releases/v8.0.0/help/Buildings_Fluid_MassExchangers.html#Buildings.Fluid.MassExchangers.ConstantEffectiveness>`_
  For a device that exchanges heat and humidity between two fluid streams.

.. _fig_merkel:

.. figure:: img/Merkel.*
   :width: 700px

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
`Buildings.Fluid.BaseClasses.PartialResistance <https://simulationresearch.lbl.gov/modelica/releases/v8.0.0/help/Buildings_Fluid_BaseClasses.html#Buildings.Fluid.BaseClasses.PartialResistance>`_.
Models should allow computing the flow resistance as a quadratic function
with regularization near zero as implemented in
`Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_dp <https://simulationresearch.lbl.gov/modelica/releases/v8.0.0/help/Buildings_Fluid_BaseClasses_FlowModels.html#Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_dp>`_ and in
`Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_m_flow <https://simulationresearch.lbl.gov/modelica/releases/v8.0.0/help/Buildings_Fluid_BaseClasses_FlowModels.html#Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_m_flow>`_.
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

Control sequences using the Control Description Language
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

To implement reusable control sequences, such as done within
the `OpenBuildingControl <https://obc.lbl.gov>`_ project, the
sequences need to comply with the
`specification of the Control Description Language <https://obc.lbl.gov/specification/cdl.html>`_.

The following rules need to be followed, in addition to the guidelines described in :numref:`sec_dev_gui_con`.


#. The naming of parameters, inputs, outputs and instances must follow the naming
   conventions in
   `Buildings.UsersGuide.Conventions <https://simulationresearch.lbl.gov/modelica/releases/v8.0.0/help/Buildings_UsersGuide.html#Buildings.UsersGuide.Conventions>`_.
   Avoid providing duplicate information in the instance name, for example if the block is within the ``Boilers`` package,
   the instance name must not contain ``boi``. Ensure that the instance name is unambiguous when viewed in a top level
   controller block.
   Consider whether the block can be used to control other equipment as well, and if so, make sure the instance name
   is also applicable for these applications.

#. Parameters that can be grouped together, such as parameters relating to temperature setpoints
   or to the configuration of the trim and respond logic, should be grouped together with the
   ``Dialog(group=STRING))`` annotation. See for example
   `G36_PR1.TerminalUnits.Controller <https://github.com/lbl-srg/modelica-buildings/blob/94d5919dbe1b2f2e317e7b69800f3b3ad07be930/Buildings/Controls/OBC/ASHRAE/G36_PR1/TerminalUnits/Controller.mo>`_.
   Do not use ``Dialog(tab=STRING))``, unless the parameter is declared with a default value
   and is of no interest to typical users.

#. In the source code, the instances must be ordered as follows:

     - First, list `Boolean` parameters,, then `Integer` parameters and then `Real` parameters.
     - Next, list inputs, then outputs, followed by blocks.
     - Protected instances are below all the public instances and follow the same instance ordering rules.
     - Within the above order, list scalar values before arrays,
       but prioritize groupings based on model specific similarities.

#. Each block must have a ``defaultComponentName`` annotation and a ``%name`` label placed above the icon.
   See for example the `CDL.Continuous.Constant <https://github.com/lbl-srg/modelica-buildings/blob/64f35506a2b725e071a900a90e3fa3a291a48dca/Buildings/Controls/OBC/CDL/Continuous/Sources/Constant.mo#L21>`_
   block.

#. To aid readability, the formatting of the Modelica source code file must be consistent with other
   implemented blocks, e.g., use two spaces for indentation (no tabulators),
   assign each parameter value on a new line. It is recommended to add an empty line between instances.
   See for example
   `G36_PR1.AHUs.SingleZone.VAV.SetPoints.ExhaustDamper <https://github.com/lbl-srg/modelica-buildings/blob/94d5919dbe1b2f2e317e7b69800f3b3ad07be930/Buildings/Controls/OBC/ASHRAE/G36_PR1/AHUs/SingleZone/VAV/SetPoints/ExhaustDamper.mo>`_.

#. For parameters, where generally valid values can be provided, provide them
   as default values.

#. Add comments to all instances. The comments should be concise. The comments
   should not contain redundant information and must not contain hard coded parameters as those can change.
   If the functionality of an instance is obvious the developer may use
   comments that closely resemble the class names, such as "Logical And".

#. Each block must have an ``info`` section that explains its functionality.
   In this ``info`` section, names of ``parameters``, ``inputs`` and ``outputs``
   need to be referenced using the html ``<code>...</code>`` element.
   In the ``info`` section, units need to be provided in SI units, or in dual units. For SI units,
   use Kelvin for temperature *differences* and degree Celsius for actual temperatures.

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
      :caption: Unit declaration for CDL.
      :name: cod_uni_dec_cdl

      Buildings.Controls.OBC.CDL.Interfaces.RealInput TZon(
        final unit="K",
        displayUnit="degC") "Measured zone air temperature";

      Buildings.Controls.OBC.CDL.Interfaces.RealInput dTSup(
        final unit="K") "Temperature difference supply air minus exhaust air";

      Buildings.Controls.OBC.CDL.Interfaces.RealOutput yDam(
        final min=0,
        final max=1,
        final unit="1") "Exhaust damper position";

   Conversion of these units to non-SI units can be done programmatically by tools that
   process CDL.

#. Units, quantities and value limits must be declared as ``final`` to avoid users to be able to change them, as
   a change in unit may cause the control logic to be incorrect.

#. If the block diagram does not fit into the drawing pane, enlarge the drawing pane rather
   than making the blocks smaller.

#. The size of the icon should be such that it provides a good fit for all the input and output interfaces. The minimum
   recommended icon size is 100 by a 100. If there are many interfaces the icon size should be extended in vertical direction.
   Icons should be symmetrical with reference to the grid origin. E.g, the default specification is

   .. code-block:: modelica

      Icon(
        coordinateSystem(
          preserveAspectRatio=true,
          extent={{-100,-100},{100,100}}))

#. For simple, small controllers, provide a unit test in a ``Validation`` or ``Examples`` package
   that is in the hierarchy one level below the implemented controller.
   See :numref:`sec_val` for unit test implementation.
   Because some control logic errors may only be noticed
   when used in a closed loop test,
   for equipment and system controllers, provide also closed loop examples that test the sequence
   for all modes of operation. If the closed loop examples include HVAC models, put them
   outside of the ``Buildings.Controls.OBC`` package.
   Make sure sequences are tested for all modes of operation, and as applicable, for winter, shoulder
   and summer days.

#. For general rules on validation models see :numref:`sec_val`. If there are multiple instances of
   the validated block, preferably list them together as opposed to far apart in the Modelica file.

#. Run the following command to detect various warnings, such as missing comments:

    .. code-block::

       $ node app.js -f Buildings/Controls/OBC/ASHRAE/PrimarySystem/{path to package} -o json -m cdl


.. _sec_val:

Validation and unit tests
-------------------------

The developer that introduces a new model, block or a function must:

1. Implement at least one example or validation model that serves as a unit test for each model, block and function,
   and run the unit tests.
   Unit tests should cover all branches of ``if-then`` constructs and
   all realistic operating modes of the system represented by the model.

2. In the `info` section of the validation model, describe to others the intent of the unit test.
   For example, an air handler unit controller test could describe
   "This model verifies that as the cooling load of the room increases, the controller
   first increases the mass flow rate setpoint and then reduces the supply temperature setpoint."

The validation models are part of automated unit tests as described at the
`unit tests wiki page <https://github.com/lbl-srg/modelica-buildings/wiki/Unit-Tests>`_.

For simple models, the validation can be against analytic solutions.
This is for example done in
`Buildings.Fluid.FixedResistances.PressureDrop <https://simulationresearch.lbl.gov/modelica/releases/v8.0.0/help/Buildings_Fluid_FixedResistances_Examples.html#Buildings.Fluid.FixedResistances.Examples.PressureDrop>`_
which uses a regression tests that checks the correct relation between mass flow rate and pressure drop.

For complex thermofluid flow devices, a comparative model validation needs to be done, for example
by comparing the result of the Modelica model against the results from EnergyPlus.
An example is
``Buildings.Fluid.HeatExchangers.CoolingTowers.Validation.MerkelEnergyPlus``.
For such validations, the following files also need to be added to the repository:

 - The EnergyPlus input data file. Please make sure it only requires a weather data file that already exists in the Buildings library.
 - A bash script called `run.sh` that

    1. runs the EnergyPlus model on Linux, and
    2. invokes a Python script that converts the EnergyPlus output file (see next item).

   This file will automatically be
   executed as part of the continuous integration testing.
 - A Python script that converts the EnergyPlus output file to the data file that can
   be read by the Modelica data reader.

See for example
`Buildings/Resources/Data/Fluid/HeatExchangers/CoolingTowers/Validation <https://github.com/lbl-srg/modelica-buildings/tree/master/Buildings/Resources/Data/Fluid/HeatExchangers/CoolingTowers/Validation/MerkelEnergyPlus>`_
for an implementation.
