within Buildings.UsersGuide.ReleaseNotes;
class Version_11_1_1 "Version 11.1.1"
  extends Modelica.Icons.ReleaseNotes;
    annotation (Documentation(info="<html>
<div class=\"release-summary\">
<p>
Version 11.1.1 is backward compatible with 11.1.0.
</p>
<p>
The library has been tested with
Dymola 2024x Refresh 1,
OpenModelica 1.26.3,
OPTIMICA 1.66 and recent versions of Impact.
</p>
<p>
This backward compatible version contains various model improvements.
It also has been updated to use the Modelica Standard Library 4.1.0.
</p>
</div>
<!-- New libraries -->
<!-- New components for existing libraries -->
<!-- Backward compatible changes -->
<p>
The following <b style=\"color:blue\">existing components</b>
have been <b style=\"color:blue\">improved</b> in a
<b style=\"color:blue\">backward compatible</b> way:
</p>
<table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
<tr><td colspan=\"2\"><b>Buildings.Electrical</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Electrical.BaseClasses.WindTurbine.PartialWindTurbine
    </td>
    <td valign=\"top\">Changed model to avoid a rounding error that occurs due to the revised definition of <code>eps</code>
                       in the development version of the Modelica Standard Library 4.1.0.<br/>
                       This is for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1996\">IBPSA, #1996</a>.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Fluid.DXSystems</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.DXSystems.Cooling.AirSource.MultiStage<br/>
                       Buildings.Fluid.DXSystems.Cooling.AirSource.SingleSpeed<br/>
                       Buildings.Fluid.DXSystems.Cooling.AirSource.VariableSpeed<br/>
                       Buildings.Fluid.DXSystems.Cooling.BaseClasses.PartialDXCoolingCoil<br/>
                       Buildings.Fluid.DXSystems.Cooling.BaseClasses.PartialWaterCooledDXCoil
    </td>
    <td valign=\"top\">Updated redeclare and replaceable statements
                       as required by Modelica Language Standard, and needed for Wolfram System Modeler.<br/>
                       This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/4421\">#4421</a>.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Fluid.FixedResistances</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.FixedResistances.PlugFlowPipe
    </td>
    <td valign=\"top\">Removed stray <code>Line</code> annotation. Added <code>if-then</code> to conditional connections.<br/>
                       This is for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/2071\">IBPSA, #2071</a>.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Fluid.Geothermal.Borefields</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.Geothermal.Borefields.Data.Filling.Template
    </td>
    <td valign=\"top\">Guarded against division by zero for steady-state simulations.<br/>
                       This is for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/2041\">IBPSA, #2041</a>.
    </td>
</tr>

<tr><td colspan=\"2\"><b>Buildings.Fluid.Geothermal</b><br/>
                      <b>Buildings.Utilities.Clustering</b>
<tr><td valign=\"top\">Buildings.Utilities.Clustering.KMeans
    </td>
    <td valign=\"top\">Improved code to avoid an error during initialization of certain borefield geometries.<br/>
                       This is for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1985\">IBPSA, #1985</a> and
                       <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1976\">IBPSA, #1976</a>.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.HeatTransfer</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.HeatTransfer.Conduction.BaseClasses.der_temperature_u
    </td>
    <td valign=\"top\">Reformulated model to avoid warning about binding equation not being a parameter expression.<br/>
                       This is for
                       <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/4215\">#4215</a>.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Fluid.Geothermal.Borefields</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.Geothermal.Borefields.BaseClasses.HeatTransfer.ThermalResponseFactors.Validation.FiniteLineSource_Erfint
    </td>
    <td valign=\"top\">Added an assert-statement for <code>err</code>
                       and removed it from reference results.<br/>
                       This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/4277\">#4277</a>.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Fluid.Examples</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.Examples.ResistanceVolumeFlowReversal
    </td>
    <td valign=\"top\">Added two-port temperature sensors to replace <code>vol[.].T</code>
                       from reference results.<br/>
                       This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/4276\">#4276</a>.
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
<tr><td colspan=\"2\"><b>Buildings.ThermalZones.EnergyPlus_9_6_0</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.ThermalZones.EnergyPlus_9_6_0.BaseClasses.ThermalZoneAdapter
    </td>
    <td valign=\"top\">Corrected misplaced bracket in the computation of the average inlet temperature to the zone.<br/>
                       This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/4559\">#4559</a>.
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
<tr><td valign=\"top\">Buildings.Fluid.Actuators.BaseClasses.PartialTwoWayValve
    </td>
    <td valign=\"top\">Changed unit attribute to avoid an error message when exporting an FMU with Dymola.<br/>
                       This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/4455\">#4455</a>.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.DXSystems.Cooling.BaseClasses.PartialCapacity
    </td>
    <td valign=\"top\">Avoided unsafe array access that relied on short-circuiting.<br/>
                       This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/4516\">#4516</a>.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.Geothermal.BaseClasses.HeatTransfer.LoadAggregation.Validation.TemperatureResponseMatrix<br/>
                       Buildings.Fluid.Geothermal.BaseClasses.HeatTransfer.LoadAggregation.aggregationWeightingFactors<br/>
                       Buildings.Fluid.Geothermal.BaseClasses.HeatTransfer.LoadAggregation.temperatureResponseMatrix<br/>
                       Buildings.Fluid.Geothermal.ZonedBorefields.BaseClasses.HeatTransfer.Validation.TemperatureResponseMatrix<br/>
                       Buildings.Fluid.Geothermal.ZonedBorefields.BaseClasses.HeatTransfer.temperatureResponseMatrix
    </td>
    <td valign=\"top\">Corrected type specification for g-function.<br/>
                       This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/4501\">#4501</a>.
    </td>
</tr>
</table>
</html>"));
end Version_11_1_1;
