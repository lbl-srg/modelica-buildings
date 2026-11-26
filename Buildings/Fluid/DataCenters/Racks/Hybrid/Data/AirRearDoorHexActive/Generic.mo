within Buildings.Fluid.DataCenters.Racks.Hybrid.Data.AirRearDoorHexActive;
record Generic
  "Generic data record for air-cooled rack with active rear door heat exchanger"
  extends Buildings.Fluid.DataCenters.Racks.Hybrid.Data.AirRearDoorHexPassive.Generic(
    redeclare replaceable parameter
      Buildings.Fluid.DataCenters.Racks.RearDoorHeatExchangers.Data.Active.Generic reaDooHex
      constrainedby Buildings.Fluid.DataCenters.Racks.RearDoorHeatExchangers.Data.Passive.Generic);

  final parameter Modelica.Units.SI.Power PFan_nominal(final min=0) = reaDooHex.PFan_nominal
    "Fan power at full speed";

  final parameter Real eta_nominal(
    final unit="1",
    final min=Modelica.Constants.small) = reaDooHex.eta_nominal
    "Fan and motor combined efficiency at nominal conditions";

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
Added <code>PFan_nominal</code> and <code>eta_nominal</code> as final parameters
so that they can be accessed without going through the constraining type of
<code>reaDooHex</code>.
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
