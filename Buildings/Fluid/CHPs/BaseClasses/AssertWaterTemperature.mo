within Buildings.Fluid.CHPs.BaseClasses;
model AssertWaterTemperature
  "Assert if water outlet temperature is outside boundaries"
  extends Modelica.Blocks.Icons.Block;

  parameter Modelica.Units.SI.Temperature TWatMax
    "Maximum cooling water temperature";
  parameter Modelica.Units.SI.TemperatureDifference THys=0.5
    "Hysteresis value to check temperature difference"
    annotation (Dialog(tab="Advanced"));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TWat(
    final unit="K",
    displayUnit="degC") "Water outlet temperature"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Utilities.Assert assMes(
    final message="Water temperature is higher than the maximum!")
    "Assert function for checking water temperature"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));

protected
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys(
    final uLow=TWatMax -THys,
    final uHigh=TWatMax + THys)
    "Check if water temperature is larger than the maximum temperature"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1
    "Check if water temperature is lower than the maximum temperature"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));

equation
  connect(hys.u, TWat)
    annotation (Line(points={{-42,0},{-120,0}}, color={0,0,127}));
  connect(hys.y, not1.u)
    annotation (Line(points={{-18,0},{18,0}}, color={255,0,255}));
  connect(not1.y, assMes.u)
    annotation (Line(points={{42,0},{58,0}}, color={255,0,255}));

annotation (
  defaultComponentName="assWatTem",
  Diagram(coordinateSystem(extent={{-100,-100},{100,100}})),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}}), graphics={
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{0,80},{-80,-60},{80,-60},{0,80}},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Polygon(
          points={{0,72},{-72,-56},{72,-56},{0,72}},
          lineColor={0,0,0},
          fillColor={255,255,170},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-4,38},{2,-24}},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Ellipse(
          extent={{-6,-32},{4,-42}},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid)}),
  Documentation(info="<html>
<p>
The model sends a warning message if the water outlet temperature is higher
than the maximum defined by the manufacturer.
</p>
</html>", revisions="<html>
<ul>
<li>
June 1, 2019, by Tea Zakula:<br/>
First implementation.
</li>
</ul>
</html>"));
end AssertWaterTemperature;
