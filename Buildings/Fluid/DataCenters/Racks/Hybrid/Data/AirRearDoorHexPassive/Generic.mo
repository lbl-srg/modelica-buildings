within Buildings.Fluid.DataCenters.Racks.Hybrid.Data.AirRearDoorHexPassive;
record Generic
  "Generic data record for air-cooled rack with passive rear door heat exchanger"
  extends Modelica.Icons.Record;

  parameter Buildings.Fluid.DataCenters.Racks.Air.Data.Generic air
    "Performance data for air-cooled component"
    annotation (Placement(transformation(extent={{20,20},{40,40}})));

  replaceable parameter Buildings.Fluid.DataCenters.Racks.RearDoorHeatExchangers.Data.Passive.Generic reaDooHex
    constrainedby Buildings.Fluid.DataCenters.Racks.RearDoorHeatExchangers.Data.Passive.Generic
    "Rear door heat exchanger performance data"
    annotation (Placement(transformation(extent={{60,20},{80,40}})));

annotation (
  defaultComponentName="dat",
  defaultComponentPrefixes="parameter",
  Documentation(info="<html>
<p>
Generic data record for air-cooled IT racks with a passive rear door heat exchanger.
</p>
<p>
This record contains two nested data records:
</p>
<ul>
<li>
<code>air</code>: Performance data for the air-cooled component, based on
<a href=\"modelica://Buildings.Fluid.DataCenters.Racks.Air.Data.Generic\">
Buildings.Fluid.DataCenters.Racks.Air.Data.Generic</a>
</li>
<li>
<code>reaDooHex</code>: Performance data for the rear door heat exchanger, based on
<a href=\"modelica://Buildings.Fluid.DataCenters.Racks.RearDoorHeatExchangers.Data.Passive.Generic\">
Buildings.Fluid.DataCenters.Racks.RearDoorHeatExchangers.Data.Passive.Generic</a>
</li>
</ul>
</html>",
    revisions="<html>
<ul>
<li>
September 29, 2026, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end Generic;
