within Buildings.Controls.OBC.ASHRAE.G36.AHUs.SingleZone.VAV.SetPoints.Validation;
model ReturnFan "Validation of return fan control"

  Buildings.Controls.OBC.ASHRAE.G36.AHUs.SingleZone.VAV.SetPoints.ReturnFan retFan
    "Cooling coil controller"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp supFanSpe(
    final height=0.7,
    final offset=0.2,
    final duration=3600) "Supply fan speed"
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse fanStatus(
    final period=3600)
    "Supply fan status"
    annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));
  Buildings.Controls.OBC.CDL.Continuous.Multiply mul
    "Fan speed should be zero when it is disabled"
    annotation (Placement(transformation(extent={{20,0},{40,20}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea
    "Boolean to real"
    annotation (Placement(transformation(extent={{-20,-40},{0,-20}})));

equation
  connect(fanStatus.y, retFan.u1SupFan) annotation (Line(points={{-58,-50},{52,
          -50},{52,-6},{58,-6}}, color={255,0,255}));
  connect(fanStatus.y, booToRea.u) annotation (Line(points={{-58,-50},{-40,-50},
          {-40,-30},{-22,-30}}, color={255,0,255}));
  connect(booToRea.y, mul.u2) annotation (Line(points={{2,-30},{10,-30},{10,4},{
          18,4}}, color={0,0,127}));
  connect(supFanSpe.y, mul.u1) annotation (Line(points={{-58,30},{0,30},{0,16},{
          18,16}}, color={0,0,127}));
  connect(mul.y, retFan.uSupFan_actual)
    annotation (Line(points={{42,10},{50,10},{50,6},{58,6}}, color={0,0,127}));

annotation (
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
    experiment(StopTime=3600, Tolerance=1e-06),
      __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/G36/AHUs/SingleZone/VAV/SetPoints/Validation/ReturnFan.mos"
    "Simulate and plot"),
Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.AHUs.SingleZone.VAV.SetPoints.ReturnFan\">
Buildings.Controls.OBC.ASHRAE.G36.AHUs.SingleZone.VAV.SetPoints.ReturnFan</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
February 8, 2022, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end ReturnFan;
