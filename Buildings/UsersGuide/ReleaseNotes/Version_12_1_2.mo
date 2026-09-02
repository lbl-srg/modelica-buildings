within Buildings.UsersGuide.ReleaseNotes;
class Version_12_1_2 "Version 12.1.2"
  extends Modelica.Icons.ReleaseNotes;
    annotation (Documentation(info="<html>
<div class=\"release-summary\">
<p>
Version 12.1.2 is ... xxx
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
<tr><td colspan=\"2\"><b>Buildings.Controls.OBC.CDL.Logical</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Controls.OBC.CDL.Logical.Edge<br/>
                       Buildings.Controls.OBC.CDL.Logical.FallingEdge<br/>
                       Buildings.Controls.OBC.CDL.Logical.Pre<br/>
                       Buildings.Controls.OBC.CDL.Logical.TrueFalseHold
    </td>
    <td valign=\"top\">Replaced initial equation with start attribute on input.<br/>
                       This is for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/2136\">IBPSA, #2136</a>.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Utilities.Psychrometrics</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Utilities.Psychrometrics.TWetBul_TDryBulXi
    </td>
    <td valign=\"top\">Added nominal attribute for temperature.<br/>
                       This is for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/2155\">IBPSA, #2155</a>.
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
<tr><td colspan=\"2\"><b>Buildings.Fluid.HeatPumps.ModularReversible.BaseClasses</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.HeatPumps.ModularReversible.BaseClasses.PartialReversibleRefrigerantMachine
    </td>
    <td valign=\"top\">Corrected the flow reversal parameter in the condenser mass flow sensor
                       (<code>allowFlowReversalEva</code> was used instead of <code>allowFlowReversalCon</code>).
                       Also corrected the sensor description from evaporator to condenser.<br/>
                       This is for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/2162\">IBPSA, #2162</a>.
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
end Version_12_1_2;