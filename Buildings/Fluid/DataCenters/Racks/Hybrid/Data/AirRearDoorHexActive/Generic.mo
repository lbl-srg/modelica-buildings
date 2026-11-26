within Buildings.Fluid.DataCenters.Racks.Hybrid.Data.AirRearDoorHexActive;
record Generic
  "Generic data record for air-cooled rack with active rear door heat exchanger"
  extends Buildings.Fluid.DataCenters.Racks.Hybrid.Data.AirRearDoorHexPassive.Generic(
    redeclare replaceable parameter
      Buildings.Fluid.DataCenters.Racks.RearDoorHeatExchangers.Data.Active.Generic reaDooHex
      constrainedby Buildings.Fluid.DataCenters.Racks.RearDoorHeatExchangers.Data.Passive.Generic);

  parameter Modelica.Units.SI.Power PFan_nominal(final min=0)=
    reaDooHex.mAir_flow_nominal*reaDooHex.dpAir_nominal/eta_nominal/Buildings.Media.Air.dStp
    "Fan power at full speed"
    annotation (Dialog(group="Rear door heat exchanger fan"));

  parameter Real eta_nominal(
    final unit="1",
    final min=Modelica.Constants.small) = 0.7
    "Fan and motor combined efficiency at nominal conditions"
    annotation (Dialog(group="Rear door heat exchanger fan"));

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
<p><b>Notes</b></p>
<p>
The parameters <code>PFan_nominal</code> and <code>eta_nominal</code> are declared at
the top level of this record because <code>reaDooHex</code> has the constraining type
<a href=\"modelica://Buildings.Fluid.DataCenters.Racks.RearDoorHeatExchangers.Data.Passive.Generic\">
Buildings.Fluid.DataCenters.Racks.RearDoorHeatExchangers.Data.Passive.Generic</a>.
In Buildings version 15.0.0, the constraining type of <code>reaDooHex</code> will be changed to
<a href=\"modelica://Buildings.Fluid.DataCenters.Racks.RearDoorHeatExchangers.Data.Active.Generic\">
Buildings.Fluid.DataCenters.Racks.RearDoorHeatExchangers.Data.Active.Generic</a>,
and the top-level parameters <code>PFan_nominal</code> and <code>eta_nominal</code> will be
removed in favor of <code>reaDooHex.PFan_nominal</code> and <code>reaDooHex.eta_nominal</code>.
</p>
</html>",
    revisions="<html>
<ul>
<li>
November 26, 2026, by Michael Wetter:<br/>
Added optional parameters <code>PFan_nominal</code> and <code>eta_nominal</code>
so that the rear door heat exchanger fan can be configured without accessing
parameters outside the constraining type of <code>reaDooHex</code>.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/4926\">Buildings, #4926</a>.
</li>
<li>
September 29, 2026, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end Generic;
