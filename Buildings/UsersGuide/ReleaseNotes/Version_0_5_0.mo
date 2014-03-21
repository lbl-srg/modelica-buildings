within Buildings.UsersGuide.ReleaseNotes;

class Version_0_5_0 "Version 0.5.0"
  extends Modelica.Icons.ReleaseNotes;
  annotation(preferredView = "info", Documentation(info = "<html>
  <ul>
  <li>
  Updated library to Modelica.Fluid 1.0.
  </li>
  <li>
  Moved most examples from package <a href=\"modelica://Buildings.Fluid.Examples\">
  Buildings.Fluid.Examples</a> to the example directory in the package of the
  individual model.
  </li>
  <li>
  Renamed package <a href=\"modelica://Buildings.Utilites.Controls\">
  Buildings.Utilites.Controls</a> to 
  <a href=\"modelica://Buildings.Utilites.Diagnostics\">
  Buildings.Utilites.Diagnostics</a>.
  </li>
  <li>
  Introduced packages 
  <a href=\"modelica://Buildings.Controls\">Buildings.Controls</a>,
  <a href=\"modelica://Buildings.HeatTransfer\">Buildings.HeatTransfer</a>
  (which contains models for heat transfer that generally does not involve 
  modeling of the fluid flow),
  <a href=\"modelica://Buildings.Fluid.Boilers\">Buildings.Fluid.Boilers</a> and
  <a href=\"modelica://Buildings.Fluid.HeatExchangers.Radiators\">
  Buildings.Fluid.HeatExchangers.Radiators</a>.
  </li>
  <li>
  Changed valve models in <a href=\"modelica://Buildings.Fluid.Actuators.Valves\">
  Buildings.Fluid.Actuators.Valves</a> so that <code>Kv</code> or <code>Cv</code> can
  be used as the flow coefficient (in [m3/h] or [USG/min]).
  </li>
  </ul>
  </html>
  "));
end Version_0_5_0;