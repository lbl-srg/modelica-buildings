within Buildings.Experimental.DistrictHeatingCooling.SubStations;
model Heating "Heating substation"
  extends
    Buildings.Experimental.DistrictHeatingCooling.SubStations.BaseClasses.HeatingOrCooling(
    final m_flow_nominal = -Q_flow_nominal/cp_default/dTHex,
    mPum_flow(final k=-1/(cp_default*dTHex)));

  parameter Modelica.SIunits.TemperatureDifference dTHex(
    max=-0.5,
    displayUnit="K") = -4
    "Temperature difference over the heat exchanger (negative)"
    annotation(Dialog(group="Design parameter"));

  parameter Modelica.SIunits.HeatFlowRate Q_flow_nominal(
    min=0) "Nominal heat flow rate added to medium (Q_flow_nominal > 0)";

  Modelica.Blocks.Interfaces.RealInput Q_flow(
    min=0,
    final unit="W") "Heat flow rate extracted from system (Q_flow >= 0)"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}})));

equation
  connect(Q_flow, mPum_flow.u) annotation (Line(points={{-120,60},{-80,60},{-80,
          40},{-62,40}}, color={0,0,127}));
  connect(Q_flow, hex.u) annotation (Line(points={{-120,60},{10,60},{10,6},{18,
          6}}, color={0,0,127}));
  annotation (
defaultComponentName="subStaHea",
 Documentation(info="<html>
<p>
Substation that removes a prescribed heat flow rate
from the water that flows through it.
The substation has a built-in pump that draws as
much water as needed to maintain the temperature difference
<code>dTHex</code>.
</p>
</html>", revisions="<html>
<ul>
<li>
January 11, 2015, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(graphics={Text(
          extent={{-106,70},{-62,50}},
          lineColor={0,0,127},
          textString="Q")}));
end Heating;
