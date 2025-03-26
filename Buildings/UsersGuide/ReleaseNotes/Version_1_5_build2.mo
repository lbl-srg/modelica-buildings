within Buildings.UsersGuide.ReleaseNotes;
class Version_1_5_build2 "Version 1.5 build 2"
  extends Modelica.Icons.ReleaseNotes;
    annotation (preferredView="info",
    Documentation(info="<html>
<p>
Version 1.5 build 2 is a maintenance release that corrects an error in
<code>Buildings.Fluid.HeatExchangers.DryCoilDiscretized</code> and in
<code>Buildings.Fluid.HeatExchangers.WetCoilDiscretized</code>.
It is fully compatible with version 1.5 build 1.
<!-- Errors that have been fixed -->
<p>
The following <b style=\"color:red\">critical errors</b> have been fixed (i.e., errors
that can lead to wrong simulation results):
</p>
<table summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
<tr><td colspan=\"2\"><b>Buildings.Fluid</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.HeatExchangers.DryCoilDiscretized<br/>
                       Buildings.Fluid.HeatExchangers.WetCoilDiscretized
    </td>
    <td valign=\"top\">
           Corrected wrong connect statements that caused the last register to have
           no liquid flow.
           This closes issue <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/194\">#194</a>.
    </td>
</tr>
</table>
<!-- Github issues -->
<p>
The following
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues\">issues</a>
have been fixed:
</p>
<table summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
<tr><td colspan=\"2\"><b>DryCoilDiscretized model not using last register, liquid flow path</b>
    </td>
</tr>
<tr><td valign=\"top\"><a href=\"https://github.com/lbl-srg/modelica-buildings/issues/194\">#194</a>
    </td>
    <td valign=\"top\">This issue has been addressed by correcting the connect statements.
    </td>
</tr>
</table>
</html>"));
end Version_1_5_build2;
