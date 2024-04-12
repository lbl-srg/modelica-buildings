within Buildings.UsersGuide.ReleaseNotes;
class Version_9_1_2 "Version 9.1.2"
    extends Modelica.Icons.ReleaseNotes;
      annotation (Documentation(info="<html>
<div class=\"release-summary\">
<p>
Version 9.1.2 is backward compatible with 9.1.0 and 9.1.1, except that relative to 9.1.0, the Spawn binaries need to be updated as described
in <code>Buildings.ThermalZones.EnergyPlus_9_6_0.UsersGuide.Installation</code>.
</p>
<p>
The library has been tested with Dymola 2023x, OpenModelica 1.22.0-dev (41-g8a5b18f-1), OPTIMICA 1.43.4 and recent versions of Impact.
</p>
<p>
This backward compatible version adds a heat meter sensor and it adds a new example that demonstrates
how to use a hydronic radiator with the updated Spawn interface.
Also, many models have been updated to improve performance, for compliance with the Modelica Language Standard and
to correct model errors.
</p>
</div>
<!-- New libraries -->
<!-- New components for existing libraries -->
<p>
The following <b style=\"color:blue\">new components</b> have been added
to <b style=\"color:blue\">existing</b> libraries:
</p>
<table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
<tr><td colspan=\"2\"><b>Buildings.Fluid.Sensors</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.Sensors.HeatMeter
    </td>
    <td valign=\"top\">Sensor to measure the heat flow rate between a supply and return pipe in a fluid circuit.<br/>
                       This is for
                       <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1831\">IBPSA, #1831</a>.

    </td>
    </tr>
<tr><td colspan=\"2\"><b>Buildings.ThermalZones.EnergyPlus_9_6_0</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.ThermalZones.EnergyPlus_9_6_0.Examples.SingleFamilyHouse.Radiator
    </td>
    <td valign=\"top\">Added example for how to couple a radiator to the zone model.<br/>
                     This is for
                     <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3659\">Buildings, #3659</a>.
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
<tr><td colspan=\"2\"><b>Buildings.Air.Systems.SingleZone.VAV</b>
    </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Air.Systems.SingleZone.VAV.BaseClasses.ControllerChillerDXHeatingEconomizer<br/>
    </td>
    <td valign=\"top\">Adjust hysteresis based on heating to avoid chatter.<br>
                       This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3735\">#3735</a>.
    </td>
    </tr>
    <tr><td colspan=\"2\"><b>Buildings.Controls.DemandResponse</b>
    </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Controls.DemandResponse.Client
    </td>
    <td valign=\"top\">Refactored implementation so it works also with OpenModelica.<br/>
                       This is for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/3754\">#3754</a>.
    </td>
    </tr>
    <tr><td colspan=\"2\"><b>Buildings.Electrical</b>
    </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Electrical.Interfaces.InductiveLoad
    </td>
    <td valign=\"top\">Reformulated calculation of reactive power to bound argument of tangent away from &pi;,
                       which avoids an infinite function value.<br/>
                       This is for
                       <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3776\">Buildings, #3776</a>.
    </td>
    </tr>
    <tr><td colspan=\"2\"><b>Buildings.Fluid.FMI</b>
    </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Fluid.FMI.AirToOutlet<br/>
                           Buildings.Fluid.FMI.InletToAir<br/>
                           Buildings.Fluid.FMI.FlowSplitter_u<br/>
                           Buildings.Fluid.FMI.Sink_T<br/>
                           Buildings.Fluid.FMI.Source_T<br/>
                           Buildings.Fluid.FMI.Adaptors.Inlet<br/>
                           Buildings.Fluid.FMI.Adaptors.Outlet
    </td>
    <td valign=\"top\">Added missing causality which is required for language compliance and for
                       Wolfram System Modeler.<br/>
                       This is for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1829\">IBPSA, #1829</a> and
                       <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1853\">IBPSA, #1853</a>.
    </td>
    <tr><td colspan=\"2\"><b>Buildings.Fluid.Sensors.Examples</b>
    </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Fluid.Sensors.Examples.PPM
    </td>
    <td valign=\"top\">Added pressure drop to avoid redundant initial conditions for pressure of control volume.
                       This corrects an issue in Wolfram System Modeler.<br/>
                       This is for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1830\">#1830</a>.
    </td>
    <tr><td colspan=\"2\"><b>Buildings.Occupants</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Occupants.BaseClasses.binaryVariableGeneration<br/>
                       Buildings.Occupants.BaseClasses.exponentialVariableGeneration<br/>
                       Buildings.Occupants.BaseClasses.weibullVariableGeneration
    </td>
    <td valign=\"top\">Initialized <code>localSeed</code>.<br/>
                       This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3549\">#3549</a>.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.ThermalZones.EnergyPlus_9_6_0</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.ThermalZones.EnergyPlus_9_6_0.ThermalZone
    </td>
    <td valign=\"top\">Added radiative heat port to allow coupling of a radiator to the thermal zone.<br/>
                     This is for
                     <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3659\">Buildings, #3659</a>.
    </td>
<tr><td valign=\"top\">Buildings.ThermalZones.EnergyPlus_9_6_0.BaseClasses.ThermalZoneAdapter
    </td>
    <td valign=\"top\">Added <code>pre()</code> operator on mass flow rate and radiative heat gain
                     to avoid an algebraic loop on discrete variables.<br/>
                     This is for
                     <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3659\">Buildings, #3659</a>.
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
<tr><td colspan=\"2\"><b>Buildings.Fluid.SolarCollectors</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.SolarCollectors.ASHRAE93<br/>
                       Buildings.Fluid.SolarCollectors.EN12975
    </td>
    <td valign=\"top\">Corrected implementation of pressure drop calculation for the situation where the collectors are in parallel,
                       e.g., if <code>sysConfig == Buildings.Fluid.SolarCollectors.Types.SystemConfiguration.Parallel</code>.<br/>
                       This is for
                       <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3597\">Buildings, #3597</a>.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Airflow.Multizone</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Airflow.Multizone.BaseClasses.interpolate
    </td>
    <td valign=\"top\">Corrected implementation to ensure that the function is once continuously differentiable.<br/>
                       This is for
                       <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1840\">IBPSA, #1840</a>.
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
<tr><td colspan=\"2\"><b>Buildings.Airflow.Multizone</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Airflow.Multizone.MediumColumn<br/>
                       Buildings.Airflow.Multizone.MediumColumnDynamic
    </td>
    <td valign=\"top\">Corrected wrong annotation.
                       This is for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1842\">IBPSA, #1842</a>.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.BoundaryConditions</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.BoundaryConditions.SolarIrradiation.BaseClasses.SkyClearness
    </td>
    <td valign=\"top\">Corrected wrong <code>displayUnit</code> attribute.<br/>
                       This is for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1848\">IBPSA, #1848</a>.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Controls.OBC.ASHRAE.G36</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.SetPoints.ReliefFan<br/>
                       Buildings.Controls.OBC.ASHRAE.G36.AHUs.SingleZone.VAV.SetPoints.ReliefFan<br/>
                       Buildings.Controls.OBC.ASHRAE.G36.AHUs.SingleZone.VAV.SetPoints.ReliefFanGroup
    </td>
    <td valign=\"top\">Corrected wrong use <code>displayUnit</code> attribute.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Examples</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Examples.DualFanDualDuct.ClosedLoop<br/>
                       Buildings.Examples.VAVReheat.BaseClasses.ASHRAE2006<br/>
                       Buildings.Examples.ScalableBenchmarks.BuildingVAV.Examples.OneFloor_OneZone
    </td>
    <td valign=\"top\">Corrected wrong use <code>displayUnit</code> attribute.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Fluid.HeatPumps</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.HeatPumps.EquationFitReversible
    </td>
    <td valign=\"top\">Corrected wrong assertion for operation mode.<br/>
                     This is for
                     <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3664\">Buildings, #3664</a>.
    </td>
</tr>

</table>
</html>"));
end Version_9_1_2;
