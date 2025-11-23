within Buildings.UsersGuide.ReleaseNotes;
class Version_13_0_0 "Version 13.0.0"
  extends Modelica.Icons.ReleaseNotes;
    annotation (Documentation(info="<html>
<div class=\"release-summary\">
<p>
Version X.Y.Z is ... xxx
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
<tr><td colspan=\"2\"><b>Buildings.Fluid</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.Humidifiers.EvaporativeCoolers
    </td>
    <td valign=\"top\">Package with evaporative cooler models based on EnergyPlus v23.1.0 Engineering Reference.<br/>
                       This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3492\">issue 3492</a>.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Controls.OBC</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Controls.OBC.ASHRAE.G36.FanCoilUnit
    </td>
    <td valign=\"top\">Control sequences for fan coil units.<br/>
                       This is for
                       <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2885\">issue 2885</a>.
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
<tr><td colspan=\"2\"><b>Buildings.Airflow</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Airflow.Multizone
    </td>
    <td valign=\"top\">Optimized code to reduce computing time for interzonal air exchange models.<br/>
                       This is for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/2043\">IBPSA, issue 2043</a>.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Controls.OBC.CDL</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Controls.OBC.CDL.Logical.Latch
    </td>
    <td valign=\"top\">Reformulated initalization to avoid non-linear equations in <code>when</code> blocks.<br/>
                       This is for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/2064\">IBPSA, issue 2064</a>.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Fluid</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.HeatPumps.ModularReversible
    </td>
    <td valign=\"top\">Improved implementation and diagnostics of safety checks.<br/>
                       This is for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/2035\">IBPSA, issue 2035</a>.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.PlugFlowPipe<br/>
                       Buildings.Fluid.PlugFlowPipeDiscretized
    </td>
    <td valign=\"top\">Added option to disable pressure drop calculation.<br/>
                       This is for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/2015\">IBPSA, issue 2015</a>.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.ThermalZones.Detailed</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.ThermalZones.Detailed.BaseClasses.ExteriorBoundaryConditions
    </td>
    <td valign=\"top\">Explicitly assigned value to the roughness of the exterior constructions.<br/>
                       This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/4367\">issue 4367</a>.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Utilities.IO.Python_3_8</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Utilities.IO.Python_3_8.Functions.BaseClasses.exchange
    </td>
    <td valign=\"top\">Added missing header file.<br/>
                       This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/4343\">issue 4343</a>.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Utilities.Math.Functions</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Utilities.Math.Functions.bicubic<br/>
                       Buildings.Utilities.Math.Functions.quadraticLinear<br/>
                       Buildings.Utilities.Math.Functions.quinticHermite<br/>
                       Buildings.Utilities.Math.Functions.smoothHeaviside<br/>
                       Buildings.Utilities.Math.Functions.smoothLimit
    </td>
    <td valign=\"top\">Made the functions inlined.<br/>
                       This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/4278\">issue 4278</a>.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Fluid.HeatExchangers</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.HeatExchangers.ThermalWheels
    </td>
    <td valign=\"top\">Package of models for heat recovery and enthalpy recovery wheels.<br/>
                       This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3538\">issue 3538</a>.
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
<tr><td valign=\"top\">Buildings.Fluid.Geothermal.Borefields.BaseClasses.HeatTransfer.GroundTemperatureResponse<br/>
                       Buildings.Fluid.Geothermal.ZonedBorefields.BaseClasses.HeatTransfer.GroundTemperatureResponse
    </td>
    <td valign=\"top\">Reformulated <code>when</code> block to avoid continuous and discrete variable assignment in the same block.<br/>
                       This is for
                       <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/4321\">#4321</a>
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Fluid.HeatExchangers</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.HeatExchangers.ThermalWheels
    </td>
    <td valign=\"top\">Package of models for heat recovery and enthalpy recovery wheels.<br/>
                       This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3538\">#3538</a>.
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
<tr><td colspan=\"2\"><b>Buildings.Controls.OBC.ASHRAE.G36.AHUs</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.Controller<br/>
                       Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.SetPoints.FreezeProtection<br/>
                       Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.SetPoints.PlantRequests<br/>
                       Buildings.Controls.OBC.ASHRAE.G36.AHUs.SingleZone.VAV.Controller<br/>
                       Buildings.Controls.OBC.ASHRAE.G36.AHUs.SingleZone.VAV.SetPoints.FreezeProtection<br/>
                       Buildings.Controls.OBC.ASHRAE.G36.AHUs.SingleZone.VAV.SetPoints.PlantRequests
    </td>
    <td valign=\"top\">Renamed the parameter <code>Thys</code> to <code>THys</code>.<br/>
                       This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/4374\">issue 4374</a>.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Templates</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Templates.Components.Chillers.Compression<br/>
                       Buildings.Templates.Components.HeatPumps.AirToWater<br/>
                       Buildings.Templates.Components.HeatPumps.WaterToWater<br/>
                       Buildings.Templates.Plants.HeatPumps.AirToWater<br/>
                       Buildings.Templates.Plants.HeatPumps.Components.HeatPumpGroups.AirToWater<br/>
                       Buildings.Templates.Plants.HeatPumps.Components.HeatRecoveryChiller
    </td>
    <td valign=\"top\">Refactored with load-dependent 2D table data heat pump model.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/4152\">#4152</a>.
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
<!-- Errors that have been fixed -->
<p>
The following <b style=\"color:red\">critical errors</b> have been fixed (i.e., errors
that can lead to wrong simulation results):
</p>
<table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
<tr><td colspan=\"2\"><b>Buildings.Controls.OBC.Utilities.PIDWithAutotuning</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Controls.OBC.Utilities.PIDWithAutotuning.SystemIdentification.FirstOrderTimeDelay.BaseClasses.TimeConstantDelay<br/>
                       Buildings.Controls.OBC.Utilities.PIDWithAutotuning.Relay.BaseClasses.NormalizedTimeDelay
    </td>
    <td valign=\"top\">Add error-handling mechanism to capture negative control gains.<br/>
                       This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/4378\">issue 4378</a>.
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
end Version_13_0_0;
