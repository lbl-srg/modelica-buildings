within Buildings.UsersGuide.ReleaseNotes;
class Version_10_1_1 "Version 10.1.1"
  extends Modelica.Icons.ReleaseNotes;
  annotation (Documentation(info="<html>
<div class=\"release-summary\">
<p>
Version 10.1.1 is backward compatible with 10.0.0 and 10.1.0.
</p>
<p>
The library has been tested with
Dymola 2024x Refresh 1,
OpenModelica 1.24.0,
OPTIMICA 1.55.11 and recent versions of Impact.
</p>
<p>
Models have been updated to improve performance, to ensure compliance with the Modelica Language Standard and to correct model errors.
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
<tr><td colspan=\"2\"><b>Buildings.Controls.Continuous</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Controls.Continuous.Examples.NumberOfRequests
    </td>
    <td valign=\"top\">Changed pulse input from 0 to 1 to 0.01 to 1
                       so that the comparison against zero is robust.<br/>
                       This is for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1897\">IBPSA, #1897</a>.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Utilities.IO.Files</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Utilities.IO.Files.WeeklySchedule
    </td>
    <td valign=\"top\">Changed syntax for inclusion of C source code to comply
                       with the Modelica Language Specification.<br/>
                       This is for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1891\">IBPSA, #1891</a>.

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
<tr><td colspan=\"2\"><b>Buildings.Fluid</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.Chillers.BaseClasses.PartialElectric<br/>
                       Buildings.Fluid.HeatPumps.EquationFitReversible
    </td>
    <td valign=\"top\">Added load limit depending on operating mode.<br/>
                       This is for
                       <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3815\">#3815</a>.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Fluid.Movers</b>
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Fluid.Movers</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.Movers.Validation.PowerSimplified
    </td>
    <td valign=\"top\">Corrected efficiency assignment.<br/>
                       This is for
                       <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1880\">IBPSA, #1880</a>.
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
<tr><td colspan=\"2\"><b>Buildings.BoundaryConditions.GroundTemperature</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.BoundaryConditions.GroundTemperature.BaseClasses.surfaceTemperature
    </td>
    <td valign=\"top\">Removed wrong <code>parameter</code> declaration which causes an error in
                       Dymola 2025x beta1.<br/>
                       This is for
                       <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3978\">#3978</a>.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Electrical.Transmission</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Electrical.Transmission.BaseClasses.BaseCable
    </td>
    <td valign=\"top\">Removed wrong <code>parameter</code> declaration which causes an error in
                       Dymola 2025x beta1.<br/>
                       This is for
                       <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3978\">#3978</a>.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Utilites</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Utilities.Math.Functions.round
    </td>
    <td valign=\"top\">Removed wrong <code>parameter</code> declaration which causes an error in
                       Dymola 2025x beta1.<br/>
                       This is for
                       <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3978\">#3978</a>.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.HeatTransfer.Conduction</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.HeatTransfer.Conduction.BaseClasses.der_temperature_u
    </td>
    <td valign=\"top\">Removed wrong <code>parameter</code> declaration which causes an error in
                       Dymola 2025x beta1.<br/>
                       This is for
                       <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3978\">#3978</a>.
    </td>
</tr>
</table>
</html>"));
end Version_10_1_1;
