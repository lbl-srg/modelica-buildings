within Buildings.UsersGuide.ReleaseNotes;

class Version_0_7_0 "Version 0.7.0"
  extends Modelica.Icons.ReleaseNotes;
  annotation(preferredView = "info", Documentation(info = "<html>
  <ul>
  <li>
  Updated library from Modelica_Fluid to Modelica.Fluid 1.0
  <li>
  Merged sensor and source models from Modelica.Fluid to Buildings.Fluid.
  </li>
  <li> Added sensor for sensible and latent enthalpy flow rate,
  <a href=\"modelica://Buildings.Fluid.Sensors.SensibleEnthalpyFlowRate\">
  Buildings.Fluid.Sensors.SensibleEnthalpyFlowRate</a> and
  <a href=\"modelica://Buildings.Fluid.Sensors.LatentEnthalpyFlowRate\">
  Buildings.Fluid.Sensors.LatentEnthalpyFlowRate</a>.
  These sensors are needed, for example, to interface air-conditioning
  systems that are modeled with Modelica with the Building Controls
  Virtual Test Bed.
  </li>
  </ul>
  </html>
  "));
end Version_0_7_0;