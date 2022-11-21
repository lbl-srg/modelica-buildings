within Buildings.Obsolete.DistrictHeatingCooling.SubStations;
model Cooling "Cooling substation"
  extends
    Buildings.Obsolete.DistrictHeatingCooling.SubStations.BaseClasses.HeatingOrCooling(
    final m_flow_nominal = -Q_flow_nominal/cp_default/dTHex,
    mPum_flow(final k=-1/(cp_default*dTHex)));
  parameter Modelica.Units.SI.TemperatureDifference dTHex(
    min=0.5,
    displayUnit="K") = 4
    "Temperature difference over the heat exchanger (positive)"
    annotation (Dialog(group="Design parameter"));

  parameter Modelica.Units.SI.HeatFlowRate Q_flow_nominal(max=0)
    "Nominal heat flow rate added to medium (Q_flow_nominal <= 0)";

  Modelica.Blocks.Interfaces.RealInput Q_flow(
    max=0,
    final unit="W") "Heat flow rate extracted from system (Q_flow &le; 0)"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}})));

equation
  connect(Q_flow, mPum_flow.u) annotation (Line(points={{-120,60},{-80,60},{-80,
          40},{-62,40}}, color={0,0,127}));
  connect(Q_flow, hex.u) annotation (Line(points={{-120,60},{-64,60},{10,60},{
          10,6},{18,6}}, color={0,0,127}));

  annotation (
  defaultComponentName="subStaCoo",
 Icon(graphics={
      Rectangle(
          extent={{-64,38},{64,-70}},
          lineColor={150,150,150},
          fillPattern=FillPattern.Sphere,
          fillColor={0,0,255}),
      Rectangle(
        extent={{-42,-4},{-14,24}},
        lineColor={255,255,255},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
      Rectangle(
        extent={{16,-4},{44,24}},
        lineColor={255,255,255},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
      Rectangle(
        extent={{16,-54},{44,-26}},
        lineColor={255,255,255},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
      Rectangle(
        extent={{-42,-54},{-14,-26}},
        lineColor={255,255,255},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-106,70},{-62,50}},
          textColor={0,0,127},
          textString="Q")}),
    Documentation(info="<html>
<p>
Substation that adds a prescribed heat flow rate
to the water that flows through it.
The substation has a built-in pump that draws as
much water as needed to maintain the temperature difference
<code>dTHex</code>.
</p>
</html>", revisions="<html>
<ul>
<li>
March 7, 2022, by Michael Wetter:<br/>
Set <code>final massDynamics=energyDynamics</code>.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1542\">#1542</a>.
</li>
<li>
January 11, 2015, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end Cooling;
