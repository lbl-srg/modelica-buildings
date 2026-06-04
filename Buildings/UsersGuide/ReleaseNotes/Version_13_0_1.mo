within Buildings.UsersGuide.ReleaseNotes;
class Version_13_0_1 "Version 13.0.1"
  extends Modelica.Icons.ReleaseNotes;
    annotation (Documentation(info="<html>
<div class=\"release-summary\">
<p>
Version 13.0.1 is ... xxx
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
<tr><td colspan=\"2\"><b>Buildings.Fluid.CHPs</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.CHPs.DistrictCHP
    </td>
    <td valign=\"top\">Package of CHP models for district energy systems.<br/>
                       This is for
                       <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3284\">issue 3284</a>.
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
<tr><td colspan=\"2\"><b>Buildings.Air.Systems.SingleZone.VAV.Examples.OptimalStart</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Air.Systems.SingleZone.VAV.Examples.OptimalStart.BaseClasses.ZoneWithAHUConventional<br/>
                       Buildings.Air.Systems.SingleZone.VAV.Examples.OptimalStart.BaseClasses.ZoneWithAHUG36
    </td>
    <td valign=\"top\">Changed the class type from block to model.<br/>
                       This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/4606\">Buildings, issue 4606</a>.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.HeatTransfer.Windows</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.HeatTransfer.Windows.BaseClasses.Overhang
    </td>
    <td valign=\"top\">Changed the class type from block to model.<br/>
                       This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/4606\">Buildings, issue 4606</a>.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.BoundaryConditions</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.BoundaryConditions.SolarGeometry.IncidenceAngle<br/>
                       Buildings.BoundaryConditions.SolarGeometry.ZenithAngle<br/>
                       Buildings.BoundaryConditions.SolarIrradiation.DiffuseIsotropic<br/>
                       Buildings.BoundaryConditions.SolarIrradiation.DiffusePerez<br/>
                       Buildings.BoundaryConditions.SolarIrradiation.DirectTiltedSurface<br/>
                       Buildings.BoundaryConditions.SolarIrradiation.GlobalPerezTiltedSurface<br/>
    </td>
    <td valign=\"top\">Changed the class type from block to model.<br/>
                       This is for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/2122\">IBPSA, issue 2122</a>.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Controls.OBC.CDL</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Controls.OBC.CDL.Integers.Change<br/>
                       Buildings.Controls.OBC.CDL.Logical.Change
    </td>
    <td valign=\"top\">Replaced initial equation with start attribute on input.<br/>
                       This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/4581\">Buildings, issue 4581</a>.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.ThermalZones.Detailed</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.ThermalZones.Detailed.Examples.FFD
    </td>
    <td valign=\"top\">Improved C source codes and recompiled FFD library to allow the examples being simulated with OpenModelica.<br/>
                       This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/4015\">Buildings, #4015</a>.<br/>
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Fluid.Sources</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.Sources.BaseClasses.PartialSource<br/>
                       Buildings.Fluid.Sources.BaseClasses.PartialAirSource
    </td>
    <td valign=\"top\">Removed deprecated <code>cardinality</code> function.<br/>
                       Removed protected parameter <code>flowDirection</code> as it was set to <code>Bidirectional</code> and had no effect on the model.
                       The annoation <code>mayOnlyConnectOnce</code> must not be used for these models as they are often used to set the
                       reference presssure in closed system flow networks.<br/>
                       This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/4607\">Buildings, #4607</a>.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.Sources.TraceSubstancesFlowSource
    </td>
    <td valign=\"top\">Removed deprecated <code>cardinality</code> function and replaced with <code>mayOnlyConnectOnce</code> annotation.<br/>
                       Removed protected parameter <code>flowDirection</code> as it was set to <code>Bidirectional</code> and had no effect on the model.<br/>
                       This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/4607\">Buildings, #4607</a>.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.ThermalZones.EnergyPlus_24_2_0</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.ThermalZones.EnergyPlus_24_2_0.Validation.MultipleBuildings
    </td>
    <td valign=\"top\">Improved C source codes to allow the validation model being simulated with OpenModelica.<br/>
                       This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3345\">Buildings, #3345</a>.<br/>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.ThermalZones.EnergyPlus_24_2_0.OpaqueConstruction
    </td>
    <td valign=\"top\">Removed deprecated <code>cardinality</code> function and replaced with <code>mustBeConnected</code> annotation.<br/>
                       This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/4607\">Buildings, #4607</a>.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Utilities.IO.BCVTB</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Utilities.IO.BCVTB.BaseClasses.FluidInterface
    </td>
    <td valign=\"top\">Removed protected parameter <code>flowDirection</code> as it was set to <code>Bidirectional</code> and had no effect on the model.<br/>
                       This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/4607\">Buildings, #4607</a>.
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
end Version_13_0_1;
