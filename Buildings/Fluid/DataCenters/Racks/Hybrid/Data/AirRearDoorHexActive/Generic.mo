within Buildings.Fluid.DataCenters.Racks.Hybrid.Data.AirRearDoorHexActive;
record Generic
  "Generic data record for air-cooled rack with active rear door heat exchanger"
  extends Buildings.Fluid.DataCenters.Racks.Hybrid.Data.AirRearDoorHexPassive.Generic(
    redeclare replaceable parameter
      Buildings.Fluid.DataCenters.Racks.RearDoorHeatExchangers.Data.Active.Generic reaDooHex
      constrainedby Buildings.Fluid.DataCenters.Racks.RearDoorHeatExchangers.Data.Active.Generic);

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
November 26, 2026, by Michael Wetter:<br/>
Corrected <code>constrainedby</code> clause for <code>reaDooHex</code>
from <code>Data.Passive.Generic</code> to <code>Data.Active.Generic</code>
so that access to <code>PFan_nominal</code> and <code>eta_nominal</code>
is covered by the constraining type.
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/4926\">Buildings, #4926</a>.
</li>
<li>
September 29, 2026, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end Generic;
