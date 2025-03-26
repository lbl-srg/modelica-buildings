within Buildings.UsersGuide.ReleaseNotes;
class Version_1_5_build3 "Version 1.5 build 3"
  extends Modelica.Icons.ReleaseNotes;
    annotation (preferredView="info",
    Documentation(info="<html>
<p>
Version 1.5 build 3 is a maintenance release that corrects an error in
<code>Buildings.Fluid.MassExchangers.HumidifierPrescribed</code>.
It is fully compatible with version 1.5 build 2.
</p>
<!-- Errors that have been fixed -->
<p>
The following <b style=\"color:red\">critical errors</b> have been fixed (i.e., errors
that can lead to wrong simulation results):
<table summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
<tr><td colspan=\"2\"><b>Buildings.Fluid</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.MassExchangers.HumidifierPrescribed
    </td>
    <td valign=\"top\">
           Corrected the enthalpy balance, which caused the latent heat flow rate to be added
           twice to the fluid stream.
           This closes issue <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/197\">#197</a>.
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
<tr><td colspan=\"2\"><b>HumidifierPrescribed accounts twice for latent heat gain</b>
    </td>
</tr>
<tr><td valign=\"top\"><a href=\"https://github.com/lbl-srg/modelica-buildings/issues/197\">#197</a>
    </td>
    <td valign=\"top\">This issue has been addressed by correcting the latent heat added to the
                       fluid stream.
    </td>
</tr>
</table>
</html>"));
end Version_1_5_build3;
