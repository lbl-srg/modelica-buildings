within Buildings.UsersGuide.ReleaseNotes;
class Version_0_12_0 "Version 0.12.0"
  extends Modelica.Icons.ReleaseNotes;
annotation (preferredView="info", Documentation(info="<html>
<p>
<b>Note:</b> The packages whose name ends with <code>Beta</code>
are still being validated.
</p>
<p>
The following <b style=\"color:red\">critical error</b> has been fixed (i.e. error
that can lead to wrong simulation results):
</p>

<table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
  <tr><td colspan=\"2\"><b>Buildings.ThermalZones</b></td></tr>
  <tr><td valign=\"top\"><code>Buildings.ThermalZones.Detailed.BaseClasses.InfraredRadiationExchange</code></td>
      <td valign=\"top\">The model <code>Buildings.ThermalZones.Detailed.BaseClasses.InfraredRadiationExchange</code>
      had an error in the view factor approximation.
      The error caused too much radiosity to flow from large to small surfaces because the law of reciprocity
      for view factors was not satisfied. This led to low surface temperatures if a surface had a large area
      compared to other surfaces.
      The bug has been fixed by rewriting the view factor calculation.
      </td>
  </tr>
</table>

<p>
The following improvements and additions have been made:
</p>
<ul>
<li>
Updated library to Modelica 3.2.
</li>
<li>
Added <code>homotopy</code> operator.
</li>
<li>
Restructured package <code>Buildings.HeatTransfer</code>.
</li>
<li>
Rewrote the models in <code>Buildings.Fluid.Actuators</code> to avoid having the flow coefficient
<code>k</code> as an algebraic variable.
This increases robustness.
</li>
<li>
Rewrote energy, species and trace substance balance in
<code>Buildings.Fluid.Interfaces.StaticTwoPortHeatMassExchanger</code>
to better handle zero mass flow rate.
</li>
<li>
Implemented functions <code>enthalpyOfCondensingGas</code> and <code>saturationPressure</code>
in single substance media
to allow use of the room model with media that do not contain water vapor.
</li>
<li>
Revised <code>Buildings.Fluid.Sources.Outside</code>
to allow use of the room model with media that do not contain water vapor.
</li>
</ul>
</html>"));
end Version_0_12_0;
