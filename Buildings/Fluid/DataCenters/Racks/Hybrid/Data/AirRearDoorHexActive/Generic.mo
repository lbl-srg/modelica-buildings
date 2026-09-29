within Buildings.Fluid.DataCenters.Racks.Hybrid.Data.AirRearDoorHexActive;
record Generic
  "Generic data record for air-cooled rack with active rear door heat exchanger"
  extends Buildings.Fluid.DataCenters.Racks.Hybrid.Data.AirRearDoorHexPassive.Generic(
    redeclare replaceable parameter
      Buildings.Fluid.DataCenters.Racks.RearDoorHeatExchangers.Data.Active.Generic reaDooHex
      constrainedby Buildings.Fluid.DataCenters.Racks.RearDoorHeatExchangers.Data.Passive.Generic
      annotation (Placement(transformation(extent={{60,20},{80,40}}))));

annotation (
  defaultComponentName="dat",
  defaultComponentPrefixes="parameter",
  Documentation(info="<html>
<p>
Generic data record for air-cooled IT racks with an active rear door heat exchanger.
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
<a href=\"modelica://Buildings.Fluid.DataCenters.Racks.RearDoorHeatExchangers.Data.Active.Generic\">
Buildings.Fluid.DataCenters.Racks.RearDoorHeatExchangers.Data.Active.Generic</a>
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
