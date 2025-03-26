within Buildings.UsersGuide.ReleaseNotes;
class Version_8_1_1 "Version 8.1.1"
  extends Modelica.Icons.ReleaseNotes;
  annotation (Documentation(info="<html>
<div class=\"release-summary\">
<p>
Version 8.1.1 is a patch that has backward compatible bug fixes.
It is backwards compatible with version 8.0.0 and 8.1.0.
</p>
<p>
The library has been tested with Dymola 2022,
JModelica (revision 14023),
OpenModelica 1.19.0-dev (449+g4f16e6af22),
OPTIMICA (revision OCT-dev-r26446_JM-r14295) and recent versions of Impact.
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
<tr><td colspan=\"2\"><b>Buildings.Examples.VAVReheat</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Examples.VAVReheat.BaseClasses.Controls.FreezeStat
  </td>
  <td valign=\"top\">Added hysteresis. Without it, models can stall due to state events.<br/>
                     This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2975\">#2975</a>.
  </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Controls.OBC</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Controls.OBC.Utilities.SunRiseSet
    </td>
    <td valign=\"top\">Changed implementation to avoid NaN in OpenModelica.<br/>
                       This is for
                       <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2835\">issue 2835</a>.
    </td>
</tr>
  <tr><td valign=\"top\">Buildings.Electrical.AC.ThreePhasesUnbalanced.Lines.Line<br/>
                         Buildings.Electrical.AC.ThreePhasesUnbalanced.Lines.Line_N<br/>
                         Buildings.Electrical.AC.ThreePhasesUnbalanced.Lines.TwoPortMatrixRLC<br/>
                         Buildings.Electrical.AC.ThreePhasesUnbalanced.Lines.TwoPortMatrixRLC_N<br/>
                         Buildings.Electrical.AC.ThreePhasesUnbalanced.Lines.TwoPortMatrixRL_N<br/>
                         Buildings.Electrical.AC.ThreePhasesUnbalanced.Lines.TwoPortRLC<br/>
                         Buildings.Electrical.AC.ThreePhasesUnbalanced.Lines.TwoPortRLC_N
    </td>
    <td valign=\"top\">Set nominal attribute for voltage at terminal.
                       This change enables Dymola 2023 beta3 to solve
                       <code>Buildings.Electrical.AC.ThreePhasesUnbalanced.Validation.IEEETests.Test4NodesFeeder.UnbalancedStepDown.DY</code>
                       and
                       <code>Buildings.Electrical.AC.ThreePhasesUnbalanced.Validation.IEEETests.Test4NodesFeeder.UnbalancedStepUp.DD</code>
                       which otherwise fail during the initialization as the homotopy steps
                       obtain unreasonable values for the voltages.
    </td>
  </tr>
<tr><td colspan=\"2\"><b>Buildings.ThermalZones.EnergyPlus</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.ThermalZones.EnergyPlus
    </td>
    <td valign=\"top\">Changed handling of forward and backward slashes on Windows.
                       Now models in this package also work with OpenModelica on Windows.
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
<tr><td colspan=\"2\"><b>Buildings.DHC</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.DHC.Examples.Combined.ParallelConstantFlow
    </td>
    <td valign=\"top\">Removed the model that represented an incorrect hydronic configuration. <br/>
    This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2967\">#2967</a>.
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
<tr><td colspan=\"2\"><b>Buildings.Applications</b>
  </td>
  </tr>
  <tr><td valign=\"top\">Buildings.Applications.DataCenters.ChillerCooled.Equipment.Validation.IntegratedPrimaryLoadSide
      </td>
      <td valign=\"top\">Removed duplicate instances of blocks that generate control signals.<br/>
                         This is for
                         <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2963\">Buildings, issue 2963</a>.
      </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Controls.OBC.CDL</b>
  </td>
  </tr>
  <tr><td valign=\"top\">Buildings.Controls.OBC.CDL.PID<br/>
                         Buildings.Controls.OBC.CDL.PIDWithReset
  </td>
  <td valign=\"top\">Corrected wrong documentation in how the derivative of the control error is approximated.<br/>
                     This is for
                     <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2994\">Buildings, issue 2994</a>.
  </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Experimental</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.DHC.CentralPlants.Cooling.Controls.ChillerStage
    </td>
    <td valign=\"top\">Corrected parameter value for <code>twoOn.nOut</code>.
                       This correction is required to simulate the model in Dymola 2022
                       if the model has been updated to MSL 4.0.0. With MSL 3.2.3, the simulation
                       works without this correction.<br/>
                       This is for
                       <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1563\">Buildings, #1563</a>.
    </td>
</tr>
  <tr><td colspan=\"2\"><b>Buildings.Media</b>
    </td>
  </tr>
  <tr><td valign=\"top\">Buildings.Media.Specialized.Water.TemperatureDependentDensity
    </td>
    <td valign=\"top\">Corrected assignment of gas constant which lead to a unit error.
                       This change does not affect the results as the value is not used for this liquid medium.<br/>
                       This is for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1603\">IBPSA, #1603</a>.
    </td>
  </tr>
<tr><td colspan=\"2\"><b>Buildings.Utilities.IO.Python36</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Utilities.IO.Python36.Functions.Examples.Exchange
    </td>
    <td valign=\"top\">Removed call to impure function <code>removeFile</code>.
                       This removal is required for MSL 4.0.0.<br/>
                       This is for
                       <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1563\">Buildings, #1563</a>.
    </td>
</tr>
</table>
</html>"));
end Version_8_1_1;
