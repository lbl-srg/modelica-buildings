within Buildings.UsersGuide.ReleaseNotes;
class Version_12_1_0 "Version 12.1.0"
  extends Modelica.Icons.ReleaseNotes;
    annotation (Documentation(info="<html>
<div class=\"release-summary\">
<p>
Version 12.1.0 is backward compatible with 12.0.0.
</p>
<p>
The library has been tested with
Dymola 2025x,
OpenModelica 1.24.0,
OPTIMICA 1.55.11 and recent versions of Impact.
</p>
<p>
This backward compatible version adds a new package with an autotuning PID controller.
</p>
<p>
Also, many models have been updated to improve performance, to ensure compliance with the Modelica Language Standard and to correct model errors.
</p>
</div>
<!-- New libraries -->
<p>
The following <b style=\"color:blue\">new libraries</b> have been added:
</p>
<table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\">
<tr><td valign=\"top\">Buildings.Controls.OBC.Utilities.PIDWithAutotuning
    </td>
    <td valign=\"top\">Package that contains an autotuning PID controller.
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
<tr><td colspan=\"2\"><b>Buildings.Fluid.Chillers</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.Chillers.ModularReversible.Modular
    </td>
    <td valign=\"top\">Added assertion to avoid wrong parameter definition for reference temperatures in reverse operation mode.
                       Improved parameter documentation.<br/>
                       This is for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1985\">IBPSA, #2013</a>.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Fluid.Geothermal</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Utilities.Clustering.KMeans
    </td>
    <td valign=\"top\">Improved code to avoid an error during initialization of certain borefield geometries.<br/>
                       This is for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1985\">IBPSA, #1985</a> and
                       <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1976\">IBPSA, #1976</a>.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Fluid.HeatPumps</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.HeatPumps.ModularReversible.Modular
    </td>
    <td valign=\"top\">Added assertion to avoid wrong parameter definition for reference temperatures in reverse operation mode.
                       Improved parameter documentation.<br/>
                       This is for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1985\">IBPSA, #2013</a>.
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
<tr><td colspan=\"2\"><b>Buildings.Templates</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Templates.Components.Actuators.Damper<br/>
                       Buildings.Templates.Components.Actuators.Valve<br/>
                       Buildings.Templates.Plants.HeatPumps.Components.ValvesIsolation
    </td>
    <td valign=\"top\">Replaced direct fluid pass-through with fixed resistance in actuator components.<br/>
                       This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/4227\">#4227</a>.
<tr><td colspan=\"2\"><b>Buildings.ThermalZones.EnergyPlus_24_2_0</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.ThermalZones.EnergyPlus_24_2_0
    </td>
    <td valign=\"top\">Updated the FMI library to version 3.0.3.<br/>
                       This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/pull/4198\">#4189</a>.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Obsolete.ThermalZones.EnergyPlus_9_6_0</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Obsolete.ThermalZones.EnergyPlus_9_6_0
    </td>
    <td valign=\"top\">Updated the FMI library to version 3.0.3.<br/>
                       This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/pull/4198\">#4189</a>.
<tr><td colspan=\"2\"><b>Buildings.Utilities</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Utilities.Clustering.KMeans
    </td>
    <td valign=\"top\">Improved code to avoid an error during initialization of certain borefield geometries.<br/>
                       This is for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1985\">IBPSA, #1985</a> and
                       <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1976\">IBPSA, #1976</a>.
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
<tr><td colspan=\"2\"><b>Buildings.Fluid.Chillers</b>
    </td>
</tr>
<tr><td valign=\"top\">IBPSA.Fluid.Chillers.ModularReversible.Controls.Safety
    </td>
    <td valign=\"top\">Corrected error that lead to the equipment safety counter to be increased, for example
                      due to minimum flow rate, even if the compressor signal <code>ySet</code> is zero.<br/>
                       This is for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/2011/\">IBPSA, #2011</a>.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Fluid.HeatExchanger</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.HeatExchanger.CoolingTowers.Merkel
    </td>
    <td valign=\"top\">Corrected computation of nominal UA value, which did not include the correction
    for the latent heat in the design airflow calculation.<br/>
    This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/4189\">#4189</a>.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Fluid.HeatPumps</b>
    </td>
</tr>
<tr><td valign=\"top\">IBPSA.Fluid.HeatPumps.ModularReversible.Controls.Safety
    </td>
    <td valign=\"top\">Corrected error that lead to the equipment safety counter to be increased, for example
                      due to minimum flow rate, even if the compressor signal <code>ySet</code> is zero.<br/>
                       This is for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/2011/\">IBPSA, #2011</a>.
    </td>
</tr>
<tr><td valign=\"top\">IBPSA.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.Frosting
    </td>
    <td valign=\"top\">Corrected unit error that led to wrong calculation of COP degradation due to frost building.
                       Disabled the model unless air is used on the evaporator side.<br/>
                       This is for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1975/\">IBPSA, #1975</a>.
    </td>
</tr>
</table>
<!-- Uncritical errors -->
</html>"));
end Version_12_1_0;
