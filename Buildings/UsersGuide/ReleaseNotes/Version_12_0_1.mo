within Buildings.UsersGuide.ReleaseNotes;
class Version_12_0_1 "Version 12.0.1"
  extends Modelica.Icons.ReleaseNotes;
    annotation (Documentation(info="<html>
<div class=\"release-summary\">
<p>
Version 12.0.1 is ... xxx
</p>
</div>
<!-- New libraries -->
<p>
The following <b style=\"color:blue\">new libraries</b> have been added:
</p>
<table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\">
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
<table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
<tr><td colspan=\"2\"><b>Buildings.Controls.OBC</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Controls.OBC.Utilities.PIDWithAutotuning
    </td>
    <td valign=\"top\">Package that contains components for the PID controller that can
                       autotune the control gain and time constants.
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
end Version_12_0_1;
