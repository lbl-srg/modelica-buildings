within Buildings.Fluid.DataCenters.Racks.Hybrid.Data.AirLiquidRearDoorHexActive;
record Generic
  "Generic data record for hybrid liquid-cooled single-phase and air-cooled rack with active rear door heat exchanger"
  extends Buildings.Fluid.DataCenters.Racks.Hybrid.Data.AirLiquid.Generic;

  parameter Buildings.Fluid.DataCenters.Racks.RearDoorHeatExchangers.Data.Active.Generic reaDooHex
    "Rear door heat exchanger performance data"
    annotation (Placement(transformation(extent={{60,20},{80,40}})));

annotation (
  defaultComponentName="dat",
  defaultComponentPrefixes="parameter",
  Documentation(info="<html>
<p>
Generic data record for hybrid IT racks that combine liquid-cooled single-phase,
air-cooled, and rear door heat exchanger components.
</p>
<p>
This record extends
<a href=\"modelica://Buildings.Fluid.DataCenters.Racks.Hybrid.Data.AirLiquid.Generic\">
Buildings.Fluid.DataCenters.Racks.Hybrid.Data.AirLiquid.Generic</a>
and adds a sub-record <code>reaDooHex</code> with performance data for the rear door
heat exchanger, based on
<a href=\"modelica://Buildings.Fluid.DataCenters.Racks.RearDoorHeatExchangers.Data.Active.Generic\">
Buildings.Fluid.DataCenters.Racks.RearDoorHeatExchangers.Data.Active.Generic</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
September 18, 2026, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end Generic;
