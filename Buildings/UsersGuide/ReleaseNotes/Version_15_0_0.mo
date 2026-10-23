within Buildings.UsersGuide.ReleaseNotes;
class Version_15_0_0 "Version 15.0.0"
  extends Modelica.Icons.ReleaseNotes;
    annotation (Documentation(info="<html>
<div class=\"release-summary\">
<p>
Version 15.0.0 is ... xxx
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
<tr><td colspan=\"2\"><b>Buildings.Fluid.BaseClasses.FlowModels</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_dp_inv<br/>
                       Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_dp_inv_der<br/>
                       Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_dp_inv_der2<br/>
                       Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_m_flow_inv<br/>
                       Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_m_flow_inv_der<br/>
                       Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_m_flow_inv_der2<br/>
                       Buildings.Fluid.BaseClasses.FlowModels.powerLaw_dp_inv<br/>
                       Buildings.Fluid.BaseClasses.FlowModels.powerLaw_dp_inv_der<br/>
                       Buildings.Fluid.BaseClasses.FlowModels.powerLaw_dp_inv_der2<br/>
                       Buildings.Fluid.BaseClasses.FlowModels.powerLaw_m_flow_inv<br/>
                       Buildings.Fluid.BaseClasses.FlowModels.powerLaw_m_flow_inv_der<br/>
                       Buildings.Fluid.BaseClasses.FlowModels.powerLaw_m_flow_inv_der2
    </td>
    <td valign=\"top\">Added exact inverse functions and their first and second order derivatives.<br/>
                       This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/4798\">Buildings, #4798</a>.
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
<tr><td colspan=\"2\"><b>Buildings.Fluid.BaseClasses.FlowModels</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_dp<br/>
                       Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_m_flow<br/>
                       Buildings.Fluid.BaseClasses.FlowModels.powerLaw_dp<br/>
                       Buildings.Fluid.BaseClasses.FlowModels.powerLaw_m_flow
    </td>
    <td valign=\"top\">Updated the <code>inverse</code> annotation to use the exact inverse functions,
                       and set <code>Inline=false</code> on the power law functions so that OpenModelica
                       applies the <code>inverse</code> annotation.<br/>
                       This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/4798\">Buildings, #4798</a>.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Fluid.Interfaces</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.Interfaces.ConservationEquation
    </td>
    <td valign=\"top\">Corrected the species mass balance by adding the term
                       <code>-medium.Xi*der(m)</code> to account for the change in total fluid mass.
                       For typical HVAC applications, the change in results is small.<br/>
                       This is for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/2168\">IBPSA, #2168</a>.
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
 <tr><td colspan=\"2\"><b>Buildings.Fluid.Boilers</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.Boilers.BoilerPolynomial<br/>
                       Buildings.Fluid.Boilers.BoilerTable
    </td>
    <td valign=\"top\">Corrected calculation of heat loss.
                       This change requires the <code>heatPort</code> to be connected; otherwise
                       the translation stops with an error message. Besides this change,
                       the model is backward compatible.<br/>
                       This is for <a href=\"https://www.github.com/lbl-srg/modelica-buildings/issues/4475\">issue #4475</a>.
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
end Version_15_0_0;
