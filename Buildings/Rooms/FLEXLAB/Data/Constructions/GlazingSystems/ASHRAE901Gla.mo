within Buildings.Rooms.FLEXLAB.Data.Constructions.GlazingSystems;
record ASHRAE901Gla =
  Buildings.HeatTransfer.Data.GlazingSystems.Generic (
  final glass={Buildings.HeatTransfer.Data.Glasses.ID101(),
   Buildings.HeatTransfer.Data.Glasses.ID101()},
  final gas = {Buildings.HeatTransfer.Data.Gases.Air(x=0.0127)},
  UFra=1.4)
  "XGL-1 window constuction used in cells 3A, 3B and RA. ASHRAE 90.1 minimally compliant"
  annotation (
defaultComponentPrefixes="parameter",
defaultComponentName="datGlaSys",
Documentation(info="<html>
  <p>
  This is a model of a window construction used in FLEXLAB test cells. It is minimally
  compliant per the ASHRAE 90.1 specification.
  </p>
  <p>
  Note: This model is not yet completed, and is currently a placeholder. See
  <a href=\"modelica://Buildings.Rooms.FLEXLAB.UsersGuide\">
  Buildings.Rooms.FLEXLAB.UsersGuide</a> for more information.
  </p>
  </html>", revisions="<html>
<ul>
<li>
September 17, 2013, by Peter Grant:<br/>
First implementation.
</li>
</ul>
</html>"));
