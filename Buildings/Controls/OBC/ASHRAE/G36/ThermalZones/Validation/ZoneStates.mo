within Buildings.Controls.OBC.ASHRAE.G36.ThermalZones.Validation;
model ZoneStates "Validation models of determining zone state"
  Buildings.Controls.OBC.ASHRAE.G36.ThermalZones.ZoneStates zonSta "Zone state"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Pulse uCoo(
    final period=2,
    final shift=1,
    final offset=0,
    final amplitude=1) "Cooling control signal"
    annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Pulse uHea(
    final period=2,
    final shift=2,
    final offset=0,
    final amplitude=1) "Heating control signal"
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));

equation
  connect(uHea.y, zonSta.uHea) annotation (Line(points={{-58,30},{-50,30},{-50,
          4},{-2,4}},     color={0,0,127}));
  connect(uCoo.y, zonSta.uCoo) annotation (Line(points={{-58,-30},{-50,-30},{
          -50,-4},{-2,-4}}, color={0,0,127}));

annotation (experiment(StopTime=3, Interval=300, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/G36/ThermalZones/Validation/ZoneStates.mos"
    "Simulate and plot"),
    Icon(coordinateSystem(preserveAspectRatio=false), graphics={
                   Ellipse(
          lineColor={75,138,73},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          extent={{-100,-100},{100,100}}), Polygon(
          lineColor={0,0,255},
          fillColor={75,138,73},
          pattern=LinePattern.None,
          fillPattern=FillPattern.Solid,
          points={{-36,58},{64,-2},{-36,-62},{-36,58}})}),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.ThermalZones.ZoneStates\">
Buildings.Controls.OBC.ASHRAE.G36.ThermalZones.ZoneStates</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
October 24, 2018, by David Blum:<br/>
First implementation.
</li>
</ul>
</html>"));
end ZoneStates;
