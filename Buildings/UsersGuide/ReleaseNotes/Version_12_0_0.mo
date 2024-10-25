within Buildings.UsersGuide.ReleaseNotes;
class Version_12_0_0 "Version 12.0.0"
  extends Modelica.Icons.ReleaseNotes;
    annotation (Documentation(info="<html>
<div class=\"release-summary\">
<p>
Version 12.0.0 is ... xxx
</p>
</div>
<!-- New libraries -->
<p>
The following <b style=\"color:blue\">new libraries</b> have been added:
</p>
<table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\">
<tr><td valign=\"top\">Buildings.Fluid.Geothermal.ZonedBorefields
    </td>
    <td valign=\"top\">Package with models for borefields in which individual groups of boreholes can be operated
                       independently from each other. In contrast to Buildings.Fluid.Geothermal.Borefields,
                       in which all boreholes are connected in parallel,
                       this package allows to form groups of parallel connected boreholes. Each of these groups
                       has its own fluid ports, allowing them for example to be connected in series,
                       or to operate groups at the center of the borefield with a warmer temperature than
                       groups at the perimeter.
    </td>
    </tr>
</table>
<!-- New components for existing libraries -->
<p>
The following <b style=\"color:blue\">new components</b> have been added
to <b style=\"color:blue\">existing</b> libraries:
</p>
<table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
<tr><td colspan=\"2\"><b>Buildings.Templates</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Templates.Plants
    </td>
    <td valign=\"top\">Several new components have been added and existing ones updated
                       to support the following new features in the heat pump plant template:
                       sidestream heat recovery chiller, primary-only pumping, buffer tanks,
                       failsafe staging conditions and internal computation of pump speed
                       or balancing valve ∆p to meet design flow.<br/>
                       This is for
                       <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3808\">#3808</a>.
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
<!-- Backward compatible changes -->
<p>
The following <b style=\"color:blue\">existing components</b>
have been <b style=\"color:blue\">improved</b> in a
<b style=\"color:blue\">backward compatible</b> way:
</p>
<table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
<tr><td colspan=\"2\"><b>Buildings.Applications</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Applications.DataCenters.ChillerCooled.Equipment.BaseClasses.PartialPlantParallel
    </td>
    <td valign=\"top\">Added input filter to the isolation valve 2.<br/>
                       This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3989\">issue 3989</a>.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Air.Systems.SingleZone</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Air.Systems.SingleZone.VAV.BaseClasses.ControllerEconomizer
    </td>
    <td valign=\"top\">Added a <code>pre</code> block to break the algebraic loop involving the mixed air temperature.<br/>
                       This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3915\">#3915</a>.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Controls.OBC.ASHRAE.G36</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Controls.OBC.ASHRAE.G36.Generic.TimeSuppression
    </td>
    <td valign=\"top\">Replaced <code>hold</code> with <code>pre</code> to break the algebraic loop involving the latch component.<br/>
                       This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3883\">#3883</a>.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Controls.OBC.ASHRAE.G36.Generic.TrimAndRespond
    </td>
    <td valign=\"top\">Added logic to hold trim and respond loop output.<br/>
                       This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3761\">#3761</a>.
<tr><td colspan=\"2\"><b>Buildings.Controls.OBC.CDL</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Controls.OBC.CDL.Logical.Latch
    </td>
    <td valign=\"top\">Simplified the implementation.<br/>
                       This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3796\">#3796</a>.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Controls.OBC.CDL.Logical.TrueFalseHold
    </td>
    <td valign=\"top\">Refactored with synchronous language elements.<br/>
                     This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3787\">issue 3787</a>
                     and <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3966\">issue 3966</a>.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Controls.OBC.CDL.Reals.Sort
    </td>
    <td valign=\"top\">Added an output variable with the indices of the sorted elements.<br/>
                       This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3809\">issue 3809</a>.
<tr><td colspan=\"2\"><b>Buildings.DHC.ETS</b>
    </td>
</tr>
<tr>
    <td valign=\"top\">Buildings.DHC.ETS.Combined.BaseClasses.PartialHeatPumpHeatExchanger<br/>
                       Buildings.DHC.ETS.Combined.Controls.SwitchBox
    </td>
    <td valign=\"top\">Added HX primary flow sensor and moving average to break the algebraic loop
                       when using components configured in steady state.<br/>
                       This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3906\">#3906</a>.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Examples</b>
    </td>
</tr>
<tr>
    <td valign=\"top\">Buildings.Examples.SimpleHouse<br/>
                       Buildings.Examples.Tutorial.SimpleHouse.SimpleHouse6
    </td>
    <td valign=\"top\">Added two-port temperature sensors to replace <code>sta_*.T</code> in reference results.<br/>
                       This is for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1913\">IBPSA #1913</a>.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Fluid</b>
    </td>
</tr>
<tr>
    <td valign=\"top\">Buildings.Fluid.Chillers.Validation.Carnot_TEva_reverseFlow<br/>
                       Buildings.Fluid.FixedResistances.Validation.LosslessPipe<br/>
                       Buildings.Fluid.HeatExchangers.Validation.ConstantEffectiveness<br/>
                       Buildings.Fluid.HeatExchangers.Radiators.Examples.RadiatorEN442_2<br/>
                       Buildings.Fluid.HeatPumps.Validation.Carnot_TCon_reverseFlow<br/>
                       Buildings.Fluid.Interfaces.Examples.Humidifier_u<br/>
                       Buildings.Fluid.Interfaces.Examples.BaseClasses.PrescribedOutletState
    </td>
    <td valign=\"top\">Added two-port temperature sensors to replace <code>sta_*.T</code> in reference results.<br/>
                       This is for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1913\">IBPSA #1913</a>.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Fluid.Movers</b>
    </td>
</tr>
<tr>
    <td valign=\"top\">Buildings.Fluid.Movers.Data.Generic
    </td>
    <td valign=\"top\">The function <code>Buildings.Fluid.Movers.BaseClasses.Euler.getPeak</code>
                       is no longer called unless needed.<br/>
                       This is for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1912\">IBPSA #1912</a>.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Fluid.Movers</b>
    </td>
</tr>
<tr>
    <td valign=\"top\">Buildings.Fluid.Movers.Validation.ComparePowerHydraulic
    </td>
    <td valign=\"top\">Added standalone declaration for the peak operating condition to ensure that
                       the same values are used for each mover.<br/>
                       This is for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1912\">IBPSA #1912</a>.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.ThermalZones.EnergyPlus_9_6_0</b>
    </td>
</tr>
<tr>
    <td valign=\"top\">Buildings.ThermalZones.EnergyPlus_9_6_0
    </td>
    <td valign=\"top\">Updated EnergyPlus binaries.<br/><br/>
                       With this update, simulations that start with a negative start time are supported.<br/>
                       This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1938\">#1938</a>.<br/><br/>
                       This update also adds support for specifying entries for the EnergyPlus run period.
                       See the documentation of <code>Buildings.ThermalZones.EnergyPlus_9_6_0.Data.RunPeriod</code> for details.<br/>
                       This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2926\">#2926</a>.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Obsolete.Controls.OBC.ASHRAE.G36_PR1</b>
    </td>
</tr>
<tr>
    <td valign=\"top\">Buildings.Obsolete.Controls.OBC.ASHRAE.G36_PR1.TerminalUnits.Reheat.SystemRequests
    </td>
    <td valign=\"top\">Replaced <code>hold</code> with <code>pre</code> to break the algebraic loop involving the latch component.<br/>
                       This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3915\">#3915</a>.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Templates</b>
</tr>
<tr><td valign=\"top\">Buildings.Templates.Plants.Controls.Setpoints.PlantReset
    </td>
    <td valign=\"top\">Updated hold logic during staging after refactoring trim and respond block.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3761\">#3761</a>.
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
<table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
<tr><td colspan=\"2\"><b>Buildings.Applications</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Applications.DataCenters.ChillerCooled.Controls.ConstantSpeedPumpStage<br/>
                       Buildings.Applications.DataCenters.ChillerCooled.Examples.IntegratedPrimarySecondaryEconomizer<br/>
                       Buildings.Applications.DataCenters.ChillerCooled.Examples.NonIntegratedPrimarySecondaryEconomizer
    </td>
    <td valign=\"top\">Added plant on signal to pumps control.<br/>
                       This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3989\">issue 3989</a>.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Controls.OBC.CDL</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Controls.OBC.CDL.Logical.TrueHold<br/>
                       Buildings.Controls.OBC.CDL.Logical.Validation.TrueHold
    </td>
    <td valign=\"top\">The blocks have been moved to the <code>Obsolete</code> package.
                       Users are encouraged to use <code>TrueFalseHold(falseHoldDuration=0)</code>
                       instead.<br/>
                       The conversion script will automatically update existing models.<br/>
                       This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3787\">issue 3787</a>.
    </td>
</tr>

<tr><td colspan=\"2\"><b>Buildings.Fluid.Actuators</b>
    </td>
</tr>
<tr>
    <td valign=\"top\">Buildings.Fluid.Actuators.Dampers.Exponential<br/>
                       Buildings.Fluid.Actuators.Dampers.MixingBox<br/>
                       Buildings.Fluid.Actuators.Dampers.MixingBoxMinimumFlow<br/>
                       Buildings.Fluid.Actuators.Dampers.PressureIndependent<br/>
                       Buildings.Fluid.Actuators.Valves.ThreeWayEqualPercentageLinear<br/>
                       Buildings.Fluid.Actuators.Valves.ThreeWayLinear<br/>
                       Buildings.Fluid.Actuators.Valves.ThreeWayTable<br/>
                       Buildings.Fluid.Actuators.Valves.TwoWayButterfly<br/>
                       Buildings.Fluid.Actuators.Valves.TwoWayEqualPercentage<br/>
                       Buildings.Fluid.Actuators.Valves.TwoWayLinear<br/>
                       Buildings.Fluid.Actuators.Valves.TwoWayPolynomial<br/>
                       Buildings.Fluid.Actuators.Valves.TwoWayPressureIndependent<br/>
                       Buildings.Fluid.Actuators.Valves.TwoWayQuickOpening<br/>
                       Buildings.Fluid.Actuators.Valves.TwoWayTable
    </td>
    <td valign=\"top\">Changed model for actuator position. The new implementation changes the actuator position
                       at a constant speed defined by the stroke time rather than a second order filter.<br/>
                       This update changes the parameter <code>use_inputFilter</code> and <code>riseTime</code> to
                       <code>use_strokeTime</code> and <code>strokeTime</code>.<br/>
                       The conversion script will automatically update existing models.<br/>
                       This is for
                       <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1926\">IBPSA, #1926</a> and
                       <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3965\">Buildings, #3965</a>.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Fluid.Geothermal</b>
    </td>
</tr>
<tr>
    <td valign=\"top\">Buildings.Fluid.Geothermal.Borefields.BaseClasses.Boreholes.OneUTube<br/>
                       Buildings.Fluid.Geothermal.Borefields.BaseClasses.Boreholes.TwoUTube<br/>
                       Buildings.Fluid.Geothermal.Borefields.BaseClasses.PartialBorefield

    </td>
    <td valign=\"top\">Removed parameter <code>dynFil</code> to avoid allowing an inconsistent
                       declaration of the energy balance configuration for the borehole filling.<br/>
                       This is for
                       <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1885\">IBPSA, #1885</a>.
    </td>
</tr>


<tr><td colspan=\"2\"><b>Buildings.DHC</b>
    </td>
</tr>
<tr>
    <td valign=\"top\">Buildings.DHC.Plants.Combined.Subsystems.MultiplePumpsDp<br/>
                       Buildings.DHC.Plants.Combined.Subsystems.MultiplePumpsFlow<br/>
                       Buildings.DHC.Plants.Combined.Subsystems.MultiplePumpsSpeed
    </td>
    <td valign=\"top\">Changed model for change in pump rotational speed. The new implementation changes the rotational speed
                       at a constant rate rather than a second order filter.<br/>
                       This update changes the parameter <code>use_inputFilter</code> to <code>use_riseTime</code>.<br/>
                       The conversion script will automatically update existing models.<br/>
                       This is for
                       <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1926\">IBPSA, #1926</a> and
                       <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3965\">Buildings, #3965</a>.
    </td>
</tr>
<tr>
    <td valign=\"top\">Buildings.DHC.Plants.Cooling.Subsystems.CoolingTowersParallel<br/>
                       Buildings.DHC.Plants.Cooling.Subsystems.CoolingTowersWithBypass<br/>
                       Buildings.DHC.Plants.Combined.Subsystems.ChillerGroup<br/>
                       Buildings.DHC.Plants.Combined.Subsystems.ChillerHeatRecoveryGroup<br/>
                       Buildings.DHC.Plants.Combined.Subsystems.HeatPumpGroup
    </td>
    <td valign=\"top\">Changed model for actuator position. The new implementation changes the actuator position
                       at a constant speed defined by the stroke time rather than a second order filter.<br/>
                       This update changes the parameter <code>use_inputFilter</code> and <code>riseTime</code> to
                       <code>use_strokeTime</code> and <code>strokeTime</code>.<br/>
                       The conversion script will automatically update existing models.<br/>
                       This is for
                       <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1926\">IBPSA, #1926</a> and
                       <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3965\">Buildings, #3965</a>.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Fluid.HydronicConfigurations</b>
    </td>
</tr>
<tr>
    <td valign=\"top\">Buildings.Fluid.HydronicConfigurations.Components.ThreeWayValve<br/>
                       Buildings.Fluid.HydronicConfigurations.Components.TwoWayValve<br/>
                       Buildings.Fluid.HydronicConfigurations.Components.Pump
    </td>
    <td valign=\"top\">Changed model for change in pump rotational speed. The new implementation changes the rotational speed
                       at a constant rate rather than a second order filter.<br/>
                       This update changes the parameter <code>use_inputFilter</code> to <code>use_riseTime</code>.<br/>
                       The conversion script will automatically update existing models.<br/>
                       This is for
                       <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1926\">IBPSA, #1926</a> and
                       <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3965\">Buildings, #3965</a>.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Fluid.Movers</b>
    </td>
</tr>
<tr>
    <td valign=\"top\">Buildings.Fluid.Movers.FlowControlled_dp<br/>
                       Buildings.Fluid.Movers.FlowControlled_m_flow<br/>
                       Buildings.Fluid.Movers.SpeedControlled_y<br/>
                       Buildings.Fluid.Movers.Preconfigured.FlowControlled_dp<br/>
                       Buildings.Fluid.Movers.Preconfigured.FlowControlled_m_flow<br/>
                       Buildings.Fluid.Movers.Preconfigured.SpeedControlled_y
    </td>
    <td valign=\"top\">Changed model for change in fan or pump rotational speed. The new implementation changes the rotational speed
                       at a constant rate rather than a second order filter.<br/>
                       This update changes the parameter <code>use_inputFilter</code> to <code>use_riseTime</code>.<br/>
                       The conversion script will automatically update existing models.<br/>
                       This is for
                       <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1926\">IBPSA, #1926</a> and
                       <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3965\">Buildings, #3965</a>.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Fluid.SolarCollectors</b>
    </td>
</tr>
<tr>
    <td valign=\"top\">Buildings.Fluid.SolarCollectors
    </td>
    <td valign=\"top\">Refactored solar collector models to allow modeling of arrays of collectors,
                       to facilitate use of rating data to parameterize the collector, and
                       to improve calculation of performance for shallow solar incidence angles.<br/>
                       The former models have been moved to <code>Buildings.Obsolete</code>.<br/>
                       This is for
                       <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3604\">#3604</a>.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Templates</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Templates.Components.Controls.Validation.StatusEmulator
    </td>
    <td valign=\"top\">Refactored using a state graph.<br/>
                       This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3923\">#3923</a>.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Templates.Plants.Controls.Utilities.SortWithIndices
    </td>
    <td valign=\"top\">Moved to the <code>Obsolete</code> package.<br/>
                       This is for
                       <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3809\">#3809</a>.
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
<!-- Errors that have been fixed -->
<p>
The following <b style=\"color:red\">critical errors</b> have been fixed (i.e., errors
that can lead to wrong simulation results):
</p>
<table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
<tr><td colspan=\"2\"><b>Buildings.Fluid</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.Chillers.BaseClasses.PartialElectric<br/>
                       Buildings.Fluid.HeatPumps.EquationFitReversible
    </td>
    <td valign=\"top\">Added load limit depending on operating mode.<br/>
                       This is for
                       <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3815\">#3815</a>.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Templates</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Templates.Plants.Controls.Utilities.TimerWithReset
    </td>
    <td valign=\"top\">Refactored to ensure <code>passed=u</code> if <code>t=0</code>.<br/>
                       This is for
                       <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3952\">#3952</a>.
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
<!-- Uncritical errors -->
<p>
The following <b style=\"color:red\">uncritical errors</b> have been fixed (i.e., errors
that do <b style=\"color:red\">not</b> lead to wrong simulation results, e.g.,
units are wrong or errors in documentation):
</p>
<table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
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
end Version_12_0_0;
