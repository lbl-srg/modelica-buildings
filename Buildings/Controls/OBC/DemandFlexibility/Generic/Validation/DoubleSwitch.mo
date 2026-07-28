within Buildings.Controls.OBC.DemandFlexibility.Generic.Validation;
model DoubleSwitch "Double switch"

  Buildings.Controls.OBC.DemandFlexibility.Generic.DoubleSwitch douSwi
    annotation (Placement(transformation(extent={{20,0},{40,20}})));
  CDL.Reals.Sources.Sin sin(
    amplitude=1,
    freqHz=1/30,
    offset=5)
    annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
  CDL.Reals.Sources.Sin sin1(
    amplitude=2,
    freqHz=1/15,
    offset=-5)
    annotation (Placement(transformation(extent={{-60,-80},{-40,-60}})));
  CDL.Logical.Sources.Pulse uEnaVar(period=60)
    "Boolean variable to enable setpoint change when true"
    annotation (Placement(transformation(extent={{-60,-20},{-40,0}})));
equation
  connect(uEnaVar.y, douSwi.u2) annotation (Line(points={{-38,-10},{-20,-10},{-20,
          10},{18,10}}, color={255,0,255}));
  connect(sin.y, douSwi.u1) annotation (Line(points={{-38,50},{0,50},{0,16},{18,
          16}}, color={0,0,127}));
  connect(sin1.y, douSwi.u3) annotation (Line(points={{-38,-70},{0,-70},{0,4},{18,
          4}}, color={0,0,127}));
annotation (experiment(StopTime=60, Interval=1, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/DemandFlexibility/Generic/Validation/SetpointResolution.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.DemandFlexibility.Generic.SetpointResolution\">
Buildings.Controls.OBC.DemandFlexibility.Generic.SetpointResolution</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
June 10, 2026, by Weiping Huang:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(coordinateSystem(preserveAspectRatio=false,extent={{-100,-100},{100,100}}),
        graphics={
        Ellipse(lineColor = {75,138,73},
                fillColor={255,255,255},
                fillPattern = FillPattern.Solid,
                extent = {{-100,-100},{100,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points = {{-36,60},{64,0},{-36,-60},{-36,60}})}),
    Diagram(coordinateSystem(preserveAspectRatio=false,
      extent={{-100,-100},{100,100}})));
end DoubleSwitch;
