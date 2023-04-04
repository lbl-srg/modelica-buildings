within Buildings.Controls.OBC.ASHRAE.G36.ThermalZones.Validation;
model ControlLoops
  "Validation models of determining heating and coooling loop signal"
  Buildings.Controls.OBC.ASHRAE.G36.ThermalZones.ControlLoops conLoo
    "Heating and cooling loop"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TZonCooSetOcc(
    final k=297.15)
    "Occupied cooling setpoint"
    annotation (Placement(transformation(extent={{-60,30},{-40,50}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TZonHeaSetOcc(
    final k=293.15)
    "Occupied heating setpoint"
    annotation (Placement(transformation(extent={{-60,-50},{-40,-30}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine zonTem(
    final amplitude=8,
    final freqHz=1/7200,
    final offset=273.15 + 18) "Zone temperature"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));

equation
  connect(TZonCooSetOcc.y, conLoo.TCooSet) annotation (Line(points={{-38,40},{
          20,40},{20,6},{38,6}}, color={0,0,127}));
  connect(TZonHeaSetOcc.y, conLoo.THeaSet) annotation (Line(points={{-38,-40},{
          20,-40},{20,-6},{38,-6}}, color={0,0,127}));
  connect(zonTem.y, conLoo.TZon)
    annotation (Line(points={{-38,0},{38,0}}, color={0,0,127}));

annotation (experiment(StopTime=7200, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/G36/ThermalZones/Validation/ControlLoops.mos"
    "Simulate and plot"),
    Icon(coordinateSystem(preserveAspectRatio=false), graphics={Ellipse(
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
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.ThermalZones.ControlLoops\">
Buildings.Controls.OBC.ASHRAE.G36.ThermalZones.ControlLoops</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
February 2, 2022, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end ControlLoops;
