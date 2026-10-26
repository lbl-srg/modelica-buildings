within Buildings.UsersGuide.ReleaseNotes;
class Version_13_0_2 "Version 13.0.2"
  extends Modelica.Icons.ReleaseNotes;
    annotation (Documentation(info="<html>
<div class=\"release-summary\">
<p>
Version 13.0.2 is ... xxx
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
</table>
<!-- Non-backward compatible changes to existing components -->
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
<tr><td colspan=\"2\"><b>Buildings.Fluid.FixedResistances</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.FixedResistances.PressureDrop<br/>
                       Buildings.Fluid.BaseClasses.FlowModels.powerLawData
    </td>
    <td valign=\"top\">Corrected the pressure difference where the flow becomes turbulent
                       for flow exponents <code>1 &lt; n &lt; 2</code>.
                       <code>powerLaw_dp</code>, which is used with <code>from_dp=true</code>
                       and as the inverse of <code>powerLaw_m_flow</code>, applied the regularization for
                       <code>abs(m_flow) &lt; k^(1-1/n)*m_flow_turbulent</code>
                       rather than for <code>abs(m_flow) &lt; m_flow_turbulent</code>.<br/>
                       This is for <a href=\"https://www.github.com/lbl-srg/modelica-buildings/issues/4800\">issue #4800</a>.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Media.Antifreeze.Functions.Validation</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Media.Antifreeze.Functions.Validation.PropyleneGlycolWater
    </td>
    <td valign=\"top\">Corrected the Prandtl number computation to use
    <code>PropyleneGlycolWater.prandtlNumber_TX_a</code> instead of
    <code>EthyleneGlycolWater.prandtlNumber_TX_a</code>.<br/>
    This is for
    <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/4772\">Buildings, issue 4772</a>.
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
end Version_13_0_2;
