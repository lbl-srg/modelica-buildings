within Buildings.UsersGuide.ReleaseNotes;
class Version_13_0_1 "Version 13.0.1"
  extends Modelica.Icons.ReleaseNotes;
    annotation (Documentation(info="<html>
<div class=\"release-summary\">
<p>
Version 13.0.1 is backward compatible with 13.0.0.
</p>
<p>
The library has been tested with
Dymola 2026x,
OpenModelica 1.26.3,
OPTIMICA 1.66 and recent versions of Impact.
</p>
<p>
This backward compatible version contains various model improvements.
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
<tr><td valign=\"top\">Buildings.Controls.OBC.CDL.Logical.Edge<br/>
                       Buildings.Controls.OBC.CDL.Logical.FallingEdge<br/>
                       Buildings.Controls.OBC.CDL.Logical.Pre<br/>
                       Buildings.Controls.OBC.CDL.Logical.TrueFalseHold
    </td>
    <td valign=\"top\">Replaced initial equation with start attribute on input.<br/>
                       This is for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/2136\">IBPSA, #2136</a>.
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
                       The annotation <code>mayOnlyConnectOnce</code> must not be used for these models as they are often used to set the
                       reference pressure in closed system flow networks.<br/>
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
<!-- Errors that have been fixed -->
<!-- Uncritical errors -->
<p>
The following <b style=\"color:red\">uncritical errors</b> have been fixed (i.e., errors
that do <b style=\"color:red\">not</b> lead to wrong simulation results, e.g.,
units are wrong or errors in documentation):
</p>
<table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
<tr><td colspan=\"2\"><b>Buildings.Fluid.DXSystems</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.DXSystems.Cooling.BaseClasses.Evaporation
    </td>
    <td valign=\"top\">Added missing variable assignment for unused variable in a branch that will not compute evaporation.<br/>
                       This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/4715\">Buildings, #4715</a>.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Fluid.Geothermal.Borefields.BaseClasses.HeatTransfer.ThermalResponseFactors</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.Geothermal.Borefields.BaseClasses.HeatTransfer.ThermalResponseFactors.gFunction
    </td>
    <td valign=\"top\">Initialized local variables <code>A</code> and <code>B</code> to avoid use of uninitialized elements
                       of a matrix. This update does not change the results.<br/>
                       This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/4707\">Buildings, #4707</a>.
    </td>
</tr>
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
Added unit specification to various models to avoid a warning in Dymola 2025x.
</li>
</ul>
</html>"));
end Version_13_0_1;
