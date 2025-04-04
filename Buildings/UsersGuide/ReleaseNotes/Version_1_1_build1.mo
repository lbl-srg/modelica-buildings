within Buildings.UsersGuide.ReleaseNotes;
class Version_1_1_build1 "Version 1.1 build 1"
  extends Modelica.Icons.ReleaseNotes;
   annotation (preferredView="info", Documentation(info="<html>
<p>
Version 1.1 build 1 contains improvements to models that address numerical problems.
In particular, flow machines and actuators now have an optional filter
that converts step changes in the input signal to a smooth change in
speed or actuator position.
Also, (<code>Buildings.Examples.Tutorial</code>)
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
                       See also <code>Buildings.Fluid.Actuators.UsersGuide</code>.
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
See <code>Buildings.Fluid.Actuators.UsersGuide</code>
and
<code>Buildings.Fluid.Movers.UsersGuide</code> for recommended control
gains and further details.
</li>
</ul>
</html>"));
end Version_1_1_build1;
