within Buildings.UsersGuide.ReleaseNotes;
class Version_8_1_2 "Version 8.1.2"
extends Modelica.Icons.ReleaseNotes;
  annotation (Documentation(info="<html>
<div class=\"release-summary\">
<p>
Version 8.1.2 is a patch that has backward compatible bug fixes.
It is backwards compatible with versions 8.0.0, 8.1.0 and 8.1.1.
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
<tr><td colspan=\"2\"><b>Buildings.HeatTransfer</b>
  </td>
</tr>
<tr><td valign=\"top\">Buildings.HeatTransfer.Windows.BaseClasses.CenterOfGlass
    </td>
    <td valign=\"top\">Changed the gas layer to be conditional.<br/>
                       This is for
                       <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3026\">#3026</a>.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Fluid</b>
  </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.Boilers.Data.Lochinvar
  </td>
  <td valign=\"top\">Added annotation <code>defaultComponentPrefixes = \"parameter\"</code>.
  </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.HeatPumps.Data.EquationFitReversible.Generic
  </td>
  <td valign=\"top\">Removed <code>protected</code> declaration inside the record as the Modelica Language Specification
                     only allows public sections in a record.<br/>
                     This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3009\">#3009</a>.
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
<tr><td colspan=\"2\"><b>Buildings.Controls</b>
  </td>
</tr>
<tr><td valign=\"top\">Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger<br/>
                       Buildings.Controls.OBC.CDL.Conversions.BooleanToReal<br/>
    </td>
    <td valign=\"top\">Corrected documentation texts where the variables were described with wrong types.<br/>
                       This is for
                       <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3016\">#3016</a>.
    </td>
</tr>
</table>
</html>"));
end Version_8_1_2;
