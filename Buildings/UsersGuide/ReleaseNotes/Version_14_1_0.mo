within Buildings.UsersGuide.ReleaseNotes;
class Version_14_1_0 "Version 14.1.0"
  extends Modelica.Icons.ReleaseNotes;
    annotation(Documentation(info="<html>
<div class=\"release-summary\">
<p>
Version 14.1.0 is ... xxx
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
<tr><td colspan=\"2\"><b>xxx</b>
    </td>
</tr>
<tr><td valign=\"top\">xxx
    </td>
    <td valign=\"top\">xxx.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Fluid.Geothermal</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.Geothermal.Borefields.TOUGH.BaseClasses.GroundResponse
    </td>
    <td valign=\"top\">Improved the python interface code to avoid permission error.<br/>
                       This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/4783\">issue 4783</a>.
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
<tr><td colspan=\"2\"><b>Buildings.Fluid.Boilers</b>
   </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.Boilers.BoilerPolynomial<br/>
                       Buildings.Fluid.Boilers.BoilerTable
    </td>
    <td valign=\"top\">Corrected calculation of heat loss.<br/>
                       This is for <a href=\"https://www.github.com/lbl-srg/modelica-buildings/issues/4475\">issue #4475</a>.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Media.Antifreeze.Functions.Validation</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Media.Antifreeze.Functions.Validation.PropyleneGlycolWater
    </td>
    <td valign=\"top\">Corrected call from
    <code>EthyleneGlycolWater.prandtlNumber_TX_a</code> to
    <code>PropyleneGlycolWater.prandtlNumber_TX_a</code>.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Fluid.DataCenters.CDUs.LiquidToLiquid.Data</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.DataCenters.CDUs.LiquidToLiquid.Data.Generic_2MW<br/>
                       Buildings.Fluid.DataCenters.CDUs.LiquidToLiquid.Data.GoogleProjectDeschutes_2MW<br/>
                       Buildings.Fluid.DataCenters.CDUs.LiquidToLiquid.Data.VertivLiebertXDU1350
    </td>
    <td valign=\"top\">Corrected sign of <code>Q_flow_nominal</code>, which must be negative.
                       For <code>GoogleProjectDeschutes_2MW</code>, added the nominal mass flow rates
                       listed in its documentation.<br/>
                       This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/4787\">Buildings, #4787</a>.
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
end Version_14_1_0;
