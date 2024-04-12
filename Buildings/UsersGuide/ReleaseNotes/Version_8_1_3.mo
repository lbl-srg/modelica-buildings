within Buildings.UsersGuide.ReleaseNotes;
class Version_8_1_3 "Version 8.1.3"
  extends Modelica.Icons.ReleaseNotes;
  annotation (Documentation(info="<html>
<div class=\"release-summary\">
<p>
Version 8.1.3 is a patch that has backward compatible bug fixes.
It is backwards compatible with versions 8.0.0, 8.1.0, 8.1.1 and 8.1.2.
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
<!-- Non-backward compatible changes to existing components -->
<!-- Errors that have been fixed -->
<p>
The following <b style=\"color:red\">critical errors</b> have been fixed (i.e., errors
that can lead to wrong simulation results):
</p>
<table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
<tr><td colspan=\"2\"><b>Buildings.Fluid.HeatExchangers</b>
    </td>
</tr>
<tr><td valign=\"top\"> Buildings.Fluid.HeatExchangers.WetCoilCounterFlow<br/>
                        Buildings.Fluid.HeatExchangers.WetCoilDiscretized</br>
    </td>
    <td valign=\"top\">Corrected removal of latent heat from component.<br/>
                       This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3027\">#3027</a>.
    </td>
</tr>
</table>
<!-- Uncritical errors -->
</html>"));
end Version_8_1_3;
