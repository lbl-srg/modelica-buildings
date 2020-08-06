within ;
package Buildings "Library with models for building energy and control systems"
  extends Modelica.Icons.Package;

package UsersGuide "User's Guide"
  extends Modelica.Icons.Information;
  class Conventions "Conventions"
    extends Modelica.Icons.Information;
    annotation (preferredView="info",
    Documentation(info="<html>
<p>
The <code>Buildings</code> library uses the following conventions,
which largely are based on the conventions of the Modelica Standard Library.
</p>

<h4>Package structure</h4>
<p>
Packages have usually the following subpackages:
</p>
<ul>
<li>
<code>UsersGuide</code> containing an overall description of the library
and how to use it.
</li>
<li>
<code>Examples</code> containing models demonstrating the
usage of the library.
</li>
<li>
<code>Validation</code> containing typically small models that validate a certain
behavior of a model.
</li>
<li>
<code>Interfaces</code> containing connectors and partial models.
</li>
<li>
<code>Types</code> containing type, enumeration and choice definitions.
</li>
</ul>


<h4>Naming</h4>
<ol>
<li>
Class names of models, blocks and packages should start with an upper-case letter and be a
noun or a noun with a combination of adjectives and nouns.
Use camel-case notation to combine multiple words, such as <code>HeatTransfer</code>.
Don't repeat higher level package names, for example, rather than <code>Chillers.CarnotChiller</code>,
use <code>Chillers.Carnot</code>.
</li>
<li>
Instance names should be a combination of the first three
characters of a word, such as <code>preDro</code> for pressure drop model.
Where applicable, a single character can be used if this is generally understood, such
as <code>T</code> for temperature, <code>p</code> for pressure, <code>u</code> for control input
and <code>y</code> for control output signal. As needed, these can be augmented, for example
a controller that outputs a control signal for a valve and a damper may output <code>yVal</code>
and <code>yDam</code>.
</li>
<li>
The following variables are frequently used for physical quantities:
<ul>
<li><code>T</code> for temperature,</li>
<li><code>p</code> for pressure,</li>
<li><code>dp</code> for pressure difference,</li>
<li><code>P</code> for power,</li>
<li><code>E</code> for energy (or <code>Q</code> for thermal energy),</li>
<li><code>X</code> for mass fraction,</li>
<li><code>Q_flow</code> for heat flow rate</li>
<li><code>m_flow</code> for mass flow rate and</li>
<li><code>H_flow</code> for enthalpy flow rate.</li>
</ul>
</li>
<li>
The nomenclature used in the package
<a href=\"modelica://Buildings.Utilities.Psychrometrics\">
Buildings.Utilities.Psychrometrics</a>
is as follows,
<ul>
<li>
Uppercase <code>X</code> denotes mass fraction per total mass.
</li>
<li>
Lowercase <code>x</code> denotes mass fraction per mass of dry air.
</li>
<li>
The notation <code>z_xy</code> denotes that the function or block has output
<code>z</code> and inputs <code>x</code> and <code>y</code>.
</li>
<li>
The symbol <code>pW</code> denotes water vapor pressure, <code>TDewPoi</code>
denotes dew point temperature, <code>TWetBul</code> denotes wet bulb temperature,
and <code>TDryBul</code> (or simply <code>T</code>) denotes dry bulb temperature.
</li>
</ul>
</li>
<li>
Control input signals usually start with <code>u</code> and control output signals usually start with <code>y</code>,
unless use of the physical quantity is clearer.
</li>
<li>
The following strings are frequently used:
<ul>
<li>
Prefix <code>use_</code> for conditionally enabled input signals, such as <code>use_T_in</code>
for enabling an input connector for temperature.
See <a href=\"modelica://Buildings.Fluid.Sources.Boundary_pT\">Buildings.Fluid.Sources.Boundary_pT</a>.
</li>
<li>
Prefix <code>have_</code> if a controller has a certain input, such as <code>have_CO2Sen</code>
in <a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36_PR1.TerminalUnits.Controller\">
Buildings.Controls.OBC.ASHRAE.G36_PR1.TerminalUnits.Controller</a> if the zone has a CO<sub>2</sub> sensor.
</li>
<li>
Suffix <code>_flow</code> for a flow variable, such as <code>Q_flow</code> and <code>m_flow</code>.
See <a href=\"Buildings.Fluid.Sensors.VolumeFlowRate\">
Buildings.Fluid.Sensors.VolumeFlowRate</a>.
</li>
<li>
Suffix <code>_nominal</code> for the design or nominal capacity, i.e., <code>Q_flow_nominal</code> is the
capacity of a device that it has at full load, and <code>m_flow_nominal</code> is the design mass flow rate.
See <a href=\"modelica://Buildings.Fluid.HeatExchangers.HeaterCooler_u\">
Buildings.Fluid.HeatExchangers.HeaterCooler_u</a>.
</li>
<li>
Suffix <code>_small</code> for a small value which is typically used for regularization (to ensure
a numerically robust implementation).
</li>
<li>
Suffix <code>Set</code> for set point.
</li>
<li>
Suffix <code>Min</code> (<code>Max</code>) for minimum (maximum),
such as in <code>TSupSetMin</code> for minimum supply temperature set point.
</li>
</ul>
</li>
<li>
The two connectors of a domain that have identical declarations
and different icons are usually distinguished by <code>_a</code>, <code>_b</code>
or <code>_p</code>, <code>_n</code>.
Examples are fluid ports <code>port_a</code> and <code>port_b</code>
or electrical connectors
<code>terminal_p</code> and <code>terminal_n</code>.
</li>
</ol>

<h4>Documentation</h4>
<ol>
<li>
In the html documentation, start additional headings with
<code>h4</code>.
(The headings <code>h1, h2, h3</code> must not be used,
because they are utilized from the automatically generated
documentation.)
</li>
<li>
Comments must be added to each class (package, model, function etc.).
</li>
<li>
The first character should be upper case.
</li>
<li>
For one-line comments of parameters, variables and classes, no period should be used at the end of the comment.
</li>
</ol>

<h4>Graphical display</h4>
<ol>
<li>
The instance name of a component is always displayed in its icon
(using the text string \"%name\") in blue color.
</li>
<li>
A connector class has the instance
name definition in the diagram layer and usually not in the icon layer, unless this helps with usability.
</li>
<li>
The value of main parameters, such as nominal capacity, are displayed
in the icon in black color in a smaller font size as the instance name
if this helps with usability.
</li>
</ol>

<h4>Miscellaneous</h4>
<ol>
<li>
Where applicable, all variable must have units, also if the variable is protected.
</li>
<li>
Each class (i.e., model, block and function) must be used in an example or validation case.
</li>
</ol>
</html>"));
  end Conventions;

  package ReleaseNotes "Release notes"
    extends Modelica.Icons.ReleaseNotes;

    class Version_8_0_0 "Version 8.0.0"
      extends Modelica.Icons.ReleaseNotes;
        annotation (Documentation(info="<html>
<div class=\"release-summary\">
<p>
Version 8.0.0 is ... xxx
</p>
</div>
<!-- New libraries -->
<p>
The following <b style=\"color:blue\">new libraries</b> have been added:
</p>
<table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=0 cellpadding=2>
<tr><td valign=\"top\">xxx
    </td>
    <td valign=\"top\">xxx.
    </td>
    </tr>
</table>
<!-- New components for existing libraries -->
<p>
The following <b style=\"color:blue\">new components</b> have been added
to <b style=\"color:blue\">existing</b> libraries:
</p>
<table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=0 cellpadding=2 style=\"border-collapse:collapse;\">
<tr><td colspan=\"2\"><b>Buildings.Controls.OBC</b>
    </td>
</tr>                   
<tr><td valign=\"top\">Buildings.Controls.OBC.ASHRAE.G36_PR1.Generic.SetPoints.GroupStatus
    </td>
    <td valign=\"top\">Find minimum and maximum values regarding the status of zones in one group. This is needed
                       for specifying the group operating mode according to ASHRAE Guideline 36, May 2020 version.<br/>
                       This is for
                       <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1893\">issue 1893</a>.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.VAV.SetPoints.ModeAndSetPoints
    </td>
    <td valign=\"top\">Moved from Buildings.Controls.OBC.ASHRAE.G36_PR1.TerminalUnits.ModeAndSetPoints,
                       reimplemented to use the operating mode specified according to ASHRAE G36 official release and changed
                       the heating and cooling demand limit level to be inputs.<br/>
                       This is for
                       <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1893\">issue 1893</a>.
    </td>
</tr>
</table>
<!-- Backward compatible changes -->
<p>
The following <b style=\"color:blue\">existing components</b>
have been <b style=\"color:blue\">improved</b> in a
<b style=\"color:blue\">backward compatible</b> way:
</p>
<table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=0 cellpadding=2 style=\"border-collapse:collapse;\">
<tr><td colspan=\"2\"><b>Buildings.Air</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Air.Systems.SingleZone.VAV.Examples.Guideline36
    </td>
    <td valign=\"top\">Updated AHU controller which applies the sequence of specifying operating mode
                       according to G36 official release.<br/>
                       This is for
                       <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1893\">issue 1893</a>.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Fluid.HeatExchangers.RadiantSlabs</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.HeatExchangers.RadiantSlabs.BaseClasses.Functions.AverageResistance
    </td>
    <td valign=\"top\">Corrected inequality test on <code>alpha</code>,
                       and changed print statement to an assertion with assertion level set to warning.<br/>
                       This is for
                       <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2009\">issue 2009</a>.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Examples</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Examples.VAVReheat.Guideline36
    </td>
    <td valign=\"top\">Upgraded sequence of specifying operating mode according to G36 official release.<br/>
                       This is for
                       <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1893\">issue 1893</a>.
    </td>
</tr>
<tr><td colspan=\"2\"><b>xxx</b>
    </td>
</tr>
<tr><td valign=\"top\">xxx
    </td>
    <td valign=\"top\">xxx.
    </td>
</tr>
</table>
<!-- Non-backward compatible changes to existing components -->
<p>
The following <b style=\"color:blue\">existing components</b>
have been <b style=\"color:blue\">improved</b> in a
<b style=\"color:blue\">non-backward compatible</b> way:
</p>
<table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=0 cellpadding=2 style=\"border-collapse:collapse;\">
<tr><td colspan=\"2\"><b>Buildings.Controls.Continuous</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Controls.Continuous.LimPID<br/>
                       Buildings.Controls.Continuous.PIDHysteresis<br/>
                       Buildings.Controls.Continuous.PIDHysteresisTimer<br/>
                       Buildings.Controls.OBC.CDL.Continuous.LimPID
    </td>
    <td valign=\"top\">Corrected wrong convention of reverse and direct action.
                       The previous parameter <code>reverseAction</code> with a default of <code>false</code>
                       has been removed, and
                       a new parameter <code>reverseActing</code> with a default of <code>true</code>
                       has been added. This was done because the previous implementation wrongly interpreted reverse action
                       as the control output changing in reverse to the change in control error, but the
                       industry convention is that reverse action means that the control output
                       changes in reverse to the measurement signal.<br/>
                       This is for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1365\">IBPSA, #1365</a>.<br/>
                       For Dymola, a conversion script makes this change.</td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Controls.OBC</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.VAV.Controller
    </td>
    <td valign=\"top\">Updated the block of specifying operating mode and setpoints.<br/>
                       This is for
                       <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1893\">issue 1893</a>.
    </td>
</tr>                
<tr><td valign=\"top\">Buildings.Controls.OBC.ASHRAE.G36_PR1.Generic.SetPoints.OperationMode
    </td>
    <td valign=\"top\">Upgraded the sequence according to ASHRAE Guideline 36, May 2020 version.<br/>
                       This is for
                       <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1893\">issue 1893</a>.
    </td>
</tr>
</table>
<!-- Errors that have been fixed -->
<p>
The following <b style=\"color:red\">critical errors</b> have been fixed (i.e., errors
that can lead to wrong simulation results):
</p>
<table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=0 cellpadding=2 style=\"border-collapse:collapse;\">
<tr><td colspan=\"2\"><b>xxx</b>
    </td>
</tr>
<tr><td valign=\"top\">xxx
    </td>
    <td valign=\"top\">xxx.
    </td>
</tr>
</table>
<!-- Uncritical errors -->
<p>
The following <b style=\"color:red\">uncritical errors</b> have been fixed (i.e., errors
that do <b style=\"color:red\">not</b> lead to wrong simulation results, e.g.,
units are wrong or errors in documentation):
</p>
<table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=0 cellpadding=2 style=\"border-collapse:collapse;\">
<tr><td colspan=\"2\"><b>xxx</b>
    </td>
</tr>
<tr><td valign=\"top\">xxx
    </td>
    <td valign=\"top\">xxx.
    </td>
</tr>
</table>
<p>
Note:
</p>
<ul>
<li>
xxx
</li>
</ul>
</html>"));
    end Version_8_0_0;

    class Version_7_0_0 "Version 7.0.0"
      extends Modelica.Icons.ReleaseNotes;
        annotation (Documentation(info="<html>
    <div class=\"release-summary\">
    <p>
    Version 7.0.0 is a major release that
    contains various new packages, new models and improvements to existing models.
    The library has been tested with
    Dymola 2020x and 2021,
    JModelica (revision 14023), and
    OPTIMICA (revision OCT-stable-r12473_JM-r14295).
    </p>
    <p>
      The following major changes have been done:
    <ul>
    <li>
      New packages have been added to model building controls (<code>Buildings.Controls.OBC.Utilities</code>)
      and to support the creation of emulators that compare the performance of building control sequences in
      the Building Optimization Performance Tests framework
      <a href=\"https://github.com/ibpsa/project1-boptest\">BOPTEST</a>.
    </li>
    <li>
      Various new control blocks have been added to <code>Buildings.Controls.OBC.CDL</code>.
    </li>
    <li>
      Various new equipment models have been added, such as models of absorption chillers, CHP equipment and heat pumps.
    </li>
    <li>
      The reduced order building models now also allow modeling air moisture and air contaminant balance.
    </li>
    <li>
      A tutorial has been added to explain how to implement control sequences using the Control Description Language
      that is being developed in the <a href=\"https://obc.lbl.gov\">OpenBuildingControl</a> project.
    </li>
    <li>
      The icons of many components have been updated so that they visualize temperatures, flow rates
      or control signals while the simulation is running.
    </li>
    <li>
      Results of the ANSI/ASHRAE Standard 14 validation (BESTEST) are now integrated in the user's guide
      <code>Buildings.ThermalZones.Detailed.Validation.BESTEST.UsersGuide</code>.
    </li>
    </ul>
    </div>
    <!-- New libraries -->
    <p>
    The following <b style=\"color:blue\">new libraries</b> have been added:
    </p>
    <table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=0 cellpadding=2>
    <tr><td valign=\"top\">Buildings.Controls.OBC.Utilities
        </td>
        <td valign=\"top\">Package with utility blocks, base classes and validation
                           models for the OpenBuildingControl (OBC) library.
        </td>
        </tr>
    <tr><td valign=\"top\">Buildings.Utilities.IO.SignalExchange
        </td>
        <td valign=\"top\">Package with blocks that can be used
                           to identify and activate control signal overwrites, and
                           to identify and read sensor signals. This package is used
                           by the Building Optimization Performance Test software
                           <a href=\"https://github.com/ibpsa/project1-boptest\">BOPTEST</a>.
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Utilities.IO.Python36
        </td>
        <td valign=\"top\">Upgraded from <code>Buildings.Utilities.IO.Python27</code>
                           since Python2.7 has been deprecated.<br/>
                           This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1760\">issue #1760</a>.
        </td>
    </tr>
    </table>
    <!-- New components for existing libraries -->
    <p>
    The following <b style=\"color:blue\">new components</b> have been added
    to <b style=\"color:blue\">existing</b> libraries:
    </p>
    <table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=0 cellpadding=2 style=\"border-collapse:collapse;\">
    <tr><td colspan=\"2\"><b>Buildings.Controls</b>
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.SetPoints.OutdoorAirFlow
        </td>
        <td valign=\"top\">Package of sequences for specifying the minimum outdoor airflow rate.
                           This replaces <code>Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.SetPoints.OutsideAirFlow</code>.
                           The new implemented sequences separate zone level calculation from the system level calculation.
                           It avoids vector-valued calculations.<br/>
                           This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1829\">#1829</a>.
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Controls.OBC.ASHRAE.G36_PR1.Generic.SetPoints.ZoneStatus
        </td>
        <td valign=\"top\">Block that outputs zone temperature status by comparing it with setpoint temperatures, with the maximum and
                           minimum temperature of the group which the zone is in. This allows separating the vector-valued calculations
                           from control sequences.<br/>
                           This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1709\">#1709</a>.
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Controls.OBC.CDL.Discrete.TriggeredMovingMean
        </td>
        <td valign=\"top\">Block that outputs the triggered discrete moving mean of an input signal.
                           This replaces <code>Buildings.Controls.OBC.CDL.Discrete.MovingMean</code>, which
                           has been moved to <code>Buildings.Obsolete</code>.<br/>
                           This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1588\">#1588</a>.
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Controls.OBC.Utilities.OptimalStart
        </td>
        <td valign=\"top\">Block that outputs optimal start time for an HVAC system prior to the occupancy.
                           This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1589\">#1589</a>.
        </td>
        </tr>
    <tr><td colspan=\"2\"><b>Buildings.Fluid</b>
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Fluid.Actuators.Valves.ThreeWayTable
        </td>
        <td valign=\"top\">Three way valves with opening characteristics based on a user-provided table.
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Fluid.CHPs
        </td>
        <td valign=\"top\">Package with model for combined heat and power device.
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Fluid.Chillers.AbsorptionIndirectSteam
        </td>
        <td valign=\"top\">Indirect steam heated absorption chiller based on performance curves.
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Fluid.FixedResistances.CheckValve
        </td>
        <td valign=\"top\">Check valve that prevents backflow, except for a small leakage flow rate.<br/>
                           This is for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1198\">IBPSA, #1198</a>
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Fluid.HeatPumps.EquationFitReversible
        </td>
        <td valign=\"top\">Heat pump model that can be reversed between heating and cooling mode,
                           that takes as a set point the leaving fluid temperature, and that computes
                           its performance based on an equation fit.
        </td>
    </tr>
    <tr><td colspan=\"2\"><b>Buildings.Examples.Tutorial</b>
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Examples.Tutorial.CDL
        </td>
        <td valign=\"top\">Tutorial that explains how to implement control sequences using
                           the <a href=\"https://obc.lbl.gov\">Control Description Language</a>.
        </td>
    </tr>
    </table>
    <!-- Backward compatible changes -->
    <p>
    The following <b style=\"color:blue\">existing components</b>
    have been <b style=\"color:blue\">improved</b> in a
    <b style=\"color:blue\">backward compatible</b> way:
    </p>
    <table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=0 cellpadding=2 style=\"border-collapse:collapse;\">
    <tr><td colspan=\"2\"><b>Buildings.BoundaryConditions.WeatherData</b>
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.BoundaryConditions.WeatherData.ReaderTMY3
        </td>
        <td valign=\"top\">Refactored weather data reader and changed implementation to allow exactly zero radiation rather
                           than a small positive value.
                           This was required to allow simulating buildings at steady-state, which is needed
                           for some controls design.
                           For examples in which buildings are simulated at steady-state, see
                           <code>Buildings.ThermalZones.Detailed.Validation.MixedAirFreeResponseSteadyState</code>,
                           <code>Buildings.Examples.VAVReheat.Validation.Guideline36SteadyState</code> and
                           <code>Buildings.ThermalZones.ReducedOrder.Validation.RoomSteadyState</code>.<br/>
                         This is for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1340\">IBPSA, #1340</a>.
        </td>
    </tr>
    <tr><td colspan=\"2\"><b>Buildings.Controls.Continuous</b>
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Controls.Continuous.LimPID
        </td>
        <td valign=\"top\">Removed homotopy that may be used during initialization to ensure that outputs are bounded.<br/>
                         This is for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1221\">IBPSA, #1221</a>.
        </td>
    </tr>
    <tr><td colspan=\"2\"><b>Buildings.Controls.OBC.CDL</b>
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Controls.OBC.CDL.Continuous.Derivative
        </td>
        <td valign=\"top\">Removed parameter <code>initType</code> and <code>x_start</code>.<br/>
                           This is for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1887\">IBPSA, #1887</a>.<br/>
                           For Dymola, a conversion script makes this change.
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Controls.OBC.CDL.Continuous.IntegratorWithReset
        </td>
        <td valign=\"top\">Removed parameter <code>initType</code>.<br/>
                           This is for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1887\">IBPSA, #1887</a>.<br/>
                           For Dymola, a conversion script makes this change.
        </td>
    </tr>

    <tr><td valign=\"top\">Buildings.Controls.OBC.CDL.Continuous.LimPID
        </td>
        <td valign=\"top\">Removed homotopy that may be used during initialization to ensure that outputs are bounded.<br/>
                           This is for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1221\">IBPSA, #1221</a>.
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Controls.OBC.CDL.Continuous.Sources.CalendarTime<br/>
                           Buildings.Controls.OBC.CDL.Types.ZeroTime
        </td>
        <td valign=\"top\">Revised implementation such that the meaning of <code>time</code> is better explained
                           and unix time stamps are correctly defined with respect to GMT.
                           Added option unix time stamp GMT.<br/>
                           This is for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1232\">IBPSA, #1232</a>.
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Controls.OBC.CDL.Continuous.Sources.CalendarTime<br/>
                           Buildings.Controls.OBC.CDL.Types.ZeroTime
        </td>
        <td valign=\"top\">Revised implementation such that the meaning of <code>time</code> is better explained
                           and unix time stamps are correctly defined with respect to GMT.
                           Added option unix time stamp GMT.<br/>
                           This is for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1232\">IBPSA, #1232</a>.
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Controls.OBC.CDL.Logical.Latch<br/>
                         Buildings.Controls.OBC.CDL.Logical.Toggle
        </td>
        <td valign=\"top\">Simplified implementation, which makes them work with OpenModelica.<br/>
                         This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1823\">#1823</a>.
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Controls.OBC.CDL.Logical.Timer
        </td>
        <td valign=\"top\">Added a boolean input to reset the accumulated timer.<br/>
                           This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1221\">#1221</a>.
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Controls.OBC.CDL.Types.Init
        </td>
        <td valign=\"top\">Removed this enumeration because it is no longer used.<br/>
                           This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1887\">#1887</a>.
        </td>
    </tr>
    <tr><td colspan=\"2\"><b>Buildings.Controls.OBC.ASHRAE.G36_PR1 </b>
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Controls.OBC.ASHRAE.G36_PR1.Generic.SetPoints.TrimAndRespond
        </td>
        <td valign=\"top\">Corrected to delay the true initial device status.<br/>
                           This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1876\">#1876</a>
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Controls.OBC.ASHRAE.G36_PR1.TerminalUnits.Reheat.DamperValves
        </td>
        <td valign=\"top\">Replaced multisum block with add blocks, replaced gain block used for normalization
                           with division block.<br/>
                           This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1830\">#1830</a>
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.VAV.Controller
        </td>
        <td valign=\"top\">Replaced the mode and setpoint calculation block with
                           <a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36_PR1.TerminalUnits.ModeAndSetPoints\">
                           Buildings.Controls.OBC.ASHRAE.G36_PR1.TerminalUnits.ModeAndSetPoints</a>.<br/>
                           This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1709\">#1709</a>
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Controls.OBC.ASHRAE.G36_PR1.TerminalUnits.Reheat.SetPoints.ActiveAirFlow
        </td>
        <td valign=\"top\">Used hysteresis to check occupancy.<br/>
                           This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1788\">#1788</a>.
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.SetPoints.OutsideAirFlow
        </td>
        <td valign=\"top\">Applied hysteresis for checking ventilation efficiency.<br/>
                           This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1787\">#1787</a>.
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Controls.OBC.ASHRAE.G36_PR1.Generic.SetPoints.TrimAndRespond
        </td>
        <td valign=\"top\">Added assertions and corrected implementation when respond amount is negative.<br/>
                           This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1530\">#1503</a>.
        </td>
    </tr>
    <tr><td colspan=\"2\"><b>Buildings.Examples.Tutorial</b>
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Examples.Tutorial.Boiler<br/>
                           Buildings.Examples.Tutorial.SpaceCooling
        </td>
        <td valign=\"top\">Updated examples to use the control blocks from the Control Description Language package
                           <code>Buildings.Controls.OBC.CDL</code>.
        </td>
    </tr>
    <tr><td colspan=\"2\"><b>Buildings.Examples.VAVReheat</b>
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Examples.VAVReheat.ThermalZones.VAVBranch
        </td>
        <td valign=\"top\">Added output connector for returned damper position.
        </td>
    </tr>
    <tr><td colspan=\"2\"><b>Buildings.Fluid</b>
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Fluid.Actuators.BaseClasses.ActuatorSignal<br/>
                           Buildings.Fluid.Actuators.Dampers.PressureIndependent
        </td>
        <td valign=\"top\">Added the computation of the damper opening.
        </td>
    </tr>
    <tr><td valign=\"top\">
                           Buildings.Fluid.Actuators.BaseClasses.PartialTwoWayValve<br/>
                           Buildings.Fluid.Actuators.Valves.TwoWayEqualPercentage<br/>
                           Buildings.Fluid.Actuators.Valves.TwoWayLinear<br/>
                           Buildings.Fluid.Actuators.Valves.TwoWayPolynomial<br/>
                           Buildings.Fluid.Actuators.Valves.TwoWayPressureIndependent<br/>
                           Buildings.Fluid.Actuators.Valves.TwoWayQuickOpening<br/>
                           Buildings.Fluid.Actuators.Valves.TwoWayTable
        </td>
        <td valign=\"top\">Improved implementation to guard against control input that is negative.
                           The new implementation constrains the input to be bigger than <i>0</i>.<br/>
                           This is for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1233\">IBPSA, #1233</a>.
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Fluid.Geothermal.Borefields.BaseClasses.HeatTransfer.ThermalResponseFactors.shaGFunction
        </td>
        <td valign=\"top\">Declared string as a constant due to JModelica's tigther type checking.<br/>
                           This is for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1230\">IBPSA, #1230</a>.
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Fluid.HeatExchangers.DXCoils.AirCooled.MultiStage<br/>
                           Buildings.Fluid.HeatExchangers.DXCoils.AirCooled.SingleSpeed<br/>
                           Buildings.Fluid.HeatExchangers.DXCoils.AirCooled.VariableSpeed<br/>
                           Buildings.Fluid.HeatExchangers.DXCoils.WaterCooled.MultiStage<br/>
                           Buildings.Fluid.HeatExchangers.DXCoils.WaterCooled.SingleSpeed<br/>
                           Buildings.Fluid.HeatExchangers.DXCoils.WaterCooled.VariableSpeed
        </td>
        <td valign=\"top\">Corrected wrong <code>min</code> and <code>max</code> attribute for change in humidity.<br/>
                           This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1933\">#1933</a>.
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Fluid.Storage.Stratified<br/>
                           Buildings.Fluid.Storage.StratifiedEnhanced<br/>
                           Buildings.Fluid.Storage.StratifiedEnhancedInternalHex
        </td>
        <td valign=\"top\">Provided option to initialize the tank temperature at different values across the height of the tank.<br/>
        This is for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1246\">IBPSA, #1246</a>.
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Fluid.SolarCollectors.BaseClasses.PartialSolarCollector
        </td>
        <td valign=\"top\">In volume, set <code>prescribedHeatFlowRate=false</code>.<br/>
                           This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1636\">#1636</a>.
        </td>
    </tr>
    <tr><td colspan=\"2\"><b>Buildings.HeatTransfer</b>
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.HeatTransfer.Convection.Exterior
        </td>
        <td valign=\"top\">Set wind direction modifier to a constant as wind speed approaches zero.<br/>
                           This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1923\">#1923</a>.
        </td>
    </tr>
    <tr><td colspan=\"2\"><b>Buildings.ThermalZones.Detailed.Validation.BESTEST.Cases6xx</b>
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.ThermalZones.Detailed.Validation.BESTEST.Cases6xx.Case600<br/>
                           Buildings.ThermalZones.Detailed.Validation.BESTEST.Cases6xx.Case600FF
        </td>
        <td valign=\"top\">Changed computation of time averaged values to avoid a time event every hour.<br/>
                           This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1714\">#1714</a>.
        </td>
    </tr>
    <tr><td colspan=\"2\"><b>Buildings.ThermalZones.ReducedOrder</b>
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.ThermalZones.ReducedOrder.RC.OneElement<br/>
                           Buildings.ThermalZones.ReducedOrder.RC.TwoElements<br/>
                           Buildings.ThermalZones.ReducedOrder.RC.ThreeElements<br/>
                           Buildings.ThermalZones.ReducedOrder.RC.FourElements
        </td>
        <td valign=\"top\">Added option to also simulate moisture balance in room air volume.
                           This can be enabled by setting the parameter <code>use_moisture_balance = true</code>.<br/>
                           This is for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1209\">IBPSA, #1209</a>.
        </td>
    </tr>
    <tr><td colspan=\"2\"><b>Buildings.Utilities</b>
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Utilities.IO.Files.CSVWriter<br/>
                           Buildings.Utilities.IO.Files.CombiTimeTableWriter<br/>
                           Buildings.Utilities.IO.Files.CombiTimeTableWriter
        </td>
        <td valign=\"top\">Revised to avoid overflow of string buffer in Dymola.<br/>
                           This is for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1219\">IBPSA, #1219</a>.
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Utilities.Math.SmoothHeaviside<br/>
                           Buildings.Utilities.Math.Functions.SmoothHeaviside
        </td>
        <td valign=\"top\">This function is now twice instead of only once Lipschitz continuously differentiable.<br/>
                           This is for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1202\">IBPSA, #1202</a>.
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Utilities.Time.CalendarTime<br/>
                           Buildings.Utilities.Time.Types.ZeroTime
        </td>
        <td valign=\"top\">Revised implementation such that the meaning of <code>time</code> is better explained
                           and unix time stamps are correctly defined with respect to GMT.
                           Added option unix time stamp GMT.<br/>
                           This is for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1192\">IBPSA, #1192</a>.
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Utilities.Comfort.Fanger
        </td>
        <td valign=\"top\">Updated the model from ASHRAE 1997 to ANSI/ASHRAE 55-2017
                           and added a validation model which compares the PMV
                           with an implementation from the University of California at Berkeley.<br/>
                           This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1936\">#1936</a>.
        </td>
    </tr>
    <tr><td colspan=\"2\"><b>Buildings.Examples</b>
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Examples.VAVReheat.ThermalZones.Floor<br/>
                           Buildings.Examples.VAVReheat.ASHRAE2006<br/>
                           Buildings.Examples.VAVReheat.Guideline36<br/>
                           Buildings.Examples.DualFanDualDuct

        </td>
        <td valign=\"top\">Updated core zone geometry parameters related to room heat and mass balance.
                           This change was done in
                           <code>Buildings.Examples.VAVReheat.ThermalZones.Floor</code>.<br/>
                           This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1719\">#1719</a>.
       </td>
    </tr>
    </table>
    <!-- Non-backward compatible changes to existing components -->
    <p>
    The following <b style=\"color:blue\">existing components</b>
    have been <b style=\"color:blue\">improved</b> in a
    <b style=\"color:blue\">non-backward compatible</b> way:
    </p>
    <table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=0 cellpadding=2 style=\"border-collapse:collapse;\">
    <tr><td colspan=\"2\"><b>Buildings.Airflow</b>
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Airflow.Multizone
        </td>
        <td valign=\"top\">Set parameters <code>m_flow_small</code>, <code>m1_flow_small</code>
                           and <code>m2_flow_small</code> to <code>final</code> so that they do
                           no longer appear on the GUI. These parameters are not used by models
                           in this package.
                           This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1362\">IBPSA, #1362</a>.<br/>
                           For Dymola, a conversion script makes this change.
        </td>
    </tr>
    <tr><td colspan=\"2\"><b>Buildings.Controls.OBC.CDL</b>
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Controls.OBC.CDL.Continuous.LimPID
        </td>
        <td valign=\"top\">Refactored model so that it is itself a CDL conformant composite block.
                           This refactoring removes the no longer use parameters <code>xd_start</code> that was
                           used to initialize the state of the derivative term. This state is now initialized
                           based on the requested initial output <code>yd_start</code> which is a new parameter
                           with a default of <code>0</code>.
                           Also, removed the parameters <code>y_start</code> and <code>initType</code> because
                           the initial output of the controller can be set by using <code>xi_start</code>
                           and <code>yd_start</code>.
                           This refactoring also removes the parameter <code>strict</code> that
                           was used in the output limiter. The new implementation enforces a strict check by default.<br/>
                           This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1878\">#1878</a>.<br/>
                           For Dymola, a conversion script makes this change.
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Controls.OBC.CDL.Continuous.LimPID
        </td>
        <td valign=\"top\">Changed the default values for the output limiter from <code>yMin=-yMax</code> to <code>yMin=0</code>
                           and from <code>yMax</code> being unspecified to <code>yMax=1</code>.<br/>
                           This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1888\">#1888</a>.<br/>
                           For Dymola, a conversion script makes this change.
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Controls.OBC.CDL.Discrete.MovingMean
        </td>
        <td valign=\"top\">This block became obsolete, use <code>Buildings.Controls.OBC.CDL.Discrete.TriggeredMovingMean</code> instead.<br/>
                           For Dymola, a conversion script makes this change.
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Controls.OBC.CDL.SetPoints.SupplyReturnTemperatureReset
        </td>
        <td valign=\"top\">Changed name from <code>HotWaterTemperatureReset</code> to <code>SupplyReturnTemperatureReset</code>.<br/>
                           This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/860\">#860</a>.<br/>
                           For Dymola, a conversion script makes this change.
        </td>
    </tr>
    <tr><td colspan=\"2\"><b>Buildings.Controls.OBC.ASHRAE.G36_PR1</b>
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.Controller
        </td>
        <td valign=\"top\">Reimplemented to add new block for specifying the minimum outdoor airfow setpoint.
                           The new block avoids vector-valued calculations.<br/>
                           The reimplemented controller needs to work with
                           <a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.SetPoints.OutdoorAirFlow.Zone\">
                           Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.SetPoints.OutdoorAirFlow.Zone</a> and
                           <a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.SetPoints.OutdoorAirFlow.SumZone\">
                           Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.SetPoints.OutdoorAirFlow.SumZone</a>,
                           to calculate the zone level minimum outdoor airflow setpoints and then find the sum, the minimum and
                           the maximum of these setpoints. See
                           <a href=\"modelica://Buildings.Examples.VAVReheat.Guideline36\">Buildings.Examples.VAVReheat.Guideline36</a>.
                           <br/>
                           This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1829\">#1829</a>.
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Controls.OBC.ASHRAE.G36_PR1.Generic.SetPoints.OperationMode
        </td>
        <td valign=\"top\">Reimplemented to remove the vector-valued calculations.<br/>
                           This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1709\">#1709</a>
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.VAV.ModeAndSetPoints
        </td>
        <td valign=\"top\">Removed from the library as it can be replaced by
                           <a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36_PR1.TerminalUnits.ModeAndSetPoints\">
                           Buildings.Controls.OBC.ASHRAE.G36_PR1.TerminalUnits.ModeAndSetPoints</a>.<br/>
                           This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1709\">#1709</a>
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.VAV.Controller
        </td>
        <td valign=\"top\">Added cooling coil control and the controller validation model.<br/>
                           This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1265\">#1265</a>
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.VAV.Economizers.Subsequences.Enable
        </td>
        <td valign=\"top\">Added the option to allow fixed plus differential dry bulb temperature cutoff.
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.VAV.Economizers.Subsequences.Modulation
        </td>
        <td valign=\"top\">Added heating coil control sequences.
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.VAV.SetPoints.Supply
        </td>
        <td valign=\"top\">Added a switch for fan control.
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.VAV.ZoneState
        </td>
        <td valign=\"top\">Improved the implementation to avoid issues when heating and cooling controls occur at the same time.
    </tr>
    <tr><td valign=\"top\">Buildings.Controls.OBC.ASHRAE.G36_PR1.TerminalUnits.Reheat.SystemRequests
        </td>
        <td valign=\"top\">Changed the actual damper position name from <code>uDam</code> to <code>yDam_actual</code>.<br/>
                         This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1873\">#1873</a>
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Controls.OBC.ASHRAE.G36_PR1.TerminalUnits.Controller
        </td>
        <td valign=\"top\">Added actual VAV damper position as the input for generating system request.<br/>
                         This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1873\">#1873</a>
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Controls.OBC.ASHRAE.G36_PR1.TerminalUnits.Reheat.DamperValves
        </td>
        <td valign=\"top\">Added option to check if the VAV damper is pressure independent.<br/>
                           This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1873\">#1873</a>
    </tr>
    <tr><td colspan=\"2\"><b>Buildings.Controls.SetPoints</b>
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Controls.SetPoints.SupplyReturnTemperatureReset
        </td>
        <td valign=\"top\">Changed name from <code>HotWaterTemperatureReset</code> to <code>SupplyReturnTemperatureReset</code>.<br/>
                           This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/860\">#860</a>.<br/>
                           For Dymola, a conversion script makes this change.
        </td>
    </tr>
    <tr><td colspan=\"2\"><b>Buildings.Fluid.Actuators</b>
        </td>
    </tr>
    <tr><td valign=\"top\">
                           Buildings.Fluid.Actuators.BaseClasses.PartialDamperExponential<br/>
                           Buildings.Fluid.Actuators.Dampers.Exponential<br/>
                           Buildings.Fluid.Actuators.Dampers.MixingBox<br/>
                           Buildings.Fluid.Actuators.Dampers.MixingBoxMinimumFlow<br/>
                           Buildings.Fluid.Actuators.Dampers.PressureIndependent<br/>
                           Buildings.Fluid.Actuators.Dampers.VAVBoxExponential
        </td>
        <td valign=\"top\">Merged <code>VAVBoxExponential</code> into <code>Exponential</code>.<br/>
                           <code>Exponential</code> now provides all modeling capabilities previously
                           implemented in <code>VAVBoxExponential</code> which is no more needed and
                           has been removed from the library.<br/>
                           New parameters <code>dpDamper_nominal</code> and <code>dpFixed_nominal</code>
                           have been introduced in <code>Exponential</code>, consistent with the
                           valve models.<br/>
                           Parameter <code>k0</code> has been replaced by a leakage coefficient.<br/>
                           For Dymola, a conversion script makes this change. However the script will
                           not make the <code>each</code> keyword persist in array declarations. The
                           keyword will have to be manually reintroduced after applying the script.<br/>
                           This is for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1188\">IBPSA, #1188</a>.
        </td>
    </tr>
    <tr><td colspan=\"2\"><b>Buildings.ThermalZones.ReducedOrder</b>
        </td>
    </tr>
    <tr><td valign=\"top\">
                           Buildings.ThermalZones.ReducedOrder.RC.OneElement<br/>
                           Buildings.ThermalZones.ReducedOrder.RC.OneElement<br/>
                           Buildings.ThermalZones.ReducedOrder.RC.OneElement<br/>
                           Buildings.ThermalZones.ReducedOrder.RC.OneElement<br/>
                           Buildings.ThermalZones.ReducedOrder.RC.ThreeElements<br/>
                           Buildings.ThermalZones.ReducedOrder.RC.ThreeElements<br/>
                           Buildings.ThermalZones.ReducedOrder.RC.TwoElements<br/>
                           Buildings.ThermalZones.ReducedOrder.RC.TwoElements<br/>
                           Buildings.ThermalZones.ReducedOrder.RC.FourElements<br/>
                           Buildings.ThermalZones.ReducedOrder.RC.FourElements<br/>
                           Buildings.ThermalZones.ReducedOrder.RC.OneElement<br/>
                           Buildings.ThermalZones.ReducedOrder.EquivalentAirTemperature.BaseClasses.PartialVDI6007<br/>
                           Buildings.ThermalZones.ReducedOrder.EquivalentAirTemperature.BaseClasses.PartialVDI6007<br/>
                           Buildings.ThermalZones.ReducedOrder.EquivalentAirTemperature.VDI6007WithWindow

        </td>
        <td valign=\"top\">Renamed convection coefficient from <code>alpha*</code> to <code>hCon*</code>.<br/>
                           For Dymola, a conversion script makes this change.<br/>
                           This is for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1168\">IBPSA, #1168</a>.
        </td>
    </tr>
    </table>
    <!-- Errors that have been fixed -->
    <p>
    The following <b style=\"color:red\">critical errors</b> have been fixed (i.e., errors
    that can lead to wrong simulation results):
    </p>
    <table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=0 cellpadding=2 style=\"border-collapse:collapse;\">
    <tr><td colspan=\"2\"><b>Buildings.Controls.OBC.CDL</b>
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Controls.OBC.CDL.Continuous.Sources.TimeTable
        </td>
        <td valign=\"top\">Corrected implementation so that it gives the correct periodicity
                         of the table if the simulation starts at a negative time.<br/>
                         This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1834\">1834</a>.
        </td>
    </tr>
    <tr><td colspan=\"2\"><b>Buildings.Electrical</b>
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Electrical.AC.OnePhase.Sources.PVSimple<br/>
                           Buildings.Electrical.AC.OnePhase.Sources.PVSimpleOriented<br/>
                           Buildings.Electrical.AC.ThreePhasesBalanced.Sources.PVSimple<br/>
                           Buildings.Electrical.AC.ThreePhasesBalanced.Sources.PVSimpleOriented<br/>
                           Buildings.Electrical.AC.ThreePhasesUnbalanced.Sources.PVsimple<br/>
                           Buildings.Electrical.AC.ThreePhasesUnbalanced.Sources.PVsimpleOriented<br/>
                           Buildings.Electrical.AC.ThreePhasesUnbalanced.Sources.PVsimpleOriented_N<br/>
                           Buildings.Electrical.AC.ThreePhasesUnbalanced.Sources.PVsimple_N<br/>
                           Buildings.Electrical.Interfaces.PartialPV
        </td>
        <td valign=\"top\">Corrected model so that reported power <code>P</code> also includes the DCAC conversion.
                           Note that the power added to the elecrical system was correct, but the power reported in
                           the output connector <code>P</code> did not include this conversion factor.<br/>
                           This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1577\">1577</a>.
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Electrical.AC.OnePhase.Storage.Battery<br/>
                         Buildings.Electrical.AC.ThreePhasesBalanced.Storage.Battery
    </td>
      <td valign=\"top\">Corrected model and improved the documentation. The previous model extracted from
                       the AC connector the input power <code>P</code> plus the AC/DC conversion losses, but <code>P</code>
                       should be the power exchanged at the AC connector. Conversion losses are now only
                       accounted for in the energy exchange at the battery.<br/>
                       This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1865\">1865</a>.
      </td>
    </tr>
    <tr><td colspan=\"2\"><b>Buildings.Examples.VAVReheat</b>
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Examples.VAVReheat.ASHRAE2006<br/>
                           Buildings.Examples.VAVReheat.Guideline36
        </td>
        <td valign=\"top\">Connected actual VAV damper position as the measured input data for
                           defining duct static pressure setpoint.<br/>
                           This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1873\">#1873</a>.
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Examples.VAVReheat.Controls.DuctStaticPressureSetpoint
        </td>
        <td valign=\"top\">Reverse action changed to <code>true</code> for the pressure set-point controller.
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Examples.VAVReheat.Controls.RoomVAV
        </td>
        <td valign=\"top\">Refactored the model to implement a single maximum control logic.
                           The previous implementation led to a maximum air flow rate in heating demand.<br/>
                           The input connector <code>TDis</code> is removed. This is non backward compatible.<br/>
                           This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1873\">#1873</a>.
        </td>
    </tr>
    <tr><td colspan=\"2\"><b>Buildings.Fluid</b>
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Fluid.HeatExchangers.CoolingTowers.YorkCalc<br/>
                           Buildings.Fluid.HeatExchangers.CoolingTowers.BaseClasses.Characteristics.normalizedPower
        </td>
        <td valign=\"top\">Corrected error in computing the cooling tower fan power consumption.<br/>
                           This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1691\">1691</a>.
        </td>
    </tr>
    <tr><td colspan=\"2\"><b>Buildings.Utilities</b>
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings/Resources/Python-Sources/KalmanFilter.py<br/>
                           Buildings.Utilities.IO.Python27.Examples.KalmanFilter
        </td>
        <td valign=\"top\">Changed the temporary file format from <code>pickle</code> to <code>json</code> as the former can trigger a
                           segfault with JModelica simulation run in a subprocess.<br/>
                           This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1587\">Buildings, #1587</a>.
        </td>
    </tr>
    </table>
    <!-- Uncritical errors -->
    <p>
    The following <b style=\"color:red\">uncritical errors</b> have been fixed (i.e., errors
    that do <b style=\"color:red\">not</b> lead to wrong simulation results, e.g.,
    units are wrong or errors in documentation):
    </p>
    <table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=0 cellpadding=2 style=\"border-collapse:collapse;\">
    <tr><td colspan=\"2\"><b>Buildings.Controls.OBC.CDL</b>
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Controls.OBC.CDL.Continuous.LimPID
        </td>
        <td valign=\"top\">Removed wrong unit declaration for gain <code>k</code>.<br/>
                           This is for
                           <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1821\">Buildings, #1821</a>.
        </td>
    </tr>
    <tr><td colspan=\"2\"><b>Buildings.Fluid.Sources</b>
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Fluid.Sources.Boundary_pT<br/>
                           Buildings.Fluid.Sources.Boundary_ph<br/>
                           Buildings.Fluid.Sources.MassFlowSource_T<br/>
                           Buildings.Fluid.Sources.MassFlowSource_h
        </td>
        <td valign=\"top\">Refactored handling of mass fractions which was needed to handle media such as
                           <a href=\"modelica://Modelica.Media.IdealGases.MixtureGases.FlueGasSixComponents\">
                           Modelica.Media.IdealGases.MixtureGases.FlueGasSixComponents</a> and
                           <a href=\"modelica://Modelica.Media.IdealGases.MixtureGases.SimpleNaturalGas\">
                           Modelica.Media.IdealGases.MixtureGases.SimpleNaturalGas</a>.<br/>
                           Prior to this change, use of these media led to a translation error.<br/>
                           This is for
                           <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1205\">IBPSA, #1205</a>.
        </td>
    </tr>
    <tr><td colspan=\"2\"><b>Buildings.ThermalZones.Detailed</b>
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.ThermalZones.Detailed.Constructions.Examples.ExteriorWallTwoWindows<br/>
                           Buildings.ThermalZones.Detailed.Constructions.Examples.ExteriorWallWithWindow
        </td>
        <td valign=\"top\">Corrected wrong assignment of a parameter.<br/>
                           This is for
                           <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1766\">IBPSA, #1766</a>.
        </td>
    </tr>
    <tr><td colspan=\"2\"><b>Buildings/Resources</b>
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings/Resources/C-Sources/cryptographicsHash.c
        </td>
        <td valign=\"top\">Add a <code>#ifndef</code> clause.<br/>
                           This is for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1278\">IBPSA, #1278</a>.
        </td>
    </tr>
    </table>
    <!-- Obsolete components -->
    <p>
    The following components have become <b style=\"color:blue\">obsolete</b>:
    </p>
    <table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=0 cellpadding=2 style=\"border-collapse:collapse;\">
    <tr><td colspan=\"2\"><b>Buildings.Obsolete</b>
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Obsolete.Controls.OBC.CDL.Discrete.MovingMean
        </td>
        <td valign=\"top\">The block <code>Buildings.Controls.OBC.CDL.Discrete.TriggeredMovingMean</code>
                           replaced the original <code>MovingMean</code> block.<br/>
                           For Dymola, a conversion script makes this change.<br/>
                           This is for <a href=\"https://github.com/ibpsa/modelica-buildings/issues/1588\">#1588</a>.
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Obsolete.Utilities.IO.Python27
        </td>
        <td valign=\"top\">The package <code>Buildings.Utilities.IO.Python27</code>
                           has been upgraded to <code>Buildings.Utilities.IO.Python36</code>.<br/>
                           For Dymola, a conversion script moves the Python27 package to here.<br/>
                           This is for <a href=\"https://github.com/ibpsa/modelica-buildings/issues/1760\">issue #1760</a>.
        </td>
    </tr>
    </table>
     </html>"));
    end Version_7_0_0;

    class Version_6_0_0 "Version 6.0.0"
      extends Modelica.Icons.ReleaseNotes;
        annotation (Documentation(info="<html>
    <div class=\"release-summary\">
   <p>
   Version 6.0.0 is a major new release that
   contains various new packages, new models and improvements to existing models.
   The library has been tested with Dymola 2019FD01 and with JModelica (revision 12903).
   </p>
   <p>
     The following major changes have been done:
   <ul>
   <li>
     Various new packages have been added, such as:
     <ul>
       <li>
         A package for simulating occupancy and occupancy that resulted from IEA EBC Annex 66.
       </li>
       <li>
         A package with models for geothermal borefields.
       </li>
       <li>
         A package with blocks for control of shades and of outdoor lights.
       </li>
       <li>
         A package with blocks that allow generating time series and scatter plots,
         and writing these plots to one or several html files.
       </li>
       <li>
         A package with blocks for unit conversion.
       </li>
     </ul>
   <li>
     Various new control blocks have been added to <code>Buildings.Controls.OBC.CDL</code>.
   </li>
   </ul>
    </div>
    <!-- New libraries -->
    <p>
    The following <b style=\"color:blue\">new libraries</b> have been added:
    </p>
    <table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=0 cellpadding=2>
    <tr><td valign=\"top\">Buildings.Controls.OBC.OutdoorLights
        </td>
        <td valign=\"top\">Package with outdoor lighting controllers.
        </td>
        </tr>
    <tr><td valign=\"top\">Buildings.Controls.OBC.Shade
        </td>
        <td valign=\"top\">Package with shade controllers.
        </td>
        </tr>
    <tr><td valign=\"top\">Buildings.Controls.OBC.UnitConversions
        </td>
        <td valign=\"top\">Package with blocks for unit conversion.
                           Blocks in this package are meant to use when reading
                           data from a building automation system,
                           or writing data to a building automation system,
                           that uses units that are different
                           from the units used by Modelica.
        </td>
        </tr>
    <tr><td valign=\"top\">Buildings.Fluid.Geothermal
        </td>
        <td valign=\"top\">Package with models for geothermal heat exchangers.
                           This package has models for borefields with vertical boreholes,
                           and for a single vertical borehole with a U-tube heat exchanger.
                           The borefield models can have any geometrical configuration,
                           and either one or two U-tube heat exchangers.
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Occupants
       </td>
       <td valign=\"top\">Package with occupant behavior models and functions to
                          simulate the occupancy and the interaction of occupants
                          with air-conditioning and heating systems, windows,
                          blinds, and lighting in residential and office buildings.
       </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Utilities.Cryptographics
        </td>
        <td valign=\"top\">Package with a function to compute a SHA1 encrypted string.
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Utilities.IO.Files
    </td>
    <td valign=\"top\">Package with blocks to write CSV files, JSON files or combi time table files.
    </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Utilities.Plotters
       </td>
       <td valign=\"top\">Package with blocks that allow generating
                          time series and scatter plots, and writing these plots to
                          one or several html files.
                          The plots can be deactivated based on an input signal and a time
                          delay, for example, to plot data only while the HVAC system
                          operates for at least <i>30</i> minutes.
       </td>
    </tr>
    </table>
    <!-- New components for existing libraries -->
    <p>
    The following <b style=\"color:blue\">new components</b> have been added
    to <b style=\"color:blue\">existing</b> libraries:
    </p>
    <table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=0 cellpadding=2 style=\"border-collapse:collapse;\">
    <tr><td colspan=\"2\"><b>Buildings.Controls.OBC.CDL</b>
        </td>
        </tr>
    <tr><td valign=\"top\">Buildings.Controls.OBC.CDL.Continuous.MultiOr
        </td>
        <td valign=\"top\">Block that outputs true boolean signal if and only if any element of the boolean input vector is true.
        </td>
        </tr>
    <tr><td valign=\"top\">Buildings.Controls.OBC.CDL.Continuous.MatrixMin
        </td>
        <td valign=\"top\">Block that outputs vector of row- or column-wise minimum values.
        </td>
        </tr>
    <tr><td valign=\"top\">Buildings.Controls.OBC.CDL.Continuous.MatrixMax
        </td>
        <td valign=\"top\">Block that outputs vector of row- or column-wise maximum values.
        </td>
        </tr>
    <tr><td valign=\"top\">Buildings.Controls.OBC.CDL.Continuous.MatrixGain
        </td>
        <td valign=\"top\">Block that outputs the product of a gain matrix with the input signal vector.
        </td>
        </tr>
    <tr><td valign=\"top\">Buildings.Controls.OBC.CDL.Discrete.MovingMean
        </td>
        <td valign=\"top\">Block that outputs the discrete moving mean of a sampled input signal.
        </td>
        </tr>
    <tr><td valign=\"top\">Buildings.Controls.OBC.CDL.Integers.Change
        </td>
        <td valign=\"top\">Block that outputs whether its Integer input changed its value, and whether it increased or decreased.
        </td>
        </tr>
    <tr><td valign=\"top\">Buildings.Controls.OBC.CDL.Logical.IntegerSwitch
        </td>
        <td valign=\"top\">Block that outputs one of two integer input signals based on a boolean input signal.
        </td>
        </tr>
    <tr><td valign=\"top\">Buildings.Controls.OBC.CDL.Routing.RealExtractor
        </td>
        <td valign=\"top\">Block that extracts a scalar signal from a signal vector dependent on an Integer-valued input.
        </td>
        </tr>
    <tr><td valign=\"top\">Buildings.Controls.OBC.CDL.Utilities.SunRiseSet
        </td>
        <td valign=\"top\">Block that outputs sunrise and sunset time for each day.
        </td>
        </tr>
    <tr><td colspan=\"2\"><b>Buildings.Fluid</b>
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Fluid.HeatExchangers
        </td>
        <td valign=\"top\">Added <code>Buildings.Fluid.HeatExchangers.PlateHeatExchangerEffectivenessNTU</code>
                           which computes the effectiveness of a plate heat exchanger
                           based on design conditions and current mass flow rates.
        </td>
        </tr>
    <tr><td colspan=\"2\"><b>Buildings.Utilities</b>
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Utilities.Math
        </td>
        <td valign=\"top\">Added Bessel, exponential integral, factorial, falling factorial and binomial functions.
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Utilities.Psychrometrics.Functions.X_pTphi
        </td>
        <td valign=\"top\">Added function to compute humidity mass fraction for given pressure, temperature
                         and relative humidity.
        </td>
    </tr>
    </table>
    <!-- Backward compatible changes -->
    <p>
    The following <b style=\"color:blue\">existing components</b>
    have been <b style=\"color:blue\">improved</b> in a
    <b style=\"color:blue\">backward compatible</b> way:
    </p>
    <table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=0 cellpadding=2 style=\"border-collapse:collapse;\">
    <tr><td colspan=\"2\"><b>Buildings.BoundaryConditions</b>
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.BoundaryConditions.WeatherData.ReaderTMY3
        </td>
        <td valign=\"top\">Updated implementation to allow for weather data file that span less than a year and cross New Year,
                         and for weather data files that span more than a year.<br/>
                         This is for <a href=\"https://github.com/lbl-srg/modelica-ibpsa/issues/842\">IBPSA, #842</a>.
        </td>
    </tr>
    <tr><td colspan=\"2\"><b>Buildings.Controls.OBC.CDL</b>
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Controls.OBC.CDL.Logical.Timer
        </td>
        <td valign=\"top\">Updated implementation to output accumulated time when input is <code>true</code>.<br/>
                         This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1212\">issue 1212</a>.
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Controls.OBC.CDL.Logical.TrueDelay
        </td>
        <td valign=\"top\">Added parameter <code>delayOnInit</code> to optionally delay the initial <code>true</code> input.<br/>
                         This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1346\">issue 1346</a>.
        </td>
    </tr>
    <tr><td colspan=\"2\"><b>Buildings.Controls.OBC.ASHRAE.G36_PR1</b>
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Controls.OBC.ASHRAE.G36_PR1/AHUs.SingleZone.VAV.SetPoints.OutsideAirFlow
        </td>
        <td valign=\"top\">Made input connector for occupancy conditionally removable to avoid having to set the
                           number of occupants as an input if there is no occupancy sensor.<br/>
                           This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1270\">issue 1270</a>.
        </td>
    </tr>
    <tr><td colspan=\"2\"><b>Buildings.Fluid</b>
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Fluid.Interfaces.ConservationEquation<br/>
                           Buildings.Fluid.MixingVolumes.MixingVolume<br/>
                           Buildings.Fluid.MixingVolumes.MixingVolumeMoistAir
        </td>
        <td valign=\"top\">Changed model so that the volume is no longer fixed at compilation time.<br/>
                           This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1411\">issue 1411</a>.
        </td>
    </tr>
    <tr><td colspan=\"2\"><b>Buildings.Media</b>
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Media.Air<br/>
                           Buildings.Media.Water<br/>
                           Buildings.Media.Antifreeze.PropyleneGlycolWater<br/>
                           Buildings.Media.Specialized.Air.PerfectGas<br/>
        </td>
        <td valign=\"top\">Improved error message when temperature or mass fraction is outside the allowed range.<br/>
                           This is for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1045\">IBPSA, issue 1045</a>.
        </td>
    </tr>
    <tr><td colspan=\"2\"><b>Buildings.Utilities.IO.Python27</b>
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Utilities.IO.Python27.Functions.exchange<br/>
        </td>
        <td valign=\"top\">Refactored setting the <code>PYTHONPATH</code> environment variable.<br/>
                         This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1421\">issue 1421</a>.
    </td>
    </table>
    <!-- Non-backward compatible changes to existing components -->
    <p>
    The following <b style=\"color:blue\">existing components</b>
    have been <b style=\"color:blue\">improved</b> in a
    <b style=\"color:blue\">non-backward compatible</b> way:
    </p>
    <table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=0 cellpadding=2 style=\"border-collapse:collapse;\">
    <tr><td colspan=\"2\"><b>Buildings.Airflow.Multizone</b>
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Airflow.Multizone.DoorDiscretizedOperable
        </td>
        <td valign=\"top\">Removed parameter <code>CD</code>.<br/>
                           For Dymola, a conversion script makes this change.<br/>
                           This is for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/971\">IBPSA, #971</a>.
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Airflow.Multizone.EffectiveAirLeakageArea
        </td>
        <td valign=\"top\">Removed parameters <code>A</code>, <code>CD</code> and <code>lWet</code>.<br/>
                           For Dymola, a conversion script makes this change.<br/>
                           This is for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/932\">IBPSA, #932</a>.
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Airflow.Multizone.MediumColumnDynamic
        </td>
        <td valign=\"top\">Removed parameter <code>m_flow_nominal</code>.<br/>
                           For Dymola, a conversion script makes this change.<br/>
                           This is for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/970\">IBPSA, #970</a>.
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Airflow.Multizone.Orifice
        </td>
        <td valign=\"top\">Removed parameter <code>lWet</code>.<br/>
                           For Dymola, a conversion script makes this change.<br/>
                           This is for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/932\">IBPSA, #932</a>.
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Airflow.Multizone.MediumColumnDynamic<br/>
                           Buildings.Airflow.Multizone.MediumColumn<br/>
                           Buildings.Airflow.Multizone.EffectiveAirLeakageArea<br/>
                           Buildings.Airflow.Multizone.Orifice
        </td>
        <td valign=\"top\">Removed parameter <code>allowFlowReversal</code> as this is not meaningful
                           for these models.<br/>
                           For Dymola, a conversion script makes this change.<br/>
                           This is for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/877\">IBPSA, #877</a>.
        </td>
    </tr>
    <tr><td colspan=\"2\"><b>Buildings.BoundaryConditions</b>
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.BoundaryConditions.WeatherData.BaseClasses.ConvertTime
        </td>
        <td valign=\"top\">Added new parameters needed for weather data files that span multiple years.
                           Models of users are not likely to be affected by this change as this model
                           is part of the weather data file reader that implements all required changes.<br/>
                           This is for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/842\">IBPSA, #842</a>.
        </td>
    </tr>
    <tr><td colspan=\"2\"><b>Buildings.Controls.OBC.ASHRAE</b>
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone<br/>
                         Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone
        </td>
        <td valign=\"top\">Renamed packages to
                           <code>Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.VAV</code>
                           and <code>Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV</code>,
                           and renamed various signals and parameters for consistency.<br/>
                           For Dymola, a conversion script makes this change.
        </td>
    </tr>
    <tr><td colspan=\"2\"><b>Buildings.Controls.OBC.CDL</b>
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Controls.OBC.CDL.RealExtractSignal
        </td>
        <td valign=\"top\">Changed block name from <code>ExtractSignal</code>.<br/>
                           For Dymola, a conversion script makes this change.
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Controls.OBC.CDL.Continuous.MultiMax
        </td>
        <td valign=\"top\">Changed output variable name from <code>yMax</code> to <code>y</code>.<br/>
                           For Dymola, a conversion script makes this change.<br/>
                           This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/\">issue 1252</a>.
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Controls.OBC.CDL.Continuous.MultiMin
        </td>
        <td valign=\"top\">Changed output variable name from <code>yMin</code> to <code>y</code>.<br/>
                           For Dymola, a conversion script makes this change.<br/>
                           This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/\">issue 1252</a>.
        </td>
    </tr>
    <tr><td colspan=\"2\"><b>Buildings.Fluid</b>
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Fluid.HeatExchangers.DryEffectivenessNTU
        </td>
        <td valign=\"top\">Renamed model to
                           <code>Buildings.Fluid.HeatExchangers.DryCoilEffectivenessNTU</code>
                           because the convective heat transfer coefficients are for air.<br/>
                           For Dymola, a conversion script makes this change.<br/>
                           Removed variable <code>Z</code> as it is not used.
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Fluid.HeatExchangers.PlateHeatExchangerEffectivenessNTU
        </td>
        <td valign=\"top\">Removed variable <code>Z</code> as it is not used.
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Fluid.HeatExchangers.Ground.Boreholes.BaseClasses.factorial
        </td>
        <td valign=\"top\">Renamed function to
                           <code>Buildings.Utilities.Math.Functions.factorial</code>
                           because it is also used by the new Geothermal package.<br/>
                           For Dymola, a conversion script makes this change.
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Fluid.HeatExchangers.Ground.Boreholes
        </td>
        <td valign=\"top\">Renamed package to
                           <code>Buildings.Fluid.Geothermal.Boreholes</code>
                           due to the introduction of the new Geothermal package.<br/>
                           For Dymola, a conversion script makes this change.
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Fluid.HeatExchangers.RadiantSlabs.BaseClasses.MassFlowRateMultiplier
        </td>
        <td valign=\"top\">Renamed model to
                           <code>Buildings.Fluid.BaseClasses.MassFlowRateMultiplier</code>
                           because it is also used by the new Geothermal package.<br/>
                           For Dymola, a conversion script makes this change.
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Fluid.Sources.FixedBoundary
        </td>
        <td valign=\"top\">This model is now obsolete and will be removed in future releases.
                           The model has been renamed model to
                           <code>Buildings.Obsolete.Fluid.Sources.FixedBoundary</code>.
                           Use <code>Buildings.Fluid.Sources.Boundary_pT</code> instead.<br/>
                           For Dymola, a conversion script makes this change.
        </td>
    </tr>
    <tr><td colspan=\"2\"><b>Buildings.Media</b>
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Media.Refrigerants.R410A
        </td>
        <td valign=\"top\">Removed the function <code>pressureSatLiq_T</code> as it was not used.<br/>
                         This is for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/995\">IBPSA, #995</a>.
        </td>
    </tr>
    <tr><td colspan=\"2\"><b>Buildings.Utilities.Reports</b>
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Utilities.Reports.Printer<br/>
                           Buildings.Utilities.Reports.printRealArray
        </td>
        <td valign=\"top\">Moved <code>Buildings.Utilities.Reports.Printer</code> to
                           <code>Buildings.Utilities.IO.Files.Printer</code> and moved
                           <code>Buildings.Utilities.Reports.printRealArray</code> to
                           <code>Buildings.Utilities.IO.Files.BaseClasses.printRealArray</code>.<br/>
                           For Dymola, a conversion script makes this change.<br/>
                           This is due to the newly introduced package <code>Buildings.Utilities.IO.Files</code>.
        </td>
    </tr>
    </table>
    <!-- Errors that have been fixed -->
    <p>
    The following <b style=\"color:red\">critical errors</b> have been fixed (i.e., errors
    that can lead to wrong simulation results):
    </p>
    <table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=0 cellpadding=2 style=\"border-collapse:collapse;\">
    <tr><td colspan=\"2\"><b>Buildings.Controls.OBC.CDL</b>
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Controls.OBC.CDL.Logical.Latch
        </td>
        <td valign=\"top\">Corrected implementation that causes wrong output at initial stage.<br/>
                         This is for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1402\">issue 1402</a>.
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Controls.OBC.CDL.Logical.Toggle
        </td>
        <td valign=\"top\">Corrected implementation that causes wrong output at initial stage.<br/>
                         This is for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1402\">issue 1402</a>.
        </td>
    </tr>

    <tr><td colspan=\"2\"><b>Buildings.Fluid.Geothermal</b>
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Fluid.Geothermal.Borefields.Data.Soil.SandStone
        </td>
        <td valign=\"top\">Corrected wrong thermal properties.<br/>
                         This is for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1062\">IBPSA, #1062</a>.
        </td>
    </tr>

    <tr><td colspan=\"2\"><b>Buildings.Fluid.HeatExchangers</b>
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Fluid.HeatExchangers.Heater_T<br/>
                           Buildings.Fluid.HeatExchangers.SensibleCooler_T
        </td>
        <td valign=\"top\">Corrected missing propagation of initial conditions.<br/>
                           This is for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1016\">IBPSA, #1016</a>.
        </td>
    </tr>
    <tr><td colspan=\"2\"><b>Buildings.ThermalZones.Detailed</b>
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.ThermalZones.Detailed.MixedAir
        </td>
        <td valign=\"top\">Propagated parameter <code>mSenFac</code> which
                           increased the thermal capacity of the room air, such as
                           to account for furniture.<br/>
                           This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1405\">issue 1405</a>.
        </td>
    </tr>
    <tr><td colspan=\"2\"><b>Buildings.ThermalZones.ReducedOrder</b>
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.ThermalZones.ReducedOrder.RC.ThreeElements<br/>
                           Buildings.ThermalZones.ReducedOrder.RC.FourElements
        </td>
        <td valign=\"top\">The RC element of the roof <code>roofRC</code>
                           was flipped to have its <code>port_b</code> on the outside.
                           The resistances <code>RRem</code> and <code>R</code>
                           of the roof and floor have been switched
                           in the documentation.<br/>
                           This is for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/997\">IBPSA, #997</a>.
        </td>
    </tr>
    </table>
    <!-- Uncritical errors -->
    <p>
    The following <b style=\"color:red\">uncritical errors</b> have been fixed (i.e., errors
    that do <b style=\"color:red\">not</b> lead to wrong simulation results, e.g.,
    units are wrong or errors in documentation):
    </p>
    <table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=0 cellpadding=2 style=\"border-collapse:collapse;\">
    <tr><td colspan=\"2\"><b>Buildings.Controls.OBC.ASHRAE</b>
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Controls.OBC.ASHRAE.G36_PR1.Generic.SetPoints.OperationMode
        </td>
        <td valign=\"top\">Corrected wrong time in the documentation of the parameters.<br/>
                           This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1409\">issue 1409</a>.
        </td>
    </tr>
    </table>
    </html>"));
    end Version_6_0_0;

   class Version_5_1_0 "Version 5.1.0"
     extends Modelica.Icons.ReleaseNotes;
       annotation (Documentation(info="<html>
   <div class=\"release-summary\">
   <p>
   Version 5.1.0 adds new libraries, new components and improves various existing components.
   Version 5.1.0 updates the license to a 3-clause BSD license.
   It is backward compatible with versions 5.0.0 and 5.0.1.
   </p>
   <p>
   This release adds
   a model for propylene glycol - water mixtures, a model for long pipes
   suited for district heating and cooling simulations, a new valve model whose
   opening characteristics can be fit to measured data, and idealized models
   that allow to prescribe the temperature and humidity in any part of a fluid flow
   system.
   </p>
   </div>
   <!-- New libraries -->
   <p>
   The following <b style=\"color:blue\">new libraries</b> have been added:
   </p>
   <table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=0 cellpadding=2>
   <tr><td valign=\"top\">Buildings.Media.Antifreeze.PropyleneGlycolWater
       </td>
       <td valign=\"top\">Package with medium model for propylene glycol - water mixture.
                          The concentration and the medium temperature for which the properties are evaluated
                          can be set when instantiating the medium.
       </td>
       </tr>
   </table>
   <!-- New components for existing libraries -->
   <p>
   The following <b style=\"color:blue\">new components</b> have been added
   to <b style=\"color:blue\">existing</b> libraries:
   </p>
   <table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=0 cellpadding=2 style=\"border-collapse:collapse;\">
   <tr><td colspan=\"2\"><b>Buildings.Fluid</b>
       </td>
   </tr>
   <tr><td valign=\"top\">Buildings.Fluid.Actuators.Valves.TwoWayPolynomial
       </td>
       <td valign=\"top\">Two-way valve with opening characteristics
                          specified by a polynomial.
                          This model may be used if a valve characteristics needs to be
                          matched to measured data.
       </td>
       </tr>
   <tr><td valign=\"top\">Buildings.Fluid.FixedResistances.PlugFlowPipe
       </td>
       <td valign=\"top\">Pipe with heat loss and transport of the fluid
                          using a plug flow model. This model is applicable for
                          simulation of long pipes such as in district heating and cooling systems.
       </td>
       </tr>
   <tr><td valign=\"top\">Buildings.Fluid.Sources.PropertySource_T<br/>
                          Buildings.Fluid.Sources.PropertySource_h
       </td>
       <td valign=\"top\">Model that changes the fluid properties of the medium that flows through it
                          based on input signals. These idealized models can be used to force a certain temperature,
                          enthalpy or humidity in a fluid flow system.
       </td>
       </tr>
   </table>
   <!-- Backward compatible changes -->
   <p>
   The following <b style=\"color:blue\">existing components</b>
   have been <b style=\"color:blue\">improved</b> in a
   <b style=\"color:blue\">backward compatible</b> way:
   </p>
   <table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=0 cellpadding=2 style=\"border-collapse:collapse;\">
   <tr><td colspan=\"2\"><b>Buildings.Airflow.Multizone</b>
       </td>
   </tr>
   <tr><td valign=\"top\">Buildings.Airflow.Multizone.DoorDiscretizedOpen<br/>
                          Buildings.Airflow.Multizone.DoorDiscretizedOperable
       </td>
       <td valign=\"top\">Removed term that assures non-zero flow rate in each path,
                          reformulated flow balance to ensure that model is symmetric,
                          and improved implementation to reduce number of calculations.<br/>
                          This is
                          for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/937\">IBPSA, issue 937</a>.
       </td>
   </tr>
   <tr><td colspan=\"2\"><b>Buildings.Applications.DataCenters</b>
       </td>
   </tr>
   <tr><td valign=\"top\">Buildings.Applications.DataCenters.ChillerCooled.Equipment.BaseClasses.PartialParallelElectricEIR
       </td>
       <td valign=\"top\">Added <code>constrainedby</code> to declaration of chiller.<br/>
                          This is for
                          <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1118\">issue 1118</a>.
       </td>
   </tr>
   <tr><td colspan=\"2\"><b>Buildings.Controls.OBC.ASHRAE.G36_PR1</b>
       </td>
   </tr>
   <tr><td valign=\"top\">Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.VAV.SetPoints.Supply
   </td>
       <td valign=\"top\">Revised implementation of fan speed control signal calculation
                          to remove the hysteresis blocks.<br/>
                          This is for
                          <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1153\">issue 1153</a>.
       </td>
   </tr>
   <tr><td colspan=\"2\"><b>Buildings.Controls.OBC.CDL</b>
       </td>
   </tr>
   <tr><td valign=\"top\">Buildings.Controls.OBC.CDL.Continuous.Line
   </td>
   <td valign=\"top\">Improved documentation and icon, and added a warning if the limits are used and x1 &gt; x2.
       </td>
   </tr>
   <tr><td colspan=\"2\"><b>Buildings.Fluid.SolarCollectors</b>
       </td>
   </tr>
   <tr><td valign=\"top\">Buildings.Fluid.SolarCollectors.ASHRAE93<br/>
                          Buildings.Fluid.SolarCollectors.EN12975
       </td>
       <td valign=\"top\">Improved calculation of heat loss.<br/>
                          This is for
                          <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1100\">issue 1100</a>.
       </td>
   </tr>
   <tr><td colspan=\"2\"><b>Buildings.Fluid.Sources</b>
       </td>
   </tr>
   <tr><td valign=\"top\">Buildings.Fluid.Sources.Boundary_pT<br/>
                          Buildings.Fluid.Sources.Boundary_ph<br/>
                          Buildings.Fluid.Sources.FixedBoundary<br/>
                          Buildings.Fluid.Sources.MassFlowSource_T<br/>
                          Buildings.Fluid.Sources.MassFlowSource_h
       </td>
       <td valign=\"top\">Refactored models to allow using <code>Xi</code> rather
                          than <code>X</code> as an input.<br/>
                          By default, the check on the medium base properties is now removed
                          to reduce translation and simulation time.<br/>
                          This is for
                          <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/882\">IBPSA, issue 882</a>.
       </td>
   </tr>
   <tr><td valign=\"top\">Buildings.Fluid.Storage.Stratified
       </td>
       <td valign=\"top\">Refactored tank to allow modeling of tanks that have multiple inlets or outlets along the height.
                          The tank now has for each control volume a fluid port that can be connected from outside the model.<br/>
                          This is for
                          <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1182\">issue 1182</a>.
       </td>
   </tr>
   <tr><td colspan=\"2\"><b>Buildings.Utilities.IO</b>
       </td>
   </tr>
   <tr><td valign=\"top\">Buildings.Utilities.IO.Python27
       </td>
       <td valign=\"top\">Added option for a Python object
                        to be passed from one Python function invocation to the next.
                        This allows to build up a Python data structure (or to instantiate a Python object),
                        and do computations on this object at each function invocation. For example,
                        a Model Predictive Control algorithm or a machine learning algorithm,
                        implemented in Python, could be fed with data at each time step.
                        It could then store this data
                        and use the current and its historical data to feed its algorithm.
                        Based on this algorithm, it could output a control signal for use in another Modelica model.
                        <br/>
                        The function <code>Buildings.Utilities.IO.Python27.Functions.exchange</code> now takes
                        two additional arguments: A class that contains a pointer to the Python interpreter
                        (for efficiency, as this avoids initializing Python at each call), and
                        a flag that determines whether the Python function returns an object and receives this
                        object at the next invocation. See
                        <code>Buildings.Utilities.IO.Python27.UsersGuide</code> and
                        <code>Buildings.Utilities.IO.Python27.Real_Real</code> for how to use
                        these two arguments.
                        <br/>
                        Models that use <code>Buildings.Utilities.IO.Python27.Real_Real</code>
                        will still work as before. The change only affects the low-level function
                        <code>Buildings.Utilities.IO.Python27.Functions.exchange</code>.
       </td>
  </tr>
  <tr><td valign=\"top\">Buildings.Utilities.IO.Python27</td>
     <td valign=\"top\">
                      Corrected <code>LibraryDirectory</code> annotation.<br/>
                     This is for
                     <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1160\">issue 1160</a>.
     </td>
   </tr>
   </table>
   <!-- Non-backward compatible changes to existing components -->
   <!-- Errors that have been fixed -->
   <p>
   The following <b style=\"color:red\">critical errors</b> have been fixed (i.e., errors
   that can lead to wrong simulation results):
   </p>
   <table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=0 cellpadding=2 style=\"border-collapse:collapse;\">
   <tr><td colspan=\"2\"><b>Buildings.Fluid.Interfaces</b>
       </td>
   </tr>
   <tr><td valign=\"top\">Buildings.Fluid.Interfaces.PrescribedOutlet
       </td>
       <td valign=\"top\">Corrected error that caused the old model do not track <code>TSet</code> and <code>X_wSet</code>
                          simultaneously.<br/>
                          This is for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/893\">IBPSA, issue 893</a>.
       </td>
   </tr>
   </table>
   <!-- Uncritical errors -->
   </html>"));
   end Version_5_1_0;

   class Version_5_0_1 "Version 5.0.1"
     extends Modelica.Icons.ReleaseNotes;
       annotation (Documentation(info="<html>
   <div class=\"release-summary\">
   <p>
   Version 5.0.1 corrects an error in <code>Buildings.Fluid.SolarCollectors</code>
   that led to too small heat losses if a collector has more than one panel.
   Also, Dymola specific annotations to load data files in a GUI have been replaced
   for compatibility with other tools.
   Otherwise, version 5.0.1 is identical to 5.0.0.
   </p>
   <p>
   All models simulate with Dymola 2017FD01, Dymola 2018 and JModelica (revision 10374).
   </p>
   </div>
   <p>
   The following <b style=\"color:red\">critical errors</b> have been fixed (i.e., errors
   that can lead to wrong simulation results):
   </p>
   <table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=0 cellpadding=2 style=\"border-collapse:collapse;\">
   <tr><td colspan=\"2\"><b>Buildings.Fluid.SolarCollectors</b>
       </td>
   </tr>
   <tr><td valign=\"top\">Buildings.Fluid.SolarCollectors.ASHRAE93<br/>
                          Buildings.Fluid.SolarCollectors.EN12975
       </td>
       <td valign=\"top\">Corrected error in parameterization of heat loss calculation
                          that led to too small heat losses if a collector has more than one panel.<br/>
                          This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1073\">issue 1073</a>.
       </td>
   </tr>
   </table>
   </html>"));
   end Version_5_0_1;


   class Version_5_0_0 "Version 5.0.0"
     extends Modelica.Icons.ReleaseNotes;
       annotation (Documentation(info="<html>
   <div class=\"release-summary\">
   <p>
   Version 5.0.0 is a major new release that
   contains new packages to model control sequences,
   a package with control sequences from ASHRAE Guideline 36 and
   a package with pre-configured models for data center chilled water plants.
   All models simulate with Dymola 2017FD01, Dymola 2018 and with JModelica (revision 10374).
   </p>
   <p>
     The following major changes have been done:
   <ul>
   <li>
   The package <code>Buildings.Controls.OBC.CDL</code> has been added.
   This package provides elementary blocks to implemented control sequences.
   The blocks conform to the Control Description Language specification
   published at <a href=\"http://obc.lbl.gov\">http://obc.lbl.gov</a>.
   </li>
   <li>
   The package <code>Buildings.Controls.OBC.ASHRAE.G36_PR1</code> has been added.
   This package contains control sequences for variable air volume flow systems
   according to ASHRAE Guideline 36, public review draft 1.
   The implementation uses blocks from the above described
   <code>Buildings.Controls.OBC.CDL</code> package, and conforms to the
   Control Description Language specification.
   </li>
   <li>
   New models for ideal heaters and sensible coolers, and ideal
   humidifiers have been added.
   </li>
   <li>
   Various models have been improved.
   </li>
   </ul>
   </div>
   <!-- New libraries -->
   <p>
   The following <b style=\"color:blue\">new libraries</b> have been added:
   </p>
   <table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=0 cellpadding=2>
   <tr><td valign=\"top\">Buildings.Applications.DataCenter
       </td>
       <td valign=\"top\">Library with component models and pre-configured
                          system models for data centers.
       </td>
       </tr>
   <tr><td valign=\"top\">Buildings.Controls.OBC
       </td>
       <td valign=\"top\">Library with basic control blocks and ready-to-use control sequences
                          from the OpenBuildingControl project
                          (<a href=\"http://obc.lbl.gov\">http://obc.lbl.gov</a>).<br/>
                          The subpackage <code>Buildings.Controls.OBC.ASHRAE</code>
                          contains control sequences
                          for HVAC systems as described in ASHRAE Guideline 36.<br/>
                          The subpackage <code>Buildings.Controls.OBC.CDL</code>
                          contains libraries with basic control blocks.
                          These are a part of a Control Description Language (CDL)
                          currently being developed, which is used to compose
                          the sequences in <code>Buildings.Controls.OBC.ASHRAE</code>.
                          The intent of this implementation is that
                          Modelica models that are conformant with the CDL
                          can be translated to product lines of different control vendors.
       </td>
       </tr>
   <tr><td valign=\"top\">Buildings.Fluid.Humidifiers
       </td>
       <td valign=\"top\">Package with spray air washer, steam humidifier and a humidifer
                          that adds a water vapor mass flow rate that is proportional to the control input.
       </td>
       </tr>
   </table>
   <!-- New components for existing libraries -->
   <p>
   The following <b style=\"color:blue\">new components</b> have been added
   to <b style=\"color:blue\">existing</b> libraries:
   </p>
   <table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=0 cellpadding=2 style=\"border-collapse:collapse;\">
   <tr><td colspan=\"2\"><b>Buildings.Fluid.HeatExchangers</b>
       </td>
   </tr>
   <tr><td valign=\"top\">Buildings.Fluid.HeatExchangers.Heater_T<br/>
                        Buildings.Fluid.HeatExchangers.SensibleCooler_T
       </td>
       <td valign=\"top\">Added these new components to allow modeling a heater
                        and a sensible-only cooler that use an input signal to
                        ideally control their outlet temperature,
                        with optional capacity limitation
                        and optional first order dynamics.
       </td>
   </tr>
   <tr><td colspan=\"2\"><b>Buildings.Fluid.MassExchangers</b>
       </td>
   </tr>
   <tr><td valign=\"top\">Buildings.Fluid.Humidifiers.SprayAirWasher_X<br/>
                          Buildings.Fluid.Humidifiers.SteamHumidifier_X
       </td>
       <td valign=\"top\">Added component which allows setting the outlet water vapor
                        mass fraction using an input signal, and controlling it ideally
                        with optional capacity limitation
                        and optional first order dynamics.
       </td>
   </tr>
   <tr><td colspan=\"2\"><b>Buildings.Fluid.Sources</b>
       </td>
   </tr>
   <tr><td valign=\"top\">Buildings.Fluid.Sources.MassFlowSource_WeatherData
       </td>
       <td valign=\"top\">Added component which allows prescribing
                          a mass flow rate that has thermal properties
                          obtained from weather data.
       </td>
   </tr>
   </table>
   <!-- Backward compatible changes -->
   <p>
   The following <b style=\"color:blue\">existing components</b>
   have been <b style=\"color:blue\">improved</b> in a
   <b style=\"color:blue\">backward compatible</b> way:
   </p>
   <table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=0 cellpadding=2 style=\"border-collapse:collapse;\">
   <tr><td colspan=\"2\"><b>Buildings.Fluid.Chillers</b>
       </td>
   </tr>
   <tr><td valign=\"top\">Buildings.Fluid.Chillers.Carnot_TEva<br/>
                          Buildings.Fluid.Chillers.Carnot_y
       </td>
       <td valign=\"top\">Added approach temperature to avoid
                          too large COPs if the temperature lift is small.<br/>
                          This is for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/698\">IBPSA, #698</a>.
       </td>
   </tr>
   <tr><td colspan=\"2\"><b>Buildings.Fluid.HeatExchangers</b>
       </td>
   </tr>
   <tr><td valign=\"top\">Buildings.Fluid.HeatExchangers.DryCoilCounterFlow<br/>
                          Buildings.Fluid.HeatExchangers.DryCoilDiscretized<br/>
                          Buildings.Fluid.HeatExchangers.WetCoilCounterFlow<br/>
                          Buildings.Fluid.HeatExchangers.WetCoilDiscretized
       </td>
       <td valign=\"top\">Improved model so that for certain parameters (dynamic balance,
                          or steady-state balance and no reverse flow,
                          or <i>hA</i>-calculation that is independent of temperature),
                          two fast state variables can be removed.<br/>
                          This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/678\">Buildings, #678</a>.
                          <br/><br/>
                          Added approximation of diffusion, which is needed for very small
                          flow rates which can happen if fans are off but wind pressure
                          entrains cold air through the HVAC system.<br/>
                          This is for
                          <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1038\">Buildings, #1038</a>.
       </td>
   </tr>
   <tr><td colspan=\"2\"><b>Buildings.Fluid.HeatPumps</b>
       </td>
   </tr>
   <tr><td valign=\"top\">Buildings.Fluid.HeatPumps.Carnot_TCon<br/>
                          Buildings.Fluid.HeatPumps.Carnot_y
       </td>
       <td valign=\"top\">Added approach temperature to avoid
                          too large COPs if the temperature lift is small.<br/>
                          This is for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/698\">IBPSA, #698</a>.
       </td>
   </tr>
   <tr><td colspan=\"2\"><b>Buildings.Fluid.Movers</b>
       </td>
   </tr>
   <tr><td valign=\"top\">Buildings.Fluid.Movers.FlowControlled_dp
       </td>
       <td valign=\"top\">Added optional input signal for
                          differential pressure measurement,
                          which will then be tracked by the model.
       </td>
   </tr>
   <tr><td colspan=\"2\"><b>Buildings.Fluid.Sensors</b>
       </td>
   </tr>
   <tr><td valign=\"top\">Buildings.Fluid.Sensors.TemperatureTwoPort
       </td>
       <td valign=\"top\">Improved optional heat loss model.<br/>
                          This is for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/840\">IBPSA, #840</a>.
       </td>
   </tr>
   <tr><td colspan=\"2\"><b>Buildings.Fluid.SolarCollectors</b>
       </td>
   </tr>
   <tr><td valign=\"top\">Buildings.Fluid.SolarCollectors.ASHRAE93<br/>
                          Buildings.Fluid.SolarCollectors.EN12975
       </td>
       <td valign=\"top\">Changed models for incidence angles below 60&deg;
                          in order to increase the accuracy near sunrise and sunset.<br/>
                          This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/785\">#785</a>.
       </td>
   </tr>
   <tr><td colspan=\"2\"><b>Buildings.ThermalZones.Detailed</b>
       </td>
   </tr>
   <tr><td valign=\"top\">Buildings.ThermalZones.Detailed.MixedAir
       </td>
       <td valign=\"top\">Added an optional input that allows injecting
                          trace substances, such as CO2 release from people,
                          to the room air.
       </td>
   </tr>
   </table>
   <!-- Non-backward compatible changes to existing components -->
   <p>
   The following <b style=\"color:blue\">existing components</b>
   have been <b style=\"color:blue\">improved</b> in a
   <b style=\"color:blue\">non-backward compatible</b> way:
   </p>
   <table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=0 cellpadding=2 style=\"border-collapse:collapse;\">
    <tr><td colspan=\"2\"><b>Buildings.Fluid</b>
       </td>
   </tr>
   <tr><td valign=\"top\">Buildings.Fluid.HeatExchangers.HeaterCooler_T
       </td>
       <td valign=\"top\">Renamed <code>Buildings.Fluid.HeatExchangers.HeaterCooler_T</code>
                        to <code>Buildings.Fluid.HeatExchangers.PrescribedOutlet</code>
                        as it now also allows to set the outlet water vapor mass fraction.<br/>
                        For Dymola, a conversion script makes this change.<br/>
                        This is for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/763\">IBPSA, #763</a>.
       </td>
   </tr>
   <tr><td valign=\"top\">Buildings.Fluid.MassExchangers.Humidifier_u
       </td>
       <td valign=\"top\">Moved model to <code>Buildings.Fluid.Humidifiers.Humidifier_u</code>.<br/>
                          Removed parameters <code>use_T_in</code> and <code>T</code>,
                          and removed input connector <code>T_in</code>, as these are no
                          longer needed.<br/>
                          For Dymola, the conversion script will remove the parameter
                          settings.<br/>
                          For Dymola, a conversion script makes this change.<br/>
                          This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/704\">#704</a>.
       </td>
   </tr>
   <tr><td valign=\"top\">Buildings.Fluid.Interfaces
       </td>
       <td valign=\"top\">Renamed <code>PrescribedOutletState</code> to <code>PrescribedOutlet</code>
                        and removed <code>PrescribedOutletStateParameters</code>.<br/>
                        This is for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/763\">IBPSA, #763</a>.
       </td>
   </tr>
   <tr><td valign=\"top\">Buildings.Fluid.HeatExchangers
       </td>
       <td valign=\"top\">Removed the function
                        <code>Buildings.Fluid.HeatExchangers.BaseClasses.appartusDewPoint</code>
                        as it was nowhere used, and it also has no validation test.<br/>
                        This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/724\">Buildings, #724</a>.
       </td>
   </tr>


   </table>
   <!-- Errors that have been fixed -->
   <p>
   The following <b style=\"color:red\">critical errors</b> have been fixed (i.e., errors
   that can lead to wrong simulation results):
   </p>
   <table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=0 cellpadding=2 style=\"border-collapse:collapse;\">
   <tr><td colspan=\"2\"><b>Buildings.Airflow</b>
       </td>
   </tr>
   <tr><td valign=\"top\">Buildings.Airflow.Multizone.EffectiveAirLeakageArea
       </td>
       <td valign=\"top\">Corrected error in computation of <code>A</code> which was
                          <code>A=CD/CDRat * L * dpRat^(0.5-m))</code> rather than
                          <code>A=CDRat/CD * L * dpRat^(0.5-m))</code>.<br/>
                          See <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/743\">#743</a>.
       </td>
   </tr>

   <tr><td colspan=\"2\"><b>Buildings.Controls</b>
       </td>
   </tr>
   <tr><td valign=\"top\">Buildings.Controls.Continuous.OffTimer
       </td>
       <td valign=\"top\">Corrected implementation as the timer had the wrong
                          if the simulation did not start at <code>time = 0</code>.
                          After the first reset, the value was correct.<br/>
                          See <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/743\">IBPSA, #743</a>.
       </td>
   </tr>

   <tr><td colspan=\"2\"><b>Buildings.Fluid</b>
       </td>
   </tr>
   <tr><td valign=\"top\">Buildings.Fluid.Interfaces.TwoPortHeatMassExchanger<br/>
                          Buildings.Fluid.Interfaces.FourPortHeatMassExchanger
       </td>
       <td valign=\"top\">Corrected assignment of <code>Q_flow</code> (or <code>Q1_flow</code>
                          and <code>Q2_flow</code>).
                          Previously, these variables were assigned only the sensible heat flow rate,
                          but they should include the latent heat exhange to be consistent with
                          the variable naming, and because the cooling coils interpret these variables
                          as if they contain the latent heat flow rate.<br/>
                          This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/704\">#704</a>.
       </td>
   </tr>
   <tr><td valign=\"top\">Buildings.Fluid.HeatExchangers.WetCoilCounterFlow<br/>
                          Buildings.Fluid.HeatExchangers.WetCoilDiscretized<br/>
                          Buildings.Fluid.HeatExchangers.BaseClasses.HexElementLatent
       </td>
       <td valign=\"top\">Added heat of condensation to coil surface heat balance
                          and removed it from the air stream.
                          This gives higher coil surface temperature and avoids
                          overestimating the latent heat ratio that was
                          observed in the previous implementation.
                          The code change was in
                          <code>Buildings.Fluid.HeatExchangers.BaseClasses.HexElementLatent</code><br/>
                          This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/711\">#711</a>.
       </td>
   </tr>
   <tr><td valign=\"top\">Buildings.Fluid.HeatExchangers.BaseClasses.HADryCoil
       </td>
       <td valign=\"top\">Corrected coefficient for temperature-dependency correction
                          of air-side convection coefficient.
                          By default, the convection coefficient
                          is assumed to be temperature-independent, in which cases this
                          correction has no effect on the results.<br/>
                          This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/698\">#698</a>.
       </td>
   </tr>
   </table>
   <!-- Uncritical errors -->
   <p>
   The following <b style=\"color:red\">uncritical errors</b> have been fixed (i.e., errors
   that do <b style=\"color:red\">not</b> lead to wrong simulation results, e.g.,
   units are wrong or errors in documentation):
   </p>
   <table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=0 cellpadding=2 style=\"border-collapse:collapse;\">
   <tr><td colspan=\"2\"><b>Buildings.HeatTransfer</b>
       </td>
   </tr>
   <tr><td valign=\"top\">Buildings.HeatTransfer.Conduction.MultiLayer
       </td>
       <td valign=\"top\">Corrected wrong result variable <code>R</code> and <code>UA</code>.
                          These variables are only used for reporting.
                          All other calculations are not affected by this error.
       </td>
   </tr>
   </table>
   </html>"));
   end Version_5_0_0;

   class Version_4_0_0 "Version 4.0.0"
     extends Modelica.Icons.ReleaseNotes;
     annotation (Documentation(info="<html>
   <div class=\"release-summary\">
   <p>
   Version 4.0.0 is a major new release. It is the first release
   that is based on the <i>Modelica IBPSA Library</i>
   (<a href=\"https://github.com/ibpsa/modelica\">https://github.com/ibpsa/modelica</a>).
   All models simulate with Dymola 2017 FD01 and with JModelica,
   and the results of these simulators have been cross-compared and are
   equal within the expected tolerance.
   </p>
   <p>
     The following major changes have been done:
   <ul>
   <li>
   It no longer uses the <code>Modelica_StateGraph2</code>
   library. Instead, it uses <code>Modelica.StateGraph</code> which is part
   of the Modelica Standard Library.
   </li>
   <li>
   The models in <code>Buildings.Fluid.Movers</code> have been refactored to increase
   the numerical robustness at very low speed when the fans or pumps are switched on or off.
   </li>
   <li>
   The following new packages have been added:
   <ul>
   <li>
   <code>Buildings.Experimental.DistrictHeatingCooling</code>
   with models for district heating and cooling
   with bi-directional flow in the distribution pipes.
   </li>
   <li>
   <code>Buildings.Fluid.FMI.Adaptors</code> and
   <code>Buildings.Fluid.FMI.ExportContainers</code>, which
   allow export of HVAC systems and of thermal zones as
   Functional Mockup Units.
   </li>
   <li>
   <code>Buildings.Fluid.HeatExchangers.ActiveBeams</code>,
   with active beams for cooling and heating.
   </li>
   <li>
   <code>Buildings.Fluid.HeatExchangers.DXCoils.WaterCooled</code>,
   with water-cooled direct expansion cooling coils.
   </li>
   <li>
   <code>Buildings.ThermalZones.ReducedOrder</code>, with
   reduced order models of thermal zones based on VDI 6007
   that are suitable for district energy simulation.
   </li>
   </ul>
   <li>
   The package <code>Buildings.Rooms</code> has been renamed to <code>Buildings.ThermalZones.Detailed</code>.
   This was done because of the introduction of <code>Buildings.ThermalZones.ReducedOrder</code>,
   which is from the <code>Annex60</code> library,
   in order for thermal zones to be in the same top-level package.<br/>
   For Dymola, the conversion script will update models that use any model of the package
   <code>Buildings.Rooms</code>.
   </li>
   <li>
   The model <code>Buildings.Fluid.FixedResistances.FixedResistanceDpM</code> has been refactored. Now, if
   the hydraulic diameter is not yet known, one can use the simpler model
   <code>Buildings.Fluid.FixedResistances.PressureDrop</code>, otherwise the model
   <code>Buildings.Fluid.FixedResistances.HydraulicDiameter</code> may be used.
   With this refactoring, also the model <code>Buildings.Fluid.FixedResistances.SplitterFixedResistanceDpM</code> has
   been renamed to <code>Buildings.Fluid.FixedResistances.Junction</code> and
   parameters that use the hydraulic diameter have been removed.
   </li>
   <li>
   The models <code>Buildings.HeatTransfer.Conduction.SingleLayer</code>,
   <code>Buildings.HeatTransfer.Conduction.MultiLayer</code>,
   and <code>Buildings.HeatTransfer.Windows.Window</code> have been refactored
   to add the option to place a state at the surface of a construction.
   This leads in many examples that use the room model to a smaller number
   of non-linear system of equations and a 20% to 40% faster simulation.
   </li>
   <li>
   The models <code>Buildings.Fluid.HeatPumps.ReciprocatingWaterToWater</code>
   and <code>Buildings.Fluid.HeatPumps.ScrollWaterToWater</code> have been added.
   Parameters to these models rely on calibration with tabulated heat pump performance
   data. Python scripts for the calibration of the heat pump models are in
   <code>Buildings/Resources/src/fluid/heatpumps/calibration</code>.
   This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/587\">issue 587</a>.
   </li>
   </ul>
   </div>
   <!-- New libraries -->
   <p>
   The following <b style=\"color:blue\">new libraries</b> have been added:
   </p>
   <table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\">

   <tr><td valign=\"top\">Buildings.Experimental.DistrictHeatingCooling
       </td>
       <td valign=\"top\">Package with models for district heating and cooling
                          with bi-directional flow in the distribution pipes.

       </td>
       </tr>

   <tr><td valign=\"top\">Buildings.Fluid.FMI.Adaptors<br/>
                          Buildings.Fluid.FMI.ExportContainers
       </td>
       <td valign=\"top\">Library with adaptors to export HVAC systems and thermal zones
                          as a Functional Mockup Unit for Model Exchange.<br/>
                          This is for
                          <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/506\">Buildings, #506</a>.
       </td>
       </tr>

   <tr><td valign=\"top\">Buildings.Fluid.HeatExchangers.ActiveBeams
       </td>
       <td valign=\"top\">Package with models of active beams for space cooling and heating.
       </td>
       </tr>

    <tr><td valign=\"top\">Buildings.Fluid.HeatExchangers.DXCoils.WaterCooled
       </td>
       <td valign=\"top\">Package with models of water-cooled direct expansion
                          cooling coils with single speed, variable speed
                          or multi-stage compressor.
        </td>
        </tr>

   <tr><td valign=\"top\">Buildings.Fluid.HeatPumps.Compressors
       </td>
       <td valign=\"top\">Package with models of compressors for heat pumps.
       </td>
       </tr>

     <tr><td valign=\"top\">Buildings.ThermalZones.ReducedOrder
       </td>
       <td valign=\"top\">Package with reduced order models of thermal zones based
                        on VDI 6007.
       </td>
       </tr>

   </table>
   <!-- New components for existing libraries -->
   <p>
   The following <b style=\"color:blue\">new components</b> have been added
   to <b style=\"color:blue\">existing</b> libraries:
   </p>
   <table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
   <tr><td colspan=\"2\"><b>Buildings.Fluid.Sensors</b>
       </td>
   </tr>
   <tr><td valign=\"top\">Buildings.Fluid.Sensors.Velocity
       </td>
       <td valign=\"top\">Sensor for the flow velocity.
       </td>
   </tr>

   <tr><td colspan=\"2\"><b>Buildings.Fluid.HeatExchangers</b>
       </td>
   </tr>
   <tr><td valign=\"top\">Buildings.Fluid.HeatExchangers.EvaporatorCondenser
       </td>
       <td valign=\"top\">Model for evaporator/condenser with refrigerant experiencing constant temperature phase change.
       </td>
   </tr>

   <tr><td colspan=\"2\"><b>Buildings.Fluid.HeatPumps</b>
       </td>
   </tr>
   <tr><td valign=\"top\">Buildings.Fluid.HeatPumps.ReciprocatingWaterToWater
       </td>
       <td valign=\"top\">Model for water to water heat pump with a reciprocating compressor.
       </td>
   </tr>
   <tr><td valign=\"top\">Buildings.Fluid.HeatPumps.ScrollWaterToWater
       </td>
       <td valign=\"top\">Model for water to water heat pump with a scroll compressor.
       </td>
   </tr>

   <tr><td colspan=\"2\"><b>Buildings.HeatTransfer.Windows.BaseClasses</b>
       </td>
   </tr>
   <tr><td valign=\"top\">Buildings.HeatTransfer.Windows.BaseClasses.HeatCapacity
       </td>
       <td valign=\"top\">Model for adding a state on the room-facing surface of a window.
This closes <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/565\">issue 565</a>.
       </td>
   </tr>


   <tr><td colspan=\"2\"><b>Buildings.Media</b>
       </td>
   </tr>
   <tr><td valign=\"top\">Buildings.Media.Refrigerants.R410A
       </td>
       <td valign=\"top\">Model for thermodynamic properties of refrigerant R410A.
       </td>
   </tr>
   <tr><td valign=\"top\">Buildings.Media.Specialized.Water.ConstantProperties_pT
       </td>
       <td valign=\"top\">Model for liquid water with constant properties at user-selected temperature.<br/>
                          This closes
                          <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/511\">IBPSA, #511</a>.
       </td>
   </tr>
   <tr><td colspan=\"2\"><b>Buildings.Utilities.Math</b>
       </td>
   </tr>
   <tr><td valign=\"top\">Buildings.Utilities.Math.IntegratorWithReset
       </td>
       <td valign=\"top\">Integrator with optional input that allows
                          resetting the state if the input changes from <code>false</code>
                          to <code>true</code>.<br/>
                          This closes
                           <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/494\">IBPSA, #494</a>.
       </td>
   </tr>
   <tr><td colspan=\"2\"><b>Buildings.Utilities.Time</b>
       </td>
   </tr>
   <tr><td valign=\"top\">Buildings.Utilities.Time.CalendarTime
       </td>
       <td valign=\"top\">Block that outputs the calendar time, time of the week, hour of the day etc.<br/>
                          This closes
                          <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/501\">IBPSA, #501</a>.
       </td>
   </tr>

   </table>
   <!-- Backward compatible changes -->
   <p>
   The following <b style=\"color:blue\">existing components</b>
   have been <b style=\"color:blue\">improved</b> in a
   <b style=\"color:blue\">backward compatible</b> way:
   </p>
   <table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
   <tr><td colspan=\"2\"><b>Buildings.BoundaryConditions</b>
       </td>
   </tr>
   <tr><td valign=\"top\">Buildings.BoundaryConditions.WeatherData.BaseClasses.Examples.GetHeaderElement<br/>
                          Buildings.BoundaryConditions.WeatherData.BaseClasses.getAbsolutePath<br/>
                          Buildings.BoundaryConditions.WeatherData.BaseClasses.getHeaderElementTMY3<br/>
                          Buildings.BoundaryConditions.WeatherData.ReaderTMY3<br/>
                          Buildings.BoundaryConditions.SolarGeometry.ProjectedShadowLength
       </td>
       <td valign=\"top\">Refactored the use of <code>Modelica.Utilities.Files.loadResource</code>
                          to make the model work in JModelica.
                          This closes
                          <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/506\">issue 506</a>.
                          <br/>
                          Removed the use of <code>Modelica.Utilities.Files.fullPathName</code>
                          in <code>Buildings.BoundaryConditions.WeatherData.BaseClasses.getAbsolutePath
                          </code> which is implicitly done in <code>Modelica.Utilities.Files.loadResource.
                          </code>
                          <br/>
                          Removed in
                          <code>Buildings.BoundaryConditions.WeatherData.BaseClasses.getAbsolutePath
                          </code>the addition of <code>file://</code> to file names which do not start
                          with <code>file://</code>, or <code>modelica://</code>.
                          This is not required when using
                          <code>Modelica.Utilities.Files.loadResource</code>.
                          This closes
                          <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/539\">issue 539</a>.
                          </td>
       </tr>
       <tr><td valign=\"top\">Buildings.BoundaryConditions.WeatherData.ReaderTMY3
       </td>
       <td valign=\"top\">Shifted the computation of the infrared irradiation such that
                          the results in <code>Buildings.BoundaryConditions.SkyTemperature.Examples.BlackBody</code>
                          are consistent for both option of the black-body sky temperature calculation.
                          This closes
                          <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/648\">IBPSA, #648</a>.
       </td>
       </tr>
       <tr>
       <td valign=\"top\">Buildings.BoundaryConditions.SolarIrradiation.BaseClasses.SkyClearness
       </td>
       <td valign=\"top\">Reduced tolerance for regularization if the sky clearness is near one or eight.
                          This closes
                          <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/521\">IBPSA, #521</a>.

       </td>
   </tr>

   <tr><td colspan=\"2\"><b>Buildings.Controls</b>
       </td>
   </tr>
   <tr><td valign=\"top\">Buildings.Controls.Continuous.LimPID<br/>
                          Buildings.Controls.Continuous.PIDHysteresis<br/>
                          Buildings.Controls.Continuous.PIDHysteresisTimer<br/>
          </td>
          <td valign=\"top\">Added option to reset the control output when an optional Boolean input signal
                           changes from <code>false</code> to <code>true</code>.<br/>
                           This closes
                           <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/494\">IBPSA, #494</a>.
       </td>
   </tr>

   <tr><td colspan=\"2\"><b>Buildings.Electrical</b>
       </td>
   </tr>
   <tr><td valign=\"top\">Buildings.Electrical.DC.Storage.Examples.Battery
       </td>
       <td valign=\"top\">Replaced <code>Modelica_StateGraph2</code> with
                          <code>Modelica.StateGraph</code>.
                          This closes
                          <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/504\">issue 504</a>.
       </td>
   </tr>
   <tr><td colspan=\"2\"><b>Buildings.Examples</b>
       </td>
   </tr>
   <tr><td valign=\"top\">Buildings.Examples.DualFanDualDuct.ClosedLoop<br/>
                          Buildings.Examples.VAVReheat.ClosedLoop

       </td>
       <td valign=\"top\">Added hysteresis to the economizer control to avoid many events.
                          This change was done in
                          <code>Buildings.Examples.VAVReheat.Controls.EconomizerTemperatureControl</code>.
                          This closes
                          <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/502\">issue 502</a>.
       </td>
   </tr>
   <tr><td valign=\"top\">Buildings.Examples.DualFanDualDuct.ClosedLoop

       </td>
       <td valign=\"top\">Set <code>filteredSpeed=false</code> in fan models to avoid a large
                          increase in computing time when simulated between <i>t=1.60E7</i>
                          and <i>t=1.66E7</i>.

       </td>
   </tr>
   <tr><td valign=\"top\">Buildings.Examples.VAVReheat.ClosedLoop

       </td>
       <td valign=\"top\">Changed chilled water supply temperature to <i>6&deg;C</i>.
                          This closes
                          <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/509\">issue 509</a>.
       </td>
   </tr>
   <tr><td valign=\"top\">Buildings.Examples.ChillerPlant.BaseClasses.Controls.BatteryControl<br/>
                          Buildings.Examples.ChillerPlant.BaseClasses.Controls.WSEControl<br/>
                          Buildings.Examples.HydronicHeating.TwoRoomsWithStorage<br/>
                          Buildings.Examples.Tutorial.Boiler.System7
       </td>
       <td valign=\"top\">Replaced <code>Modelica_StateGraph2</code> with
                          <code>Modelica.StateGraph</code>.
                          This closes
                          <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/504\">issue 504</a>.
       </td>
   </tr>
   <tr><td colspan=\"2\"><b>Buildings.HeatTransfer</b>
       </td>
   </tr>
   <tr><td valign=\"top\">Buildings.HeatTransfer.Conduction.SingleLayer
       </td>
       <td valign=\"top\">Added option to place a state at the surface of a construction.
                          This closes
                          <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/565\">issue 565</a>.
       </td>
   </tr>
   <tr><td valign=\"top\">Buildings.HeatTransfer.Conduction.MultiLayer
       </td>
       <td valign=\"top\">Added option to place a state at the surface of a construction.
                          This closes
                          <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/565\">issue 565</a>.
       </td>
   </tr>
   <tr><td valign=\"top\">Buildings.HeatTransfer.Windows.Window
       </td>
       <td valign=\"top\">Added option to place a state at the surface of a construction.
                          This closes
                          <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/565\">issue 565</a>.
       </td>
   </tr>

   <tr><td valign=\"top\">Buildings.HeatTransfer.Windows.BeamDepthInRoom
       </td>
       <td valign=\"top\">Refactored the use of <code>Modelica.Utilities.Files.loadResource</code>.
                          This closes
                          <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/506\">issue 506</a>.
       </td>
   </tr>

   <tr><td colspan=\"2\"><b>Buildings.ThermalZones</b>
       </td>
   </tr>
   <tr><td valign=\"top\">Buildings.ThermalZones.Detailed.CFD<br/>
                          Buildings.ThermalZones.Detailed.BaseClasses.CFDExchange
       </td>
       <td valign=\"top\">Refactored the use of <code>Modelica.Utilities.Files.loadResource</code>.
                          This closes
                          <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/506\">issue 506</a>.
       </td>
   </tr>
   <tr><td valign=\"top\">Buildings.ThermalZones.Detailed.MixedAir<br/>
                          Buildings.ThermalZones.Detailed.CFD
       </td>
       <td valign=\"top\">Refactored the distribution of the diffuse solar irradiation.
                          Previously, the model assumed that all diffuse irradiation first hits the floor before it is
                          diffusely reflected to all other surfaces. Now, the incoming diffuse solar irradiation is distributed
                          to all surfaces, proportional to their emissivity plus transmissivity times area.
                          This closes
                          <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/451\">issue 451</a>.
       </td>
   </tr>
   </table>
   <!-- Non-backward compatible changes to existing components -->
   <p>
   The following <b style=\"color:blue\">existing components</b>
   have been <b style=\"color:blue\">improved</b> in a
   <b style=\"color:blue\">non-backward compatible</b> way:
   </p>
   <table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
   <tr><td colspan=\"2\"><b>Buildings.BoundaryConditions</b>
       </td>
   </tr>
   <tr><td valign=\"top\">Buildings.BoundaryConditions.WeatherData.BaseClasses.getHeaderElementTMY3
       </td>
       <td valign=\"top\">This function is used to read location coordinates
                          from the TMY3 weather data file. The call to
                          <code>Buildings.BoundaryConditions.WeatherData.BaseClasses.getAbsolutePath</code>
                          has been removed as it calls the function
                          <a href=\"modelica://Modelica.Utilities.Files.loadResource\">
                          Modelica.Utilities.Files.loadResource</a>, whose return value needs
                          to be known at compilation time to store the weather data in the FMU.
                          This is not supported by JModelica.
                          Most models should still work as this call has been added at a higher level
                          of the model hierarchy. If models don't work, add a call to <code>loadResource</code>
                          at the top-level.
                          This closes
                          <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/506\">Buildings, #506</a>.
       </td>
   </tr>
   <tr><td colspan=\"2\"><b>Buildings.Controls</b>
       </td>
   </tr>
   <tr><td valign=\"top\">Buildings.Controls.Continuous.PIDHysteresis
       </td>
       <td valign=\"top\">Set <code>zer(final k=0)</code> and made
                          <code>swi</code>, <code>zer</code> and
                          <code>zer1</code> protected, as they are for
                          <a href=\"modelica://Buildings.Controls.Continuous.PIDHysteresis\">
                          Buildings.Controls.Continuous.PIDHysteresis</a>.
                          Only models that access these instances, which typically is not the case,
                          are affected by this change.
       </td>
   </tr>
   <tr><td valign=\"top\">Buildings.Controls.Continuous.LimPID<br/>
                          Buildings.Controls.Continuous.PIDHysteresis<br/>
                          Buildings.Controls.Continuous.PIDHysteresisTimer<br/>
          </td>
          <td valign=\"top\">Removed the parameter <code>limitsAtInit</code> as
                           it is not used.<br/>
                           For Dymola, the conversion script will update models that set this parameter.<br/>
       </td>
   </tr>
   <tr><td valign=\"top\">Buildings.Controls.SetPoints.Table
       </td>
       <td valign=\"top\">Changed protected final parameter <code>nCol</code> to <code>nRow</code>.<br/>
                          For Dymola, the conversion script will update models that access this parameter.<br/>
                          This is for
                          <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/555\">issue 555</a>.
       </td>
   </tr>

   <tr><td colspan=\"2\"><b>Buildings.Fluid.Actuators</b>
       </td>
   </tr>

   <tr><td valign=\"top\">Buildings.Fluid.Actuators.Dampers.Exponential<br/>
                          Buildings.Fluid.Actuators.Dampers.MixingBox<br/>
                          Buildings.Fluid.Actuators.Dampers.MixingBoxMinimumFlow<br/>
                          Buildings.Fluid.Actuators.Dampers.VAVBoxExponential<br/>
                          Buildings.Fluid.Actuators.Dampers.MixingBoxMinimumFlow<br/>
                          Buildings.Fluid.Actuators.Valves.ThreeWayEqualPercentageLinear<br/>
                          Buildings.Fluid.Actuators.Valves.ThreeWayLinear<br/>
                          Buildings.Fluid.Actuators.Valves.TwoWayEqualPercentage<br/>
                          Buildings.Fluid.Actuators.Valves.TwoWayLinear<br/>
                          Buildings.Fluid.Actuators.Valves.TwoWayPressureIndependent<br/>
                          Buildings.Fluid.Actuators.Valves.TwoWayQuickOpening<br/>
                          Buildings.Fluid.Actuators.Valves.TwoWayTable
       </td>
       <td valign=\"top\">Renamed the parameter
                          <code>filteredOpening</code> to
                          <code>use_inputFilter</code>.<br/>
                          For Dymola, the conversion script will update models that access this parameter.<br/>
                          This is for
                          <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/665\">IBPSA, #665</a>
       </td>
   </tr>

   <tr><td valign=\"top\">Buildings.Fluid.Actuators.Dampers.Exponential<br/>
                          Buildings.Fluid.Actuators.Dampers.MixingBox<br/>
                          Buildings.Fluid.Actuators.Dampers.MixingBoxMinimumFlow<br/>
                          Buildings.Fluid.Actuators.Dampers.VAVBoxExponential<br/>
                          Buildings.Fluid.Actuators.Dampers.MixingBoxMinimumFlow
       </td>
       <td valign=\"top\">Renamed the parameters
                          <code>use_v_nominal</code> and all area related parameters,
                          because <code>m_flow_nominal</code> and <code>v_nominal</code>
                          are used to compute the area.<br/>
                          For Dymola, the conversion script will update models that access this parameter.<br/>
                          This is for
                          <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/544\">IBPSA, #544</a>
       </td>
   </tr>

   <tr><td colspan=\"2\"><b>Buildings.Fluid.Chillers</b>
       </td>
   </tr>
   <tr><td valign=\"top\">Buildings.Fluid.Chillers.Carnot_TEva<br/>
                          Buildings.Fluid.Chillers.Carnot_y
       </td>
       <td valign=\"top\">Removed the parameters
                          <code>effInpEva</code> and
                          <code>effInpCon</code>.
                          Now, always the leaving water temperatures are used to compute the coefficient
                          of performance (COP). Previously, the
                          entering water temperature could be used, but this can give COPs that are higher than
                          the Carnot efficiency if the temperature lift is small.
                          For Dymola, the conversion script will update models.<br/>
                          This is for
                          <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/497\">IBPSA, #497</a>
       </td>
   </tr>

   <tr><td colspan=\"2\"><b>Buildings.Fluid.FixedResistances</b>
       </td>
   </tr>
   <tr><td valign=\"top\">Buildings.Fluid.FixedResistances.FixedResistanceDpM
       </td>
       <td valign=\"top\">Renamed
                          <code>Buildings.Fluid.FixedResistances.FixedResistanceDpM</code> to
                          <code>Buildings.Fluid.FixedResistances.PressureDrop</code>
                          and removed the parameters <code>use_dh</code>, <code>dh</code> and <code>ReC</code>.
                          For Dymola, the conversion script will update models.
                          If a model needs to be used that allows specifying <code>dh</code> and <code>ReC</code>,
                          then the new model
                          <code>Buildings.Fluid.FixedResistances.HydraulicDiameter</code> can be used.
       </td>
   </tr>
   <tr><td valign=\"top\">Buildings.Fluid.FixedResistances.SplitterFixedResistanceDpM
       </td>
       <td valign=\"top\">Renamed
                          <code>Buildings.Fluid.FixedResistances.SplitterFixedResistanceDpM</code> to
                          <code>Buildings.Fluid.FixedResistances.Junction</code>
                          and removed the parameters <code>use_dh</code>, <code>dh</code> and <code>ReC</code>.
                          For Dymola, the conversion script will update models.
                          If a model needs to be used that allows specifying <code>dh</code> and <code>ReC</code>,
                          then use <code>Buildings.Fluid.FixedResistances.Junction</code> with
                          <code>dp_nominal = 0</code> (which removes the pressure drop) and use
                          <code>Buildings.Fluid.FixedResistances.HydraulicDiameter</code> at each fluid port.
       </td>
   </tr>

   <tr><td colspan=\"2\"><b>Buildings.Fluid.FMI</b>
       </td>
   </tr>
   <tr><td valign=\"top\">Buildings.Fluid.FMI.InletAdaptor<br/>
                          Buildings.Fluid.FMI.OutletAdaptor<br/>
                          Buildings.Fluid.FMI.TwoPort<br/>
                          Buildings.Fluid.FMI.TwoPortComponent
       </td>
       <td valign=\"top\">Renamed
                          <code>Buildings.Fluid.FMI.InletAdaptor</code> to
                          <code>Buildings.Fluid.FMI.Adaptors.Inlet</code>,<br/>
                          renamed
                          <code>Buildings.Fluid.FMI.OutletAdaptor</code> to
                          <code>Buildings.Fluid.FMI.Adaptors.Outlet</code>,<br/>
                          renamed
                          <code>Buildings.Fluid.FMI.TwoPort</code> to
                          <code>Buildings.Fluid.FMI.ExportContainers.PartialTwoPort</code>,<br/>
                          renamed
                          <code>Buildings.Fluid.FMI.TwoPortComponent</code> to
                          <code>Buildings.Fluid.FMI.ExportContainers.ReplaceableTwoPort</code>.
                          This was due to the restructuring of the <code>Buildings.Fluid.FMI</code>
                          package for
                          <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/506\">Buildings, #506</a>.<br/>
                          For Dymola, the conversion script updates these models.
       </td>
   </tr>

   <tr><td colspan=\"2\"><b>Buildings.Fluid.HeatExchangers</b>
       </td>
   </tr>
   <tr><td valign=\"top\">
                          Buildings.Fluid.HeatExchangers.DXCoils.AirCooled.SingleSpeed<br/>
                          Buildings.Fluid.HeatExchangers.DXCoils.AirCooled.VariableSpeed<br/>
                          Buildings.Fluid.HeatExchangers.DXCoils.AirCooled.MultiStage<br/>
                          Buildings.Fluid.HeatExchangers.DXCoils.Data
       </td>
       <td valign=\"top\">Renamed
                          <code>Buildings.Fluid.HeatExchangers.DXCoils.AirCooled.SingleSpeed</code> to<br/>
                          <code>Buildings.Fluid.HeatExchangers.DXCoils.AirCooled.SingleSpeed</code>,<br/>
                          <code>Buildings.Fluid.HeatExchangers.DXCoils.AirCooled.VariableSpeed</code> to<br/>
                          <code>Buildings.Fluid.HeatExchangers.DXCoils.AirCooled.VariableSpeed</code>,<br/>
                          <code>Buildings.Fluid.HeatExchangers.DXCoils.AirCooled.MultiStage</code> to<br/>
                          <code>Buildings.Fluid.HeatExchangers.DXCoils.AirCooled.MultiStage</code> and<br/>
                          <code>Buildings.Fluid.HeatExchangers.DXCoils.Data</code> to<br/>
                          <code>Buildings.Fluid.HeatExchangers.DXCoils.AirCooled.Data</code>.<br/>
                          This was due to the addition of the new package
                          <code>Buildings.Fluid.HeatExchangers.DXCoils.WaterCooled</code>.
                          This is for
                          <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/635\">Buildings, #635</a>.<br/>
                          For Dymola, the conversion script updates these models.
       </td>
   </tr>

   <tr><td colspan=\"2\"><b>Buildings.Fluid.HeatPumps</b>
       </td>
   </tr>
   <tr><td valign=\"top\">Buildings.Fluid.HeatPumps.Carnot_TEva<br/>
                          Buildings.Fluid.HeatPumps.Carnot_y
       </td>
       <td valign=\"top\">Removed the parameters
                          <code>effInpEva</code> and
                          <code>effInpCon</code>.
                          Now, always the leaving water temperatures are used to compute the coefficient
                          of performance (COP). Previously, the
                          entering water temperature could be used, but this can give COPs that are higher than
                          the Carnot efficiency if the temperature lift is small.
                          For Dymola, the conversion script will update models.<br/>
                          This is for
                          <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/497\">IBPSA, #497</a>
       </td>
   </tr>

   <tr><td valign=\"top\">Buildings.Fluid.HeatExchangers.Boreholes
       </td>
       <td valign=\"top\">Moved the package <code>Buildings.Fluid.HeatExchangers.Boreholes</code> to
                          <code>Buildings.Fluid.Geothermal.Boreholes</code>.
                          This is for compatibility with an ongoing model development that will include
                          a borefield model.<br/>
                          For Dymola, the conversion script will update models that use any model of the package
                          <code>Buildings.Fluid.HeatExchangers.Boreholes</code>.
       </td>
   </tr>
   <tr><td valign=\"top\">Buildings.Fluid.Movers
       </td>
       <td valign=\"top\">Removed the function
                          <code>Buildings.Fluid.Movers.BaseClasses.Characteristics.flowApproximationAtOrigin</code>
                          and changed the arguments of the function
                          <code>Buildings.Fluid.Movers.BaseClasses.Characteristics.pressure</code>.<br/>
                          This was done due to the refactoring of the fan and pump model for low speed. This is for
                          <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/458\">IBPSA, #458</a>.<br/>
                          Users who simply use the existing model in <code>Buildings.Fluid.Movers</code> are not affected by
                          this change as the function are called by a low-level implementation only.
       </td>
   </tr>

   <tr><td valign=\"top\">Buildings.Fluid.Movers.
                          Buildings.Fluid.Movers.FlowControlled_dp<br/>
                          Buildings.Fluid.Movers.FlowControlled_m_flow<br/>
                          Buildings.Fluid.Movers.SpeedControlled_Nrpm<br/>
                          Buildings.Fluid.Movers.SpeedControlled_y
       </td>
       <td valign=\"top\">Renamed the parameter
                          <code>filteredSpeed</code> to
                          <code>use_inputFilter</code>.<br/>
                          For Dymola, the conversion script will update models that access this parameter.<br/>
                          This is for
                          <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/665\">IBPSA, #665</a>
       </td>
   </tr>

   <tr><td valign=\"top\">Buildings.Fluid.HeatExchangers.CoolingTowers
       </td>
       <td valign=\"top\">Changed the name of the function
                          <code>Buildings.Fluid.HeatExchangers.CoolingTowers.BaseClasses.Characteristics.efficiency</code>
                          to
                          <code>Buildings.Fluid.HeatExchangers.CoolingTowers.BaseClasses.Characteristics.normalizedPower</code>.
                          Changed the name of the record
                          <code>Buildings.Fluid.HeatExchangers.CoolingTowers.BaseClasses.Characteristics.efficiencyParameters</code>
                          to
                          <code>Buildings.Fluid.HeatExchangers.CoolingTowers.BaseClasses.Characteristics.fan</code>,
                          and changed the parameter of this record from
                          <code>eta</code> to <code>r_P</code>.
                          This change was done as the performance is for the relative power consumption, and not the fan
                          efficiency, as the old parameter name suggests.
                          Users who use the default parameters are not affected by this change.
                          If the default parameters were changed, then for Dymola,
                          the conversion script will update the model.
       </td>
   </tr>
   <tr><td colspan=\"2\"><b>Buildings.HeatTransfer</b>
       </td>
   </tr>
       <tr><td valign=\"top\">Buildings.HeatTransfer.BaseClasses.TransmittedRadiation<br/>
                              Buildings.HeatTransfer.BaseClasses.WindowRadiation
       </td>
       <td valign=\"top\">Refactored the model to allow separate treatment for the diffuse and direct irradiation,
                          which is needed for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/451\">issue 451</a>.
       </td>
    </tr>

    <tr><td valign=\"top\">Buildings.HeatTransfer.Conduction.BaseClasses.PartialConstruction
       </td>
       <td valign=\"top\">Removed parameter <code>A</code> as it is already declared in
                          <a href=\"modelica://Buildings.HeatTransfer.Conduction.BaseClasses.PartialConductor\">
                          Buildings.HeatTransfer.Conduction.BaseClasses.PartialConductor</a>
                          which is often used with this class.
       </td>
    </tr>

   <tr><td colspan=\"2\"><b>Buildings.ThermalZones</b>
       </td>
   </tr>
   <tr><td valign=\"top\">Buildings.ThermalZones.Detailed

       </td>
       <td valign=\"top\">Moved package from <code>Buildings.Rooms</code> to <code>Buildings.ThermalZones.Detailed</code>.
                          This was done because <code>Buildings</code> has a new package
                          <code>Buildings.ThermalZones.ReducedOrder</code> with reduced order building models.
                          Hence, the more detailed room models should be in the same top-level package as they
                          are also for modeling of thermal zones.<br/>
                          For Dymola, the conversion script will update models that use any model of the package
                          <code>Buildings.ThermalZones</code>.
       </td>
   </tr>

   <tr><td valign=\"top\">Buildings.ThermalZones.Detailed.CFD<br/>
                          Buildings.ThermalZones.Detailed.MixedAir<br/>
                          Buildings.ThermalZones.Detailed.BaseClasses.CFDAirHeatMassBalance<br/>
                          Buildings.ThermalZones.Detailed.BaseClasses.MixedAirHeatMassBalance<br/>
                          Buildings.ThermalZones.Detailed.BaseClasses.PartialAirHeatMassBalance<br/>
                          Buildings.ThermalZones.Detailed.BaseClasses.RoomHeatMassBalance

       </td>
       <td valign=\"top\">Refactored implementation of latent heat gain for
                          <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/515\">Buildings, #515</a>.
                          Users who simply use <code>Buildings.MixedAir.Rooms.CFD</code> or
                          <code>Buildings.MixedAir.Rooms.MixedAir</code> will not be affected by this change,
                          except if they access variables related to the heat gain.

       </td>
   </tr>
   <tr><td valign=\"top\">Buildings.ThermalZones.Detailed.BaseClasses.AirHeatMassBalanceMixed<br/>
                          Buildings.ThermalZones.Detailed.BaseClasses.MixedAirHeatGain
       </td>
       <td valign=\"top\">Removed models as these are no longer needed due after the refactoring
                          of the room model for
                          <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/515\">Buildings, #515</a>.
       </td>
    </tr>
    <tr><td valign=\"top\">Buildings.ThermalZones.Detailed.BaseClasses.RoomHeatMassBalance<br/>
                           Buildings.ThermalZones.Detailed.BaseClasses.SolarRadiationExchange
       </td>
       <td valign=\"top\">Refactored the distribution of the diffuse solar irradiation, which required replacing the
                          input and output signals.
                          Previously, the model assumed that all diffuse irradiation first hits the floor before it is
                          diffusely reflected to all other surfaces. Now, the incoming diffuse solar irradiation is distributed
                          to all surfaces, proportional to their emissivity plus transmissivity times area.<br/>
                          This closes
                          <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/451\">issue 451</a>.
"    +
    "       </td>
    </tr>

   <tr><td valign=\"top\">Buildings.ThermalZones.Detailed.BaseClasses.CFDHeatGain
       </td>
       <td valign=\"top\">Renamed model from <code>Buildings.ThermalZones.Detailed.BaseClasses.CFDHeatGain</code> to
                          <code>Buildings.ThermalZones.Detailed.BaseClasses.HeatGain</code>.<br/>
                          This is for
                          <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/515\">Buildings, #515</a>.
       </td>
   </tr>

   <tr><td valign=\"top\">Buildings.ThermalZones.Detailed.BaseClasses.CFDExchange
       </td>
       <td valign=\"top\">Removed the parameter <code>uStart</code> as it is not required. As this is in a base
                          class, users typically won't need to change their models
                          unless they use this base class directly.<br/>
                          This is for
                          <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/579\">Buildings, #579</a>.
       </td>
   </tr>

   <tr><td colspan=\"2\"><b>Buildings.Utilities</b>
       </td>
   </tr>
       <tr><td valign=\"top\">Buildings.Utilities.Psychrometrics.WetBul_pTX
       </td>
       <td valign=\"top\">Deleted the model
                          <code>Buildings.Utilities.Psychrometrics.WetBul_pTX</code>
                          as the same functionality is provided by
                          <code>Buildings.Utilities.Psychrometrics.TWetBul_TDryBulXi</code>.
                          Users who use <code>Buildings.Utilities.Psychrometrics.WetBul_pTX</code>
                          need to replace the model manually and reconnect the input and output ports.<br/>
                          This is for
                          <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/475\">IBPSA, #475</a>.
       </td>
    </tr>

   </table>
   <!-- Errors that have been fixed -->
   <p>
   The following <b style=\"color:red\">critical errors</b> have been fixed (i.e., errors
   that can lead to wrong simulation results):
   </p>
   <table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
   <tr><td colspan=\"2\"><b>Buildings.Fluid</b>
       </td>
   </tr>
   <tr><td valign=\"top\">Buildings.Fluid.HeatExchangers.DXCoils.AirCooled.MultiStage<br/>
                          Buildings.Fluid.HeatExchangers.DXCoils.AirCooled.SingleSpeed<br/>
                          Buildings.Fluid.HeatExchangers.DXCoils.AirCooled.VariableSpeed<br/>
                          Buildings.Fluid.HeatExchangers.DXCoils.AirCooled.BaseClasses.Evaporation
       </td>
       <td valign=\"top\">Corrected the computation of the wet bulb state in the model
                          that computes the reevaporation of water vapor into the air stream when the coil
                          is switched off. The results change slightly.
                          This closes <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/520\">issue 520</a>
                          and integrates the change of
                          <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/474\">IBPSA, #474</a>.

       </td>
   </tr>
   <tr><td valign=\"top\">Buildings.Fluid.Storage.StratifiedEnhancedInternalHex
       </td>
       <td valign=\"top\">Corrected computation of the heat exchanger location which was wrong
                          if <code>hHex_a &lt; hHex_b</code>, e.g., the port a of the heat exchanger
                          is below the port b.
                          This closes
                          <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/531\">issue 531</a>.
       </td>
   </tr>   <tr><td colspan=\"2\"><b>Buildings.Examples</b>
       </td>
   </tr>
   <tr><td valign=\"top\">Buildings.Examples.VAVReheat.ClosedLoop<br/>
                          Buildings.Examples.DualFanDualDuct.ClosedLoop<br/>
                          Buildings.Examples.VAVReheat.Controls.Economizer
       </td>
       <td valign=\"top\">Corrected the economizer controller which closed
                          the outside air when there was no freeze concern during summer.
                          This closes <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/511\">issue 511</a>.
       </td>
   </tr>
   </table>
   <!-- Uncritical errors -->
   <p>
   The following <b style=\"color:red\">uncritical errors</b> have been fixed (i.e., errors
   that do <b style=\"color:red\">not</b> lead to wrong simulation results, e.g.,
   units are wrong or errors in documentation):
   </p>
   <table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
   <tr><td colspan=\"2\"><b>Buildings.Electrical</b>
       </td>
   </tr>
   <tr><td valign=\"top\">Buildings.Electrical.AC.OnePhase.Sources.Grid<br/>
                          Buildings.Electrical.AC.ThreePhasesUnbalanced.Sources.Grid<br/>
                          Buildings.Electrical.AC.ThreePhasesUnbalanced.Sources.Grid_N
       </td>
       <td valign=\"top\">Corrected sign error in documentation string of
                          variable <code>P</code>.
       </td>
   </tr>
   <tr><td colspan=\"2\"><b>Buildings.Fluid</b>
       </td>
   </tr>
   <tr><td valign=\"top\">Buildings.Fluid.HeatExchanger.WetCoilCounterFlow<br/>
                          Buildings.Fluid.HeatExchanger.WetCoilDiscretized
       </td>
       <td valign=\"top\">Redeclared <code>Medium2</code> to force it to be a subclass
                          of <code>Modelica.Media.Interfaces.PartialCondensingGases</code>.<br/>
                          This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/544\">
                          issue 544</a>.
       </td>
   </tr>
   <tr><td valign=\"top\">Buildings.Fluid.Storage
       </td>
       <td valign=\"top\">Removed medium declaration, which is not needed and inconsistent with
                          the declaration in the base class.<br/>
                          This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/544\">
                          issue 544</a>.
       </td>
   </tr>
   <tr><td colspan=\"2\"><b>Buildings.ThermalZones.Detailed.Validation.BESTEST</b>
       </td>
   </tr>
   <tr><td valign=\"top\">Buildings.ThermalZones.Detailed.Validation.BESTEST.Cases9xx.Case900<br/>
                          Buildings.ThermalZones.Detailed.Validation.BESTEST.Cases9xx.Case900
       </td>
       <td valign=\"top\">Added missing <code>parameter</code> keyword,
                          which is required as the variable (for the materials) is assigned to a parameter.
                          This is for
                          <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/543\">issue 543</a>.
       </td>
   </tr>
   </table>
   </html>"));
   end Version_4_0_0;

   class Version_3_0_0 "Version 3.0.0"
     extends Modelica.Icons.ReleaseNotes;
       annotation (Documentation(info="<html>
   <div class=\"release-summary\">
   <p>
   Version 3.0.0 is a major new release.
   </p>
   <p>
     The following major changes have been done:
   <ul>
     <li>
       Electrochromic windows have been added. See <code>Buildings.ThermalZones.Detailed.Examples.ElectroChromicWindow</code>.
     </li>
     <li>
       The models in <code>Buildings.Fluid.Movers</code> can now be configured to use
       three different control input signals: a continuous signal (depending on the model
       either normalized speed, speed in rpm, prescribed mass flow rate or prescribed head),
       discrete stages of these quantities, or on/off.
       The models also have been refactored to make their implementation clearer.
     </li>
     <li>
       The new package <code>Buildings.Fluid.HeatPumps</code> has been added.
       This package contains models for idealized heat pumps
       whose COP changes proportional to the change in COP of a Carnot cycle,
       with an optional correction for the part load efficiency.
     </li>
     <li>
       Various models, in particular in the package <code>Buildings.Electrical</code>,
       have been reformulated to comply with the Modelica Language Definition.
       All models comply with the pedantic Modelica check of Dymola.
     </li>
   </ul>
   </div>
   <!-- New libraries -->
   <p>
   The following <b style=\"color:blue\">new libraries</b> have been added:
   </p>
   <table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\">
   <tr><td valign=\"top\">Buildings.Fluid.HeatPumps
       </td>
       <td valign=\"top\">Library with heat pump models.
                          This library contains models for idealized heat pumps
                          whose COP changes proportional to the change in COP of a Carnot cycle.
                          Optionally, a part load efficiency curve can be specified.
                          The model <code>Buildings.Fluid.HeatPumps.Carnot_TCon</code>
                          takes as a control input the leaving
                          condenser fluid temperature, and the model
                          <code>Buildings.Fluid.HeatPumps.Carnot_y</code> takes as
                          a control signal the compressor speed.
       </td>
       </tr>
   </table>
   <!-- New components for existing libraries -->
   <p>
   The following <b style=\"color:blue\">new components</b> have been added
   to <b style=\"color:blue\">existing</b> libraries:
   </p>
   <table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
   <tr><td colspan=\"2\"><b>Buildings.BoundaryConditions.SolarGeometry</b>
       </td>
   </tr>
   <tr><td valign=\"top\">Buildings.BoundaryConditions.SolarGeometry.ProjectedShadowLength
       </td>
       <td valign=\"top\">Block that computes the length of a shadow projected onto a horizontal plane
                          into the direction that is perpendicular to the azimuth of a surface.
       </td>
       </tr>
   <tr><td colspan=\"2\"><b>Buildings.Electrical</b>
       </td>
   </tr>
   <tr><td valign=\"top\">Buildings.Electrical.AC.ThreePhasesUnbalanced.Interfaces.Adapter3to3<br/>
                        Buildings.Electrical.AC.ThreePhasesUnbalanced.Interfaces.Connection3to3Ground_n<br/>
                        Buildings.Electrical.AC.ThreePhasesUnbalanced.Interfaces.Connection3to3Ground_p
       </td>
       <td valign=\"top\">Adapters for unbalanced three phase systems which are required because
                        the previous formulation used connect statements that violate the Modelica
                        Language Definition. This change was required to enable pedantic model check and translation
                        in Dymola 2016 FD01.
                          This is for
                          <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/426\">#426</a>.
       </td>
       </tr>

   <tr><td colspan=\"2\"><b>Buildings.Fluid.Chillers</b>
       </td>
   </tr>
   <tr><td valign=\"top\">Buildings.Fluid.Chillers.Carnot_TEva
       </td>
       <td valign=\"top\">Chiller model whose efficiency changes with temperatures
                          similarly to a change in Carnot efficiency. The control input signal
                          is the evaporator leaving fluid temperature.
                          This is for
                          <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/353\">IBPSA, #353</a>.
       </td>
       </tr>
   <tr><td colspan=\"2\"><b>Buildings.Fluid.Sensors</b>
       </td>
   </tr>
   <tr><td valign=\"top\">Buildings.Fluid.Sensors.PPM<br/>
                          Buildings.Fluid.Sensors.PPMTwoPort
       </td>
       <td valign=\"top\">Sensors that measure trace substances in parts per million.
       </td>
       </tr>
   <tr><td colspan=\"2\"><b>Buildings.HeatTransfer.Windows</b>
       </td>
   </tr>
   <tr><td valign=\"top\">Buildings.HeatTransfer.Windows.BeamDepthInRoom
       </td>
       <td valign=\"top\">Block that computes the maximum distance at which
                          a solar beam that enters the window hits the workplane.
       </td>
       </tr>
   <tr><td colspan=\"2\"><b>Buildings.Utilities.Math</b>
       </td>
   </tr>
   <tr><td valign=\"top\">Buildings.Utilities.Math.Functions.smoothInterpolation
       </td>
       <td valign=\"top\">Function that interpolates for vectors <code>xSup[]</code>, <code>ySup[]</code>
                          and independent variable <code>x</code>.
                          The interpolation is done using a cubic Hermite spline with linear extrapolation.
       </td>
       </tr>
   </table>
   <!-- Backward compatible changes -->
   <p>
   The following <b style=\"color:blue\">existing components</b>
   have been <b style=\"color:blue\">improved</b> in a
   <b style=\"color:blue\">backward compatible</b> way:
   </p>
   <table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
   <tr><td colspan=\"2\"><b>Buildings.Fluid</b>
       </td>
   </tr>

   <tr><td valign=\"top\">Buildings.Fluid.Actuators.Valves.ThreeWayEqualPercentageLinear<br/>
                          Buildings.Fluid.Actuators.Valves.ThreeWayLinear
    </td>
    <td valign=\"top\">Changed the default value for valve leakage
                       parameter <code>l</code> from <code>0</code> to <code>0.0001</code>.
                       This is the same value as is used for the two-way valves,
                       and avoids an assertion that would be triggered if <code>l=0</code>.
    </td>
    </tr>

    <tr><td valign=\"top\">Buildings.Fluid.Geothermal.Boreholes.UTube
       </td>
       <td valign=\"top\">Updated code for 64 bit on Linux and Windows.
                          This closes
                          <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/485\">issue 485</a>.
       </td>
    </tr>

   <tr><td valign=\"top\">Buildings.Fluid.HeatExchangers.DryEffectivenessNTU
    </td>
    <td valign=\"top\">Reformulated model to allow translation in OpenModelica.
                       This is for issue
                        <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/490\">#490</a>.
    </td>
   </tr>

   <tr><td valign=\"top\">Buildings.Fluid.Chillers.Carnot
    </td>
    <td valign=\"top\">Changed the sign convention for <code>dTEva_nominal</code>.
                       Now, this quantity needs to be negative.
                       This change was done to be consistent with other models.
                       In this version, a warning will be written if the sign
                       is not updated, but the results will be the same.
                       In future versions the warning will be
                       changed to an error.<br/>
                       The parameters <code>dTEva_nominal</code> and
                       <code>dTCon_nominal</code> are now used
                       to assign default values for the nominal mass flow rates.
    </td>
   </tr>

   <tr><td valign=\"top\">Buildings.Fluid.MixingVolumes.MixingVolume<br/>
                          Buildings.Fluid.MixingVolumes.MixingVolumeMoistAir
    </td>
    <td valign=\"top\">Added the parameter <code>use_C_flow</code>. If set
                       to <code>true</code>, an input connector will be enabled that can be used
                       to add a trace substance flow rate, such as CO2, to the volume.
    </td>
   </tr>

   <tr><td valign=\"top\">Buildings.Fluid.Movers.FlowControlled_dp<br/>
                          Buildings.Fluid.Movers.FlowControlled_m_flow<br/>
                          Buildings.Fluid.Movers.FlowControlled_Nrpm<br/>
                          Buildings.Fluid.Movers.FlowControlled_y
    </td>
    <td valign=\"top\">Added the parameter <code>inputType</code> which allows
                       to set the input as an continuous input signal,
                       to set the input as an Integer input signal that selects the stage of the mover,
                       or to remove the input connector and use a parameter
                       to assign the control signal.
    </td>
   </tr>

   <tr><td valign=\"top\">Buildings.Fluid.Storage.StratifiedEnhancedInternalHex
       </td>
       <td valign=\"top\">Added option to set dynamics of heat exchanger material
                        separately from the dynamics of the fluid inside the heat
                        exchanger.
                        This is for issue
                        <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/434\">#434</a>.
       </td>
   </tr>
   <tr><td valign=\"top\">Buildings.Fluid.Interfaces.FourPortHeatMassExchanger<br/>
                          Buildings.Fluid.Interfaces.TwoPortHeatMassExchanger

       </td>
       <td valign=\"top\">Propagated parameter <code>allowFlowReversal</code>
                          which can cause a simpler energy balance to be used.
       </td>
   </tr>
   <tr><td valign=\"top\">Buildings.Fluid.Interfaces.PartialTwoPortTransport

       </td>
       <td valign=\"top\">Implemented more efficient computation of <code>port_a.Xi_outflow</code>
                          and <code>port_a.C_outflow</code> when <code>allowFlowReversal=false</code>.
                          This is for
                          <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/305\">IBPSA issue 305</a>.
       </td>
   </tr>
   <tr><td valign=\"top\">Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_dp<br/>
                        Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_m_flow

       </td>
       <td valign=\"top\">Refactored for a more efficient implementation.
                        Removed double declaration of <code>smooth(..)</code> and <code>smoothOrder</code>
                        and changed <code>Inline=true</code> to <code>LateInline=true</code>.
                        This is for
                        <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/301\">IBPSA issue 301</a>
                        and for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/279\">IBPSA issue 279</a>.
       </td>
   </tr>
   <tr><td colspan=\"2\"><b>Buildings.ThermalZones</b>
       </td>
   </tr>
   <tr><td valign=\"top\">Buildings.ThermalZones.Detailed.BaseClasses.CFDExchange
       </td>
       <td valign=\"top\">Set <code>start</code> and <code>fixed</code>
                          attributes in
                          <code>u[nWri](start=_uStart, each fixed=true)</code>
                          to avoid a warning in Dymola 2016 about unspecified initial conditions.
                          This closes
                          <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/422\">issue 422</a>.<br/>
                          Set <code>start</code> and <code>fixed</code>
                          attributes in
                          <code>firstTrigger(start=false, fixed=true)</code>,
                          <code>retVal(start=0, fixed=true)</code> and <code>modTimRea(fixed=false)</code>
                          to avoid such a warning in the pedantic Modelica check in Dymola 2016.
                          This closes
                          <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/459\">issue 459</a>.
       </td>
   </tr>
   <tr><td valign=\"top\">Buildings.ThermalZones.Detailed.CFD
       </td>
       <td valign=\"top\">Updated code for 64 bit on Linux and Windows.
                          This closes
                          <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/485\">issue 485</a>.
       </td>
   </tr>
   <tr><td valign=\"top\">Buildings.Utilities.Math.Functions
       </td>
       <td valign=\"top\">Refactored <code>Buildings.Utilities.Math.Functions.inverseXRegularized</code>
                        to make it more efficient as it is used in many steady-state energy balances.
                          This closes
                          <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/302\">IBPSA issue 302</a>.
       </td>
   </tr>
  </table>
   <!-- Non-backward compatible changes to existing components -->
   <p>
   The following <b style=\"color:blue\">existing components</b>
   have been <b style=\"color:blue\">improved</b> in a
   <b style=\"color:blue\">non-backward compatible</b> way:
   </p>
   <table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
    <tr><td colspan=\"2\"><b>Buildings.BoundaryConditions</b>
       </td>
   </tr>
   <tr><td valign=\"top\">Buildings.BoundaryConditions.SkyTemperature.BlackBody<br/>
                          Buildings.BoundaryConditions.WeatherData.Bus
     </td>
       <td valign=\"top\">Renamed the connector from <code>radHorIR</code> to <code>HHorIR</code>
                          This is for
                          <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/376\">IBPSA issue 376</a>.
                          For Dymola, the conversion script updates these connections.
                          However, this also results in a renaming of the weather bus variable
                          <code>weaBus.radHorIR</code> to <code>HHorIR</code>, which may
                          require a manual update.
       </td>
     </tr>

    <tr><td colspan=\"2\"><b>Buildings.Fluid</b>
       </td>
   </tr>
   <tr><td valign=\"top\">Buildings.Fluid.Interfaces.StaticTwoPortConservationEquation
     </td>
     <td valign=\"top\">Removed the constant <code>sensibleOnly</code> and
                        introduced instead the parameter <code>use_mWat_flow</code>.
                        The new parameter, if set to <code>true</code>, will enable an input connector
                        that can be used to add water to the conservation equation..
                        For Dymola, the conversion script updates the model for these changes.
     </td>
   </tr>
   <tr><td valign=\"top\">Buildings.Fluid.Chillers.Carnot
     </td>
     <td valign=\"top\">Renamed the model to  <code>Buildings.Fluid.Chillers.Carnot_y</code>
                        due to the addition of the new model <code>Buildings.Fluid.Chillers.Carnot_TEva</code>.
                        In addition, the following parameter names were changed:
                        <code>use_eta_Carnot</code> was changed to <code>use_eta_Carnot_nominal</code>, and
                        <code>etaCar</code> was changed to <code>etaCarnot_nominal</code>.
                        This is for
                        <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/353\">IBPSA issue 353</a>.
                        For Dymola, the conversion script removes these parameters.
     </td>
   </tr>
   <tr><td valign=\"top\">Buildings.Fluid.Movers.FlowControlled_dp<br/>
                          Buildings.Fluid.Movers.FlowControlled_m_flow<br/>
                          Buildings.Fluid.Movers.FlowControlled_Nrpm<br/>
                          Buildings.Fluid.Movers.FlowControlled_y
     </td>
     <td valign=\"top\">Removed the parameters <code>use_powerCharacteristics</code>
                        and <code>motorCooledByFluid</code> as these are already
                        declared in the performance data record <code>per</code>.
                        This is for issue
                        <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/434\">#457</a>.
                        For Dymola, the conversion script removes these parameters.
     </td>
   </tr>
   <tr><td valign=\"top\">Buildings.Fluid.Movers.FlowControlled_dp<br/>
                          Buildings.Fluid.Movers.FlowControlled_m_flow<br/>
                          Buildings.Fluid.Movers.FlowControlled_Nrpm<br/>
                          Buildings.Fluid.Movers.FlowControlled_y
     </td>
     <td valign=\"top\">Removed the public variable <code>r_N</code>.
                        This is for
                        <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/417\">IBPSA issue 417</a>.
                        For Dymola, the conversion script removes
                        assignments of <code>r_N(start)</code>.
     </td>
   </tr>
   <tr><td valign=\"top\">Buildings.Fluid.Movers.FlowControlled_dp<br/>
                          Buildings.Fluid.Movers.FlowControlled_m_flow
   </td>
   <td valign=\"top\">Write a warning if no pressure curve is provided because
                     the efficiency calculation can only be done correctly if a pressure curve
                     is provided. The warning can be suppressed by providing a pressure curve, or
                     by setting <code>nominalValuesDefineDefaultPressureCurve=true</code>.
     </td>
   </tr>

   <tr><td valign=\"top\">Buildings.Fluid.Movers.Data
     </td>
     <td valign=\"top\">Replaced the parameters
                        <code>Buildings.Fluid.Movers.Data.FlowControlled</code>,
                        <code>Buildings.Fluid.Movers.Data.SpeedControlled_y</code>, and
                        <code>Buildings.Fluid.Movers.Data.SpeedControlled_Nrpm</code> by
                        the parameter
                        <code>Buildings.Fluid.Movers.Data.Generic</code>
                        which is used for all four types of movers.
                        This is for
                        <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/417\">IBPSA issue 417</a>.
                        This change allows to correctly compute the fan or pump power also for the models
                        <code>Buildings.Fluid.Movers.FlowControlled_dp</code>,
                        <code>Buildings.Fluid.Movers.FlowControlled_m_flow</code>
                        for speeds that are different from the nominal speed, provided that the user
                        specifies the pressure curve.
                        For Dymola, the conversion script updates this parameter.<br/><br/>
                        In the previous record
                        <code>Buildings.Fluid.Movers.Data.SpeedControlled_Nrpm</code>,
                        changed the parameter <code>N_nominal</code> to <code>speed_rpm_nominal</code>.
                        This is for
                        <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/396\">IBPSA issue 396</a>.
                        For Dymola, the conversion script updates this parameter.
     </td>
   </tr>

   <tr><td valign=\"top\">Buildings.Fluid.BaseClasses.PartialThreeWayResistance<br/>
                          Buildings.Fluid.Movers.BaseClasses.PartialFlowMachine<br/>
                          Buildings.Fluid.Movers.FlowControlled_dp<br/>
                          Buildings.Fluid.Movers.FlowControlled_m_flow<br/>
                          Buildings.Fluid.Movers.FlowControlled_Nrpm<br/>
                          Buildings.Fluid.Movers.FlowControlled_y<br/>
                          Buildings.Fluid.Actuators.Valves.ThreeWayEqualPercentageLinear<br/>
                          Buildings.Fluid.Actuators.Valves.ThreeWayLinear<br/>
                          Buildings.Fluid.Actuators.Valves.TwoWayEqualPercentage
     </td>
     <td valign=\"top\">Removed parameter <code>dynamicBalance</code> that overwrote the setting
                        of <code>energyDynamics</code> and <code>massDynamics</code>.
                        This is for
                        <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/411\">
                        IBPSA, issue 411</a>.
                        For Dymola, the conversion script updates the models.
     </td>
   </tr>
   <tr><td valign=\"top\">Buildings.Fluid.Interfaces.PartialTwoPort
     </td>
     <td valign=\"top\">Renamed the protected parameters
                        <code>port_a_exposesState</code>, <code>port_b_exposesState</code> and
                        <code>showDesignFlowDirection</code>.
                        This is for
                        <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/349\">IBPSA issue 349</a>
                        and
                        <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/351\">IBPSA issue 351</a>.
                        For Dymola, the conversion script updates models
                        that extend from <code>Buildings.Fluid.Interfaces.PartialTwoPort</code>.
     </td>
   </tr>
   <tr><td valign=\"top\">Buildings.Fluid.Interfaces.FourPort
     </td>
     <td valign=\"top\">Renamed model to <code>Buildings.Fluid.Interfaces.PartialFourPort</code> and
                        removed the parameters
                        <code>h_outflow_a1_start</code>,
                        <code>h_outflow_b1_start</code>,
                        <code>h_outflow_a2_start</code> and
                        <code>h_outflow_b2_start</code>
                        to make the model similar to <code>Buildings.Fluid.Interfaces.PartialTwoPort</code>.
                        See <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/299\">IBPSA issue 299</a>
                        for a discussion.
                        For Dymola, the conversion script updates models
                        that extend from <code>Buildings.Fluid.Interfaces.FourPort</code>.
     </td>
   </tr>
   <tr><td valign=\"top\">Buildings.Fluid.Interfaces.StaticTwoPortConservationEquation
       </td>
       <td valign=\"top\">
                        Revised implementation of conservation equations and
                        added default values for outlet quantities at <code>port_a</code>
                        if <code>allowFlowReversal=false</code>.
                        This is for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/281\">IBPSA issue 281</a>.
                        Also, revised implementation so that equations are always consistent
                        and do not lead to division by zero,
                        also when connecting a <code>prescribedHeatFlowRate</code>
                        to <code>MixingVolume</code> instances.
                        Renamed <code>use_safeDivision</code> to <code>prescribedHeatFlowRate</code>.
                        See <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/282\">IBPSA issue 282</a>
                        for a discussion.
                        For users who simply instantiate existing component models, this change is backward
                        compatible.
                        However, developers who implement component models that extend from
                        <code>Buildings.Fluid.Interfaces.StaticTwoPortConservationEquation</code> may need to update
                        the parameter <code>use_safeDivision</code> and use instead <code>prescribedHeatFlowRate</code>.
                        See the model documentation.
       </td>
   </tr>
   <tr><td colspan=\"2\"><b>Buildings.ThermalZones</b>
       </td>
   <tr><td valign=\"top\">Buildings.ThermalZones.Detailed.MixedAir<br/>
                          Buildings.ThermalZones.Detailed.CFD
       </td>
       <td valign=\"top\">These models can now be used with electrochromic windows.
                          This required to change the glass properties
                          <code>tauSol</code>, <code>rhoSol_a</code> and <code>rhoSol_b</code>
                          to be arrays. For example, to convert an existing model, use
                          <code>tauSol={0.6}</code> instead of <code>tauSol=0.6</code>.
                          For Dymola, the conversion script will automatically
                          update existing models.
       </td>
   </tr>
   <tr><td colspan=\"2\"><b>Buildings.Obsolete</b>
       </td>
   <tr><td valign=\"top\">Buildings.Obsolete.Fluid.Movers<br/>
                          Buildings.Obsolete.Media
       </td>
       <td valign=\"top\">Removed these packages which have models from
                          release 2.0.0.
       </td>
   </tr>
   </table>
   <!-- Errors that have been fixed -->
   <p>
   The following <b style=\"color:red\">critical errors</b> have been fixed (i.e., errors
   that can lead to wrong simulation results):
   </p>
   <table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
   <tr><td colspan=\"2\"><b>Buildings.Fluid.Chillers</b>
       </td>
   </tr>
   <tr><td valign=\"top\">Buildings.Fluid.Chillers.Carnot
       </td>
       <td valign=\"top\">Corrected wrong computation of state of leaving fluid
                          <code>staB1</code> and <code>staB2</code>
                          for the configuration without flow reversal.
                          The previous implementation mistakenly used the <code>inStream</code> operator.
                          This is for
                          <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/476\">
                          issue 476</a>
       </td>
   </tr>
   </table>
   <!-- Uncritical errors -->
   <p>
   The following <b style=\"color:red\">uncritical errors</b> have been fixed (i.e., errors
   that do <b style=\"color:red\">not</b> lead to wrong simulation results, e.g.,
   units are wrong or errors in documentation):
   </p>
   <table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
   <tr><td colspan=\"2\"><b>Buildings.Electrical</b>
       </td>
   </tr>
   <tr><td valign=\"top\">Buildings.Electrical.Interfaces.PartialWindTurbine
       </td>
       <td valign=\"top\">Reformulated test for equality of <code>Real</code> variables. This closes
                          <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/493\">issue 493</a>.
       </td>
   </tr>
   <tr><td colspan=\"2\"><b>Buildings.HeatTransfer</b>
       </td>
   </tr>
   <tr><td valign=\"top\">Buildings.HeatTransfer.Conduction.SingleLayer<br/>
                          Buildings.HeatTransfer.Data.BaseClasses
       </td>
       <td valign=\"top\">Reformulated test for equality of <code>Real</code> variables. This closes
                          <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/493\">issue 493</a>.
       </td>
   </tr>
   <tr><td colspan=\"2\"><b>Buildings.Fluid</b>
       </td>
   </tr>
   <tr><td valign=\"top\">Buildings.Fluid.FMI.FlowSplitter_u
       </td>
       <td valign=\"top\">Corrected wrong assert statement. This closes
                          <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/442\">issue 442</a>.
       </td>
   </tr>
   <tr><td valign=\"top\">Buildings.Fluid.Chillers.Carnot
       </td>
       <td valign=\"top\">Corrected wrong assert statement for test on the efficiency function. This closes
                          <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/468\">issue 468</a>.
       </td>
   </tr>


   <tr><td colspan=\"2\"><b>Buildings.Media</b>
       </td>
   </tr>
   <tr><td valign=\"top\">Buildings.Media.Specialized.Water.TemperatureDependentDensity
       </td>
       <td valign=\"top\">Removed dublicate entry of <code>smooth</code> and <code>smoothOrder</code>.
                          This is for
                          <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/303\">IBPSA issue 303</a>.
       </td>
   </tr>

   <tr><td colspan=\"2\"><b>Buildings.ThermalZones</b>
       </td>
   </tr>
   <tr><td valign=\"top\">Buildings.ThermalZones.Detailed.BaseClasses.MixedAirHeatGain
       </td>
       <td valign=\"top\">Reformulated test for equality of <code>Real</code> variables. This closes
                          <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/493\">issue 493</a>.
       </td>
   </tr>


   <tr><td colspan=\"2\"><b>Buildings.Utilities.Math</b>
       </td>
   </tr>
   <tr><td valign=\"top\">Buildings.Utilities.Math.Functions.BaseClasses.der_2_regNonZeroPower<br/>
                          Buildings.Utilities.Math.Functions.BaseClasses.der_polynomial<br/>
                          Buildings.Utilities.Math.Functions.BaseClasses.der_regNonZeroPower

       </td>
       <td valign=\"top\">Corrected wrong derivative implementation and improved their regression tests.
                          This is for
                          <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/303\">IBPSA issue 303</a>.

       </td>
   </tr>

   <tr><td colspan=\"2\"><b>Buildings.Utilities.Psychrometrics</b>
       </td>
   </tr>
   <tr><td valign=\"top\">Buildings.Utilities.Psychrometrics.Density_pTX
       </td>
       <td valign=\"top\">Corrected wrong default component name.
       </td>
   </tr>

   <tr><td valign=\"top\">Buildings.Utilities.Psychrometrics.Functions.saturationPressure
       </td>
       <td valign=\"top\">Changed <code>smoothOrder</code> from <i>5</i> to <i>1</i> as
                         <a href=\"modelica://Buildings.Utilities.Math.Functions.spliceFunction\">
                         Buildings.Utilities.Math.Functions.spliceFunction</a> is only once
                         continuously differentiable.
                         Inlined the function.
       </td>
   </tr>

   <tr><td colspan=\"2\"><b>Buildings.Utilities.IO.Python27</b>
       </td>
   </tr>
   <tr><td valign=\"top\">Buildings.Utilities.IO.Python27.exchange
       </td>
       <td valign=\"top\">Updated Python implementation to allow compiling code
                          on 64 bit Linux. Previously, on Linux a segmentation fault
                          occurred during run-time if 64 bit code rather than
                          32 bit code was generated. This is now corrected.<br/>
                          Also, Windows 64 bit binaries have been added.<br/>
                          This closes
                          <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/287\">issue 287</a>.
       </td>
   </tr>

   </table>
   </html>"));
   end Version_3_0_0;

   class Version_2_1_0 "Version 2.1.0"
     extends Modelica.Icons.ReleaseNotes;
       annotation (Documentation(info="<html>
   <p>
   Version 2.1.0 is fully compatible with version 2.0.0.
   It adds the package <code>Buildings.Fluid.FMI</code> that provides containers
   for exporting thermofluid flow components as FMUs.
   It also updates the temperature sensor to optionally simulate heat losses,
   and it contains bug fixes for the trace substance sensor if used without flow reversal.
   Improvements have been made to various models to reduce the simulation time, and
   to <code>Buildings.Examples.Tutorial.Boiler</code> to simplify the control implementation.
   </p>
   <!-- New libraries -->
   <p>
   The following <b style=\"color:blue\">new libraries</b> have been added:
   </p>
   <table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\">
   <tr><td valign=\"top\">Buildings.Fluid.FMI
       </td>
       <td valign=\"top\">This package contains blocks that serve as containers for exporting
                          models from <code>Buildings.Fluid</code> as a Functional Mockup Unit (FMU).<br/>
                          This allows using models from <code>Buildings.Fluid</code>, add them
                          to a block that only has input and output signals, but no acausal connectors,
                          and then export the model as a Functional Mockup Unit.
                          Models can be individual models or systems that are composed of various
                          models.
                          For more information, see the
                          <a href=\"modelica://Buildings.Fluid.FMI.UsersGuide\">User's Guide</a>.
       </td>
       </tr>
   </table>
   <!-- New components for existing libraries -->

   <!-- Backward compatible changes -->
   <p>
   The following <b style=\"color:blue\">existing components</b>
   have been <b style=\"color:blue\">improved</b> in a
   <b style=\"color:blue\">backward compatible</b> way:
   </p>
   <table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
   <tr><td colspan=\"2\"><b>Buildings.Examples</b>
       </td>
   </tr>
   <tr><td valign=\"top\">Buildings.Examples.Tutorial.Boiler.System5<br/>
                        Buildings.Examples.Tutorial.Boiler.System6<br/>
                        Buildings.Examples.Tutorial.Boiler.System7
       </td>
       <td valign=\"top\">Changed control input for <code>conPIDBoi</code> and set
                        <code>reverseAction=true</code>
                        to address issue
                        <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/436\">#436</a>.
       </td>
   </tr>
   <tr><td colspan=\"2\"><b>Buildings.Fluid</b>
       </td>
   </tr>
   <tr><td valign=\"top\">Buildings.Fluid.Chillers.Carnot<br/>
                          Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.PartialDXCoil<br/>
                          Buildings.Fluid.HeatExchangers.HeaterCooler_u<br/>
                          Buildings.Fluid.MassExchangers.Humidifier_u
       </td>
       <td valign=\"top\">Set parameter <code>prescribedHeatFlowRate=true</code>
                          which causes a simpler energy balance to be used.
       </td>
   </tr>
   <tr><td valign=\"top\">Buildings.Fluid.Sensors.TemperatureTwoPort
       </td>
       <td valign=\"top\">Added option to simulate thermal loss, which is
                        useful if the sensor is used to measure
                        the fluid temperature in a system with on/off control
                        for the mass flow rate.
       </td>
   </tr>
   <tr><td valign=\"top\">Buildings.Fluid.SolarCollectors.ASHRAE93<br/>
                          Buildings.Fluid.SolarCollectors.EN12975
       </td>
       <td valign=\"top\">Corrected sign error in computation of heat loss
                          that prevents the medium to exceed <code>Medium.T_min</code>
                          or <code>Medium.T_max</code>. With the previous implementation,
                          an assertion may be generated unnecessarily rather than
                          the model guiding against the violation of these bounds.
       </td>
   </tr>
   <tr><td valign=\"top\">Buildings.Fluid.MixingVolumes.BaseClasses.PartialMixingVolume


       </td>
       <td valign=\"top\">Added test on <code>allowFlowReversal</code> in criteria
                          about what energy balance implementation to use.
                          This causes simpler models, for example when exporting
                          <code>Buildings.Fluid.HeatExchangers.HeaterCooler_u</code>
                          as an FMU.
       </td>
   </tr>
   </table>
   <!-- Non-backward compatible changes to existing components -->

   <!-- Errors that have been fixed -->
   <p>
   The following <b style=\"color:red\">critical errors</b> have been fixed (i.e., errors
   that can lead to wrong simulation results):
   </p>
   <table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
   <tr><td colspan=\"2\"><b>Buildings.Fluid</b>
       </td>
   </tr>
   <tr><td valign=\"top\">Buildings.Fluid.Sensors.TraceSubstanceTwoPort
       </td>
       <td valign=\"top\">Corrected wrong sensor signal if <code>allowFlowReversal=false</code>.
                          For this setting, the sensor output was for the wrong flow direction.
                          This corrects
                          <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/249\">issue 249</a>.
       </td>
   </tr>
   </table>
   <!-- Uncritical errors -->
   <p>
   The following <b style=\"color:red\">uncritical errors</b> have been fixed (i.e., errors
   that do <b style=\"color:red\">not</b> lead to wrong simulation results, e.g.,
   units are wrong or errors in documentation):
   </p>
   <table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
   <tr><td colspan=\"2\"><b>Buildings.Fluid</b>
       </td>
   </tr>
   <tr><td valign=\"top\">Buildings.Fluid.Interfaces.ConservationEquation<br/>
                          Buildings.Fluid.Interfaces.StaticTwoPortConservationEquation
       </td>
       <td valign=\"top\">Corrected documentation.
       </td>
   </tr>
   </table>
   </html>"));
   end Version_2_1_0;

    class Version_2_0_0 "Version 2.0.0"
      extends Modelica.Icons.ReleaseNotes;
        annotation (Documentation(info="<html>
<p>
Version 2.0.0 is a major release that contains various new packages, models
and improvements.
</p>
<p>
The following major additions have been done in version 2.0:
</p>
<ul>
<li>
A CFD model
that is embedded in a thermal zone has been added.
This model is implemented in <a href=\"modelica://Buildings.ThermalZones.Detailed.CFD\">Buildings.ThermalZones.Detailed.CFD</a>.
The CFD model is an implementation of the Fast Fluid Dynamics code
that allows three-dimensional CFD inside a thermal zone,
coupled to building heat transfer, HVAC components and feedback control loops.
</li>
<li>
A new package
<a href=\"modelica://Buildings.Electrical\">Buildings.Electrical</a>
has been added.
This package allows studying
buildings to electrical grid integration. It includes models for loads, transformers,
cables, batteries, PV and wind turbines.
Models exist for DC and AC systems with two- or three-phase that can be balanced and unbalanced.
The models compute voltage, current, active and reactive power
based on the quasi-stationary assumption or using the dynamic phasorial representation.
</li>
<li>
The new package
<a href=\"modelica://Buildings.Controls.DemandResponse\">
Buildings.Controls.DemandResponse</a>
contains models for demand response simulation.
</li>
<li>
The new package
<a href=\"modelica://Buildings.Controls.Predictors\">
Buildings.Controls.Predictors</a>
contains a data-driven model that predicts the electrical load
of a building. The prediction can be done
either using an average baseline or
a linear regression with respect to outside temperature.
For both, optionally a day-of adjustment can be made.
</li>
</ul>
<p>
The tables below give more detailed information to the revisions
of this library compared to the previous release 1.6 build 1.
</p>
<!-- New libraries -->
<p>
The following <b style=\"color:blue\">new libraries</b> have been added:
</p>
<table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\">
<tr><td valign=\"top\">Buildings.Electrical
    </td>
    <td valign=\"top\">Library for electrical grid simulation that
                       allows to study building to electrical grid integration.
                       The library contains models of loads, generation and transmission
                       for DC and AC systems.
    </td>
    </tr>
<tr><td valign=\"top\">Buildings.Controls.DemandResponse
    </td>
    <td valign=\"top\">Library with a model for demand response prediction.
    </td>
    </tr>
<tr><td valign=\"top\">Buildings.Controls.Predictors
    </td>
    <td valign=\"top\">Library with a data-driven model that predicts the electrical load
                     of a building. The prediction can be done
                     either using an average baseline or
                     a linear regression with respect to outside temperature.
                     For both, optionally a day-of adjustment can be made.
    </td>
    </tr>
</table>
<!-- New components for existing libraries -->
<p>
The following <b style=\"color:blue\">new components</b> have been added
to <b style=\"color:blue\">existing</b> libraries:
</p>
<table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
<tr><td colspan=\"2\"><b>Buildings.Fluid</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.Actuators.Valves.TwoWayPressureIndependent
    </td>
    <td valign=\"top\">Model of a pressure-independent two way valve.
    </td>
    </tr>
<tr><td valign=\"top\">Buildings.Fluid.HeatExchangers.HeaterCooler_T
    </td>
    <td valign=\"top\">Model of a heater or cooler that takes as an input
                       the set point for the temperature of the fluid that leaves
                       the component. The set point is tracked exactly
                       if the component has sufficient capacity.
                       Optionally, the component can be configured to compute
                       a dynamic rather than a steady-state response.
    </td>
    </tr>

<tr><td colspan=\"2\"><b>Buildings.Utilities</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Utilities.Psychrometrics.Phi_pTX<br/>
                       Buildings.Utilities.Psychrometrics.Functions.phi_pTX
    </td>
    <td valign=\"top\">Block and function that computes the relative humidity
                       for given pressure, temperature and water vapor mass fraction.
    </td>
    </tr>

<tr><td colspan=\"2\"><b>Buildings.ThermalZones</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.ThermalZones.Detailed.CFD
    </td>
    <td valign=\"top\">Room model that computes the room air flow
                       using computational fluid dynamics (CFD).
                       The CFD simulation is coupled to the thermal simulation of the room
                       and, through the fluid port, to the air conditioning system.
                       Currently, the supported CFD program is the
                       Fast Fluid Dynamics (FFD) program.
                       See
                       <a href=\"modelica://Buildings.ThermalZones.Detailed.UsersGuide.CFD\">Buildings.ThermalZones.Detailed.UsersGuide.CFD</a>
                       for detailed explanations.
    </td>
    </tr>

</table>
<!-- Backward compatible changes -->
<p>
The following <b style=\"color:blue\">existing components</b>
have been <b style=\"color:blue\">improved</b> in a
<b style=\"color:blue\">backward compatible</b> way:
</p>
<table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
<tr><td colspan=\"2\"><b>Buildings.BoundaryConditions</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.BoundaryConditions.WeatherData.ReaderTMY3
    </td>
    <td valign=\"top\">Added option to obtain the black body sky temperature
                       from a parameter or an input signal rather than
                       computing it in the weather data reader.<br/><br/>
                       Removed redundant connection
                       <code>connect(conHorRad.HOut, cheHorRad.HIn);</code>.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Fluid</b>
    </td>
</tr>

<tr><td valign=\"top\">Buildings.Chillers.ElectricEIR<br/>
                       Buildings.Chillers.ElectricReformulatedEIR
    </td>
    <td valign=\"top\">Changed implementation so that the model
                       is continuously differentiable.
                       This is for issue
                       <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/373\">373</a>.
    </td>
    </tr>

<tr><td valign=\"top\">Buildings.Fluid.HeatExchangers.DryCoilCounterFlow
    </td>
    <td valign=\"top\">Changed assignment of <code>T_m</code> to avoid using the conditionally
                       enabled model <code>ele[:].mas.T</code>, which is only
                       valid in a connect statement.
                       Moved assignments of
                       <code>Q1_flow</code>, <code>Q2_flow</code>, <code>T1</code>,
                       <code>T2</code> and <code>T_m</code> outside of equation section
                       to avoid mixing graphical and textual modeling within the same model.
    </td>
    </tr>

<tr><td valign=\"top\">Buildings.Fluid.HeatExchangers.DryCoilDiscretized
    </td>
    <td valign=\"top\">Removed parameter <code>m1_flow_nominal</code>, as this parameter is already
                    declared in its base class
                    <a href=\"modelica://Buildings.Fluid.Interfaces.PartialFourPortInterface\">
                    Buildings.Fluid.Interfaces.PartialFourPortInterface</a>.
                    This change avoids an error in OpenModelica as the two declarations
                    had a different value for the <code>min</code> attribute, which is not valid
                    in Modelica.
    </td>
    </tr>
    <tr>
    <td valign=\"top\">Buildings.Fluid.HeatExchangers.BaseClasses.CoilRegister<br/>
                       Buildings.Fluid.HeatExchangers.BaseClasses.DuctManifoldDistributor
    </td>
    <td valign=\"top\">Reformulated the multiple iterators in the <code>sum</code> function
                       as this language construct is not supported in OpenModelica.
    </td>
    </tr>

    <tr>
    <td valign=\"top\">Buildings.Fluid.HeatExchangers.RadiantSlabs.SingleCircuitSlab
    </td>
    <td valign=\"top\">Set start value for <code>hPip(fluid(T))</code> to avoid
                       a warning about conflicting start values.
    </td>
    </tr>

<tr><td valign=\"top\">Buildings.Fluid.Movers.SpeedControlled_y<br/>
                       Buildings.Fluid.Movers.SpeedControlled_Nrpm<br/>
                       Buildings.Fluid.Movers.FlowControlled_dp<br/>
                       Buildings.Fluid.Movers.FlowControlled_m_flow

    </td>
    <td valign=\"top\">For the parameter setting <code>use_powerCharacteristic=true</code>,
                     changed the computation of the power consumption at
                     reduced speed to properly account for the
                     affinity laws. This is in response to
                     <a href=\"https://github.com/lbl-srg/modelica-buildings/pull/202\">#202</a>.
    </td>
</tr>

    <tr>
    <td valign=\"top\">Buildings.Fluid.SolarCollectors.ASHRAE93<br/>
                       Buildings.Fluid.SolarCollectors.EN12975
    </td>
    <td valign=\"top\">Reformulated the model to avoid a translation error
                       if glycol is used.<br/>
                       Propagated parameters for initialization in base class
                       <code>Buildings.Fluid.SolarCollectors.BaseClasses.PartialSolarCollector</code>
                       and set <code>prescribedHeatFlowRate=true</code>.
    </td>
    </tr>

    <tr>
    <td valign=\"top\">Buildings.Fluid.Storage.StratifiedEnhancedInternalHex
    </td>
    <td valign=\"top\">Replaced the <code>abs()</code> function in the assignment of the parameter
                       <code>nSegHexTan</code> as the return value of <code>abs()</code>
                       is a <code>Real</code> which causes a type error during model check.
    </td>
    </tr>
<tr><td colspan=\"2\"><b>Buildings.HeatTransfer</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.HeatTransfer.Conduction.MultiLayer
    </td>
    <td valign=\"top\">Changed the assignment of <code>_T_a_start</code>,
                       <code>_T_b_start</code> and <code>RTot</code> to be
                       in the initial equation section as opposed to
                       the parameter declaration.
                       This is needed to avoid an error during model check
                       and translation in Dymola 2015 FD01 beta1.
    </td>
    </tr>

<tr><td valign=\"top\">Buildings.HeatTransfer.Windows.InteriorHeatTransferConvective
    </td>
    <td valign=\"top\">Changed model to allow a temperature dependent convective heat transfer
                       on the room side.
                       This is for issue
                       <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/52\">52</a>.
    </td>
    </tr>

<tr><td colspan=\"2\"><b>Buildings.Media</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Media.Interfaces.PartialSimpleIdealGasMedium<br/>
                       Buildings.Media.Interfaces.PartialSimpleMedium
    </td>
    <td valign=\"top\">Set <code>T(start=T_default)</code> and
                       <code>p(start=p_default)</code> in the
                       <code>ThermodynamicState</code> record. Setting the start value for
                       <code>T</code> is required to avoid an error due to
                       conflicting start values when translating
                       <code>Buildings.Examples.VAVReheat.ClosedLoop</code> in pedantic mode.
    </td>
</tr>

<tr><td colspan=\"2\"><b>Buildings.ThermalZones</b>
    </td>
    </tr>

<tr><td valign=\"top\">Buildings.ThermalZones.Detailed.MixedAir
    </td>
    <td valign=\"top\">Changed model to allow a temperature dependent convective heat transfer
                       on the room side for windows.
                       This is for issue
                       <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/52\">52</a>.
    </td>
    </tr>

<tr><td valign=\"top\">Rooms.BaseClasses.ExteriorBoundaryConditionsWithWindow
    </td>
    <td valign=\"top\">Conditionally removed the shade model if no shade is present.
                       This corrects
                       <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/234\">#234</a>.
    </td>
</tr>

</table>
<!-- Non-backward compatible changes to existing components -->
<p>
The following <b style=\"color:blue\">existing components</b>
have been <b style=\"color:blue\">improved</b> in a
<b style=\"color:blue\">non-backward compatible</b> way:
</p>
<table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
<tr><td colspan=\"2\"><b>Buildings.Airflow</b>
   </td>
</tr>
<tr><td valign=\"top\">Buildings.Airflow.Multizone.ZonalFlow_ACS<br/>
                       Buildings.Airflow.Multizone.ZonalFlow_m_flow
   </td>
   <td valign=\"top\">Removed parameter <code>forceErrorControlOnFlow</code> as it was not used.
                       For Dymola, the conversion script will automatically
                       update existing models.
   </td>
</tr>

<tr><td colspan=\"2\"><b>Buildings.BoundaryConditions</b>
   </td>
</tr>
<tr><td valign=\"top\">Buildings.BoundaryConditions.WeatherData.ReaderTMY3
   </td>
   <td valign=\"top\">Changed the following signals for compatibility with OpenModelica:<br/>
                      <code>weaBus.sol.zen</code> to <code>weaBus.solZen</code>.<br/>
                      <code>weaBus.sol.dec</code> to <code>weaBus.solDec</code>.<br/>
                      <code>weaBus.sol.alt</code> to <code>weaBus.solAlt</code>.<br/>
                      <code>weaBus.sol.solHouAng</code> to <code>weaBus.solHouAng</code>.<br/>
                      For Dymola, the conversion script will automatically
                      update existing models.
   </td>
</tr>

<tr><td colspan=\"2\"><b>Buildings.Examples</b>
   </td>
</tr>
<tr><td valign=\"top\">Buildings.Examples.VAVReheat.Controls.IntegerSum
   </td>
   <td valign=\"top\">Removed block as it is not used in any model.
                      Models that require an integer sum can use
                      <code>Modelica.Blocks.MathInteger.Sum</code>.
   </td>
</tr>
<tr><td valign=\"top\">Buildings.Examples.VAVReheat.Controls.UnoccupiedOn
   </td>
   <td valign=\"top\">Removed block as it is not used in any model.
   </td>
</tr>

<tr><td colspan=\"2\"><b>Buildings.HeatTransfer</b>
    </td>
    </tr>

<tr><td valign=\"top\">Buildings.HeatTransfer.Data.GlazingSystems.Generic
    </td>
    <td valign=\"top\">Removed parameter <code>nLay</code> as OpenModelica
                       could not assign it during translation.
                       For Dymola, the conversion script will automatically
                       update existing models.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.HeatTransfer.Conduction.BaseClasses.der_temperature_u
    </td>
    <td valign=\"top\">Changed the input argument for this function from type
                       <code>Buildings.HeatTransfer.Data.BaseClasses.Material</code>
                       to the elements of this type as OpenModelica fails to translate the
                       model if the input to this function is a record.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.HeatTransfer.Types.Azimuth<br/>
                       Buildings.HeatTransfer.Types.Tilt
    </td>
    <td valign=\"top\">Moved these types from <code>Buildings.HeatTransfer</code>
                       to the top-level package <code>Buildings</code> because
                       they are used in <code>Buildings.BoundaryConditions</code>,
                       <code>Buildings.HeatTransfer</code> and <code>Buildings.ThermalZones.Detailed</code>.<br/>
                       For Dymola, the conversion script will automatically
                       update existing models.
    </td>
</tr>


<tr><td colspan=\"2\"><b>Buildings.Fluid</b>
    </td>
    </tr>

<tr><td valign=\"top\">Buildings.Fluid.FixedResistances.Pipe<br/>
                       Buildings.Fluid.FixedResistances.BaseClasses.Pipe<br/>
                       Buildings.Fluid.HeatExchangers.RadiantSlabs.SingleCircuitSlab
    </td>
    <td valign=\"top\">Renamed pressure drop from <code>res</code> to
                       <code>preDro</code> to use the same name as in other models.
                       This corrects
                       <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/271\">#271</a>.
                       For Dymola, the conversion script will automatically
                       update existing models.
    </td>
</tr>

<tr><td valign=\"top\">Buildings.Fluid.HeatExchangers.DryCoilDiscretized<br/>
                       Buildings.Fluid.HeatExchangers.WetCoilDiscretized
    </td>
    <td valign=\"top\">Reformulated flow splitter in the model to reduce
                       the dimension of the coupled linear or nonlinear
                       system of equations. With this revision, the optional
                       control volume in the duct inlet has been removed
                       as it is no longer needed. Therefore, the parameter
                       <code>dl</code> has also been removed.
                       Replaced the parameters <code>energyDynamics1</code>
                       and  <code>energyDynamics2</code> with
                       <code>energyDynamics</code>.
                       Removed the parameter <code>ductConnectionDynamics</code>.<br/>
                       For Dymola, the conversion script will automatically
                       update existing models.

    </td>
</tr>

<tr><td valign=\"top\">Buildings.Fluid.HeatExchangers.HeaterCoolerPrescribed
    </td>
    <td valign=\"top\">Renamed the model to <code>HeaterCooler_u</code> due to
                       the introduction of the new model <code>HeaterCooler_T</code>.<br/>
                       For Dymola, the conversion script will automatically
                       update existing models.

    </td>
</tr>

<tr><td valign=\"top\">Buildings.Fluid.HeatExchangers.RadiantSlabs.SingleCircuitSlab<br/>
                       Buildings.Fluid.HeatExchangers.RadiantSlabs.ParallelCircuitsSlab
    </td>
    <td valign=\"top\">Changed the models to use by default an <i>&epsilon;-NTU</i>
                       approach for the heat transfer between the fluid and the slab
                       rather than a finite difference scheme along the
                       flow path.
                       Optionally, the finite difference scheme can also be used
                       as this is needed for some control design applications.<br/>
                       The new <i>&epsilon;-NTU</i> formulation has shown to lead to
                       about five times faster
                       computation on several test cases including the models in
                       <a href=\"modelica://Buildings.ThermalZones.Detailed.FLEXLAB.Rooms.Examples\">
                       Buildings.ThermalZones.Detailed.FLEXLAB.Rooms.Examples</a>.<br/>
                       For Dymola, the conversion script will automatically
                       update existing models.
 </td>
</tr>

<tr><td valign=\"top\">Buildings.Fluid.HeatExchangers.BaseClasses.DuctManifoldFixedResistance
    </td>
    <td valign=\"top\">Reformulated flow splitter in the model to reduce
                       the dimension of the coupled linear or nonlinear
                       system of equations. With this revision, the optional
                       control volume in the duct inlet has been removed
                       as it is no longer needed. Therefore, the parameters
                       <code>dl</code> and <code>energyDynamics</code> have
                       also been removed.<br/>
                       For Dymola, the conversion script will automatically
                       update existing models.
    </td>
<tr><td valign=\"top\">Buildings.Fluid.HeatExchangers.BaseClasses.CoilRegister
    </td>
    <td valign=\"top\">Replaced the parameters <code>energyDynamics1</code>
                       and <code>energyDynamics2</code> with
                       the new parameter <code>energyDynamics</code>.
                       Removed the parameters <code>steadyState_1</code>
                       and <code>steadyState_2</code> as this information
                       is already contained in <code>energyDynamics</code>.<br/>
                       For Dymola, the conversion script will automatically
                       update existing models.
    </td>
</tr>

<tr><td valign=\"top\">Buildings.Fluid.MassExchangers.HumidifierPrescribed
    </td>
    <td valign=\"top\">Renamed the model to <code>Humidifier_u</code> due to
                       the introduction of the new model <code>HeaterCooler_T</code>
                       and to use the same naming pattern as <code>HeaterCooler_u</code>.<br/>
                       For Dymola, the conversion script will automatically
                       update existing models.

    </td>
</tr>

<tr><td valign=\"top\">Buildings.Fluid.Movers
    </td>
    <td valign=\"top\">This package has been redesigned.
                       The models have been renamed as follows:<br/>
                       <code>Buildings.Fluid.Movers.FlowMachine_dp</code>
                       is now called
                       <code>Buildings.Fluid.Movers.FlowControlled_dp</code>.<br/>
                       <code>Buildings.Fluid.Movers.FlowMachine_m_flow</code>
                       is now called
                       <code>Buildings.Fluid.Movers.FlowControlled_m_flow</code>.<br/>
                       <code>Buildings.Fluid.Movers.FlowMachine_Nrpm</code>
                       is now called
                       <code>Buildings.Fluid.Movers.SpeedControlled_Nrpm</code>.<br/>
                       <code>Buildings.Fluid.Movers.FlowMachine_y</code>
                       is now called
                       <code>Buildings.Fluid.Movers.SpeedControlled_y</code>.<br/><br/>
                       In addition, the performance
                       data of all movers are now stored in a record.
                       These records are in
                       <a href=\"modelica://Buildings.Fluid.Movers.Data\">
                       Buildings.Fluid.Movers.Data</a>.
                       For most existing instances, it should be sufficient to enclose
                       the existing performance data in a record called <code>per</code>.
                       For example,
                       <code><br/>
                       Buildings.Fluid.Movers.FlowMachine_y fan(<br/>
                       &nbsp;redeclare package Medium = Medium,<br/>
                       &nbsp;pressure(<br/>
                       &nbsp;&nbsp;V_flow={0,m_flow_nominal,2*m_flow_nominal}/1.2,<br/>
                       &nbsp;&nbsp;dp={2*dp_nominal,dp_nominal,0})));<br/>
                       </code>
                       becomes
                       <code><br/>
                       Buildings.Fluid.Movers.SpeedControlled_y fan(<br/>
                       &nbsp;redeclare package Medium = Medium,<br/>
                       &nbsp;per(<br/>
                       &nbsp;&nbsp;pressure(<br/>
                       &nbsp;&nbsp;&nbsp;V_flow={0,m_flow_nominal,2*m_flow_nominal}/1.2,<br/>
                       &nbsp;&nbsp;&nbsp;dp={2*dp_nominal,dp_nominal,0})));<br/>
                       </code>
                       <br/>
                       See the <a href=\"modelica://Buildings.Fluid.Movers.UsersGuide\">
                       User's Guide</a> for more information about these records.
                       <br/><br/>
                       For Dymola, the conversion script will
                       update existing models to use the old implementations
                       which are now in the package <code>Buildings.Obsolete.Fluid.Movers</code>.
    </td>
</tr>


<tr><td colspan=\"2\"><b>Buildings.Media</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Media
    </td>
<td>
                       Renamed all media to simplify the media selection.
                       For typical building energy simulation,
                       <a href=\"modelica://Buildings.Media.Air\">Buildings.Media.Air</a> and
                       <a href=\"modelica://Buildings.Media.Water\">Buildings.Media.Water</a>
                       should be used.<br/><br/>
                       The following changes were made.<br/><br/>
                       Renamed <code>Buildings.Media.GasesPTDecoupled.MoistAirUnsaturated</code><br/>
                       to <code>Buildings.Media.Air</code>.<br/><br/>
                       Renamed <code>Buildings.Media.ConstantPropertyLiquidWater</code><br/>
                       to <code>Buildings.Media.Water</code>.<br/><br/>
                       Renamed <code>Buildings.Media.PerfectGases.MoistAir</code><br/>
                       to <code>Buildings.Obsolete.Media.PerfectGases.MoistAir</code>.<br/><br/>
                       Renamed <code>Buildings.Media.GasesConstantDensity.MoistAirUnsaturated</code><br/>
                       to <code>Buildings.Obsolete.Media.GasesConstantDensity.MoistAirUnsaturated</code>.<br/><br/>
                       Renamed <code>Buildings.Media.GasesConstantDensity.MoistAir</code><br/>
                       to <code>Buildings.Obsolete.Media.GasesConstantDensity.MoistAir</code>.<br/><br/>
                       Renamed <code>Buildings.Media.GasesConstantDensity.SimpleAir</code><br/>
                       to <code>Buildings.Obsolete.Media.GasesConstantDensity.SimpleAir</code>.<br/><br/>
                       Renamed <code>Buildings.Media.IdealGases.SimpleAir</code><br/>
                       to <code>Buildings.Obsolete.Media.IdealGases.SimpleAir</code>.<br/><br/>
                       Renamed <code>Buildings.Media.GasesPTDecoupled.MoistAir</code><br/>
                       to <code>Buildings.Obsolete.Media.GasesPTDecoupled.MoistAir</code>.<br/><br/>
                       Renamed <code>Buildings.Media.GasesPTDecoupled.SimpleAir</code><br/>
                       to <code>Buildings.Obsolete.Media.GasesPTDecoupled.SimpleAir</code>.<br/><br/>
                       For Dymola, the conversion script will
                       update existing models according to the above list.

</td>
</tr>


<tr><td valign=\"top\">Buildings.Media.Water
    </td>
    <td valign=\"top\">Removed option to model water as a compressible medium as
                       this option was not useful.
    </td>
</tr>

<tr><td colspan=\"2\"><b>Buildings.ThermalZones</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.ThermalZones.Detailed.BaseClasses.ParameterConstructionWithWindow
    </td>
    <td valign=\"top\">Removed the keyword <code>replaceable</code> for the parameters
                       <code>ove</code> and <code>sidFin</code>.<br/>
                       Models that instantiate <code>Buildings.ThermalZones.Detailed.MixedAir</code> are
                       not affected by this change.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.ThermalZones.Detailed.Examples.BESTEST
    </td>
    <td valign=\"top\">Moved the package to <code>Buildings.ThermalZones.Detailed.Validation.BESTEST</code>.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Utilities</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Utilities.SimulationTime
    </td>
    <td valign=\"top\">Moved the block <code>Buildings.Utilities.SimulationTime</code>
                       to <code>Buildings.Utilities.Time.ModelTime</code>.<br/>
                       For Dymola, the conversion script will
                       update existing models according to the above list.
    </td>
</tr>

</table>
<!-- Errors that have been fixed -->
<p>
The following <b style=\"color:red\">critical errors</b> have been fixed (i.e., errors
that can lead to wrong simulation results):
</p>
<table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
<tr><td colspan=\"2\"><b>Buildings.BoundaryConditions</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.BoundaryConditions.WeatherData.ReaderTMY3
    </td>
    <td valign=\"top\">Corrected error that led the total and opaque sky cover to be ten times
                       too low if its value was obtained from the parameter or the input connector.
                       For the standard configuration in which the sky cover is obtained from
                       the weather data file, the model was correct. This error only affected
                       the other two possible configurations.
    </td>
</tr><tr><td colspan=\"2\"><b>Buildings.Fluid</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.Data.Pipes
    </td>
    <td valign=\"top\">Corrected wrong entries for inner and outer diameter
                       of PEX pipes.
    </td>
    </tr>
<tr><td valign=\"top\">Buildings.Fluid.Geothermal.Boreholes.BaseClasses.singleUTubeResistances
    </td>
    <td valign=\"top\">Corrected error in function that used <code>beta</code>
                       before it was assigned a value.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.Storage.Stratified<br/>
                       Buildings.Fluid.Storage.StratifiedEnhanced<br/>
                       Buildings.Fluid.Storage.StratifiedEnhancedInternalHex
    </td>
    <td valign=\"top\">Replaced the use of <code>Medium.lambda_const</code> with
                       <code>Medium.thermalConductivity(sta_default)</code> as
                       <code>lambda_const</code> is not declared for all media.
                       This avoids a translation error if certain media are used.
    </td>
</tr><tr><td valign=\"top\">Buildings.Fluid.Storage.StratifiedEnhancedInternalHex
    </td>
    <td valign=\"top\">Corrected issue
                       <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/271\">#271</a>
                       which led to a compilation error if the heat exchanger
                       and the tank had different media.
    </td>
</tr>

<tr><td colspan=\"2\"><b>Buildings.HeatTransfer</b>
    </td>
</tr>

<tr><td valign=\"top\">Buildings.HeatTransfer.Windows.BaseClasses.GlassLayer
    </td>
    <td valign=\"top\">Corrected issue
                       <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/304\">#304</a>
                       that led to an error in the glass temperatures if the glass conductance
                       is very small.
    </td>
</tr>

<tr><td colspan=\"2\"><b>Buildings.ThermalZones</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.ThermalZones.Detailed.MixedAir
    </td>
    <td valign=\"top\">Added propagation of the parameter value <code>linearizeRadiation</code>
                       to the window model. Prior to this change, the radiation
                       was never linearized for computing the glass long-wave radiation.
    </td>
<tr><td valign=\"top\">Buildings.ThermalZones.Detailed.FLEXLAB.Rooms.Examples.X3WithRadiantFloor<br/>
                            Buildings.ThermalZones.Detailed.FLEXLAB.Rooms.Examples.X3AWithRadiantFloor<br/>
                            Buildings.ThermalZones.Detailed.FLEXLAB.Rooms.Examples.X3BWithRadiantFloor
    </td>
    <td valign=\"top\">Corrected wrong entries for inner and outer diameter
                       of PEX pipes.
    </td>
</tr>
</table>
<!-- Uncritical errors -->
<p>
The following <b style=\"color:red\">uncritical errors</b> have been fixed (i.e., errors
that do <b style=\"color:red\">not</b> lead to wrong simulation results, e.g.,
units are wrong or errors in documentation):
</p>
<table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
<tr><td colspan=\"2\"><b>Buildings.Fluid</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.FixedResistances.FixedResistanceDpM
    </td>
    <td valign=\"top\">Corrected error in documentation of computation of <code>k</code>.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.HeatTransfer</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.HeatTransfer.Windows.BaseClasses.GlassLayer
    </td>
    <td valign=\"top\">Changed type of <code>tauIR</code> from
                       <code>Modelica.SIunits.Emissivity</code> to
                       <code>Modelica.SIunits.TransmissionCoefficient</code>.
                       This avoids a type error in OpenModelica.
    </td>
</tr>

</table>

<p>
<b>Note:</b>
</p>
<p>
With version 2.0, we start using semantic versioning as described at <a href=\"http://semver.org/\">http://semver.org/</a>.
</p>
</html>"));
    end Version_2_0_0;

    class Version_1_6_build1 "Version 1.6 build 1"
      extends Modelica.Icons.ReleaseNotes;
        annotation (Documentation(info="<html>
<p>
Version 1.6 build 1 updates the <code>Buildings</code> library to the
Modelica Standard Library 3.2.1 and to <code>Modelica_StateGraph2</code> 2.0.2.
</p>
<p>
This is the first version of the <code>Buildings</code> library
that contains models from the
<a href=\"https://github.com/ibpsa/modelica\">
IEA EBC Annex 60 library</a>,
a Modelica library for building and community energy systems that is
collaboratively developed within the project
<a href=\"http://www.iea-annex60.org\">
\"New generation computational tools for building and community energy systems
based on the Modelica and Functional Mockup Interface standards\"</a>,
a project that is conducted under the
Energy in Buildings and Communities Programme (EBC) of the
International Energy Agency (IEA).
</p>
<!-- New libraries -->
<!-- New components for existing libraries -->
<p>
The following <b style=\"color:blue\">new components</b> have been added
to <b style=\"color:blue\">existing</b> libraries:
</p>
<table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
<tr><td colspan=\"2\"><b>Buildings.Fluid</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.Actuators.Valves.TwoWayTable
    </td>
    <td valign=\"top\">Two way valve for which the opening characteristics
                       is specified by a table.
    </td>
    </tr>
<tr><td colspan=\"2\"><b>Buildings.Utilities.Math</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Utilities.Math.Examples.Average
                       Buildings.Utilities.Math.Examples.InverseXRegularized
                       Buildings.Utilities.Math.Examples.Polynominal
                       Buildings.Utilities.Math.Examples.PowerLinearized
                       Buildings.Utilities.Math.Examples.QuadraticLinear
                       Buildings.Utilities.Math.Examples.RegNonZeroPower
                       Buildings.Utilities.Math.Examples.SmoothExponential
                       Buildings.Utilities.Math.Functions.average
                       Buildings.Utilities.Math.Functions.booleanReplicator
                       Buildings.Utilities.Math.Functions.Examples.IsMonotonic
                       Buildings.Utilities.Math.Functions.Examples.TrapezoidalIntegration
                       Buildings.Utilities.Math.Functions.integerReplicator
                       Buildings.Utilities.Math.InverseXRegularized
                       Buildings.Utilities.Math.Polynominal
                       Buildings.Utilities.Math.PowerLinearized
                       Buildings.Utilities.Math.QuadraticLinear
                       Buildings.Utilities.Math.RegNonZeroPower
                       Buildings.Utilities.Math.SmoothExponential
                       Buildings.Utilities.Math.TrapezoidalIntegration
    </td>
    <td valign=\"top\">Various functions and blocks for mathematical operations.
    </td>
    </tr>
<tr><td colspan=\"2\"><b>Buildings.Utilities.Psychrometrics</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Utilities.Psychrometrics.Examples.SaturationPressureLiquid
                       Buildings.Utilities.Psychrometrics.Examples.SaturationPressure
                       Buildings.Utilities.Psychrometrics.Examples.SublimationPressureIce
                       Buildings.Utilities.Psychrometrics.Functions.BaseClasses.der_saturationPressureLiquid
                       Buildings.Utilities.Psychrometrics.Functions.BaseClasses.der_sublimationPressureIce
                       Buildings.Utilities.Psychrometrics.Functions.BaseClasses.Examples.SaturationPressureDerivativeCheck
                       Buildings.Utilities.Psychrometrics.Functions.Examples.SaturationPressure
                       Buildings.Utilities.Psychrometrics.Functions.saturationPressureLiquid
                       Buildings.Utilities.Psychrometrics.Functions.saturationPressure
                       Buildings.Utilities.Psychrometrics.Functions.sublimationPressureIce
                       Buildings.Utilities.Psychrometrics.SaturationPressureLiquid
                       Buildings.Utilities.Psychrometrics.SaturationPressure
                       Buildings.Utilities.Psychrometrics.SublimationPressureIce
    </td>
    <td valign=\"top\">Various functions and blocks for psychrometric calculations.
    </td>
    </tr>
</table>
<!-- Backward compatible changes -->
<p>
The following <b style=\"color:blue\">existing components</b>
have been <b style=\"color:blue\">improved</b> in a
<b style=\"color:blue\">backward compatible</b> way:
</p>
<table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
<tr><td colspan=\"2\"><b>Buildings.Fluid</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.Interfaces.PartialTwoPortInterface<br/>
                       Buildings.Fluid.Interfaces.PartialFourPortInterface
    </td>
    <td valign=\"top\">Removed call to homotopy function
                       in the computation of the connector variables as
                       these are conditionally enabled variables and
                       therefore must not be used in any equation. They
                       are only for output reporting.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.Actuators.Dampers.Exponential
    </td>
    <td valign=\"top\">Improved documentation of the flow resistance.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.BoundaryConditions</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.BoundaryConditions.WeatherData.ReaderTMY3<br/>
    </td>
    <td valign=\"top\">Added the option to use a constant, an input signal or the weather file as the source
                       for the ceiling height, the total sky cover, the opaque sky cover, the dew point temperature,
                       and the infrared horizontal radiation <code>HInfHor</code>.
    </td>
</tr>
</table>
<!-- Non-backward compatible changes to existing components -->
<p>
The following <b style=\"color:blue\">existing components</b>
have been <b style=\"color:blue\">improved</b> in a
<b style=\"color:blue\">non-backward compatible</b> way:
</p>
<table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">

<tr><td colspan=\"2\"><b>Buildings.Fluid</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.Movers.FlowMachinePolynomial
    </td>
    <td valign=\"top\">Moved the model to the package
                       <code>Buildings.Obsolete</code>,
                       as this model is planned to be removed in future versions.
                       The conversion script should update old instances of
                       this model automatically in Dymola.
                       Users should change their models to use a flow machine from
                       the package <code>Buildings.Fluid.Movers</code>.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.Storage.ExpansionVessel
    </td>
    <td valign=\"top\">Simplified the model to have a constant pressure.
                       The following non-backward compatible changes
                       have been made.
                       <ol>
                       <li>The parameter <code>VTot</code> was renamed to <code>V_start</code>.</li>
                       <li>The following parameters were removed: <code>VGas0</code>,
                           <code>pMax</code>, <code>energyDynamics</code> and <code>massDynamics</code>.</li>
                       </ol>
                       The conversion script should update old instances of
                       this model automatically in Dymola.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.Storage.StratifiedEnhancedInternalHex
    </td>
    <td valign=\"top\">Revised the model as the old version required the port<sub>a</sub>
                       of the heat exchanger to be located higher than port<sub>b</sub>.
                       This makes sense if the heat exchanger is used to heat up the tank,
                       but not if it is used to cool down a tank, such as in a cooling plant.
                       The following parameters were changed:
                       <ol>
                         <li>Changed <code>hexTopHeight</code> to <code>hHex_a</code>.</li>
                         <li>Changed <code>hexBotHeight</code> to <code>hHex_b</code>.</li>
                         <li>Changed <code>topHexSeg</code> to <code>segHex_a</code>,
                          and made it protected as this is deduced from <code>hHex_a</code>.</li>
                         <li>Changed <code>botHexSeg</code> to <code>segHex_b</code>,
                          and made it protected as this is deduced from <code>hHex_b</code>.</li>
                       </ol>
                       The names of the following ports have been changed:
                       <ol>
                         <li>Changed <code>port_a1</code> to <code>portHex_a</code>.</li>
                         <li>Changed <code>port_b1</code> to <code>portHex_b</code>.</li>
                       </ol>
                       The conversion script should update old instances of
                       this model automatically in Dymola for all of the above changes.
    </td>
</tr>
</table>
<!-- Errors that have been fixed -->
<p>
The following <b style=\"color:red\">critical errors</b> have been fixed (i.e., errors
that can lead to wrong simulation results):
</p>
<table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
<tr><td colspan=\"2\"><b>Buildings.Fluid</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.Geothermal.Boreholes.UTube
    </td>
    <td valign=\"top\">Reimplemented the resistor network inside the borehole
                       as the old implementation led to too slow a transient
                       response. This change also led to the removal of the
                       parameters <code>B0</code> and <code>B1</code>
                       as the new implementation does not require them.
    </td>
</tr>
</table>
<!-- Uncritical errors -->
<p>
The following <b style=\"color:red\">uncritical errors</b> have been fixed (i.e., errors
that do <b style=\"color:red\">not</b> lead to wrong simulation results, e.g.,
units are wrong or errors in documentation):
</p>
<table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
<tr><td colspan=\"2\"><b>Buildings.Fluid</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.Geothermal.Boreholes.BaseClasses.HexInternalElement
    </td>
    <td valign=\"top\">Corrected error in documentation which stated a wrong default value
                       for the pipe spacing.
    </td>
    </tr>
<tr><td valign=\"top\">Buildings.Fluid.HeatExchangers.BaseClasses.ntu_epsilonZ()
    </td>
    <td valign=\"top\">Added dummy argument to function call of <code>Internal.solve</code>
                       to avoid a warning during model check in Dymola 2015.
    </td>
<tr><td valign=\"top\">Buildings.Fluid.HeatExchangers.DryEffectivenessNTU
    </td>
    <td valign=\"top\">Changed <code>assert</code> statement to avoid comparing
                       enumeration with an integer, which triggers a warning
                       in Dymola 2015.
    </td>

    </tr>    <tr><td valign=\"top\">Buildings.ThermalZones.Detailed.Constructions.Examples.ExteriorWall<br/>
                           Buildings.ThermalZones.Detailed.Constructions.Examples.ExteriorWallWithWindow<br/>
                           Buildings.ThermalZones.Detailed.Constructions.Examples.ExteriorWallTwoWindows
    </td>
    <td valign=\"top\">Corrected wrong assignment of parameter in instance <code>bouConExt(conMod=...)</code>
                       which was set to an interior instead of an exterior convection model.
    </td>
    </tr>
<tr><td valign=\"top\">Buildings.Utilities.Psychrometrics.Functions.TDewPoi_pW()
    </td>
    <td valign=\"top\">Added dummy argument to function call of <code>Internal.solve</code>
                       to avoid a warning during model check in Dymola 2015.
    </td>
</table>
<!-- Github issues -->
<p>
The followings
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues\">issues</a>
have been fixed:
</p>
<table border=\"1\" summary=\"github issues\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
<tr><td colspan=\"2\"><b>Buildings.Fluid</b>
    </td>
</tr>
<tr><td valign=\"top\"><a href=\"https://github.com/lbl-srg/modelica-buildings/issues/196\">#196</a>
    </td>
    <td valign=\"top\">Change capacity location in borehole grout.
    </td>
</tr>
</table>
</html>"));
    end Version_1_6_build1;

    class Version_1_5_build3 "Version 1.5 build 3"
      extends Modelica.Icons.ReleaseNotes;
        annotation (preferredView="info",
        Documentation(info="<html>
<p>
Version 1.5 build 3 is a maintenance release that corrects an error in
<code>Buildings.Fluid.MassExchangers.HumidifierPrescribed</code>.
It is fully compatible with version 1.5 build 2.
</p>
<!-- Errors that have been fixed -->
<p>
The following <b style=\"color:red\">critical errors</b> have been fixed (i.e., errors
that can lead to wrong simulation results):
<table summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
<tr><td colspan=\"2\"><b>Buildings.Fluid</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.MassExchangers.HumidifierPrescribed
    </td>
    <td valign=\"top\">
           Corrected the enthalpy balance, which caused the latent heat flow rate to be added
           twice to the fluid stream.
           This closes issue <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/197\">#197</a>.
    </td>
</tr>
</table>
<!-- Github issues -->
<p>
The following
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues\">issues</a>
have been fixed:
</p>
<table summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
<tr><td colspan=\"2\"><b>HumidifierPrescribed accounts twice for latent heat gain</b>
    </td>
</tr>
<tr><td valign=\"top\"><a href=\"https://github.com/lbl-srg/modelica-buildings/issues/197\">#197</a>
    </td>
    <td valign=\"top\">This issue has been addressed by correcting the latent heat added to the
                       fluid stream.
    </td>
</tr>
</table>
</html>"));
    end Version_1_5_build3;

    class Version_1_5_build2 "Version 1.5 build 2"
      extends Modelica.Icons.ReleaseNotes;
        annotation (preferredView="info",
        Documentation(info="<html>
<p>
Version 1.5 build 2 is a maintenance release that corrects an error in
<a href=\"modelica://Buildings.Fluid.HeatExchangers.DryCoilDiscretized\">
Buildings.Fluid.HeatExchangers.DryCoilDiscretized</a> and in
<a href=\"modelica://Buildings.Fluid.HeatExchangers.WetCoilDiscretized\">
Buildings.Fluid.HeatExchangers.WetCoilDiscretized</a>.
It is fully compatible with version 1.5 build 1.
<!-- Errors that have been fixed -->
<p>
The following <b style=\"color:red\">critical errors</b> have been fixed (i.e., errors
that can lead to wrong simulation results):
</p>
<table summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
<tr><td colspan=\"2\"><b>Buildings.Fluid</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.HeatExchangers.DryCoilDiscretized<br/>
                       Buildings.Fluid.HeatExchangers.WetCoilDiscretized
    </td>
    <td valign=\"top\">
           Corrected wrong connect statements that caused the last register to have
           no liquid flow.
           This closes issue <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/194\">#194</a>.
    </td>
</tr>
</table>
<!-- Github issues -->
<p>
The following
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues\">issues</a>
have been fixed:
</p>
<table summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
<tr><td colspan=\"2\"><b>DryCoilDiscretized model not using last register, liquid flow path</b>
    </td>
</tr>
<tr><td valign=\"top\"><a href=\"https://github.com/lbl-srg/modelica-buildings/issues/194\">#194</a>
    </td>
    <td valign=\"top\">This issue has been addressed by correcting the connect statements.
    </td>
</tr>
</table>
</html>"));
    end Version_1_5_build2;

    class Version_1_5_build1 "Version 1.5 build 1"
      extends Modelica.Icons.ReleaseNotes;
        annotation (preferredView="info",
        Documentation(info="<html>
<p>
Version 1.5 build 1 is a major release that contains new packages with models for
solar collectors and for the Facility for Low Energy Experiments (FLEXLAB)
at the Lawrence Berkeley National Laboratory.
</p>
<p>
This release also contains a major revision of all info sections to correct invalid html syntax.
The package <code>Buildings.HeatTransfer.Radiosity</code> has been revised to comply
with the Modelica language specification.
The package <code>Buildings.ThermalZones.Detailed</code> has been revised to aid implementation of
non-uniformly mixed room air models.
This release also contains various corrections that avoid warnings during translation
when used with Modelica 3.2.1.
Various models have been revised to increase compatibility with OpenModelica.
However, currently only a subset of the models work with OpenModelica.
</p>
<!-- New libraries -->
<p>
The following <b style=\"color:blue\">new libraries</b> have been added:
</p>
<table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\">
<tr><td valign=\"top\">Buildings.Fluid.SolarCollectors
    </td>
    <td valign=\"top\">Library with solar collectors.
    </td>
    </tr>
<tr><td valign=\"top\">Buildings.ThermalZones.Detailed.FLEXLAB
    </td>
    <td valign=\"top\">Package with models for test cells of LBNL's FLEXLAB
                       (Facility for Low Energy Experiments in Buildings).
    </td>
    </tr>
<tr><td valign=\"top\">Buildings.Utilities.IO.FLEXLAB
    </td>
    <td valign=\"top\">Package that demonstrates two-way data exchange
                       between Modelica and LBNL's FLEXLAB (Facility for
                       Low Energy Experiments in Buildings).
    </td>
    </tr>
</table>
<!-- New components for existing libraries -->
<p>
The following <b style=\"color:blue\">new components</b> have been added
to <b style=\"color:blue\">existing</b> libraries:
</p>
<table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
<tr><td colspan=\"2\"><b>Buildings.Fluid.Storage</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.Storage.StratifiedEnhancedInternalHex
    </td>
    <td valign=\"top\">Added a model of a tank with built-in heat exchanger.
                       This model may be used together with solar thermal plants.
    </td>
    </tr>
<tr><td colspan=\"2\"><b>Buildings.Resources</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Resources.Include
    </td>
    <td valign=\"top\">Added an <code>Include</code> folder and the <code>bcvtb.h</code>
    header file to it to fix compilation errors in BCVTB example files.
    </td>
    </tr>
</table>
<!-- Backward compatible changes -->
<p>
The following <b style=\"color:blue\">existing components</b>
have been <b style=\"color:blue\">improved</b> in a
<b style=\"color:blue\">backward compatible</b> way:
</p>
<table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">

<tr><td colspan=\"2\"><b>Buildings.BoundaryConditions</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.BoundaryConditions.WeatherData.ReaderTMY3<br/>
                       Buildings.BoundaryConditions.WeatherData.BaseClasses.getAbsolutePath
    </td>
    <td valign=\"top\">Improved the algorithm that determines the absolute path of the file.
                       Now weather files are searched in the path specified, and if not found, the urls
                       <code>file://</code>, <code>modelica://</code> and <code>modelica://Buildings</code>
                       are added in this order to search for the weather file.
                       This allows using the data reader without having to specify an absolute path,
                       as long as the <code>Buildings</code> library
                       is on the <code>MODELICAPATH</code>.
    </td>
</tr>


<tr><td colspan=\"2\"><b>Buildings.Fluid</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.Interfaces.StaticTwoPortConservationEquation
    </td>
    <td valign=\"top\">Reformulated computation of outlet properties to avoid an event at zero mass flow rate.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.HeatExchangers.CoolingTowers.YorkCalc
    </td>
    <td valign=\"top\">Simplified the implementation for the situation if
                       <code>allowReverseFlow=false</code>.
                       Avoided the use of the conditionally enabled variables <code>sta_a</code> and
                       <code>sta_b</code> as this was not proper use of the Modelica syntax.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.Interfaces.Examples.ReverseFlowHumidifier
    </td>
    <td valign=\"top\">Changed one instance of <code>Modelica.Fluid.Sources.MassFlowSource_T</code>,
                       that was connected to the two fluid streams,
                       to two instances, each having half the mass flow rate.
                       This is required for the model to work with Modelica 3.2.1 due to the
                       change introduced in
                       ticket <a href=\"https://trac.modelica.org/Modelica/ticket/739\">#739</a>.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.Sensors.EnthalpyFlowRate<br/>
                       Buildings.Fluid.Sensors.SensibleEnthalpyFlowRate<br/>
                       Buildings.Fluid.Sensors.LatentEnthalpyFlowRate<br/>
                       Buildings.Fluid.Sensors.VolumeFlowRate
    </td>
    <td valign=\"top\">Removed default value <code>tau=0</code> as the base class
                       already sets <code>tau=1</code>.
                       This change was made so that all sensors use the same default value.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.Sensors.TraceSubstancesTwoPort
    </td>
    <td valign=\"top\">Added default value <code>C_start=0</code>.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.HeatTransfer</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.HeatTransfer.Data.OpaqueConstructions.Generic
    </td>
    <td valign=\"top\">Changed the annotation of the
                       instance <code>material</code> from
                       <code>Evaluate=true</code> to <code>Evaluate=false</code>.
                       This is required to allow changing the
                       material properties after compilation.
                       Note, however, that the number of state variables in
                       <a href=\"modelica://Buildings.HeatTransfer.Data.BaseClasses.Material\">
                       Buildings.HeatTransfer.Data.BaseClasses.Material</a>
                       are only computed when the model is translated, because
                       the number of state variables is fixed
                       at compilation time.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Utilities</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Utilities.Diagnostics.AssertEquality<br/>
                       Buildings.Utilities.Diagnostics.AssertInequality
    </td>
    <td valign=\"top\">Added <code>time</code> in print statement as OpenModelica,
                       in its error message, does not output the time
                       when the assert is triggered.
    </td>
</tr>
</table>
<!-- Non-backward compatible changes to existing components -->
<p>
The following <b style=\"color:blue\">existing components</b>
have been <b style=\"color:blue\">improved</b> in a
<b style=\"color:blue\">non-backward compatible</b> way:
</p>
<table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">

<tr><td colspan=\"2\"><b>Buildings.Airflow</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Airflow.Multizone.Orifice<br/>
                       Buildings.Airflow.Multizone.EffectiveAirLeakageArea<br/>
                       Buildings.Airflow.Multizone.ZonalFlow_ACS
    </td>
    <td valign=\"top\">Changed the parameter <code>useConstantDensity</code> to
                       <code>useDefaultProperties</code> to use consistent names
                       within this package.
                       A conversion script in <code>Resources/Scripts/Dymola</code>
                       can be used to update old models that use this parameter.
    </td>
</tr>

<tr><td colspan=\"2\"><b>Buildings.Fluid</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.BaseClasses.IndexWater
    </td>
    <td valign=\"top\">Renamed class to
                       <code>Buildings.Fluid.BaseClasses.IndexMassFraction</code>
                       as it is applicable for all mass fraction sensors.
    </td>
</tr>
<tr><td valign=\"top\">
                       Buildings.Fluid.HeatExchangers.ConstantEffectiveness<br/>
                       Buildings.Fluid.HeatExchangers.DryEffectivenessNTU<br/>
                       Buildings.Fluid.Interfaces.ConservationEquation<br/>
                       Buildings.Fluid.Interfaces.StaticFourPortHeatMassExchanger<br/>
                       Buildings.Fluid.Interfaces.StaticTwoPortConservationEquation<br/>
                       Buildings.Fluid.Interfaces.StaticTwoPortHeatMassExchanger<br/>
                       Buildings.Fluid.MassExchangers.ConstantEffectiveness<br/>
                       Buildings.Fluid.MassExchangers.HumidifierPrescribed<br/>
                       Buildings.Fluid.MixingVolumes.BaseClasses.PartialMixingVolumeWaterPort<br/>
                       Buildings.Fluid.MixingVolumes.MixingVolume<br/>
                       Buildings.Fluid.MixingVolumes.MixingVolumeDryAir<br/>
                       Buildings.Fluid.MixingVolumes.MixingVolumeMoistAir<br/>
                       Buildings.Fluid.Storage.ExpansionVessel
    </td>
    <td valign=\"top\">Changed the input connector <code>mXi_flow</code> (or <code>mXi1_flow</code>
                       and <code>mXi2_flow</code>) to <code>mWat_flow</code> (or <code>mWat1_flow</code>
                       and <code>mWat2_flow</code>).
                       This change has been done as declaring <code>mXi_flow</code> is ambiguous
                       because it does not specify what other species are added unless a mass flow rate
                       <code>m_flow</code> is also known. To avoid this confusion, the connector variables
                       have been renamed.
                       The equations that were used were, however, correct.
                       This addresses issue <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/165\">#165</a>.
    </td>
</tr>
<tr><td valign=\"top\">
                       Buildings.Fluid.Storage.BaseClasses.IndirectTankHeatExchanger<br/>
                       Buildings.Fluid.BaseClasses.PartialResistance<br/>
                       Buildings.Fluid.FixedResistances.BaseClasses.Pipe<br/>
                       Buildings.Fluid.FixedResistances.FixedResistanceDpM<br/>
                       Buildings.Fluid.FixedResistances.LosslessPipe<br/>
                       Buildings.Fluid.Geothermal.Boreholes.BaseClasses.BoreholeSegment<br/>
                       Buildings.Fluid.Geothermal.Boreholes.UTube<br/>
                       Buildings.Fluid.HeatExchangers.RadiantSlabs.ParallelCircuitsSlab<br/>
                       Buildings.Fluid.Interfaces.FourPortHeatMassExchanger<br/>
                       Buildings.Fluid.Interfaces.PartialFourPortInterface<br/>
                       Buildings.Fluid.Interfaces.PartialTwoPortInterface<br/>
                       Buildings.Fluid.Interfaces.StaticFourPortHeatMassExchanger<br/>
                       Buildings.Fluid.Interfaces.StaticTwoPortHeatMassExchanger<br/>
                       Buildings.Fluid.Interfaces.TwoPortHeatMassExchanger<br/>
                       Buildings.Fluid.MixingVolumes.BaseClasses.PartialMixingVolume<br/>
                       Buildings.Fluid.Movers.BaseClasses.FlowControlled<br/>
                       Buildings.Fluid.Movers.BaseClasses.IdealSource<br/>
                       Buildings.Fluid.Movers.BaseClasses.PrescribedFlowMachine<br/>
    </td>
    <td valign=\"top\">Removed the computation of <code>V_flow</code> and removed the parameter
                       <code>show_V_flow</code>.
                       The reason is that the computation of <code>V_flow</code> required
                       the use of <code>sta_a</code> (to compute the density),
                       but <code>sta_a</code> is also a variable that is conditionally
                       enabled. However, this was not correct Modelica syntax as conditional variables
                       can only be used in a <code>connect</code>
                       statement, not in an assignment. Dymola 2014 FD01 beta3 is checking
                       for this incorrect syntax. Hence, <code>V_flow</code> was removed as its
                       conditional implementation would require a rather cumbersome implementation
                       that uses a new connector that carries the state of the medium.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.MixingVolumes
    </td>
    <td valign=\"top\">Removed <code>Buildings.Fluid.MixingVolumes.MixingVolumeDryAir</code>
                       as this model is no longer used. The model
                       <code>Buildings.Fluid.MixingVolumes.MixingVolume</code>
                       can be used instead of.<br/>
                       Removed base class <code>Buildings.Fluid.MixingVolumes.BaseClasses.PartialMixingVolumeWaterPort</code>
                       as this model is no longer used.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.Sensors.Examples.TraceSubstances
    </td>
    <td valign=\"top\">Renamed example from <code>ExtraProperty</code> to
                     <code>TraceSubstances</code> in order to use the same name
                     as the sensor.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.Sources.PrescribedExtraPropertyFlowRate
    </td>
    <td valign=\"top\">Renamed model to<code>TraceSubstancesFlowRate</code> to
                     use the same terminology than the Modelica Standard Library.<br/>
                     The conversion script updates existing models that instantiate
                     this model.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.Sources.Examples.PrescribedExtraPropertyFlow
    </td>
    <td valign=\"top\">Renamed example to<code>TraceSubstancesFlowRate</code>
                     in order to use the same name as the source model.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.MixingVolumes.BaseClasses.PartialMixingVolume<br/>
                       Buildings.Fluid.FixedResistances.Pipe<br/>
                       Buildings.Fluid.HeatExchangers.RadiantSlabs.ParallelCircuitsSlab<br/>
                       Buildings.Fluid.HeatExchangers.RadiantSlabs.SingleCircuitSlab<br/>
                       Buildings.Fluid.Movers.BaseClasses.FlowControlled
    </td>
    <td valign=\"top\">Renamed <code>X_nominal</code> to <code>X_default</code>
                       or <code>X_start</code>, where <code>X</code> may be
                       <code>state</code>, <code>rho</code>, or <code>mu</code>,
                       depending on whether the medium default values or the start values
                       are used in the computation of the state
                       and derived quantities.
    </td>
</tr>

<tr><td colspan=\"2\"><b>Buildings.HeatTransfer<br/>
                         Buildings.ThermalZones</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.HeatTransfer.Interfaces.RadiosityInflow<br/>
                       Buildings.HeatTransfer.Interfaces.RadiosityOutflow<br/>
                       Buildings.HeatTransfer.Radiosity.BaseClasses.ParametersTwoSurfaces<br/>
                       Buildings.HeatTransfer.Radiosity.Constant<br/>
                       Buildings.HeatTransfer.Radiosity.Examples.OpaqueSurface<br/>
                       Buildings.HeatTransfer.Radiosity.Examples.OutdoorRadiosity<br/>
                       Buildings.HeatTransfer.Radiosity.IndoorRadiosity<br/>
                       Buildings.HeatTransfer.Radiosity.OpaqueSurface<br/>
                       Buildings.HeatTransfer.Radiosity.OutdoorRadiosity<br/>
                       Buildings.HeatTransfer.Radiosity.RadiositySplitter<br/>
                       Buildings.HeatTransfer.Radiosity.package<br/>
                       Buildings.HeatTransfer.Windows.BaseClasses.Examples.CenterOfGlass<br/>
                       Buildings.HeatTransfer.Windows.BaseClasses.Examples.GlassLayer<br/>
                       Buildings.HeatTransfer.Windows.BaseClasses.Examples.Shade<br/>
                       Buildings.HeatTransfer.Windows.BaseClasses.GlassLayer<br/>
                       Buildings.HeatTransfer.Windows.BaseClasses.Shade<br/>
                       Buildings.HeatTransfer.Windows.Examples.BoundaryHeatTransfer<br/>
                       Buildings.HeatTransfer.Windows.ExteriorHeatTransfer<br/>
                       Buildings.HeatTransfer.Windows.InteriorHeatTransfer<br/>
                       Buildings.ThermalZones.Detailed.BaseClasses.InfraredRadiationExchange<br/>
                       Buildings.ThermalZones.Detailed.BaseClasses.InfraredRadiationGainDistribution<br/>
                       Buildings.ThermalZones.Detailed.BaseClasses.MixedAir<br/>
                       Buildings.ThermalZones.Detailed.BaseClasses.Overhang<br/>
                       Buildings.ThermalZones.Detailed.BaseClasses.SideFins
    </td>
    <td valign=\"top\">Changed the connectors for the radiosity model.
                       The previous implemenation declared the radiosity as a
                       <code>flow</code> variables, but the implementation did not use
                       a potential variable.<br/>
                       Therefore, the radiosity was the only variable in the connector,
                       which is not allowed for <code>flow</code> variables.
                       This change required a reformulation of models because with the new formulation,
                       the incoming and outcoming radiosity are both non-negative values.
                       This addresses issue <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/158\">#158</a>.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.HeatTransfer<br/>
                         Buildings.ThermalZones</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.HeatTransfer.Windows.BaseClasses.PartialConvection<br/>
                       Buildings.HeatTransfer.Windows.BaseClasses.PartialWindowBoundaryCondition<br/>
                       Buildings.HeatTransfer.Windows.BaseClasses.Shade<br/>
                       Buildings.HeatTransfer.Windows.BaseClasses.ShadeConvection<br/>
                       Buildings.HeatTransfer.Windows.BaseClasses.ShadeRadiation<br/>
                       Buildings.HeatTransfer.Windows.InteriorHeatTransfer<br/>
                       Buildings.HeatTransfer.Windows.InteriorHeatTransferConvective<br/>
                       Buildings.ThermalZones.Detailed.ExteriorBoundaryConditionsWithWindow<br/>
                       Buildings.ThermalZones.Detailed.PartialSurfaceInterface<br/>
                       Buildings.ThermalZones.Detailed.InfraredRadiationExchange<br/>
                       Buildings.ThermalZones.Detailed.AirHeatMassBalanceMixed<br/>
                       Buildings.ThermalZones.Detailed.SolarRadiationExchange<br/>
                       Buildings.ThermalZones.Detailed.RadiationTemperature<br/>
                       Buildings.ThermalZones.Detailed.InfraredRadiationGainDistribution
    </td>
    <td valign=\"top\">Redesigned the implementation of the room model and its base classes.
                       This redesign separates convection from radiation, and it provides
                       one composite model for the convection and the heat and mass balance in
                       the room. This change was done to allow an implementation of the room air
                       heat and mass balance that does not assume uniformly mixed room air.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.HeatTransfer</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.HeatTransfer.Convection.Functions.HeatFlux.rayleigh
    </td>
    <td valign=\"top\">Renamed function from <code>raleigh</code> to <code>rayleigh</code>.
    </td>
</tr>


</table>
<!-- Errors that have been fixed -->
<p>
The following <b style=\"color:red\">critical errors</b> have been fixed (i.e., errors
that can lead to wrong simulation results):
</p>
<table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
<tr><td colspan=\"2\"><b>Buildings.Fluid</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.Sensors.SpecificEntropyTwoPort
    </td>
    <td valign=\"top\">
           Corrected wrong computation of the dynamics used for the sensor signal.
    </td>
</tr>

<tr><td colspan=\"2\"><b>Buildings.HeatTransfer</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.HeatTransfer.Data.GlazingSystems.DoubleClearAir13Clear
    </td>
    <td valign=\"top\">
           Corrected the glass layer thickness, which was <i>5.7</i> mm instead of
           <i>3</i> mm, as the documentation states.
    </td>
</tr>
</table>
<!-- Uncritical errors -->
<p>
The following <b style=\"color:red\">uncritical errors</b> have been fixed (i.e., errors
that do <b style=\"color:red\">not</b> lead to wrong simulation results, e.g.,
units are wrong or errors in documentation):
</p>
<table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
<tr><td colspan=\"2\"><b>Buildings</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.BoundaryConditions.SkyTemperature.BlackBody<br/>
              Buildings.BoundaryConditions.WeatherData.BaseClasses.CheckTemperature<br/>
              Buildings.BoundaryConditions.WeatherData.ReaderTMY3<br/>
              Buildings.Controls.SetPoints.HotWaterTemperatureReset<br/>
              Buildings.Examples.ChillerPlant.BaseClasses.Controls.ChillerSwitch<br/>
              Buildings.Examples.ChillerPlant.BaseClasses.Controls.WSEControl<br/>
              Buildings.Fluid.Boilers.BoilerPolynomial<br/>
              Buildings.Fluid.HeatExchangers.BaseClasses.HexElement<br/>
              Buildings.Fluid.HeatExchangers.BaseClasses.MassExchange<br/>
              Buildings.Fluid.HeatExchangers.BaseClasses.MassExchangeDummy<br/>
              Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.ApparatusDewPoint<br/>
              Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.ApparatusDryPoint<br/>
              Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.CoolingCapacity<br/>
              Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.DXCooling<br/>
              Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.DryCoil<br/>
              Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.DryWetSelector<br/>
              Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.Evaporation<br/>
              Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.WetCoil<br/>
              Buildings.Fluid.MixingVolumes.BaseClasses.PartialMixingVolumeWaterPort<br/>
              Buildings.Fluid.Sensors.RelativeTemperature<br/>
              Buildings.Fluid.Sensors.Temperature<br/>
              Buildings.Fluid.Sensors.TemperatureTwoPort<br/>
              Buildings.Fluid.Sensors.TemperatureWetBulbTwoPort<br/>
              Buildings.Fluid.SolarCollectors.BaseClasses.PartialHeatLoss<br/>
              Buildings.Utilities.Comfort.Fanger<br/>
              Buildings.Utilities.IO.BCVTB.From_degC<br/>
              Buildings.Utilities.IO.BCVTB.To_degC<br/>
              Buildings.Utilities.Psychrometrics.TDewPoi_pW<br/>
              Buildings.Utilities.Psychrometrics.TWetBul_TDryBulPhi<br/>
              Buildings.Utilities.Psychrometrics.TWetBul_TDryBulXi<br/>
              Buildings.Utilities.Psychrometrics.WetBul_pTX<br/>
              Buildings.Utilities.Psychrometrics.pW_TDewPoi
    </td>
    <td valign=\"top\">Replaced wrong attribute <code>quantity=\"Temperature\"</code>
                     with <code>quantity=\"ThermodynamicTemperature\"</code>.
    </td>
</tr>

<tr><td colspan=\"2\"><b>Buildings.Fluid</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.Data.Fuels.Generic
    </td>
    <td valign=\"top\">Corrected wrong type for <code>mCO2</code>.
                       It was declared as <code>Modelica.SIunits.MassFraction</code>,
                       which is incorrect.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.HeatExchangers.CoolingTowers.Correlations.BaseClasses.Bounds
    </td>
    <td valign=\"top\">Corrected wrong type for <code>FRWat_min</code>, <code>FRWat_max</code>
                       and <code>liqGasRat_max</code>.
                       They were declared as <code>Modelica.SIunits.MassFraction</code>,
                       which is incorrect as, for example, <code>FRWat_max</code> can be larger than one.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.HeatExchangers.ConstantEffectiveness<br/>
                     Buildings.Fluid.MassExchangers.ConstantEffectiveness
    </td>
    <td valign=\"top\">Corrected error in the documentation that was not updated
                     when the implementation of zero flow rate was revised.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.Interfaces.ConservationEquation
    </td>
    <td valign=\"top\">Corrected the syntax error
                       <code>Medium.ExtraProperty C[Medium.nC](each nominal=C_nominal)</code>
                       to
                       <code>Medium.ExtraProperty C[Medium.nC](nominal=C_nominal)</code>
                       because <code>C_nominal</code> is a vector.
                       This syntax error caused a compilation error in OpenModelica.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.Sensors.SensibleEnthalpyFlowRate<br/>
                       Buildings.Fluid.Sensors.LatentEnthalpyFlowRate<br/>
                       Buildings.Fluid.Sensors.MassFraction<br/>
                       Buildings.Fluid.Sensors.MassFractionTwoPort
    </td>
    <td valign=\"top\">Changed medium declaration in the <code>extends</code> statement
                       to <code>replaceable</code> to avoid a translation error in
                       OpenModelica.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.Sensors.TraceSubstances<br/>
                       Buildings.Fluid.Sensors.TraceSubstancesTwoPort
    </td>
    <td valign=\"top\">Corrected syntax errors in setting nominal value for output signal
                       and for state variable.
                       This eliminates a compilation error in OpenModelica.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.Sources.TraceSubstancesFlowSource
    </td>
    <td valign=\"top\">Added missing <code>each</code> in declaration of
                       <code>C_in_internal</code>.
                       This eliminates a compilation error in OpenModelica.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Utilities.Python27</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Utilities.IO.Python27.Functions.exchange
    </td>
    <td valign=\"top\">Corrected error in C code that lead to message
                       <code>'module' object has no attribute 'argv'</code>
                       when a python module accessed <code>sys.argv</code>.
    </td>
</tr>



</table>
<!-- Github issues -->
<p>
The following
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues\">issues</a>
have been fixed:
</p>
<table summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
<tr><td colspan=\"2\"><b>Verify mass and species balance</b>
    </td>
</tr>
<tr><td valign=\"top\"><a href=\"https://github.com/lbl-srg/modelica-buildings/issues/165\">#165</a>
    </td>
    <td valign=\"top\">This issue has been addressed by renaming the connectors to avoid an ambiguity
                       in the model equation. The equations were correct.
    </td>
<tr><td colspan=\"2\"><b>Remove flow attribute from radiosity connectors</b>
    </td>
</tr>
<tr><td valign=\"top\"><a href=\"https://github.com/lbl-srg/modelica-buildings/issues/158\">#158</a>
    </td>
    <td valign=\"top\">This issue has been addressed by reformulating the radiosity models.
                       With the new implementation, incoming and outgoing radiosity are non-negative
                       quantities.
    </td>
</tr>
</table>
</html>"));
    end Version_1_5_build1;

  class Version_1_4_build1 "Version 1.4 build 1"
    extends Modelica.Icons.ReleaseNotes;
     annotation (preferredView="info",
     Documentation(info="<html>
<p>
Version 1.4 build 1 contains the new package <code>Buildings.Utilities.IO.Python27</code>
that allows calling Python functions from Modelica.
It also contains in the package <a href=\"modelica://Buildings.HeatTransfer.Conduction.SingleLayer\">
Buildings.HeatTransfer.Conduction.SingleLayer</a>
a new model for heat conduction in phase change material. This model can be used as a layer
of the room heat transfer model.
</p>

<p>
Non-backward compatible changes had to be introduced
in the valve models
<a href=\"modelica://Buildings.Fluid.Actuators.Valves\">
Buildings.Fluid.Actuators.Valves</a> to fully comply with the Modelica language specification,
and in the models in the package
<a href=\"modelica://Buildings.Utilities.Diagnostics\">
Buildings.Utilities.Diagnostics</a>
as they used the <code>cardinality</code> function which is deprecated in the Modelica
Language Specification.
</p>

<p>
See below for details.
<!-- New libraries -->
</p>
<p>
The following <b style=\"color:blue\">new libraries</b> have been added:
</p>
<table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\">
<tr><td valign=\"top\">Buildings.Utilities.IO.Python27
    </td>
    <td valign=\"top\">
         Package that contains blocks and functions that embed Python 2.7 in Modelica.
         Data can be sent to Python functions and received from Python functions.
         This allows for example data analysis in Python as part of a Modelica model,
         or data exchange as part of a hardware-in-the-loop simulation in which
         Python is used to communicate with hardware.
    </td>
    </tr>
</table>
<!-- New components for existing libraries -->
<p>
The following <b style=\"color:blue\">new components</b> have been added
to <b style=\"color:blue\">existing</b> libraries:
</p>
<table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
<tr><td colspan=\"2\"><b>Buildings.BoundaryConditions.WeatherData</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.BoundaryConditions.WeatherData.BaseClasses.getAbsolutePath
    </td>
    <td valign=\"top\">This function is used by the weather data reader to set
                       the path to the weather file relative to the root directory
                       of the Buildings library.
    </td>
    </tr>
</table>
<!-- Backward compatible changes -->
<p>
The following <b style=\"color:blue\">existing components</b>
have been <b style=\"color:blue\">improved</b> in a
<b style=\"color:blue\">backward compatible</b> way:
</p>
<table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
<tr><td colspan=\"2\"><b>Buildings.Fluid</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.MixingVolumes.BaseClasses.PartialMixingVolume
    </td>
    <td valign=\"top\">Removed the check of multiple connections to the same element
                       of a fluid port, as this check required the use of the deprecated
                       <code>cardinality</code> function.
    </td>
</tr><tr><td colspan=\"2\"><b>Buildings.HeatTransfer</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.HeatTransfer.Conduction.SingleLayer
    </td>
    <td valign=\"top\">Added option to model layers with phase change material.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.ThermalZones</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.ThermalZones.Detailed.BaseClasses.InfraredRadiationExchange
    </td>
    <td valign=\"top\">Removed the use of the <code>cardinality</code> function
                       as this function is deprecated in the Modelica Language Specification.
    </td>
</tr>
</table>
<!-- Non-backward compatible changes to existing components -->

<p>
The following <b style=\"color:blue\">existing components</b>
have been <b style=\"color:blue\">improved</b> in a
<b style=\"color:blue\">non-backward compatible</b> way:
</p>
<table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">

<tr><td colspan=\"2\"><b>Buildings.Fluid</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.Actuators.Valves
    </td>
    <td valign=\"top\">All valves now require the declaration of <code>dp_nominal</code>
                       if the parameter assignment is
                       <code>CvData = Buildings.Fluid.Types.CvTypes.OpPoint</code>.
                       This change was needed because in the previous version,
                       <code>dp_nominal</code> had
                       a default value of <i>6000</i> Pascals. However, if
                       <code>CvData &gt;&lt; Buildings.Fluid.Types.CvTypes.OpPoint</code>, then
                       <code>dp_nominal</code> is computed in the initial algorithm section and hence
                       providing a default value is not allowed according to
                       the Modelica Language Specification.
                       Hence, it had to be removed.<br/>
                       As part of this change, we set <code>dp(nominal=6000)</code> for all valves,
                       because the earlier formulation uses a value that is not known during compilation,
                       and hence leads to an error in Dymola 2014.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.MixingVolumes.MixingVolumeDryAir<br/>
                       Buildings.Fluid.MixingVolumes.MixingVolumeMoistAir
    </td>
    <td valign=\"top\">Removed the use of the deprecated
                       <code>cardinality</code> function.
                       Therefore, now all input signals must be connected..
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Utilities</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Utilities.Diagnostics.AssertEquality<br/>
                       Buildings.Utilities.Diagnostics.AssertInequality
    </td>
    <td valign=\"top\">Removed the option to not connect input signals, as this
                       required the use of the <code>cardinality</code> function which
                       is deprecated in the MSL, and not correctly implemented in OpenModelica.
                       Therefore, if using these models, both input signals must be connected.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Utilities.Math.Functions.splineDerivatives
    </td>
    <td valign=\"top\">Removed the default value
                       <code>input Boolean ensureMonotonicity=isMonotonic(y, strict=false)</code>
                       as the Modelica language specification is not clear whether defaults can be computed
                       or must be constants.
    </td>
</tr></table>
<!-- Errors that have been fixed -->

<p>
The following <b style=\"color:red\">critical errors</b> have been fixed (i.e., errors
that can lead to wrong simulation results):
</p>
<table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">

<tr><td colspan=\"2\"><b>Buildings.Controls</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Controls.SetPoints.HotWaterTemperatureReset
    </td>
    <td valign=\"top\">Corrected error that led to wrong results if the room air temperature is
                     different from its nominal value <code>TRoo_nominal</code>.
                     This fixes <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/74\">issue 74</a>.
    </td>
</tr>

<tr><td colspan=\"2\"><b>Buildings.HeatTransfer</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.HeatExchangers.RadiantSlabs.SingleCircuitSlab<br/>
                     Buildings.Fluid.HeatExchangers.RadiantSlabs.ParallelCircuitSlab
    </td>
    <td valign=\"top\">Fixed bug in the assignment of the fictitious thermal resistance by replacing
                     <code>RFic[nSeg](each G=A/Rx)</code> with
                     <code>RFic[nSeg](each G=A/nSeg/Rx)</code>.
                     This fixes <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/79\">issue 79</a>.
    </td>
</tr>

<tr><td colspan=\"2\"><b>Buildings.Utilities</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Utilities.Diagnostics.AssertEquality<br/>
                       Buildings.Utilities.Diagnostics.AssertInequality
    </td>
    <td valign=\"top\">Replaced <code>when</code> test with <code>if</code> test as
                       equations within a <code>when</code> section are only evaluated
                       when the condition becomes true.
                       This fixes <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/72\">issue 72</a>.
    </td>
</tr>
</table>
<!-- Uncritical errors -->

<p>
The following <b style=\"color:red\">uncritical errors</b> have been fixed (i.e., errors
that do <b style=\"color:red\">not</b> lead to wrong simulation results, e.g.,
units are wrong or errors in documentation):
</p>
<table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
<tr><td colspan=\"2\"><b>Buildings.Fluid</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.Actuators.Valves.ThreeWayEqualPercentageLinear<br/>
                       Buildings.Fluid.Actuators.Valves.ThreeWayLinear
    </td>
    <td valign=\"top\">The documenation was
                       <i>Fraction Kv(port_1 &rarr; port_2)/Kv(port_3 &rarr; port_2)</i> instead of
                       <i>Fraction Kv(port_3 &rarr; port_2)/Kv(port_1 &rarr; port_2)</i>.
                       Because the parameter set correctly its attributes
                       <code>min=0</code> and <code>max=1</code>,
                       instances of these models used the correct value.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.Actuators.BaseClasses.ValveParameters
    </td>
    <td valign=\"top\">Removed stray backslash in write statement.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.Interfaces.ConservationEquation<br/>
                       Buildings.Fluid.Interfaces.StaticTwoPortConservationEquation<br/>
                       Buildings.Fluid.Interfaces.StaticTwoPortHeatMassExchanger
    </td>
    <td valign=\"top\">Removed wrong unit attribute of <code>COut</code>.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.HeatExchangers.BaseClasses.HexElement
    </td>
    <td valign=\"top\">Changed the redeclaration of <code>vol2</code> to be replaceable,
                     as <code>vol2</code> is replaced in some models.
    </td>
</tr>
</table>
<!-- Github issues -->
<p>
The following
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues\">issues</a>
have been fixed:
</p>
<table summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
<tr><td colspan=\"2\"><b>Add explanation of nStaRef.</b>
    </td>
</tr>
<tr><td valign=\"top\"><a href=\"https://github.com/lbl-srg/modelica-buildings/issues/70\">&#35;70</a>
    </td>
    <td valign=\"top\">
    Described in
    <a href=\"modelica://Buildings.HeatTransfer.Data.Solids\">
    Buildings.HeatTransfer.Data.Solids</a>
    how the parameter <code>nStaRef</code> is used
    to compute the spatial grid that is used for simulating transient heat conduction.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Assert statement does not fire.</b>
    </td>
</tr>
<tr><td valign=\"top\"><a href=\"https://github.com/lbl-srg/modelica-buildings/issues/72\">&#35;72</a>
    </td>
    <td valign=\"top\">
    The blocks <code>Buildings.Utilities.Diagnostics.AssertEquality</code> and
    <code>Buildings.Utilities.Diagnostics.AssertInequality</code> did not fire because
    the test on the time was in a <code>when</code> instead of an <code>if</code> statement.
    This was wrong because <code>when</code> sections are only evaluated
    when the condition becomes true.
    </td>
</tr>
<tr><td colspan=\"2\"><b><code>HotWaterTemperatureReset</code> computes wrong results if room temperature differs from nominal value.</b>
    </td>
</tr>
<tr><td valign=\"top\"><a href=\"https://github.com/lbl-srg/modelica-buildings/issues/74\">&#35;74</a>
    </td>
    <td valign=\"top\">The equation
<pre>TSup = TRoo_in_internal
          + ((TSup_nominal+TRet_nominal)/2-TRoo_in_internal) * qRel^(1/m)
          + (TSup_nominal-TRet_nominal)/2 * qRel;</pre>
should be formulated as
<pre>TSup = TRoo_in_internal
          + ((TSup_nominal+TRet_nominal)/2-TRoo_nominal) * qRel^(1/m)
          + (TSup_nominal-TRet_nominal)/2 * qRel;</pre>
    </td>
</tr>
<tr><td colspan=\"2\"><b>Bug in <code>RadiantSlabs.SingleCircuitSlab</code> fictitious resistance RFic.</b>
    </td>
</tr>
<tr><td valign=\"top\"><a href=\"https://github.com/lbl-srg/modelica-buildings/issues/79\">&#35;79</a>
    </td>
    <td valign=\"top\">This bug has been fixed in the assignment of the fictitious thermal resistance by replacing
                     <code>RFic[nSeg](each G=A/Rx)</code> with
                     <code>RFic[nSeg](each G=A/nSeg/Rx)</code>.
                     The bug also affected <code>RadiantSlabs.ParallelCircuitSlab</code>.
    </td>
</tr>
</table>

<p>
Note:
</p>
<ul>
<li>
This version contains various updates that allow
the syntax of the example models to be checked in the pedantic mode
in Dymola 2014.
</li>
</ul>
</html>"));
  end Version_1_4_build1;

  class Version_1_3_build1 "Version 1.3 build 1"
    extends Modelica.Icons.ReleaseNotes;
     annotation (preferredView="info", Documentation(info="<html>
<p>
In version 1.3 build 1, models for direct evaporative cooling coils with multiple stages or with
a variable speed compressor have been added.
This version also contains improvements to the fan and pump models to better treat zero mass flow rate.
Various other improvements have been made to improve the numerics and to use consistent variable names.
A detailed list of changes is shown below.
<!-- New libraries -->
</p>
<p>
The following <b style=\"color:blue\">new libraries</b> have been added:
</p>
<table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\">
<tr><td valign=\"top\">Buildings.Fluid.HeatExchangers.DXCoils
    </td>
    <td valign=\"top\">Library with direct evaporative cooling coils.
    </td>
    </tr>
</table>
<!-- New components for existing libraries -->
<p>
The following <b style=\"color:blue\">new components</b> have been added
to <b style=\"color:blue\">existing</b> libraries:
</p>
<table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
<tr><td colspan=\"2\"><b>Buildings.Examples</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Examples.ChillerPlant.DataCenterContinuousTimeControl
    </td>
    <td valign=\"top\">Added chilled water plant model with continuous time control that
                       replaces the discrete time control in
                       <code>Buildings.Examples.ChillerPlant.DataCenterDiscreteTimeControl</code>.
    </td>
    </tr>
<tr><td colspan=\"2\"><b>Buildings.Utilities</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Utilities.Psychrometrics.Functions.X_pSatpphi
    </td>
    <td valign=\"top\">Function that computes moisture concentration based
                       on saturation pressure, total pressure and relative
                       humidity.
    </td>
    </tr>
<tr><td valign=\"top\">Buildings.Utilities.Psychrometrics.TWetBul_TDryBulPhi
    </td>
    <td valign=\"top\">Block that computes the wet bulb temperature for given
                     dry bulb temperature, relative humidity and atmospheric pressure.
    </td>
    </tr>
<tr><td valign=\"top\">Buildings.Utilities.Psychrometrics.WetBul_pTX
    </td>
    <td valign=\"top\">Block that computes the temperature and mass fraction
                       at the wet bulb state for given dry bulb temperature,
                       species concentration and atmospheric pressure.
    </td>
    </tr>
</table>
<!-- Backward compatbile changes -->
<p>
The following <b style=\"color:blue\">existing components</b>
have been <b style=\"color:blue\">improved</b> in a
<b style=\"color:blue\">backward compatible</b> way:
</p>
<table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
<tr><td colspan=\"2\"><b>Buildings.BoundaryConditions</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.BoundaryConditions.WeatherData.ReaderTMY3
    </td>
    <td valign=\"top\">Added computation of the wet bulb temperature.
                       Computing the wet bulb temperature introduces a nonlinear
                       equation. As we have not observed an increase in computing time
                       because of computing the wet bulb temperature, it is computed
                       by default. By setting the parameter
                       <code>computeWetBulbTemperature=false</code>, the computation of the
                       wet bulb temperature can be removed.
    </td>
</tr>

<tr><td colspan=\"2\"><b>Buildings.Controls</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Controls.SetPoints.OccupancySchedule
    </td>
    <td valign=\"top\">Added <code>pre</code> operator and relaxed tolerance in <code>assert</code> statement.
    </td>
</tr>

<tr><td colspan=\"2\"><b>Buildings.Fluid</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.Movers.FlowControlled_dp<br/>
                       Buildings.Fluid.Movers.FlowControlled_m_flow<br/>
                       Buildings.Fluid.Movers.SpeedControlled_Nrpm<br/>
                       Buildings.Fluid.Movers.SpeedControlled_y<br/>
    </td>
    <td valign=\"top\">Reformulated implementation of efficiency model
                       to avoid a division by zero at zero mass flow rate
                       for models in which a user specifies
                       a power instead of an efficiency performance curve.
    </td>
    </tr>
<tr><td colspan=\"2\"><b>Buildings.Utilities</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Utilities.Psychrometrics.TWetBul_TDryBulXi
    </td>
    <td valign=\"top\">Added option to approximate the wet bulb temperature using an
                     explicit equation.
                     Reformulated the original model to change the dimension of the
                     nonlinear system of equations from two to one.
    </td>
    </tr>
</table>
<!-- Non-backward compatible changes to existing components -->
<p>
The following <b style=\"color:blue\">existing components</b>
have been <b style=\"color:blue\">improved</b> in a
<b style=\"color:blue\">non-backward compatible</b> way:
</p>
<table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
<tr><td colspan=\"2\"><b>Buildings.BoundaryConditions</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.BoundaryConditions.WeatherData.ReaderTMY3<br/>
                       Buildings.BoundaryConditions.Types
    </td>
    <td valign=\"top\">Improved the optional inputs for the radiation data global horizontal, diffuse horizontal and direct normal radiation.
    If a user specifies two of them, the third will be automatically calculated.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.BoundaryConditions.SkyTemperature.BlackBody
    </td>
    <td valign=\"top\">Renamed <code>radHor</code> to <code>radHorIR</code>
                       to indicate that the radiation is in the infrared
                       spectrum.
    </td>
</tr>

<tr><td colspan=\"2\"><b>Buildings.Fluid</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Airflow.Multizone.BaseClasses.DoorDiscretized<br/>
                     Buildings.Airflow.Multizone.DoorDiscretizedOpen<br/>
                     Buildings.Airflow.Multizone.DoorDiscretizedOperable<br/>
                     Buildings.Airflow.Multizone.Orifice<br/>
                     Buildings.Airflow.Multizone.ZonalFlow_ACS<br/>
                     Buildings.Fluid.Actuators.BaseClasses.PartialDamperExponential<br/>
                     Buildings.Fluid.Actuators.Dampers.MixingBox<br/>
                     Buildings.Fluid.Actuators.Dampers.VAVBoxExponential<br/>
                     Buildings.Fluid.BaseClasses.PartialResistance<br/>
                     Buildings.Fluid.Interfaces.TwoPortHeatMassExchanger<br/>
                     Buildings.Fluid.Movers.BaseClasses.PowerInterface<br/>
                     Buildings.Fluid.Storage.BaseClasses.Buoyancy<br/>
                     Buildings.Fluid.HeatExchangers.BaseClasses.MassExchange
    </td>
    <td valign=\"top\">Renamed protected parameters for consistency with the naming conventions.
                     In previous releases, fluid properties had the suffix <code>0</code>
                     or <code>_nominal</code> instead of <code>_default</code> when they
                     where computed based on the medium default properties.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.Sensors.SensibleEnthalpyFlowRate<br/>
                     Buildings.Fluid.Sensors.LatentEnthalpyFlowRate
    </td>
    <td valign=\"top\">Moved computation of parameter <code>i_w</code> to new base class
                     <code>Buildings.Fluid.BaseClasses.IndexWater</code>
                     The value of this parameter is now assigned dynamically and does not require to be specified
                     by the user.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.Storage.BaseClasses.ThirdOrderStratifier
    </td>
    <td valign=\"top\">Removed unused protected parameters <code>sta0</code> and <code>cp0</code>.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Examples</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Examples.ChillerPlant.DataCenterDiscreteTimeControl<br/>
                       Buildings.Examples.ChillerPlant.BaseClasses.Controls.TrimAndRespond<br/>
                       Buildings.Examples.ChillerPlant.BaseClasses.Controls.ZeroOrderHold
    </td>
    <td valign=\"top\">Re-implemented the controls for setpoint reset.
    Revised the model <code>TrimAndRespond</code> and deleted the model <code>ZeroOrderHold</code>.
    Improved the documentation.
    </td>
</tr>
</table>
<!-- Errors that have been fixed -->
<p>
The following <b style=\"color:red\">critical errors</b> have been fixed (i.e., errors
that can lead to wrong simulation results):
</p>
<table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
<tr><td colspan=\"2\"><b>Buildings.Examples</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Examples.ChillerPlant.DataCenterDiscreteTimeControl
    </td>
    <td valign=\"top\">Fixed error in wet bulb temperature. The previous version used
                     a model to compute the wet bulb temperature that takes as an
                     input the relative humidity, but required mass fraction as an input.
    </td>
</tr>
</table>
<!-- Uncritical errors -->
<p>
The following <b style=\"color:red\">uncritical errors</b> have been fixed (i.e., errors
that do <b style=\"color:red\">not</b> lead to wrong simulation results, e.g.,
units are wrong or errors in documentation):
</p>
<table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
<tr><td colspan=\"2\"><b>Buildings.BoundaryConditions</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.BoundaryConditions.WeatherData.ReaderTMY3<br/>
                       Buildings.BoundaryConditions.SkyTemperature.BlackBody
    </td>
    <td valign=\"top\">Renamed <code>radHor</code> to <code>radHorIR</code>.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Fluid</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.BaseClasses.FlowModels.Examples.InverseFlowFunction
    </td>
    <td valign=\"top\">Fixed error in the documentation.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.Interfaces.TwoPortHeatMassExchanger
    </td>
    <td valign=\"top\">Fixed broken link in the documentation.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.Movers.BaseClasses.Characteristics.powerParameters
    </td>
    <td valign=\"top\">Fixed wrong <code>displayUnit</code> and
                       <code>max</code> attribute for power.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.MixingVolumes
    </td>
    <td valign=\"top\">In documentation, removed reference to the parameter
                       <code>use_HeatTransfer</code> which no longer exists.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.HeatTransfer</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.HeatTransfer.Windows.Functions.glassPropertyUncoated
    </td>
    <td valign=\"top\">Improved the documentation for implementation and added comments for model limitations.
    </td>
</tr>
</table>
<!-- Github issues -->
<!-- none -->
</html>"));
  end Version_1_3_build1;

  class Version_1_2_build1 "Version 1.2 build 1"
    extends Modelica.Icons.ReleaseNotes;
     annotation (preferredView="info", Documentation(info="<html>
<p>
In version 1.2 build 1, models for radiant slabs and window overhangs and sidefins have been added.
This version also contains various improvements to existing models.
A detailed list of changes is shown below.
<!-- New libraries -->
</p>
<p>
The following <b style=\"color:blue\">new libraries</b> have been added:
</p>
<table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\">
<tr><td valign=\"top\">Buildings.Fluid.HeatExchangers.RadiantSlabs
    </td>
    <td valign=\"top\">Package with models for radiant slabs
                       with pipes or a capillary heat exchanger
                       embedded in the construction.
    </td>
    </tr>
<tr><td valign=\"top\">Buildings.Fluid.Data.Pipes
    </td>
    <td valign=\"top\">Package with records for pipes.
    </td>
    </tr>
</table>
<!-- New components for existing libraries -->

<p>
The following <b style=\"color:blue\">new components</b> have been added
to <b style=\"color:blue\">existing</b> libraries:
</p>
<table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
<tr><td colspan=\"2\"><b>Buildings.HeatTransfer</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.HeatTransfer.Windows.FixedShade<br/>
                       Buildings.HeatTransfer.Windows.Overhang<br/>
                       Buildings.HeatTransfer.Windows.SideFins
    </td>
    <td valign=\"top\">For windows with either an overhang or side fins,
                       these blocks output the fraction of the area
                       that is sun exposed.
    </td>
    </tr>
<tr><td colspan=\"2\"><b>Buildings.ThermalZones</b>
    </td>
</tr>

<tr><td valign=\"top\">Buildings.ThermalZones.Detailed.Examples.BESTEST
    </td>
    <td valign=\"top\">Added BESTEST validation models for case 610, 620, 630, 640,
                       650FF, 650, 920, 940, 950FF, 950, and 960.
    </td>
    </tr>
</table>
<!-- Backward compatible changes -->
<p>
The following <b style=\"color:blue\">existing components</b>
have been <b style=\"color:blue\">improved</b> in a
<b style=\"color:blue\">backward compatible</b> way:
</p>
<table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
<tr><td colspan=\"2\"><b>Buildings.BoundaryConditions</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.BoundaryConditions.WeatherData.ReaderTMY3
    </td>
    <td valign=\"top\">Removed assignment of <code>HGloHor_in</code> in its declaration,
                       because this gives an overdetermined system if the input connector
                       is used.<br/>
                       Added new sub-bus that contains the solar position.
                       This allows reusing the solar position in various other models.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.BoundaryConditions.SolarIrradiation.DiffuseIsotropic<br/>
                       Buildings.BoundaryConditions.SolarIrradiation.DiffusePerez<br/>
                       Buildings.BoundaryConditions.SolarIrradiation.BaseClasses.DiffuseIsotropic<br/>
                       Buildings.BoundaryConditions.SolarIrradiation.BaseClasses.DiffusePerez<br/>
    </td>
    <td valign=\"top\">Added optional output of diffuse radiation from the sky and ground.
                       This allows reusing the diffuse radiation in solar thermal collector.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.BoundaryConditions.SolarGeometry.BaseClasses.SolarAzimuth
    </td>
    <td valign=\"top\">Changed implementation to avoid an event at solar noon.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.HeatTransfer</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.HeatTransfer.Data.BoreholeFillings
    </td>
    <td valign=\"top\">
                       Renamed class to <code>BoreholeFillings</code>
                       to be consistent with data records being plural.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Media</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Media.GasesPTDecoupled.MoistAir<br/>
                       Buildings.Media.Air<br/>
                       Buildings.Media.PerfectGases.MoistAir<br/>
                       Buildings.Media.PerfectGases.MoistAirUnsaturated<br/>
                       Buildings.Media.GasesConstantDensity.MoistAir<br/>
                       Buildings.Media.GasesConstantDensity.MoistAirUnsaturated
    </td>
    <td valign=\"top\">Added redeclaration of <code>ThermodynamicState</code>
                       to avoid a warning
                       during model check and translation.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.ThermalZones</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.ThermalZones.Detailed.MixedAir
    </td>
    <td valign=\"top\">Added a check that ensures that the number of surfaces
                       are equal to the length of the parameter that contains
                       the surface area, and added a check to ensure that no surface area
                       is equal to zero. These checks help detecting erroneous declarations
                       of the room model. The changes were done in
                       <code>Buildings.ThermalZones.Detailed.MixedAir.PartialSurfaceInterface</code>.
    </td>
</tr>
</table>
<!-- Non-backward compatbile changes to existing components -->
<p>
The following <b style=\"color:blue\">existing components</b>
have been <b style=\"color:blue\">improved</b> in a
<b style=\"color:blue\">non-backward compatible</b> way:
</p>
<table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
<tr><td colspan=\"2\"><b>Buildings.ThermalZones</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.ThermalZones.Detailed.MixedAir
    </td>
    <td valign=\"top\">Added optional modeling of window overhangs and side fins.
                       The modeling of window overhangs and side fins required the
                       introduction of the new parameters
                       <code>hWin</code> for the window height and
                       <code>wWin</code> for the window width, in addition to the
                       parameters <code>ove</code> and <code>sidFin</code> which are used
                       to declare the geometry of overhangs and side fins.
                       The parameters <code>hWin</code> and <code>wWin</code>
                       replace the previously used parameter <code>AWin</code> for the
                       window area.
                       Users need to manually replace <code>AWin</code> with <code>hWin</code>
                       and <code>wWin</code> when updating models
                       from a previous version of the library.<br/>
                       See the information section in
                       <a href=\"modelica://Buildings.ThermalZones.Detailed.MixedAir\">
                       Buildings.ThermalZones.Detailed.MixedAir</a> for how to use these models.
    </td>
</tr>
</table>
<!-- Errors that have been fixed -->
<p>
The following <b style=\"color:red\">critical errors</b> have been fixed (i.e., errors
that can lead to wrong simulation results):
</p>
<table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
<tr><td colspan=\"2\"><b>Buildings.Controls</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Controls.SetPoints.OccupancySchedule
    </td>
    <td valign=\"top\">
                      Fixed a bug that caused an error in the schedule if the simulation start time was negative or equal to the first entry in the schedule.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Fluid</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.Storage.BaseClass.ThirdOrderStratifier
    </td>
    <td valign=\"top\">Revised the implementation to reduce the temperature overshoot.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.HeatTransfer</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.HeatTransfer.Windows.BaseClasses.GlassLayer
    </td>
    <td valign=\"top\">Fixed the bug in the temperature linearization and
                       in the heat flow through the glass layer if the transmissivity of glass
                       in the infrared regime is non-zero.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.HeatTransfer.Windows.BaseClasses.CenterOfGlass
    </td>
    <td valign=\"top\">Fixed a bug in the parameter assignment of the instance <code>glass</code>.
                       Previously, the infrared emissivity of surface a was assigned to the surface b.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Utilities</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Utilities.IO.BCVTB
    </td>
    <td valign=\"top\">Added a call to <code>Buildings.Utilities.IO.BCVTB.BaseClasses.exchangeReals</code>
                       in the <code>initial algorithm</code> section.
                       This is needed to propagate the initial condition to the server.
                       It also leads to one more data exchange, which is correct and avoids the
                       warning message in Ptolemy that says that the simulation reached its stop time
                       one time step prior to the final time.
    </td>
</tr>
</table>
<!-- Uncritical errors -->
<p>
The following <b style=\"color:red\">uncritical errors</b> have been fixed (i.e., errors
that do <b style=\"color:red\">not</b> lead to wrong simulation results, e.g.,
units are wrong or errors in documentation):
</p>
<table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
<tr><td colspan=\"2\"><b>Buildings.BoundaryConditions</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.BoundaryConditions.WeatherData.ReaderTMY3
    </td>
    <td valign=\"top\">Corrected the documentation of the unit requirement for
                       input files, parameters and connectors.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Fluid</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.Interfaces.PartialFourPortInterface<br/>
                       Buildings.Fluid.Interfaces.PartialTwoPortInterface
    </td>
    <td valign=\"top\">Replaced the erroneous function call <code>Medium.density</code> with
                       <code>Medium1.density</code> and <code>Medium2.density</code> in
                        <code>PartialFourPortInterface</code>.
                       Changed condition to remove <code>sta_a1</code> and
                       <code>sta_a2</code> in <code>PartialFourPortInterface</code>, and
                       <code>sta_a</code> in <code>PartialTwoPortInterface</code>, to also
                       compute the state at the inlet port if <code>show_V_flow=true</code>.<br/>
                       The previous implementation resulted in a translation error
                       if <code>show_V_flow=true</code>, but worked correctly otherwise
                       because the erroneous function call is removed if  <code>show_V_flow=false</code>.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.Chillers.Examples.BaseClasses.PartialElectric
    </td>
    <td valign=\"top\">Corrected the nominal mass flow rate used in the mass flow source.
    </td>
</tr>
</table>
<!-- Github issues -->
<p>
The following
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues\">issues</a>
have been fixed:
</p>
<table summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
<tr><td colspan=\"2\"><b>Heat transfer in glass layer</b>
    </td>
</tr>
<tr><td valign=\"top\"><a href=\"https://github.com/lbl-srg/modelica-buildings/issues/56\">&#35;56</a>
    </td>
    <td valign=\"top\">Fixed bug in heat flow through the glass layer if the infrared transmissivity is non-zero.
    </td>
</tr>
<tr><td valign=\"top\"><a href=\"https://github.com/lbl-srg/modelica-buildings/issues/57\">&#35;57</a>
    </td>
    <td valign=\"top\">Fixed bug in temperature linearization of window glass.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Overshooting in enhanced stratified tank</b>
    </td>
</tr>
<tr><td valign=\"top\"><a href=\"https://github.com/lbl-srg/modelica-buildings/issues/15\">&#35;15</a>
    </td>
    <td valign=\"top\">Revised the implementation to reduce the temperature over-shoot.
    </td>
</tr>
</table>
</html>"));
  end Version_1_2_build1;

  class Version_1_1_build1 "Version 1.1 build 1"
    extends Modelica.Icons.ReleaseNotes;
     annotation (preferredView="info", Documentation(info="<html>
<p>
Version 1.1 build 1 contains improvements to models that address numerical problems.
In particular, flow machines and actuators now have an optional filter
that converts step changes in the input signal to a smooth change in
speed or actuator position.
Also, (<a href=\"modelica://Buildings.Examples.Tutorial\">
Buildings.Examples.Tutorial</a>)
has been added to provide step-by-step instruction for how to build
system models.
<!-- New libraries -->
</p>
<p>
The following <b style=\"color:blue\">new libraries</b> have been added:
</p>
<table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\">
<tr><td valign=\"top\">Buildings.Examples.Tutorial
    </td>
    <td valign=\"top\">Tutorial with step by step instructions for how to
                       build system models.
    </td>
    </tr>
</table>
<!-- New components for existing libraries -->
<p>
The following <b style=\"color:blue\">new components</b> have been added
to <b style=\"color:blue\">existing</b> libraries:
</p>
<table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
<tr><td colspan=\"2\"><b>Buildings.Fluid</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.FixedResistances.Pipe
    </td>
    <td valign=\"top\">Added a model for a pipe with transport delay and optional heat
                       exchange with the environment.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.Actuators.UsersGuide
    </td>
    <td valign=\"top\">Added a user's guide for actuator models.
    </td>
<tr><td valign=\"top\">Buildings.Fluid.Interfaces.ConservationEquation<br/>
                     Buildings.Fluid.Interfaces.StaticConservationEquation
    </td>
    <td valign=\"top\">These base classes have been added to simplify the implementation
                     of dynamic and steady-state thermofluid models.
    </td>
    </tr>
<tr><td valign=\"top\">Buildings.Fluid.Data.Fuels
    </td>
    <td valign=\"top\">Package with physical properties of fuels that are used by the
                     boiler model.
    </td>
    </tr>
</table>
<!-- Backward compatible changes -->

<p>
The following <b style=\"color:blue\">existing components</b>
have been <b style=\"color:blue\">improved</b> in a
<b style=\"color:blue\">backward compatible</b> way:
</p>
<table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
<tr><td colspan=\"2\"><b>Buildings.Fluid</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.Actuators.Dampers.Exponential<br/>
                       Buildings.Fluid.Actuators.Dampers.VAVBoxExponential<br/>
                       Buildings.Fluid.Actuators.Dampers.MixingBox<br/>
                       Buildings.Fluid.Actuators.Dampers.MixingBoxMinimumFlow<br/>
                       Buildings.Fluid.Actuators.Valves.ThreeWayEqualPercentageLinear<br/>
                       Buildings.Fluid.Actuators.Valves.ThreeWayLinear<br/>
                       Buildings.Fluid.Actuators.Valves.TwoWayEqualPercentage<br/>
                       Buildings.Fluid.Actuators.Valves.TwoWayLinear<br/>
                       Buildings.Fluid.Actuators.Valves.TwoWayQuickOpening
    </td>
    <td valign=\"top\">Added an optional 2nd order lowpass filter for the input signal.
                       The filter approximates the travel time of the actuators.
                       It also makes the system of equations easier to solve
                       because a step change in the input signal causes a gradual change in the actuator
                       position.<br/>
                       Note that this filter affects the time response of closed loop control.
                       Therefore, enabling the filter may require retuning of control loops.
                       See the user's guide of the Buildings.Fluid.Actuators package.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.Boilers.BoilerPolynomial
    </td>
    <td valign=\"top\">Added computation of fuel usage and improved the documentation.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.Movers.SpeedControlled_y<br/>
                       Buildings.Fluid.Movers.SpeedControlled_Nrpm<br/>
                       Buildings.Fluid.Movers.FlowControlled_dp<br/>
                       Buildings.Fluid.Movers.FlowControlled_m_flow
    </td>
    <td valign=\"top\">Added a 2nd order lowpass filter to the input signal.
                       The filter approximates the startup and shutdown transients of fans or pumps.
                       It also makes the system of equations easier to solve
                       because a step change in the input signal causes a gradual change in the
                       mass flow rate.<br/>
                       Note that this filter affects the time response of closed loop control.
                       Therefore, enabling the filter may require retuning of control loops.
                       See the user's guide of the Buildings.Fluid.Movers package.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.Interfaces.StaticTwoPortHeatMassExchanger
    </td>
    <td valign=\"top\">Changed model to use graphical implementation of models for
                       pressure drop and conservation equations.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.BaseClasses.PartialResistance<br/>
                       Buildings.Fluid.FixedResistances.FixedResistanceDpM<br/>
                       Buildings.Fluid.Actuators.BaseClasses.PartialTwoWayValve<br/>
                       Buildings.Fluid.Actuators.BaseClasses.PartialDamperExponential
    </td>
    <td valign=\"top\">Revised base classes and models to simplify object inheritance tree.
                       Set <code>m_flow_small</code> to <code>final</code> in Buildings.Fluid.BaseClasses.PartialResistance,
                       and removed its assignment in the other classes.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.FixedResistances.FixedResistanceDpM<br/>
                       Buildings.Fluid.FixedResistances.SplitterFixedResistanceDpM
    </td>
    <td valign=\"top\">Improved documentation.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.HeatTransfer</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.HeatTransfer.Windows.Functions.glassProperty
    </td>
    <td valign=\"top\">Added the function <code>glassPropertyUncoated</code> that calculates the property for uncoated glass.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.ThermalZones</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.ThermalZones.Detailed.MixedAir
    </td>
    <td valign=\"top\">Changed model to use new implementation of
                       Buildings.HeatTransfer.Radiosity.OutdoorRadiosity
                       in its base classes.
                       This change leads to the use of the same equations for the radiative
                       heat transfer between window and ambient as is used for
                       the opaque constructions.
    </td>
</tr>
</table>
<!-- Non-backward compatible changes to existing components -->

<p>
The following <b style=\"color:blue\">existing components</b>
have been <b style=\"color:blue\">improved</b> in a
<b style=\"color:blue\">non-backward compatible</b> way:
</p>
<table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">

<tr><td colspan=\"2\"><b>Buildings.Fluid</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.Actuators.Valves.ThreeWayEqualPercentageLinear<br/>
                       Buildings.Fluid.Actuators.Valves.ThreeWayLinear<br/>
                       Buildings.Fluid.Actuators.Valves.TwoWayEqualPercentage<br/>
                       Buildings.Fluid.Actuators.Valves.TwoWayLinear<br/>
                       Buildings.Fluid.Actuators.Valves.TwoWayQuickOpening
    </td>
    <td valign=\"top\">Changed models to allow modeling of a fixed resistance that is
                       within the controlled flow leg. This allows in some cases
                       to avoid a nonlinear equation if a flow resistance is
                       in series to the valve.
                       This change required changing the parameter for the valve resistance
                       <code>dp_nominal</code> to <code>dpValve_nominal</code>,
                       and introducing the parameter
                       <code>dpFixed_nominal</code>, with <code>dpFixed_nominal=0</code>
                       as its default value.
                       Previous models that instantiate these components need to change the
                       assignment of <code>dp_nominal</code> to an assignment of
                       <code>dpValve_nominal</code>.
                       See also <a href=\"modelica://Buildings.Fluid.Actuators.UsersGuide\">
                       Buildings.Fluid.Actuators.UsersGuide</a>.
    </td>
</tr>

<tr><td colspan=\"2\"><b>Buildings.HeatTransfer</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.HeatTransfer.Radiosity.OutdoorRadiosity<br/>
                       Buildings.HeatTransfer.Windows.ExteriorHeatTransfer
    </td>
    <td valign=\"top\">Changed model to use new implementation of
                       Buildings.HeatTransfer.Radiosity.OutdoorRadiosity.
                       This change leads to the use of the same equations for the radiative
                       heat transfer between window and ambient as is used for
                       the opaque constructions.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Controls</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Controls.SetPoints.OccupancySchedule
    </td>
    <td valign=\"top\">Changed model to fix a bug that caused the output of the block
                       to be incorrect when the simulation started
                       at a time different from zero.
                       When fixing this bug, the parameter <code>startTime</code> was removed,
                       and the parameter <code>endTime</code> was renamed to <code>period</code>.
                       The period always starts at <i>t=0</i> seconds.
    </td>
</tr>
</table>
<!-- Errors that have been fixed -->

<p>
The following <b style=\"color:red\">critical errors</b> have been fixed (i.e., errors
that can lead to wrong simulation results):
</p>
<table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
<tr><td colspan=\"2\"><b>Buildings.Controls</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Controls.SetPoints.OccupancySchedule
    </td>
    <td valign=\"top\">The output of the block was incorrect when the simulation started
                       at a time different from zero.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Fluid.HeatExchangers</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.HeatExchangers.DryCoilCounterFlow<br/>
                       Buildings.Fluid.HeatExchangers.WetCoilCounterFlow
    </td>
    <td valign=\"top\">Corrected error in assignment of <code>dp2_nominal</code>.
                       The previous assignment caused a pressure drop in all except one element,
                       instead of the opposite. This caused too high a flow resistance
                       of the heat exchanger.
    </td>
</tr>
</table>
<!-- Uncritical errors -->

<p>
The following <b style=\"color:red\">uncritical errors</b> have been fixed (i.e., errors
that do <b style=\"color:red\">not</b> lead to wrong simulation results, e.g.,
units are wrong or errors in documentation):
</p>
<table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
<tr><td colspan=\"2\"><b>Buildings.BoundaryConditions</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.BoundaryConditions.SkyTemperature.BlackBody
    </td>
    <td valign=\"top\">Fixed error in BlackBody model that was causing a translation error when <code>calTSky</code> was set to <code>Buildings.BoundaryConditions.Types.SkyTemperatureCalculation.HorizontalRadiation</code>.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Fluid</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.Interfaces.TwoPortHeatMassExchanger
    </td>
    <td valign=\"top\">Fixed wrong class reference in information section.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Utilities</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Utilities.IO.BCVTB.Examples.MoistAir
    </td>
    <td valign=\"top\">Updated fan parameters, which were still for
                       version 0.12 of the Buildings library and hence caused
                       a translation error with version 1.0 or higher.
    </td>
</tr>
</table>
<!-- Github issues -->

<p>
The following
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues\">issues</a>
have been fixed:
</p>
<table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
<tr><td colspan=\"2\"><b>Exterior longwave radiation exchange in window model</b>
    </td>
</tr>
<tr><td valign=\"top\"><a href=\"https://github.com/lbl-srg/modelica-buildings/issues/51\">&#35;51</a>
    </td>
    <td valign=\"top\">Changed model to use new implementation of
                       Buildings.HeatTransfer.Radiosity.OutdoorRadiosity.
                       This change leads to the use of the same equations for the radiative
                       heat transfer between window and ambient as is used for
                       the opaque constructions.
    </td>
</tr>
<tr><td valign=\"top\"><a href=\"https://github.com/lbl-srg/modelica-buildings/issues/53\">&#35;53</a>
    </td>
    <td valign=\"top\">Fixed bug in Buildings.Controls.SetPoints.OccupancySchedule that
                       led to wrong results when the simulation started at a time different from zero.
    </td>
</tr>
</table>

<p>
Note:
</p>
<ul>
<li>
The use of filters for actuator and flow machine input
signals changes the dynamic response of feedback control loops.
Therefore, control gains may need to be retuned.
See <a href=\"modelica://Buildings.Fluid.Actuators.UsersGuide\">
Buildings.Fluid.Actuators.UsersGuide</a>
and
<a href=\"modelica://Buildings.Fluid.Movers.UsersGuide\">
Buildings.Fluid.Movers.UsersGuide</a> for recommended control
gains and further details.
</li>
</ul>
</html>"));
  end Version_1_1_build1;

  class Version_1_0_build2 "Version 1.0 build 2"
    extends Modelica.Icons.ReleaseNotes;
     annotation (preferredView="info", Documentation(info="<html>
<p>
Version 1.0 build 2 has been released to correct model errors that
were present in version 1.0 build 1. Both versions are compatible.
In addition, version 1.0 build 2 contains improved documentation
of various example models.
<!-- New libraries -->
<!-- New components for existing libraries -->
<!-- Backward compatible changes -->
</p>

<p>
The following <b style=\"color:blue\">existing components</b>
have been <b style=\"color:blue\">improved</b> in a
<b style=\"color:blue\">backward compatible</b> way:
</p>
<table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
<tr><td colspan=\"2\"><b>Buildings.Controls</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Controls.Continuous<br/>
                       Buildings.Controls.Discrete<br/>
                       Buildings.Controls.SetPoints
    </td>
    <td valign=\"top\">Improved documentation of models and of examples.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Airflow.Multizone</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Airflow.Multizone.DoorDiscretizedOpen<br/>
                     Buildings.Airflow.Multizone.DoorDiscretizedOperable
    </td>
    <td valign=\"top\">Changed the computation of the discharge coefficient to use the
       nominal density instead of the actual density.
       Computing <code>sqrt(2/rho)</code> sometimes causes warnings from the solver,
       as it seems to try negative values for the density during iterative solutions.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Airflow.Multizone.Examples
    </td>
    <td valign=\"top\">Improved documentation of examples.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Examples.DualFanDualDuct</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Examples.DualFanDualDuct.Controls.RoomMixingBox
    </td>
    <td valign=\"top\">Improved control of minimum air flow rate to avoid overheating.
    </td>
</tr>
</table>

<!-- Non-backward compatbile changes to existing components -->
<!-- Errors that have been fixed -->
<p>
The following <b style=\"color:red\">critical errors</b> have been fixed (i.e., errors
that can lead to wrong simulation results):
</p>
<table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">

<tr><td colspan=\"2\"><b>Buildings.HeatTransfer</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.HeatTransfer.Convection.Exterior
    </td>
    <td valign=\"top\">Fixed error in assignment of wind-based convection coefficient.
                     The old implementation did not take into account the surface roughness.
    </td>
</tr>

<tr><td colspan=\"2\"><b>Buildings.ThermalZones</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.ThermalZones.Detailed.BaseClasses.SolarRadiationExchange
    </td>
    <td valign=\"top\">In the previous version, the radiative properties
     of the long-wave spectrum instead of the solar spectrum have been used
     to compute the distribution of the solar radiation among the surfaces
     inside the room.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.ThermalZones.Detailed.BaseClasses.MixedAir
    </td>
    <td valign=\"top\">Added missing connect statement between window frame
     surface and window frame convection model. Prior to this bug fix,
     no convective heat transfer was computed between window frame and
     room air.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.ThermalZones.Detailed.BaseClasses.HeatGain
    </td>
    <td valign=\"top\">Fixed bug that caused convective heat gains
     to be removed from the room instead of added to the room.
    </td>
</tr>
</table>
<!-- Uncritical errors -->
<!-- Github issues -->

<p>
The following
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues\">issues</a>
have been fixed:
</p>
<table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
<tr><td colspan=\"2\"><b>Buildings.Fluid.Geothermal.Boreholes</b>
    </td>
</tr>
<tr><td valign=\"top\"><a href=\"https://github.com/lbl-srg/modelica-buildings/issues/45\">&#35;45</a>
    </td>
    <td valign=\"top\">Dymola 2012 FD01 hangs when simulating a borehole heat exchanger.
    This was caused by a wrong release of memory in <code>freeArray.c</code>.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.ThermalZones</b>
    </td>
</tr>
<tr><td valign=\"top\"><a href=\"https://github.com/lbl-srg/modelica-buildings/issues/46\">&#35;46</a>
    </td>
    <td valign=\"top\">The convective internal heat gain has the wrong sign.
    </td>
</tr>

</table>
</html>"));
  end Version_1_0_build2;

  class Version_1_0_build1 "Version 1.0 build 1"
    extends Modelica.Icons.ReleaseNotes;
     annotation (preferredView="info", Documentation(info="<html>
<p>
Version 1.0 is the first official release of the <code>Buildings</code>
library.
Compared to the last pre-release, which is version 0.12, this version contains
new models as well as significant improvements to the model formulation
that leads to faster and more robust simulation. A detailed list of changes is shown below.
</p>
<p>
Version 1.0 is not backward compatible to version 0.12, i.e., models developed with
versions 0.12 will require some changes in their parameters to
work with version 1.0.
The conversion script
<a href=\"modelica://Buildings/Resources/Scripts/Dymola/ConvertBuildings_from_0.12_to_1.0.mos\">
Buildings/Resources/Scripts/Dymola/ConvertBuildings_from_0.12_to_1.0.mos</a> can help
in converting old models to this version of the library.
</p>
<p>
The following <b style=\"color:blue\">new libraries</b> have been added:
</p>
<table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\">
<tr><td valign=\"top\">Buildings.Fluid.Geothermal.Boreholes</td>
    <td valign=\"top\">
    This is a library with a model for a borehole heat exchanger.
    </td></tr>
</table>
<p>
The following <b style=\"color:blue\">new components</b> have been added
to <b style=\"color:blue\">existing</b> libraries:
</p>
<table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
<tr><td colspan=\"2\"><b>Buildings.Airflow.Multizone</b></td></tr>
<tr><td valign=\"top\">Buildings.Airflow.Multizone.BaseClasses.windPressureLowRise
                      </td>
    <td valign=\"top\">Added a function that computes wind pressure on the facade of low-rise buildings.
    </td> </tr>
<tr><td colspan=\"2\"><b>Buildings.Examples</b></td></tr>
<tr><td valign=\"top\">Buildings.Examples.ChillerPlant
                      </td>
    <td valign=\"top\">Added an example for a chilled water plant model.
    </td> </tr>
<tr><td colspan=\"2\"><b>Buildings.Fluid.Interfaces</b></td></tr>
<tr><td valign=\"top\">Buildings.Fluid.Interfaces.UsersGuide
                      </td>
    <td valign=\"top\">Added a user's guide that describes
                       the main functionality of all base classes.
    </td> </tr>
<tr><td colspan=\"2\"><b>Buildings.Fluid.Sources</b></td></tr>
<tr><td valign=\"top\">Buildings.Fluid.Sources.Outside_Cp<br/>
                       Buildings.Fluid.Sources.Outside_CpLowRise
                      </td>
    <td valign=\"top\">Added models to compute wind pressure on building
                       facades.
    </td> </tr>
<tr><td colspan=\"2\"><b>Buildings.HeatTransfer</b></td></tr>
<tr><td valign=\"top\">Buildings.HeatTransfer.Conductor
                      </td>
    <td valign=\"top\">Added a model for heat conduction in circular coordinates.
    </td> </tr>
<tr><td colspan=\"2\"><b>Buildings.ThermalZones.Detailed.Examples</b></td></tr>
<tr><td valign=\"top\">Buildings.ThermalZones.Detailed.Examples.BESTEST
                      </td>
    <td valign=\"top\">Added BESTEST validation models.
    </td> </tr>
<tr><td colspan=\"2\"><b>Buildings.Utilities.Math</b></td></tr>
<tr><td valign=\"top\">Buildings.Utilities.Math.Functions.cubicHermiteLinearExtrapolation<br/>
                       Buildings.Utilities.Math.Functions.splineDerivatives.
                      </td>
    <td valign=\"top\">Added functions for cubic hermite spline interpolation, with
                       option for monotone increasing (or decreasing) spline.
    </td> </tr>
</table>

<p>
The following <b style=\"color:blue\">existing components</b>
have been <b style=\"color:blue\">improved</b> in a
<b style=\"color:blue\">backward compatible</b> way:
</p>
<table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">

<tr><td colspan=\"2\"><b>Buildings.Airflow.Multizone</b></td></tr>
<tr><td valign=\"top\">Buildings.Airflow.Multizone.BaseClasses.powerLaw</td>
    <td valign=\"top\">This function has been reimplemented to handle zero flow rate
                     in a more robust and more efficient way.
                     This change improves all components that model flow resistance in
                     the package Buildings.Airflow.Multizone.</td>
</tr>

<tr><td colspan=\"2\"><b>Buildings.BoundaryConditions.WeatherData</b></td></tr>
<tr><td valign=\"top\">Buildings.BoundaryConditions.WeatherData.ReaderTMY3</td>
    <td valign=\"top\">This model has now the option of using a constant value,
                     using the data from the weather file, or from an input connector for 7 variables,
                     including atmospheric pressure, relative humidity, dry bulb temperature,
                     global horizontal radiation, diffuse horizontal radiation,
                     wind direction and wind speed.</td>
</tr>

<tr><td colspan=\"2\"><b>Buildings.Fluid</b></td></tr>
<tr><td valign=\"top\">
                      Buildings.Fluid.Actuators.BaseClasses.PartialActuator<br/>
                      Buildings.Fluid.Actuators.BaseClasses.PartialDamperExponential<br/>
                      Buildings.Fluid.Actuators.BaseClasses.PartialTwoWayValve<br/>
                      Buildings.Fluid.BaseClasses.PartialResistance<br/>
                      Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_dp<br/>
                      Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_m_flow<br/>
                      Buildings.Fluid.Interfaces.StaticTwoPortHeatMassExchanger</td>
    <td valign=\"top\">The computation of the linearized flow resistance has been moved from
                     the functions to the model, i.e., into an equation section.
                     If the linear implementation is in a function body, then a symbolic processor
                     may not invert the equation. This can lead to systems of coupled equations in
                     cases where an explicit solution is possible.
                     In addition, the handling of zero flow rate has been improved for the nonlinear
                     pressure drop model.
                     These improvements affect all models in <code>Buildings.Fluid</code> that compute
                     flow resistance.</td>
</tr>

<tr><td colspan=\"2\"><b>Buildings.Fluid.HeatExchangers</b></td></tr>
<tr><td valign=\"top\">Buildings.Fluid.HeatExchangers.HeaterCoolerPrescribed</td>
    <td valign=\"top\">This model can now be configured as a steady-state or dynamic model.</td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.HeatExchangers.DryCoilCounterFlow<br/>
                     Buildings.Fluid.HeatExchangers.WetCoilCounterFlow<br/>
                     Buildings.Fluid.HeatExchangers.DryCoilDiscretized<br/>
                     Buildings.Fluid.HeatExchangers.WetCoilDiscretized</td>
    <td valign=\"top\">The implementation for handling zero flow rate, if the models
are used as steady-state models, have been improved.</td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.HeatExchangers.BaseClasses.ntu_epsilonZ</td>
    <td valign=\"top\">Changed implementation to use
                     <code>Modelica.Media.Common.OneNonLinearEquation</code> instead of
                     <code>Buildings.Utilities.Math.BaseClasses.OneNonLinearEquation</code>,
                     which was removed for this version of the library.
                     </td>
</tr>


<tr><td colspan=\"2\"><b>Buildings.Fluid.HeatExchangers.CoolingTowers</b></td></tr>
<tr><td valign=\"top\">Buildings.Fluid.HeatExchangers.CoolingTowers.YorkCalc<br/>
                     Buildings.Fluid.HeatExchangers.CoolingTowers.FixedApproach</td>
    <td valign=\"top\">
       These models are now based on a new base class <code>Buildings.Fluid.HeatExchangers.CoolingTowers.BaseClasses.CoolingTower</code>.
       This allows using the models as replaceable models without warning when checking the model.
    </td></tr>
<tr><td valign=\"top\">Buildings.Fluid.HeatExchangers.CoolingTowers.YorkCalc</td>
    <td valign=\"top\">
       Changed implementation of performance curve to avoid division by zero.
    </td></tr>

<tr><td colspan=\"2\"><b>Buildings.Fluid.MassExchangers</b></td></tr>
<tr><td valign=\"top\">Buildings.Fluid.MassExchangers.HumidifierPrescribed</td>
    <td valign=\"top\">This model can now be configured as a steady-state or dynamic model.</td>
</tr>

<tr><td colspan=\"2\"><b>Buildings.Fluid.Sensors</b></td></tr>
<tr><td valign=\"top\">Buildings.Fluid.Sensors.*TwoPort</td>
    <td valign=\"top\">All sensors with two ports, except for the mass flow rate sensor,
                     have been revised to add sensor dynamics.
                     Adding sensor dynamics avoids numerical problems when mass flow
                     rates are close to zero and the sensor is configured to allow
                     flow reversal. See
                     <a href=\"modelica://Buildings.Fluid.Sensors.UsersGuide\">
                     Buildings.Fluid.Sensors.UsersGuide</a> for details.</td>
</tr>

<tr><td colspan=\"2\"><b>Buildings.Fluid.Storage</b></td></tr>
<tr><td valign=\"top\">Buildings.Fluid.Storage.Stratified<br/>
                     Buildings.Fluid.Storage.StratifiedEnhanced</td>
    <td valign=\"top\">Changed the implementation of the model <code>Buoyancy</code>
                     to make it differentiable in the temperatures.</td>
</tr>

<tr><td colspan=\"2\"><b>Buildings.Media</b></td></tr>
<tr><td valign=\"top\">Buildings.Media.Interfaces.PartialSimpleMedium<br/>
                     Buildings.Media.Interfaces.PartialSimpleIdealGasMedium</td>
    <td valign=\"top\">Moved the assignment of the <code>stateSelect</code> attribute for
                     the <code>BaseProperties</code> to the model
                     <code>Buildings.Fluid.MixingVolumes.MixingVolume</code>. This allows
                     to handle it differently for steady-state and dynamic models.</td>
</tr>

<tr><td colspan=\"2\"><b>Buildings.Utilities.Psychrometrics</b></td></tr>
<tr><td valign=\"top\">Buildings.Utilities.Psychrometrics.Functions.TDewPoi_pW</td>
    <td valign=\"top\">Changed implementation to use
                     <code>Modelica.Media.Common.OneNonLinearEquation</code> instead of
                     <code>Buildings.Utilities.Math.BaseClasses.OneNonLinearEquation</code>,
                     which was removed for this version of the library.
                     </td>
</tr>

</table>

<p>
The following <b style=\"color:blue\">existing components</b>
have been <b style=\"color:blue\">improved</b> in a
<b style=\"color:blue\">non-backward compatible</b> way:
</p>
<table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">

<tr><td colspan=\"2\"><b>Buildings.Airflow.Multizone</b></td></tr>
<tr><td valign=\"top\">Buildings.Airflow.Multizone.MediumColumnDynamic</td>
    <td valign=\"top\">The implementation has been changed to better handle mass flow rates
near zero flow.
This required the introduction of a new parameter <code>m_flow_nominal</code>
that is used for the regularization near zero mass flow rate.</td></tr>

<tr><td colspan=\"2\"><b>Buildings.Fluid</b></td></tr>
<tr><td valign=\"top\">Buildings.Fluid.Storage.Examples.Stratified<br/>
                     Buildings.Fluid.MixingVolumes</td>
    <td valign=\"top\">
                     Removed the parameters <code>use_T_start</code> and <code>h_start</code>,
                     as <code>T_start</code> is more convenient to use than <code>h_start</code>
                     for building simulation.
                     </td>
</tr>

<tr><td colspan=\"2\"><b>Buildings.Fluid.Boilers</b></td></tr>
<tr><td valign=\"top\">Buildings.Fluid.Boilers.BoilerPolynomial</td>
    <td valign=\"top\">The parameter <code>dT_nominal</code> has been removed
as it can be computed from the parameter <code>m_flow_nominal</code>.
This change was needed to avoid a non-literal value for the nominal
attribute for the mass flow rate in the pressure drop model.</td>
</tr>

<tr><td colspan=\"2\"><b>Buildings.Fluid.MixingVolumes</b></td></tr>
<tr><td valign=\"top\">Buildings.Fluid.MixingVolumes.MixingVolume<br/>
                     Buildings.Fluid.MixingVolumes.MixingVolumeDryAir<br/>
                     Buildings.Fluid.MixingVolumes.MixingVolumeMoistAir</td>
    <td valign=\"top\">The implementation has been changed to better handle mass flow rates
near zero flow if the components have exactly two fluid ports connected.
This required the introduction of a new parameter <code>m_flow_nominal</code>
that is used for the regularization near zero mass flow rate.</td>
</tr>

<tr><td colspan=\"2\"><b>Buildings.Fluid.Movers</b></td></tr>
<tr><td valign=\"top\">Buildings.Fluid.Movers.SpeedControlled_y<br/>
                     Buildings.Fluid.Movers.SpeedControlled_Nrpm<br/>
                     Buildings.Fluid.Movers.FlowControlled_dp<br/>
                     Buildings.Fluid.Movers.FlowControlled_m_flow</td>
    <td valign=\"top\">
                     The performance data are now defined through records and not
                     through replaceable functions. The performance data now needs to be
                     declared in the form<pre>
 pressure(V_flow_nominal={0,V_flow_nominal,2*V_flow_nominal},
          dp_nominal={2*dp_nominal,dp_nominal,0})</pre>
                     where <code>pressure</code> is an instance of a record. A similar declaration is
                     used for power and efficiency.
                     <br/>
                     The parameter m_flow_nominal has been removed from
                     FlowMachine_y and FlowMachine_Nrpm.
                                <br/>
                     The parameter m_flow_max has been replaced by m_flow_nominal in
                     FlowMachine_m_flow.
                                <br/>
                     The implementation of the pressure drop computation as a function
                     of speed and volume flow rate has been revised to avoid a singularity
                     near zero volume flow rate and zero speed.<br/>
                     The implementation has also been simplified to avoid using two different flow paths
                     if the models are configured for steady-state or dynamic simulation.</td></tr>



<tr><td colspan=\"2\"><b>Buildings.Fluid.Interfaces</b></td></tr>
<tr><td valign=\"top\">Buildings.Fluid.Interfaces.FourPortHeatMassExchanger<br/>
                     Buildings.Fluid.Interfaces.PartialDynamicStaticFourPortHeatMassExchanger<br/>
                     Buildings.Fluid.Interfaces.TwoPortHeatMassExchanger<br/>
                     Buildings.Fluid.Interfaces.PartialDynamicStaticTwoPortHeatMassExchanger<br/>
                     Buildings.Fluid.Interfaces.ConservationEquation</td>
    <td valign=\"top\">The implementation has been changed to better handle mass flow rates
near zero flow if the components have exactly two fluid ports connected.</td>
</tr>


<tr><td colspan=\"2\"><b>Buildings.Fluid.Sensors</b></td></tr>
<tr><td valign=\"top\">Buildings.Fluid.Sensors.TemperatureTwoPortDynamic</td>
    <td valign=\"top\">This model has been deleted since the sensor
                     <a href=\"modelica://Buildings.Fluid.Sensors.TemperatureTwoPort\">
                     Buildings.Fluid.Sensors.TemperatureTwoPort</a> has been revised
                     and can now also be used as a dynamic model of a sensor.</td>
</tr>

<tr><td colspan=\"2\"><b>Buildings.Fluid.Interfaces</b></td></tr>
<tr><td valign=\"top\">Buildings.Fluid.Interfaces.PartialStaticTwoPortInterface</td>
    <td valign=\"top\">Renamed to Buildings.Fluid.Interfaces.PartialTwoPortInterface</td>
<tr><td valign=\"top\">Buildings.Fluid.Interfaces.PartialStaticStaticTwoPortHeatMassExchanger</td>
    <td valign=\"top\">Renamed to Buildings.Fluid.Interfaces.StaticTwoPortHeatMassExchanger</td>
<tr><td valign=\"top\">Buildings.Fluid.Interfaces.PartialTwoPortHeatMassExchanger</td>
    <td valign=\"top\">Renamed to Buildings.Fluid.Interfaces.TwoPortHeatMassExchanger</td>
<tr><td valign=\"top\">Buildings.Fluid.Interfaces.PartialFourPort</td>
    <td valign=\"top\">Renamed to Buildings.Fluid.Interfaces.FourPort</td>
<tr><td valign=\"top\">Buildings.Fluid.Interfaces.PartialStaticStaticFourPortHeatMassExchanger</td>
    <td valign=\"top\">Renamed to Buildings.Fluid.Interfaces.StaticFourPortHeatMassExchanger</td>
<tr><td valign=\"top\">Buildings.Fluid.Interfaces.PartialStaticFourPortInterface</td>
    <td valign=\"top\">Renamed to Buildings.Fluid.Interfaces.PartialFourPortInterface</td>
<tr><td valign=\"top\">Buildings.Fluid.Interfaces.PartialFourPortHeatMassExchanger</td>
    <td valign=\"top\">Renamed to Buildings.Fluid.Interfaces.FourPortHeatMassExchanger</td>
</tr>

<tr><td colspan=\"2\"><b>Buildings.Utilities.Math</b></td></tr>
<tr><td valign=\"top\">Buildings.Utilities.Math.BaseClasses.OneNonLinearEquation</td>
    <td valign=\"top\">This package has been removed, and all functions have been
                       revised to use Modelica.Media.Common.OneNonLinearEquation.</td>
</tr>

<tr><td colspan=\"2\"><b>Buildings.Utilities.Reports</b></td></tr>
<tr><td valign=\"top\">Buildings.Utilities.IO.Files.Printer<br/>
                     Buildings.Utilities.IO.Files.BaseClasses.printRealArray</td>
    <td valign=\"top\">Changed parameter <code>precision</code> to <code>significantDigits</code> and
                     <code>minimumWidth</code> to <code>minimumLength</code>
                     to use the same terminology as the Modelica Standard Library.</td>
</tr>

</table>

<p>
The following <b style=\"color:red\">critical errors</b> have been fixed (i.e., errors
that can lead to wrong simulation results):
</p>
<table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">


<tr><td colspan=\"2\"><b>Buildings.BoundaryConditions</b></td></tr>
<tr><td valign=\"top\">Buildings.BoundaryConditions.SkyTemperature.BlackBody</td>
    <td valign=\"top\">Fixed error in <code>if-then</code> statement that led to
                       a selection of the wrong branch to compute the sky temperature.</td></tr>
<tr><td colspan=\"2\"><b>Buildings.Media</b></td></tr>
<tr><td valign=\"top\">Buildings.Media.PartialSimpleMedium<br/>
                       Buildings.Media.GasesConstantDensity.SimpleAir</td>
    <td valign=\"top\">Fixed error in assignment of <code>singleState</code> parameter.
                       This change can lead to different initial conditions if the density of
                       water is modeled as a function of pressure, or if the
                       medium model Buildings.Media.GasesConstantDensity.SimpleAir is used.</td></tr>

<tr><td valign=\"top\">Buildings.Media.GasesConstantDensity<br/>
                       Buildings.Media.GasesConstantDensity.MoistAir<br/>
                       Buildings.Media.GasesConstantDensity.MoistAirUnsaturated<br/>
                       Buildings.Media.GasesConstantDensity.SimpleAir</td>
    <td valign=\"top\">Fixed error in the function <code>density</code> which returned a non-constant density,
                     and added a call to <code>ModelicaError(...)</code> in <code>setState_dTX</code> since this
                     function cannot assign the medium pressure based on the density (as density is a constant
                     in this model).
</td></tr>

<tr><td valign=\"top\">Buildings.Media.Interfaces.PartialSimpleIdealGasMedium</td>
    <td valign=\"top\">Updated package with a new copy from the Modelica Standard Library, since
                     the Modelica Standard Library fixed a bug in computing the internal energy of the medium.
                     This bug led to very fast temperature transients at the start of the simulation.
</td></tr>

<tr><td valign=\"top\">Buildings.Media.Interfaces.PartialSimpleMedium</td>
    <td valign=\"top\">Fixed bug in function density, which always returned <code>d_const</code>,
                       regardless of the value of <code>constantDensity</code>.
</td></tr>

<tr><td valign=\"top\">Buildings.Media.GasesPTDecoupled</td>
    <td valign=\"top\">Fixed bug in <code>u=h-R*T</code>, which is only valid for ideal gases.
                       For this medium, the function is <code>u=h-pStd/dStp</code>.
</td></tr>

<tr><td valign=\"top\">Buildings.Media.GasesConstantDensity</td>
    <td valign=\"top\">Fixed bug in <code>u=h-R*T</code>, which is only valid for ideal gases.
                       For this medium, the function is <code>u=h-p/dStp</code>.
</td></tr>

<tr><td colspan=\"2\"><b>Buildings.ThermalZones</b></td></tr>
<tr><td valign=\"top\">Buildings.ThermalZones.Detailed.MixedAir<br/>
                     Buildings.ThermalZones.Detailed.BaseClasses.ExteriorBoundaryConditions</td>
    <td valign=\"top\">Fixed bug (<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/35\">issue 35</a>)
                     that leads to the wrong solar heat gain for
                     roofs and for floors. Prior to this bug fix, the outside facing surface
                     of a ceiling received solar irradiation as if it were a floor
                     and vice versa.</td></tr>
<tr><td valign=\"top\">Buildings.ThermalZones.Detailed.MixedAir<br/>
                     Buildings.ThermalZones.Detailed.BaseClasses.ExteriorBoundaryConditionsWithWindow</td>
    <td valign=\"top\">Fixed bug (<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/36\">issue 36</a>)
                     that leads to too high a surface temperature of the window frame when
                     it receives solar radiation. The previous version did not compute
                     the infrared radiation exchange between the
                     window frame and the sky.</td></tr>

</table>

<p>
The following <b style=\"color:red\">uncritical errors</b> have been fixed (i.e., errors
that do <b style=\"color:red\">not</b> lead to wrong simulation results, but, e.g.,
units are wrong or errors in documentation):
</p>
<table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
<tr><td colspan=\"2\"><b>Buildings.BoundaryConditions</b></td></tr>
<tr><td valign=\"top\">Buildings.BoundaryConditions.WeatherData.BaseClasses.ConvertRadiation</td>
    <td>Corrected wrong unit label.
    </td>
</tr>
</table>

<p>
The following
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues\">issues</a>
have been fixed:
</p>
<table summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
<tr><td colspan=\"2\"><b>Buildings.BoundaryConditions</b></td></tr>
<tr><td valign=\"top\">
    <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/8\">&#35;8</a></td>
    <td valign=\"top\">
         Add switches for new data.
    </td>
</tr>
<tr><td valign=\"top\">
    <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/19\">&#35;19</a></td>
    <td valign=\"top\">
         Shift the time for the radiation data 30 min forth and output the local civil time in the data reader.
    </td>
</tr>
<tr><td valign=\"top\">
    <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/41\">&#35;41</a></td>
    <td valign=\"top\">
       Using when-then sentences to reduce CPU time.
    </td>
</tr>
<tr><td valign=\"top\">
    <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/43\">&#35;43</a></td>
    <td valign=\"top\">
         Add a ConvertRadiation to convert the unit of radiation from TMY3.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Fluid</b></td></tr>
<tr><td valign=\"top\">
    <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/28\">&#35;28</a></td>
    <td valign=\"top\">
         Move scripts to Buildings\\Resources\\Scripts\\Dymola.
    </td>
</tr>

<tr><td colspan=\"2\"><b>Buildings.HeatTransfer</b></td></tr>
<tr><td valign=\"top\">
    <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/18\">&#35;18</a></td>
    <td valign=\"top\">
         Add a smooth interpolation function to avoid the event.
    </td>
</tr>

<tr><td colspan=\"2\"><b>Buildings.Media</b></td></tr>
<tr><td valign=\"top\">
    <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/30\">&#35;30</a></td>
    <td valign=\"top\">
         Removed non-required structurally incomplete annotation.
    </td>
</tr>

<tr><td colspan=\"2\"><b>Buildings.ThermalZones</b></td></tr>
<tr><td valign=\"top\">
    <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/35\">&#35;35</a></td>
    <td valign=\"top\">
         Wrong surface tilt for radiation at exterior surfaces of floors and ceilings.
    </td>
</tr>
<tr><td valign=\"top\">
    <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/36\">&#35;36</a></td>
    <td valign=\"top\">
         High window frame temperatures.
    </td>
</tr>
</table>

<p>
Note:
</p>
<ul>
<li>
The version number scheme has been changed. It is now identical to the one used by the Modelica Standard Library.
Versions are identified with two numbers <code>x.y</code> and a build number. The first official
release of each version has the build number <code>1</code>. For each released bug fix,
the build number is incremented.
See
<a href=\"modelica://Modelica.UsersGuide.ReleaseNotes.VersionManagement\">
Modelica.UsersGuide.ReleaseNotes.VersionManagement</a> for details.
</li>
<li>
To allow adding scripts for multiple simulation environments,
all scripts have been moved to the directory <code>Buildings/Resources/Scripts/Dymola</code> and the annotation that
generates the entry in the <code>Command</code> pull down menu has been changed to
<code>__Dymola_Commands(file=...)</code>
</li>
</ul>
</html>"));
  end Version_1_0_build1;

  class Version_0_12_0 "Version 0.12.0"
    extends Modelica.Icons.ReleaseNotes;
  annotation (preferredView="info", Documentation(info="<html>
<p>
<b>Note:</b> The packages whose name ends with <code>Beta</code>
are still being validated.
</p>
<p>
The following <b style=\"color:red\">critical error</b> has been fixed (i.e. error
that can lead to wrong simulation results):
</p>

<table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
  <tr><td colspan=\"2\"><b>Buildings.ThermalZones</b></td></tr>
  <tr><td valign=\"top\"><a href=\"modelica://Buildings.ThermalZones.Detailed.BaseClasses.InfraredRadiationExchange\">
  Buildings.ThermalZones.Detailed.BaseClasses.InfraredRadiationExchange</a></td>
      <td valign=\"top\">The model <code>Buildings.ThermalZones.Detailed.BaseClasses.InfraredRadiationExchange</code>
      had an error in the view factor approximation.
      The error caused too much radiosity to flow from large to small surfaces because the law of reciprocity
      for view factors was not satisfied. This led to low surface temperatures if a surface had a large area
      compared to other surfaces.
      The bug has been fixed by rewriting the view factor calculation.
      </td>
  </tr>
</table>

<p>
The following improvements and additions have been made:
</p>
<ul>
<li>
Updated library to Modelica 3.2.
</li>
<li>
Added <code>homotopy</code> operator.
</li>
<li>
Restructured package <a href=\"modelica://Buildings.HeatTransfer\">
Buildings.HeatTransfer</a>.
</li>
<li>
Rewrote the models in <a href=\"modelica://Buildings.Fluid.Actuators\">
Buildings.Fluid.Actuators</a> to avoid having the flow coefficient
<code>k</code> as an algebraic variable.
This increases robustness.
</li>
<li>
Rewrote energy, species and trace substance balance in
<a href=\"modelica://Buildings.Fluid.Interfaces.StaticTwoPortHeatMassExchanger\">
Buildings.Fluid.Interfaces.StaticTwoPortHeatMassExchanger</a>
to better handle zero mass flow rate.
</li>
<li>
Implemented functions <code>enthalpyOfCondensingGas</code> and <code>saturationPressure</code>
in single substance media
to allow use of the room model with media that do not contain water vapor.
</li>
<li>
Revised <a href=\"modelica://Buildings.Fluid.Sources.Outside\">
Buildings.Fluid.Sources.Outside</a>
to allow use of the room model with media that do not contain water vapor.
</li>
</ul>
</html>"));
  end Version_0_12_0;

  class Version_0_11_0 "Version 0.11.0"
    extends Modelica.Icons.ReleaseNotes;
  annotation (preferredView="info", Documentation(info="<html>
<p>
<b>Note:</b> The packages whose name ends with <code>Beta</code>
are still being validated.
</p>

<ul>
<li>
Added the package
<a href=\"modelica://Buildings.ThermalZones.Detailed\">
Buildings.ThermalZones.Detailed</a> to compute heat transfer in rooms
and through the building envelope.
Multiple instances of these models can be connected to create
a multi-zone building model.
</li>
<li>
Added the package
<a href=\"modelica://Buildings.HeatTransfer.Windows\">
Buildings.HeatTransfer.Windows</a>
to compute heat transfer (solar radiation, infrared radiation,
convection and conduction) through glazing systems.
</li>
<li>
In package
<a href=\"modelica://Buildings.Fluid.Chillers\">
Buildings.Fluid.Chillers</a>, added the chiller models
<a href=\"modelica://Buildings.Fluid.Chillers.ElectricReformulatedEIR\">
Buildings.Fluid.Chillers.ElectricReformulatedEIR</a>
and
<a href=\"modelica://Buildings.Fluid.Chillers.ElectricEIR\">
Buildings.Fluid.Cphillers.ElectricEIR</a>, and added
the package
<a href=\"modelica://Buildings.Fluid.Chillers.Data\">
Buildings.Fluid.Chillers.Data</a>
that contains data sets of chiller performance data.
</li>
<li>
Added package
<a href=\"modelica://Buildings.BoundaryConditions\">
Buildings.BoundaryConditions</a>
with models to compute boundary conditions, such as
solar irradiation and sky temperature.
</li>
<li>
Added package
<code>Buildings.Utilities.IO.WeatherData</code>
with models to read weather data in the TMY3 format.
</li>
<li>
Revised the package
<a href=\"modelica://Buildings.Fluid.Sensors\">Buildings.Fluid.Sensors</a>.
</li>
<li>
Revised the package
<a href=\"modelica://Buildings.Fluid.HeatExchangers.CoolingTowers\">
Buildings.Fluid.HeatExchangers.CoolingTowers</a>.
</li>
<li>
In
<a href=\"modelica://Buildings.Fluid.Interfaces.StaticTwoPortHeatMassExchanger\">
Buildings.Fluid.Interfaces.StaticFourPortHeatMassExchanger</a>
and
<a href=\"modelica://Buildings.Fluid.Interfaces.StaticTwoPortHeatMassExchanger\">
Buildings.Fluid.Interfaces.StaticFourPortHeatMassExchanger</a>,
fixed bug in energy and moisture balance that affected results if a component
adds or removes moisture to the air stream.
In the old implementation, the enthalpy and species
outflow at <code>port_b</code> was multiplied with the mass flow rate at
<code>port_a</code>. The old implementation led to small errors that were proportional
to the amount of moisture change. For example, if the moisture added by the component
was <code>0.005 kg/kg</code>, then the error was <code>0.5%</code>.
Also, the results for forward flow and reverse flow differed by this amount.
With the new implementation, the energy and moisture balance is exact.
</li>
<li>
In
<a href=\"modelica://Buildings.Fluid.Interfaces.ConservationEquation\">
Buildings.Fluid.Interfaces.ConservationEquation</a> and in
<code>Buildings.Media.Interfaces.PartialSimpleMedium</code>, set
nominal attribute for medium to provide consistent normalization.
Without this change, Dymola 7.4 uses different values for the nominal attribute
based on the value of <code>Advanced.OutputModelicaCodeWithJacobians=true/false;</code>
in the model
<a href=\"modelica://Buildings.Examples.HydronicHeating\">
Buildings.Examples.HydronicHeating</a>.
</li>
<li>
Fixed bug in energy balance of
<code>Buildings.Fluid.Chillers.Carnot</code>.
</li>
<li>
Fixed bug in efficiency curves in package
<a href=\"modelica://Buildings.Fluid.Movers.BaseClasses.Characteristics\">
Buildings.Fluid.Movers.BaseClasses.Characteristics</a>.
</li>
</ul>
</html>"));
  end Version_0_11_0;

  class Version_0_10_0 "Version 0.10.0"
    extends Modelica.Icons.ReleaseNotes;
  annotation (preferredView="info", Documentation(info=
                   "<html>
<ul>
<li>
Added package
<a href=\"modelica://Buildings.Airflow.Multizone\">
Buildings.Airflow.Multizone</a>
with models for multizone airflow and contaminant transport.
</li>
<li>
Added the model
<a href=\"modelica://Buildings.Utilities.Comfort.Fanger\">
Buildings.Utilities.Comfort.Fanger</a>
for thermal comfort calculations.
</li>
<li>
Rewrote
<a href=\"modelica://Buildings.Fluid.Storage.BaseClasses.ThirdOrderStratifier\">
Buildings.Fluid.Storage.BaseClasses.ThirdOrderStratifier</a>, which is used in
<a href=\"modelica://Buildings.Fluid.Storage.StratifiedEnhanced\">
Buildings.Fluid.Storage.StratifiedEnhanced</a>,
to avoid state events when the flow reverses.
This leads to faster and more robust simulation.
</li>
<li>
In models of package
<a href=\"modelica://Buildings.Fluid.MixingVolumes\">
Buildings.Fluid.MixingVolumes</a>,
added nominal value for <code>mC</code> to avoid wrong trajectory
when concentration is around 1E-7.
See also <a href=\"https://trac.modelica.org/Modelica/ticket/393\">
https://trac.modelica.org/Modelica/ticket/393</a>.
</li>
<li>
Fixed bug in fan and pump models that led to too small an enthalpy
increase across the flow device.
</li>
<li>
In model <a href=\"modelica://Buildings.Fluid.Movers.FlowControlled_dp\">
Buildings.Fluid.Movers.FlowControlled_dp</a>,
changed <code>assert(dp_in &ge; 0, ...)</code> to <code>assert(dp_in &ge; -0.1, ...)</code>.
The former implementation triggered the assert if <code>dp_in</code> was solved for
in a nonlinear equation since the solution can be slightly negative while still being
within the solver tolerance.
</li>
<li>
Added model
<a href=\"modelica://Buildings.Controls.SetPoints.Table\">
Buildings.Controls.SetPoints.Table</a>
that allows the specification of a floating setpoint using a table of values.
</li>
<li>
Revised model
<a href=\"modelica://Buildings.Fluid.HeatExchangers.Radiators.RadiatorEN442_2\">
Buildings.Fluid.HeatExchangers.Radiators.RadiatorEN442_2</a>.
The new version has exactly the same nominal power during the simulation as specified
by the parameters. This also required a change in the parameters.
</li>
</ul>
</html>"));
  end Version_0_10_0;

  class Version_0_9_1 "Version 0.9.1"
    extends Modelica.Icons.ReleaseNotes;
  annotation (preferredView="info", Documentation(info="<html>
<p>
The following <b style=\"color:red\">critical error</b> has been fixed (i.e. error
that can lead to wrong simulation results):
</p>

<table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
  <tr><td colspan=\"2\"><b>Buildings.Fluid.Storage.</b></td></tr>
  <tr><td valign=\"top\"><a href=\"modelica://Buildings.Fluid.Storage.StratifiedEnhanced\">
  Buildings.Fluid.Storage.StratifiedEnhanced</a></td>
      <td valign=\"top\">The model <code>Buildings.Fluid.Storage.BaseClasses.Stratifier</code>
      had a sign error that lead to a wrong energy balance.
      The model that was affected by this error is
      <a href=\"modelica://Buildings.Fluid.Storage.StratifiedEnhanced\">
      Buildings.Fluid.Storage.StratifiedEnhanced</a>.
      The model
      <a href=\"modelica://Buildings.Fluid.Storage.Stratified\">
      Buildings.Fluid.Storage.Stratified</a> was not affected.<br/>
      The bug has been fixed by using the newly introduced model
      <a href=\"modelica://Buildings.Fluid.Storage.BaseClasses.ThirdOrderStratifier\">
        Buildings.Fluid.Storage.BaseClasses.ThirdOrderStratifier</a>. This model
      uses a third-order upwind scheme to reduce the numerical dissipation instead of the
      correction term that was used in <code>Buildings.Fluid.Storage.BaseClasses.Stratifier</code>.
      The model <code>Buildings.Fluid.Storage.BaseClasses.Stratifier</code> has been removed since it
      also led to significant overshoot in temperatures when the stratification was pronounced.
      </td>
  </tr>
</table>
</html>"));
  end Version_0_9_1;

  class Version_0_9_0 "Version 0.9.0"
    extends Modelica.Icons.ReleaseNotes;
  annotation (preferredView="info", Documentation(info=
                   "<html>
<ul>
<li>
Added the following heat exchanger models
<ul>
<li>
<code>Buildings.Fluid.HeatExchangers.DryEffectivenessNTU</code>
for a sensible heat exchanger that uses the <code>epsilon-NTU</code>
relations to compute the heat transfer.
</li>
<li>
<a href=\"modelica://Buildings.Fluid.HeatExchangers.DryCoilCounterFlow\">
Buildings.Fluid.HeatExchangers.DryCoilCounterFlow</a> and
<a href=\"modelica://Buildings.Fluid.HeatExchangers.WetCoilCounterFlow\">
Buildings.Fluid.HeatExchangers.WetCoilCounterFlow</a>
to model a coil without and with water vapor condensation. These models
approximate the coil as a counterflow heat exchanger.
</li>
</ul>
<li>
Revised air damper
<a href=\"modelica://Buildings.Fluid.Actuators.BaseClasses.exponentialDamper\">
Buildings.Fluid.Actuators.BaseClasses.exponentialDamper</a>.
The new implementation avoids warnings and leads to faster convergence
since the solver does not attempt anymore to solve for a variable that
needs to be strictly positive.
</li>
<li>
Revised package
<a href=\"modelica://Buildings.Fluid.Movers\">
Buildings.Fluid.Movers</a>
to allow zero flow for some pump or fan models.
If the input to the model is the control signal <code>y</code>, then
the flow is equal to zero if <code>y=0</code>. This change required rewriting
the package to avoid division by the rotational speed.
</li>
<li>
Revised package
<a href=\"modelica://Buildings.HeatTransfer\">
Buildings.HeatTransfer</a>
to include a model for a multi-layer construction, and to
allow individual material layers to be computed steady-state or
transient.
</li>
<li>
In package  <a href=\"modelica://Buildings.Fluid\">
Buildings.Fluid</a>, changed models so that
if the parameter <code>dp_nominal</code> is set to zero,
then the pressure drop equation is removed. This allows, for example,
to model a heating and a cooling coil in series, and lump there pressure drops
into a single element, thereby reducing the dimension of the nonlinear system
of equations.
</li>
<li>
Added model <a href=\"modelica://Buildings.Controls.Continuous.LimPID\">
Buildings.Controls.Continuous.LimPID</a>, which is identical to
<a href=\"modelica://Modelica.Blocks.Continuous.LimPID\">
Modelica.Blocks.Continuous.LimPID</a>, except that it
allows reverse control action. This simplifies use of the controller
for cooling applications.
</li>
<li>
Added model <a href=\"modelica://Buildings.Fluid.Actuators.Dampers.MixingBox\">
Buildings.Fluid.Actuators.Dampers.MixingBox</a> for an outside air
mixing box with air dampers.
</li>
<li>
Changed implementation of flow resistance in
<a href=\"modelica://Buildings.Fluid.Actuators.Dampers.MixingBoxMinimumFlow\">
Buildings.Fluid.Actuators.Dampers.MixingBoxMinimumFlow</a>. Instead of using a
fixed resistance and a damper model in series, only one model is used
that internally adds these two resistances. This leads to smaller systems
of nonlinear equations.
</li>
<li>
Changed
<code>Buildings.Media.PerfectGases.MoistAir.T_phX</code> (and by inheritance all
other moist air medium models) to first compute <code>T</code>
in closed form assuming no saturation. Then, a check is done to determine
whether the state is in the fog region. If the state is in the fog region,
then <code>Internal.solve</code> is called. This new implementation
can lead to significantly shorter computing
time in models that frequently call <code>T_phX</code>.
</li>
<li>
Added package
<code>Buildings.Media.GasesConstantDensity</code> which contains medium models
for dry air and moist air.
The use of a constant density avoids having pressure as a state variable in mixing volumes. Hence, fast transients
introduced by a change in pressure are avoided.
The drawback is that the dimensionality of the coupled
nonlinear equation system is typically larger for flow
networks.
</li>
<li>
In
<a href=\"modelica://Buildings.Fluid.Actuators.BaseClasses.PartialDamperExponential\">
Buildings.Fluid.Actuators.BaseClasses.PartialDamperExponential</a>,
added default value for parameter <code>A</code> to avoid compilation error
if the parameter is disabled but not specified.
</li>
<li>
Simplified the mixing volumes in
<a href=\"modelica://Buildings.Fluid.MixingVolumes\">
Buildings.Fluid.MixingVolumes</a> by removing the port velocity,
pressure drop and height.
</li>
</ul>
</html>"));
  end Version_0_9_0;

  class Version_0_8_0 "Version 0.8.0"
    extends Modelica.Icons.ReleaseNotes;
              annotation (preferredView="info", Documentation(info=
                   "<html>
<ul>
<li>
In
<a href=\"modelica://Buildings.Fluid.Interfaces.ConservationEquation\">
Buildings.Fluid.Interfaces.ConservationEquation</a>,
added to <code>Medium.BaseProperties</code> the initialization
<code>X(start=X_start[1:Medium.nX])</code>. Previously, the initialization
was only done for <code>Xi</code> but not for <code>X</code>, which caused the
medium to be initialized to <code>reference_X</code>, ignoring the value of <code>X_start</code>.
</li>
<li>
Renamed <code>Buildings.Media.PerfectGases.MoistAirNonSaturated</code>
to <code>Buildings.Media.PerfectGases.MoistAirUnsaturated</code>
and <code>Buildings.Media.GasesPTDecoupled.MoistAirNoLiquid</code>
to
<a href=\"modelica://Buildings.Media.Air\">
Buildings.Media.Air</a>,
and added <code>assert</code> statements if saturation occurs.
</li>
<li>
Added regularizaation near zero flow to
<a href=\"modelica://Buildings.Fluid.HeatExchangers.ConstantEffectiveness\">
Buildings.Fluid.HeatExchangers.ConstantEffectiveness</a>
and
<a href=\"modelica://Buildings.Fluid.MassExchangers.ConstantEffectiveness\">
Buildings.Fluid.MassExchangers.ConstantEffectiveness</a>.
</li>
<li>
Fixed bug regarding temperature offset in
<code>Buildings.Media.PerfectGases.MoistAirUnsaturated.T_phX</code>.
</li>
<li>
Added implementation of function
<a href=\"modelica://Buildings.Media.Air.enthalpyOfNonCondensingGas\">
Buildings.Media.Air.enthalpyOfNonCondensingGas</a> and its derivative.
</li>
<li>
In <code>Buildings.Media.PerfectGases.MoistAir</code>, fixed
bug in implementation of <code>Buildings.Media.PerfectGases.MoistAir.T_phX</code>.
In the previous version, it computed the inverse of its parent class,
which gave slightly different results.
</li>
<li>
In <a href=\"modelica://Buildings.Utilities.IO.BCVTB.BCVTB\">
Buildings.Utilities.IO.BCVTB.BCVTB</a>, added parameter to specify
the value to be sent to the BCVTB at the first data exchange,
and added parameter that deactivates the interface. Deactivating
the interface is sometimes useful during debugging.
</li>
<li>
In <code>Buildings.Media.GasesPTDecoupled.MoistAir</code> and in
<code>Buildings.Media.PerfectGases.MoistAir</code>, added function
<code>enthalpyOfNonCondensingGas</code> and its derivative.
<li>
In <a href=\"modelica://Buildings.Media\">
Buildings.Media</a>,
fixed bug in implementations of derivatives.
</li>
<li>
Added model
<a href=\"modelica://Buildings.Fluid.Storage.ExpansionVessel\">
Buildings.Fluid.Storage.ExpansionVessel</a>.
</li>
<li>
Added Wrapper function <code>Buildings.Fluid.Movers.BaseClasses.Characteristics.solve</code>
for <a href=\"modelica://Modelica.Math.Matrices.solve\">
Modelica.Math.Matrices.solve</a>. This is currently needed since
<a href=\"modelica://Modelica.Math.Matrices.solve\">
Modelica.Math.Matrices.solve</a> does not specify a
derivative.
</li>
<li>
Fixed bug in
<a href=\"Buildings.Fluid.Storage.Stratified\">
Buildings.Fluid.Storage.Stratified</a>.
In the previous version,
for computing the heat conduction between the top (or bottom) segment and
the outside,
the whole thickness of the water volume was used
instead of only half the thickness.
<li>
In <code>Buildings.Media.ConstantPropertyLiquidWater</code>, added the option to specify
a compressibility. This can help reducing the size of the coupled nonlinear system of
equations, at the expense of introducing stiffness. This change required to change
the inheritance tree of the medium. Its base class is now
<code>Buildings.Media.Interfaces.PartialSimpleMedium</code>,
which contains the equation for the compressibility. The default setting will model
the flow as incompressible.
</li>
<li>
In <a href=\"modelica://Buildings.Controls.Continuous.Examples.PIDHysteresis\">
Buildings.Controls.Continuous.Examples.PIDHysteresis</a>
and <a href=\"modelica://Buildings.Controls.Continuous.Examples.PIDHysteresisTimer\">
Buildings.Controls.Continuous.Examples.PIDHysteresisTimer</a>,
fixed error in default parameter <code>eOn</code>.
Fixed error by introducing parameter <code>Td</code>,
which used to be hard-wired in the PID controller.
</li>
<li>
Added more models for fans and pumps to the package
<a href=\"modelica://Buildings.Fluid.Movers\">
Buildings.Fluid.Movers</a>.
The models are similar to the ones in
<a href=\"modelica://Modelica.Fluid.Machines\">
Modelica.Fluid.Machines</a> but have been adapted for
air-based systems, and to include more characteristic curves
in
<a href=\"modelica://Buildings.Fluid.Movers.BaseClasses.Characteristics\">
Buildings.Fluid.Movers.BaseClasses.Characteristics</a>.
The new models are better suited than the existing fan model
<code>Buildings.Fluid.Movers.FlowMachinePolynomial</code> for zero flow rate.
</li>
<li>
Added an optional mixing volume to <a href=\"modelica://Buildings.Fluid.BaseClasses.PartialThreeWayResistance\">
Buildings.Fluid.BaseClasses.PartialThreeWayResistance</a>
and hence to the flow splitter and to the three-way valves. This often breaks algebraic loops and provides a state for the temperature if the mass flow rate goes to zero.
</li>
</ul>
</html>"));
  end Version_0_8_0;

  class Version_0_7_0 "Version 0.7.0"
    extends Modelica.Icons.ReleaseNotes;
              annotation (preferredView="info", Documentation(info=
                   "<html>
<ul>
<li>
Updated library from Modelica_Fluid to Modelica.Fluid 1.0
</li>
<li>
Merged sensor and source models from Modelica.Fluid to Buildings.Fluid.
</li>
<li> Added sensor for sensible and latent enthalpy flow rate,
<a href=\"modelica://Buildings.Fluid.Sensors.SensibleEnthalpyFlowRate\">
Buildings.Fluid.Sensors.SensibleEnthalpyFlowRate</a> and
<a href=\"modelica://Buildings.Fluid.Sensors.LatentEnthalpyFlowRate\">
Buildings.Fluid.Sensors.LatentEnthalpyFlowRate</a>.
These sensors are needed, for example, to interface air-conditioning
systems that are modeled with Modelica with the Building Controls
Virtual Test Bed.
</li>
</ul>
</html>"));
  end Version_0_7_0;

  class Version_0_6_0 "Version 0.6.0"
    extends Modelica.Icons.ReleaseNotes;
      annotation (preferredView="info", Documentation(info=
                   "<html>
<ul>
<li>
Added the package
<a href=\"modelica://Buildings.Utilities.IO.BCVTB\">
Buildings.Utilities.IO.BCVTB</a>
which contains an interface to the
<a href=\"http://simulationresearch.lbl.gov/bcvtb\">Building Controls Virtual Test Bed.</a>
<li>
Updated license to Modelica License 2.
</li>
<li>
Replaced
<code>Buildings.Utilities.Psychrometrics.HumidityRatioPressure</code>
by
<code>Buildings.Utilities.Psychrometrics.HumidityRatio_pWat</code>
and
<code>Buildings.Utilities.Psychrometrics.VaporPressure_X</code>
because the old model used <code>RealInput</code> ports, which are obsolete
in Modelica 3.0.
</li>
<li>
Changed the base class
<a href=\"modelica://Buildings.Fluid.Interfaces.StaticTwoPortHeatMassExchanger\">
Buildings.Fluid.Interfaces.StaticTwoPortHeatMassExchanger</a>
to enable computation of pressure drop of mechanical equipment.
</li>
<li>
Introduced package
<a href=\"modelica://Buildings.Fluid.BaseClasses.FlowModels\">
Buildings.Fluid.BaseClasses.FlowModels</a> to model pressure drop,
and rewrote
<a href=\"modelica://Buildings.Fluid.BaseClasses.PartialResistance\">
Buildings.Fluid.BaseClasses.PartialResistance</a>.
</li>
<li>
Redesigned package
<a href=\"modelica://Buildings.Utilities.Math\">
Buildings.Utilities.Math</a> to allow having blocks and functions
with the same name. Functions are now in
<a href=\"modelica://Buildings.Utilities.Math.Functions\">
Buildings.Utilities.Math.Functions</a>.
</li>
<li>
Fixed sign error in
<code>Buildings.Fluid.Storage.BaseClasses.Stratifier</code>
which caused a wrong energy balance in
<a href=\"modelica://Buildings.Fluid.Storage.StratifiedEnhanced\">
Buildings.Fluid.Storage.StratifiedEnhanced</a>.
</li>
<li>
Renamed
<code>Buildings.Fluid.HeatExchangers.HeaterCoolerIdeal</code> to
<code>Buildings.Fluid.HeatExchangers.HeaterCoolerPrescribed</code>
to have the same nomenclatures as is used for
<code>Buildings.Fluid.MassExchangers.HumidifierPrescribed</code>
</li>
<li>
In
<a href=\"modelica://Buildings.Fluid/Actuators/BaseClasses/PartialDamperExponential\">
Buildings.Fluid/Actuators/BaseClasses/PartialDamperExponential</a>,
added option to compute linearization near zero based on
the fraction of nominal flow instead of the Reynolds number.
This was set as the default, as it leads most reliably to a model
parametrization that leads to a derivative <code>d m_flow/d p</code>
near the origin that is not too steep for a Newton-based solver.
</li>
<li>
In damper and VAV box models, added optional parameters
to allow specifying the nominal face velocity instead of the area.
</li>
<li>
Set nominal attribute for pressure drop <code>dp</code> in
<a href=\"modelica://Buildings.Fluid.BaseClasses.PartialResistance\">
Buildings.Fluid.BaseClasses.PartialResistance</a> and in its
child classes.
</li>
<li>
Added models for chiller
(<code>Buildings.Fluid.Chillers.Carnot</code>),
for occupancy
(<a href=\"modelica://Buildings.Controls.SetPoints.OccupancySchedule\">
Buildings.Controls.SetPoints.OccupancySchedule</a>) and for
blocks that take a vector as an argument
(<a href=\"modelica://Buildings.Utilities.Math.Min\">
Buildings.Utilities.Math.Min</a>,
<a href=\"modelica://Buildings.Utilities.Math.Max\">
Buildings.Utilities.Math.Max</a>, and
<a href=\"modelica://Buildings.Utilities.Math.Average\">
Buildings.Utilities.Math.Average</a>).
</li>
<li>
Changed various variable names to be consistent with naming
convention used in Modelica.Fluid 1.0.
</li>
</ul>
</html>"));
  end Version_0_6_0;

  class Version_0_5_0 "Version 0.5.0"
    extends Modelica.Icons.ReleaseNotes;
      annotation (preferredView="info", Documentation(info=
                   "<html>
<ul>
<li>
Updated library to Modelica.Fluid 1.0.
</li>
<li>
Moved most examples from package <a href=\"modelica://Buildings.Fluid.Examples\">
Buildings.Fluid.Examples</a> to the example directory in the package of the
individual model.
</li>
<li>
Renamed package <code>Buildings.Utilites.Controls</code> to
<code>Buildings.Utilites.Diagnostics</code>.
</li>
<li>
Introduced packages
<a href=\"modelica://Buildings.Controls\">Buildings.Controls</a>,
<a href=\"modelica://Buildings.HeatTransfer\">Buildings.HeatTransfer</a>
(which contains models for heat transfer that generally does not involve
modeling of the fluid flow),
<a href=\"modelica://Buildings.Fluid.Boilers\">Buildings.Fluid.Boilers</a> and
<a href=\"modelica://Buildings.Fluid.HeatExchangers.Radiators\">
Buildings.Fluid.HeatExchangers.Radiators</a>.
</li>
<li>
Changed valve models in <a href=\"modelica://Buildings.Fluid.Actuators.Valves\">
Buildings.Fluid.Actuators.Valves</a> so that <code>Kv</code> or <code>Cv</code> can
be used as the flow coefficient (in [m3/h] or [USG/min]).
</li>
</ul>
</html>"));
  end Version_0_5_0;

  class Version_0_4_0 "Version 0.4.0"
    extends Modelica.Icons.ReleaseNotes;
      annotation (preferredView="info", Documentation(info=
                   "<html>
<ul>
<li>
Added package <a href=\"modelica://Buildings.Fluid.Storage\">
Buildings.Fluid.Storage</a>
with models for thermal energy storage.
<li>
Added a steady-state model for a heat and moisture exchanger with
constant effectiveness.
See <a href=\"modelica://Buildings.Fluid.MassExchangers.ConstantEffectiveness\">
Buildings.Fluid.MassExchangers.ConstantEffectiveness</a>
</li>
<li>
Added package <code>Buildings.Utilities.Reports</code>.
The package contains models that facilitate reporting.
</li>
</ul>
</html>"));
  end Version_0_4_0;

  class Version_0_3_0 "Version 0.3.0"
    extends Modelica.Icons.ReleaseNotes;
      annotation (preferredView="info", Documentation(info=
                   "<html>
<ul>
<li>
Added package <a href=\"modelica://Buildings.Fluid.Sources\">Buildings.Fluid.Sources</a>.
The package contains models for modeling species that
do not affect the medium balance of volumes. This can be used to track
for example carbon dioxide or other species that have a small concentration.
</li>
<li>
The package <a href=\"modelica://Buildings.Fluid.Actuators.Motors\">Buildings.Fluid.Actuators.Motors</a> has been added.
The package contains a motor model for valves and dampers.
</li>
<li>
The package <a href=\"modelica://Buildings.Media\">Buildings.Media</a> has been reorganized and
the new medium model
<code>Buildings.Media.GasesPTDecoupled.MoistAir</code>
has been added.
<br/>
In addition, this package now contains a bug fix that is needed for Modelica 2.2.1 and 2.2.2.
The bugs are fixed by using a new
base class
<code>Buildings.Media.Interfaces.PartialSimpleIdealGasMedium</code>
 (that fixes the bugs) instead of
<a href=\"modelica://Modelica.Media.Interfaces.PartialSimpleIdealGasMedium\">
Modelica.Media.Interfaces.PartialSimpleIdealGasMedium</a>.
In the original implementation, initial states of fluid volumes can be far away from
the steady-state value because of an inconsistent implementation of the enthalpy
and internal energy.
When the <code>Buildings</code> library is upgraded to
to Modelica 3.0.0, it should be safe to remove this bug fix.
</li>
<li>
The package <a href=\"modelica://Buildings.Fluid.HeatExchangers\">Buildings.Fluid.HeatExchangers</a>
has been revised and several models have been renamed.
The heat exchanger models have been revised to allow computing the fluid volumes either
dynamically, or in steady-state.
</li>
<li>
The damper with exponential opening characteristic has been revised to allow control signals
over the whole range between <code>0</code> and <code>1</code>. This was in earlier versions restricted.
In the same model, a bug was fixed that caused the flow to be largest for <code>y=0</code>, i.e., when the damper is closed.
</li>
<li>
Additional models for psychrometric equations have been added. The new models contain equations
that convert dew point temperature and water vapor pressure, as well
as water vapor concentration and water vapor pressure.
</li>
<li>
A new mixing volume has been added that allows latent heat exchange with the volume.
This model can be used to model a volume of moist air with water vapor condensation
inside the volume. The condensate is removed from the volume in its liquid phase.
</li>
</ul>
</html>"));
  end Version_0_3_0;

  class Version_0_2_0 "Version 0.2.0"
    extends Modelica.Icons.ReleaseNotes;
      annotation (preferredView="info", Documentation(info=
                   "<html>
<p>
New in this version are models for two and three way valves.
In addition, the <code>Fluids</code> package has been slightly revised.
The package <code>Fluid.BaseClasses</code> has been added because in
the previous version, partial models for fixed resistances
where part of the <code>Actuator</code> package.
</p>
</html>"));
  end Version_0_2_0;

  class Version_0_1_0 "Version 0.1.0"
    extends Modelica.Icons.ReleaseNotes;
      annotation (preferredView="info", Documentation(info="<html>
<p>
First release of the library.
</p>
<p>
This version contains basic models for modeling building HVAC systems.
It also contains new medium models in the package
<a href=\"modelica://Buildings.Media\">Buildings.Media</a>. These medium models
have simpler property functions than the ones from
<a href=\"modelica://Modelica.Media\">Modelica.Media</a>. For example,
there is medium model with constant heat capacity which is often sufficiently
accurate for building HVAC simulation, in contrast to the more detailed models
from <a href=\"modelica://Modelica.Media\">Modelica.Media</a> that are valid in
a larger temperature range, at the expense of introducing non-linearities due
to the medium properties.
</p>
</html>"));
  end Version_0_1_0;

    annotation (preferredView="info",
    Documentation(info="<html>
<p>
This section summarizes the changes that have been performed
on the Buildings library.
</p>
<ul>
<li>
<a href=\"modelica://Buildings.UsersGuide.ReleaseNotes.Version_7_0_1\">Version 7.0.1</a>
</li>
<li>
<a href=\"modelica://Buildings.UsersGuide.ReleaseNotes.Version_7_0_0\">Version 7.0.0</a> (May 28, 2020)
</li>
<li>
<a href=\"modelica://Buildings.UsersGuide.ReleaseNotes.Version_6_0_0\">Version 6.0.0</a> (July 15, 2019)
</li>
<li>
<a href=\"modelica://Buildings.UsersGuide.ReleaseNotes.Version_5_1_0\">Version 5.1.0</a> (June 14, 2018)
</li>
<li>
<a href=\"modelica://Buildings.UsersGuide.ReleaseNotes.Version_5_0_1\">Version 5.0.1</a> (November 22, 2017)
</li>
<li>
<a href=\"modelica://Buildings.UsersGuide.ReleaseNotes.Version_5_0_0\">Version 5.0.0</a> (November 17, 2017)
</li>
<li>
<a href=\"modelica://Buildings.UsersGuide.ReleaseNotes.Version_4_0_0\">Version 4.0.0</a> (March 29, 2017)
</li>
<li>
<a href=\"modelica://Buildings.UsersGuide.ReleaseNotes.Version_3_0_0\">Version 3.0.0</a> (March 29, 2016)
</li>
<li>
<a href=\"modelica://Buildings.UsersGuide.ReleaseNotes.Version_2_1_0\">Version 2.1.0</a> (July 13, 2015)
</li>
<li>
<a href=\"modelica://Buildings.UsersGuide.ReleaseNotes.Version_2_0_0\">Version 2.0.0</a> (May 4, 2015)
</li>
<li>
<a href=\"modelica://Buildings.UsersGuide.ReleaseNotes.Version_1_6_build1\">Version 1.6 build1</a> (June 19, 2014)
</li>
<li>
<a href=\"modelica://Buildings.UsersGuide.ReleaseNotes.Version_1_5_build3\">Version 1.5 build3</a> (February 12, 2014)
</li>
<li>
<a href=\"modelica://Buildings.UsersGuide.ReleaseNotes.Version_1_5_build2\">Version 1.5 build2</a> (December 13, 2013)
</li>
<li>
<a href=\"modelica://Buildings.UsersGuide.ReleaseNotes.Version_1_5_build1\">Version 1.5 build1</a> (October 24, 2013)
</li>
<li>
<a href=\"modelica://Buildings.UsersGuide.ReleaseNotes.Version_1_4_build1\">Version 1.4 build1</a> (May 15, 2013)
</li>
<li>
<a href=\"modelica://Buildings.UsersGuide.ReleaseNotes.Version_1_3_build1\">Version 1.3 build1</a> (January 8, 2013)
</li>
<li>
<a href=\"modelica://Buildings.UsersGuide.ReleaseNotes.Version_1_2_build1\">Version 1.2 build1</a> (July 26, 2012)
</li>
<li>
<a href=\"modelica://Buildings.UsersGuide.ReleaseNotes.Version_1_1_build1\">Version 1.1 build1</a> (February 29, 2012)
</li>
<li>
<a href=\"modelica://Buildings.UsersGuide.ReleaseNotes.Version_1_0_build2\">Version 1.0 build2</a> (December 8, 2011)
</li>
<li>
<a href=\"modelica://Buildings.UsersGuide.ReleaseNotes.Version_1_0_build1\">Version 1.0 build1</a> (November 4, 2011)
</li>
<li>
<a href=\"modelica://Buildings.UsersGuide.ReleaseNotes.Version_0_12_0\">Version 0.12.0 </a> (May 6, 2011)
<li>
<a href=\"modelica://Buildings.UsersGuide.ReleaseNotes.Version_0_11_0\">Version 0.11.0 </a> (March 17, 2011)
<li>
<a href=\"modelica://Buildings.UsersGuide.ReleaseNotes.Version_0_10_0\">Version 0.10.0 </a> (July 30, 2010)
<li>
<a href=\"modelica://Buildings.UsersGuide.ReleaseNotes.Version_0_9_1\">Version 0.9.1 </a> (June 24, 2010)
<li>
<a href=\"modelica://Buildings.UsersGuide.ReleaseNotes.Version_0_9_0\">Version 0.9.0 </a> (June 11, 2010)
<li>
<a href=\"modelica://Buildings.UsersGuide.ReleaseNotes.Version_0_8_0\">Version 0.8.0 </a> (February 6, 2010)
<li>
<a href=\"modelica://Buildings.UsersGuide.ReleaseNotes.Version_0_7_0\">Version 0.7.0 </a> (September 29, 2009)
<li>
<a href=\"modelica://Buildings.UsersGuide.ReleaseNotes.Version_0_6_0\">Version 0.6.0 </a> (May 15, 2009)
<li>
<a href=\"modelica://Buildings.UsersGuide.ReleaseNotes.Version_0_5_0\">Version 0.5.0 </a> (February 19, 2009)
<li>
<a href=\"modelica://Buildings.UsersGuide.ReleaseNotes.Version_0_4_0\">Version 0.4.0 </a> (October 31, 2008)
<li>
<a href=\"modelica://Buildings.UsersGuide.ReleaseNotes.Version_0_3_0\">Version 0.3.0 </a> (September 30, 2008)
<li>
<a href=\"modelica://Buildings.UsersGuide.ReleaseNotes.Version_0_2_0\">Version 0.2.0 </a> (June 17, 2008)
<li>
<a href=\"modelica://Buildings.UsersGuide.ReleaseNotes.Version_0_1_0\">Version 0.1.0 </a> (May 27, 2008)
</li>
</ul>

</html>"));
  end ReleaseNotes;

  class Contact "Contact"
    extends Modelica.Icons.Contact;
    annotation (preferredView="info",
    Documentation(info="<html>
<h4><font color=\"#008000\" size=\"5\">Contact</font></h4>
<p>
The development of the Buildings library is organized by<br/>
<a href=\"http://simulationresearch.lbl.gov/wetter\">Michael Wetter</a><br/>
    Lawrence Berkeley National Laboratory (LBNL)<br/>
    One Cyclotron Road<br/>
    Bldg. 90-3147<br/>
    Berkeley, CA 94720<br/>
    USA<br/>
    email: <a href=\"mailto:MWetter@lbl.gov\">MWetter@lbl.gov</a><br/>
</p>
</html>"));
  end Contact;

  class Acknowledgements "Acknowledgements"
    extends Modelica.Icons.Information;
    annotation (preferredView="info",
    Documentation(info="<html>
<h4><font color=\"#008000\" size=\"5\">Acknowledgements</font></h4>
<p>
 The development of this library was supported
</p>
 <ul>
 <li>by the Assistant Secretary for
  Energy Efficiency and Renewable Energy, Office of Building
  Technologies of the U.S. Department of Energy, under
  contracts No. DE-AC02-05CH11231 and DE-EE0007688, and
 </li>
 <li>
  by the California Energy Commission, Public Interest Energy Research Program, Buildings End Use Energy Efficiency Program, award number 500-10-052.
 </li>
 </ul>
<p>
The core of this library is the Modelica IBPSA library,
a free open-source library with basic models that codify best practices for
the implementation of models for building and community energy and control systems.
The development of the IBPSA library is organized through the
<a href=\"https://ibpsa.github.io/project1\">IBPSA Project 1</a>
of the International Building Performance Simulation Association (IBPSA).
From 2012 to 2017, the development was organized through the
<a href=\"http://www.iea-annex60.org\">Annex 60 project</a>
of the Energy in Buildings and Communities Programme of the International Energy Agency (IEA EBC).
</p>
 <p>
  The <a href=\"modelica://Buildings.Airflow.Multizone\">package for multizone airflow modeling</a>
  and the <a href=\"modelica://Buildings.Utilities.Comfort.Fanger\">model for thermal comfort</a>
  was contributed by the United Technologies Research Center, which also contributed to the
  validation of the <a href=\"modelica://Buildings.ThermalZones.Detailed.MixedAir\">room heat transfer model</a>.
</p>
<p>
We thank Dietmar Winkler from Telemark University College for the various feedback that
helped improve the organization and structure of the library.
</p>
<p>
The following people have directly contributed to the implementation of the Buildings library
(many others have contributed by other means than model implementation):
</p>
<ul>
<li>David Blum, Lawrence Berkeley National Laboratory, USA
</li>
<li>Marco Bonvini, Lawrence Berkeley National Laboratory, USA
</li>
<li>Felix B&uuml;nning, RWTH Aachen, Germany
</li>
<li>Massimo Cimmino, Polytechnique Montr&eacute;al, Canada
</li>
<li>Rainer Czetina, University of Applied Sciences Technikum Wien, Austria
</li>
<li>Hagar Elarga, Lawrence Berkeley National Laboratory, USA
</li>
<li>Yangyang Fu, University of Colorado Boulder, Colorado, USA
</li>
<li>Antoine Gautier, Lawrence Berkeley National Laboratory, USA
</li>
<li>Sebastian Giglmayr, University of Applied Sciences Technikum Wien, Austria
</li>
<li>Milica Grahovac, Lawrence Berkeley National Laboratory, USA
</li>
<li>Peter Grant, Lawrence Berkeley National Laboratory, USA
</li>
<li>Brandon M. Hencey, Cornell University, USA
</li>
<li>Kathryn Hinkelman, University of Colorado Boulder, Colorado, USA
</li>
<li>Jianjun Hu, Lawrence Berkeley National Laboratory, USA
</li>
<li>Roman Ilk, University of Applied Sciences Technikum Wien, Austria
</li>
<li>Dan Li, University of Miami, Florida, USA
</li>
<li>Filip Jorissen, KU Leuven, Belgium
</li>
<li>Thierry S. Nouidui, Lawrence Berkeley National Laboratory, USA
</li>
<li>Markus Nurschinger, University of Applied Sciences Technikum Wien, Austria
</li>
<li>Xiufeng Pang, Lawrence Berkeley National Laboratory, USA
</li>
<li>Damien Picard, KU Leuven, Belgium
</li>
<li>Kaustubh Phalak, Lawrence Berkeley National Laboratory, USA
</li>
<li>Thomas Sevilla, University of Miami, Florida, USA
</li>
<li>Martin Sj&ouml;lund, Link&ouml;ping University, Sweden
</li>
<li>Matthis Thorade, Berlin University of the Arts, Germany
</li>
<li>Wei Tian, University of Miami, Florida, USA
</li>
<li>Armin Teskeredzic, Mechanical Engineering Faculty Sarajevo and GIZ, Bosnia and Herzegovina
</li>
<li>Rafael Velazquez, University of Seville, Spain
</li>
<li>Pierre Vigouroux, Institut National des Sciences Appliquees, France
</li>
<li>Sebastian Vock, University of Applied Sciences Technikum Wien, Austria
</li>
<li>Vladimir Vukovic, Austrian Institute of Technology, Austria
</li>
<li>Michael Wetter, Lawrence Berkeley National Laboratory, USA
</li>
<li>Tea Zakula, University of Zagreb, Croatia
</li>
<li>Ettore Zanetti, Politecnico di Milano, Italy
</li>
<li>Rebecca Zarin Pass, Lawrence Berkeley National Laboratory, USA
</li>
<li>Kun Zhang, Lawrence Berkeley National Laboratory, USA
</li>
<li>Wangda Zuo, University of Colorado Boulder, Colorado, USA
</li>
</ul>
</html>"));
  end Acknowledgements;

  class License "License"
    extends Modelica.Icons.Information;
    annotation (preferredView="info",
    Documentation(info="<html>
<h4>License</h4>
<p>
Modelica Buildings Library. Copyright (c) 1998-2020
Modelica Association,
International Building Performance Simulation Association (IBPSA),
The Regents of the University of California, through Lawrence Berkeley National Laboratory
(subject to receipt of any required approvals from the U.S. Dept. of Energy) and
contributors.
All rights reserved.
</p>
<p>
NOTICE.  This Software was developed under funding from the U.S. Department of Energy and
the U.S. Government consequently retains certain rights.
As such, the U.S. Government has been granted for itself and others acting on its behalf
a paid-up, nonexclusive, irrevocable, worldwide license in the Software
to reproduce, distribute copies to the public, prepare derivative works, and
perform publicly and display publicly, and to permit other to do so.
</p>
<p>
Redistribution and use in source and binary forms, with or without modification,
are permitted provided that the following conditions are met:
</p>
<ol>
<li>
Redistributions of source code must retain the above copyright notice,
this list of conditions and the following disclaimer.
</li>
<li>
Redistributions in binary form must reproduce the above copyright notice,
this list of conditions and the following disclaimer
in the documentation and/or other materials provided with the distribution.
</li>
<li>
Neither the names of the Modelica Association,
International Building Performance Simulation Association (IBPSA),
the University of California,
Lawrence Berkeley National Laboratory,
U.S. Dept. of Energy,
nor the names of its contributors
may be used to endorse or promote products derived from this software
without specific prior written permission.
</li>
</ol>
<p>
THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS \"AS IS\" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS
BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING
IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
</p>
<p>
You are under no obligation whatsoever to provide any bug fixes, patches,
or upgrades to the features, functionality or performance of the source code
(\"Enhancements\") to anyone; however, if you choose to make your Enhancements
available either publicly, or directly to Lawrence Berkeley National
Laboratory, without imposing a separate written license agreement for such
Enhancements, then you hereby grant the following license: a non-exclusive,
royalty-free perpetual license to install, use, modify, prepare derivative
works, incorporate into other computer software, distribute, and sublicense
such enhancements or derivative works thereof, in binary and source code form.
</p>
<p>
Note: The license is a revised 3 clause BSD license with an ADDED paragraph
at the end that makes it easy to accept improvements.
</p>
<h4>Third Party License</h4>
<p>
To parse weather file, the function <code>getTimeSpan.c</code> uses
third party code that uses the following license:
</p>
<p>
Copyright (c) 2011 The NetBSD Foundation, Inc.<br/>
All rights reserved.
</p>
<p>
This code is derived from software contributed to The NetBSD Foundation
by Christos Zoulas.
</p>
<p>
Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions
are met:
</p>
<ol>
<li>
  Redistributions of source code must retain the above copyright
  notice, this list of conditions and the following disclaimer.
</li>
<li>
  Redistributions in binary form must reproduce the above copyright
  notice, this list of conditions and the following disclaimer in the
  documentation and/or other materials provided with the distribution.
</li>
</ol>
<p>
THIS SOFTWARE IS PROVIDED BY THE NETBSD FOUNDATION, INC. AND CONTRIBUTORS
''AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED
TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE FOUNDATION OR CONTRIBUTORS
BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
POSSIBILITY OF SUCH DAMAGE.
</p>
</html>"));
  end License;

  annotation (preferredView="info",
  Documentation(info="<html>
<p>
The <code>Buildings</code> library is a free open-source library for modeling of building energy and control systems.
Many models are based on models from the package
<a href=\"modelica://Modelica.Fluid\">Modelica.Fluid</a> and use
the same ports to ensure compatibility with models from that library.
</p>
<p>
The web page for this library is
<a href=\"http://simulationresearch.lbl.gov/modelica\">http://simulationresearch.lbl.gov/modelica</a>.
We welcome contributions from different users to further advance this library,
whether it is through collaborative model development, through model use and testing
or through requirements definition or by providing feedback regarding the model applicability
to solve specific problems.
</p>
<p>
The library has the following <i>User's Guides</i>:
</p>
<ol>
<li>
General information about the use of the <code>Buildings</code> library
is available at
<a href=\"http://simulationresearch.lbl.gov/modelica/userGuide\">
http://simulationresearch.lbl.gov/modelica/userGuide</a>.
This web site covers general information that is not specific to the
use of individual packages or models.
Discussed topics include
how to get started, best practices, how to post-process results using Python,
work-around for problems and how to develop models.<br/>
</li>
<li>
Some of packages have their own
User's Guides that can be accessed by the links below.
These User's Guides are explaining items that are specific to the
particular package.<br/>
<table summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\">
<tr><td valign=\"top\"><a href=\"modelica://Buildings.Airflow.Multizone.UsersGuide\">Airflow.Multizone</a>
   </td>
   <td valign=\"top\">Package for multizone airflow and contaminant transport.</td>
</tr>
<tr><td valign=\"top\"><a href=\"modelica://Buildings.BoundaryConditions.UsersGuide\">BoundaryConditions</a>
   </td>
   <td valign=\"top\">Package for computing boundary conditions, such as solar irradiation.</td>
</tr>
<tr><td valign=\"top\"><a href=\"modelica://Buildings.Fluid.UsersGuide\">Fluid</a>
   </td>
   <td valign=\"top\">Package for one-dimensional fluid in piping networks with heat exchangers, valves, etc.</td>
</tr>
<tr><td valign=\"top\"><a href=\"modelica://Buildings.Fluid.Actuators.UsersGuide\">Fluid.Actuators</a>
   </td>
   <td valign=\"top\">Package with valves and air dampers.</td>
</tr>
<tr><td valign=\"top\"><a href=\"modelica://Buildings.Fluid.FMI.UsersGuide\">Fluid.FMI</a>
   </td>
   <td valign=\"top\">Package with blocks to export thermofluid flow models as Functional Mockup Units.</td>
</tr>
<tr><td valign=\"top\"><a href=\"modelica://Buildings.Fluid.HeatExchangers.ActiveBeams.UsersGuide\">Fluid.HeatExchangers.ActiveBeams</a>
   </td>
   <td valign=\"top\">Package with active beams.</td>
</tr>
<tr><td valign=\"top\"><a href=\"modelica://Buildings.Fluid.HeatExchangers.DXCoils.UsersGuide\">Fluid.HeatExchangers.DXCoils</a>
   </td>
   <td valign=\"top\">Package with direct evaporative cooling coils.</td>
</tr>
<tr><td valign=\"top\"><a href=\"modelica://Buildings.Fluid.HeatExchangers.RadiantSlabs.UsersGuide\">Fluid.HeatExchangers.RadiantSlabs</a>
   </td>
   <td valign=\"top\">Package with radiant slabs.</td>
</tr>
<tr><td valign=\"top\"><a href=\"modelica://Buildings.Fluid.Movers.UsersGuide\">Fluid.Movers</a>
   </td>
   <td valign=\"top\">Package with fans and pumps.</td>
</tr>
<tr><td valign=\"top\"><a href=\"modelica://Buildings.Fluid.Sensors.UsersGuide\">Fluid.Sensors</a>
   </td>
   <td valign=\"top\">Package with sensors.</td>
<tr><td valign=\"top\"><a href=\"modelica://Buildings.Fluid.Storage.UsersGuide\">Fluid.Storage</a>
   </td>
   <td valign=\"top\">Package with storage tanks and an expansion vessel.</td>
<tr><td valign=\"top\"><a href=\"modelica://Buildings.Fluid.SolarCollectors.UsersGuide\">Fluid.SolarCollectors</a>
   </td>
   <td valign=\"top\">Package with solar collectors.</td>
</tr>
<tr><td valign=\"top\"><a href=\"modelica://Buildings.Fluid.Interfaces.UsersGuide\">Fluid.Interfaces</a>
   </td>
   <td valign=\"top\">Base models that can be used by developers to implement new models.</td>
</tr>
<tr><td valign=\"top\"><a href=\"modelica://Buildings.HeatTransfer.UsersGuide\">HeatTransfer</a>
   </td>
   <td valign=\"top\">Package for heat transfer in building constructions.</td>
</tr>
<tr><td valign=\"top\"><a href=\"modelica://Buildings.ThermalZones.Detailed.UsersGuide.MixedAir\">Rooms.MixedAir</a>
   </td>
   <td valign=\"top\">Package for heat transfer in rooms and through the building envelope with the
                      room air being modeled using the mixed air assumption.</td>
</tr>
<tr><td valign=\"top\"><a href=\"modelica://Buildings.ThermalZones.Detailed.UsersGuide.MixedAir\">Rooms.CFD</a>
   </td>
   <td valign=\"top\">Package for heat transfer in rooms and through the building envelope with the
                      room air being modeled using computational fluid dynamics.</td>
</tr>

<tr><td valign=\"top\"><a href=\"modelica://Buildings.ThermalZones.Detailed.Examples.FFD.UsersGuide\">Rooms.Examples.FFD</a>
   </td>
   <td valign=\"top\">Package with examples that use the Fast Fluid Dynamics program for
                      the computational fluid dynamics.</td>
</tr>

<tr><td valign=\"top\"><a href=\"modelica://Buildings.Utilities.IO.Python36.UsersGuide\">Utilities.IO.Python36</a>
   </td>
   <td valign=\"top\">Package to call Python functions from Modelica.</td>
</tr>

<tr><td valign=\"top\"><a href=\"modelica://Buildings.Utilities.Plotters.UsersGuide\">Utilities.Plotters</a>
   </td>
   <td valign=\"top\">Package that allow writing time series and scatter plots to an html output file.</td>
</tr>

</table><br/>
</li>
<li>
There are also tutorials available at
<a href=\"modelica://Buildings.Examples.Tutorial\">
Buildings.Examples.Tutorial</a>.
These tutorials contain step by step instructions for how to build system models.
</li>
</ol>
</html>"));
end UsersGuide;


annotation (
preferredView="info",
version="8.0.0",
versionDate="2020-05-28",
dateModified="2020-05-28",
uses(Modelica(version="3.2.3")),
conversion(
  from(version={"7.0.0"},
      script="modelica://Buildings/Resources/Scripts/Dymola/ConvertBuildings_from_7_to_8.0.0.mos")),
preferredView="info",
Documentation(info="<html>
<p>
The <code>Buildings</code> library is a free library
for modeling building energy and control systems.
Many models are based on models from the package
<code>Modelica.Fluid</code> and use
the same ports to ensure compatibility with the Modelica Standard
Library.
</p>
<p>
The figure below shows a section of the schematic view of the model
<a href=\"modelica://Buildings.Examples.HydronicHeating\">
Buildings.Examples.HydronicHeating</a>.
In the lower part of the figure, there is a dynamic model of a boiler, a pump and a stratified energy storage tank. Based on the temperatures of the storage tank, a finite state machine switches the boiler and its pump on and off.
The heat distribution is done using a hydronic heating system with a three way valve and a pump with variable revolutions. The upper right hand corner shows a room model that is connected to a radiator whose flow is controlled by a thermostatic valve.
</p>
<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/UsersGuide/HydronicHeating.png\" border=\"1\"/>
</p>
<p>
The web page for this library is
<a href=\"http://simulationresearch.lbl.gov/modelica\">http://simulationresearch.lbl.gov/modelica</a>,
and the development page is
<a href=\"https://github.com/lbl-srg/modelica-buildings\">https://github.com/lbl-srg/modelica-buildings</a>.
Contributions to further advance the library are welcomed.
Contributions may not only be in the form of model development, but also
through model use, model testing,
requirements definition or providing feedback regarding the model applicability
to solve specific problems.
</p>
</html>"));
end Buildings;
