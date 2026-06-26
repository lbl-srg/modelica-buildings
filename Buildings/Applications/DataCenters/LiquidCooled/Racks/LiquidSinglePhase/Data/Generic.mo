within Buildings.Applications.DataCenters.LiquidCooled.Racks.LiquidSinglePhase.Data;
record Generic
  "Generic data record for liquid-cooled single-phase rack"
  extends Buildings.Applications.DataCenters.LiquidCooled.Racks.BaseClasses.Data.Generic(
    dp_nominal=50000,
    n=1.85);

  parameter BaseClasses.Generic_R_m_flow theRes "Thermal resistance data"
    annotation (Placement(transformation(extent={{60,60},{80,80}})));
annotation (
  defaultComponentName="dat",
  defaultComponentPrefixes="parameter",
  Documentation(info="<html>
<p>
Generic data record for liquid-cooled single-phase IT rack.
<p>
</html>", revisions="<html>
<ul>
<li>
June 26, 2026, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end Generic;
