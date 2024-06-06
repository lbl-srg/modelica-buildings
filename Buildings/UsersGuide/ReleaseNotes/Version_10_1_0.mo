within Buildings.UsersGuide.ReleaseNotes;
class Version_10_1_0 "Version 10.1.0"
  extends
      Modelica.Icons.ReleaseNotes;
    annotation (
      Documentation(info = "<html>
<div class=\"release-summary\">
<p>
Version 10.1.0 is backward compatible with version 10.0.0.
</p>
<p>
The library has been tested with
Dymola 2024x,
OpenModelica 1.22.1-1,
OPTIMICA 1.43.4 and recent versions of Impact.
</p>
<p>
The following major changes have been done compared to release 10.0.0:
</p>
<ul>
<li>
A package to model aquifer thermal energy storage has been added.
</li>
</ul>
<p>
Many models have been updated to improve performance, for compliance with the Modelica Language Standard and to correct model errors.
</p>
</div>
<!-- New libraries -->
<p>
The following <b style=\"color:blue\">new libraries</b> have been added:
</p>
<table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\">
<tr><td valign=\"top\">Buildings.Fluid.Geothermal.Aquifer
    </td>
    <td valign=\"top\">Library with component models for aquifer thermal energy storage.
    </td>
    </tr>
</table>
<!-- New components for existing libraries -->
<p>
The following <b style=\"color:blue\">new components</b> have been added
to <b style=\"color:blue\">existing</b> libraries:
</p>
<table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
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
<tr><td colspan=\"2\"><b>Buildings.BoundaryConditions.WeatherData</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.BoundaryConditions.WeatherData.Bus
    </td>
    <td valign=\"top\">Declared variables on weather data bus, which avoids
                       a warning in OMEdit, and improves usability of weather data bus.<br/>
                       This is for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1798\">IBPSA, issue 1798</a>.
    </td>
</tr>
    <tr><td colspan=\"2\"><b>Buildings.Experimental</b>
    </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Experimental.DHC.Loads.Combined.BuildingTimeSeriesWithETS<br/>
                       Buildings.Experimental.DHC.Loads.Combined.BaseClasses.PartialBuildingWithETS
    </td>
    <td valign=\"top\">Added parameters <code>TDisWatMin</code> and <code>TDisWatMax</code>
                       in lieu of using <code>datDes</code>.<br/>
                       This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3697\">issue 3697</a>.
    </td>
    </tr>
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
</table>
<!-- Uncritical errors -->
<p>
The following <b style=\"color:red\">uncritical errors</b> have been fixed (i.e., errors
that do <b style=\"color:red\">not</b> lead to wrong simulation results, e.g.,
units are wrong or errors in documentation):
</p>
<table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
<tr><td colspan=\"2\"><b>Buildings.Experimental.DHC</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Experimental.DHC.EnergyTransferStations.BaseClasses.PartialDirect<br/>
                       Buildings.Experimental.DHC.EnergyTransferStations.BaseClasses.PartialIndirect<br/>
                       Buildings.Experimental.DHC.Loads.Steam.BuildingTimeSeriesAtETS
    </td>
    <td valign=\"top\">Corrected wrong <code>displayUnit</code> string.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Experimental.DHC.Plants.Cooling.BaseClasses.TankBranch
    </td>
    <td valign=\"top\">Corrected wrong use of <code>displayUnit</code>.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Fluid.Geothermal.Borefields</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.Geothermal.Borefields.BaseClasses.Boreholes.BaseClasses.Functions.internalResistancesOneUTube<br/>
                       Buildings.Fluid.Geothermal.Borefields.BaseClasses.Boreholes.BaseClasses.Functions.internalResistancesTwoUTube
    </td>
    <td valign=\"top\">Corrected usage of <code>getInstanceName()</code>, which was called inside
                       these functions. This does not conform with the Modelica Language Standard, and causes
                       the compilation to fail in OpenModelica 1.22.0.<br/>
                       This is for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1814\">IBPSA, #1814</a>
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.ThermalZones.EnergyPlus_9_6_0</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.ThermalZones.EnergyPlus_9_6_0.Examples.SingleFamilyHouse.HeatPumpRadiantHeatingGroundHeatTransfer
    </td>
    <td valign=\"top\">Corrected wrong <code>displayUnit</code> string.
    </td>
</tr>
</table>
</html>"));
end Version_10_1_0;
