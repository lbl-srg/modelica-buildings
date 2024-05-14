within Buildings.UsersGuide.ReleaseNotes;
class Version_11_0_1 "Version 11.0.1"
  extends Modelica.Icons.ReleaseNotes;
    annotation (Documentation(info="<html>
<div class=\"release-summary\">
<p>
Version 11.0.1 is ... xxx
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
<tr><td colspan=\"2\"><b>Buildings.Controls.OBC.CDL</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Controls.OBC.CDL.Reals.Sort
    </td>
    <td valign=\"top\">Added an output variable with the indices of the sorted elements.<br/>
                       This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3809\">issue 3809</a>.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Controls.OBC.CDL.Logical.Latch
    </td>
    <td valign=\"top\">Simplified the implementation.<br/>
                       This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3796\">#3796</a>.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Examples</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Examples.ChillerPlant.BaseClasses.Controls.Examples.ChillerSetPointControl<br/>
                       Buildings.Examples.Tutorial.Boiler.System2<br/>
                       Buildings.Examples.Tutorial.Boiler.System3<br/>
                       Buildings.Examples.Tutorial.Boiler.System4<br/>
                       Buildings.Examples.Tutorial.Boiler.System5<br/>
                       Buildings.Examples.Tutorial.Boiler.System6<br/>
                       Buildings.Examples.Tutorial.Boiler.System7<br/>
                       Buildings.Examples.Tutorial.SpaceCooling.System2<br/>
                       Buildings.Examples.Tutorial.SpaceCooling.System3
    </td>
    <td valign=\"top\">Specified <code>nominalValuesDefineDefaultPressureCurve=true</code>
                       in the mover component to suppress a warning.<br/>
                       This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3819\">#3819</a>.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Fluid</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.Boilers.Examples.BoilerPolynomialClosedLoop<br/>
                       Buildings.Fluid.FMI.ExportContainers.Examples.FMUs.Fan<br/>
                       Buildings.Fluid.FMI.ExportContainers.Examples.FMUs.HVACZones<br/>
                       Buildings.Fluid.Geothermal.Borefields.Examples.RectangularBorefield<br/>
                       Buildings.Fluid.Movers.Examples.MoverParameter<br/>
                       Buildings.Fluid.Movers.Validation.FlowControlled_dp<br/>
                       Buildings.Fluid.Movers.Validation.FlowControlled_dpSystem<br/>
                       Buildings.Fluid.Movers.Validation.FlowControlled_m_flow<br/>
                       Buildings.Fluid.Movers.Validation.Pump_y_stratos<br/>
                       Buildings.Fluid.Movers.Validation.PumpCurveDerivatives
    </td>
    <td valign=\"top\">Specified <code>nominalValuesDefineDefaultPressureCurve=true</code>
                       in the mover component to suppress a warning.<br/>
                       This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3819\">#3819</a>.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Fluid.FMI.ExportContainers</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.FMI.ExportContainers.Validation.RoomHVAC
    </td>
    <td valign=\"top\">Removed redundant <code>nominalValuesDefineDefaultPressureCurve=true</code>
                       which is now modified in a lower-level model.<br/>
                       This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3819\">#3819</a>.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Fluid.Movers</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.Movers.Data.Generic
    </td>
    <td valign=\"top\">Default efficiency method assignments now depend on
                       the availability of pressure curves.
                       This reduces the occurrance of a warning message.<br/>
                       This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3819\">#3819</a>.
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
end Version_11_0_1;
