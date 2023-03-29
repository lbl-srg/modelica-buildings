within Buildings.Controls.OBC.CDL.Continuous.Validation;
model Ramp "Validation model for the Ramp block"

  Buildings.Controls.OBC.CDL.Continuous.Ramp ramUp(
    final raisingSlewRate=1/20)
    "Ramp the input increasing"
    annotation (Placement(transformation(extent={{-40,70},{-20,90}})));
  Buildings.Controls.OBC.CDL.Continuous.Ramp ramUp1(
    final raisingSlewRate=1/10)
    "Ramp the input increasing in different speed"
    annotation (Placement(transformation(extent={{-40,10},{-20,30}})));
  Buildings.Controls.OBC.CDL.Continuous.Ramp ramUpDow(
    final raisingSlewRate=1/5)
    "Limit the increase and decrease of the input if the active is true"
    annotation (Placement(transformation(extent={{-40,-70},{-20,-50}})));
  Buildings.Controls.OBC.CDL.Continuous.Ramp ramUpDow1(final
      raisingSlewRate=1/5, final fallingSlewRate=-1/2)
    "Different increase and decrease slew rate limits"
    annotation (Placement(transformation(extent={{80,-10},{100,10}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul1(
    final width=0.9,
    final period=12,
    final shift=1) "Boolean pulse"
    annotation (Placement(transformation(extent={{-100,20},{-80,40}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Pulse pul(
    final width=0.8,
    final period=12.0,
    final shift=2.0)
                   "Boolean pulse"
    annotation (Placement(transformation(extent={{-100,70},{-80,90}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul2(
    final width=0.9,
    final period=12,
    final shift=2) "Boolean pulse"
    annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Pulse pul1(
    final width=0.2,
    final period=12.0,
    final shift=1.5) "Boolean pulse"
    annotation (Placement(transformation(extent={{-100,-40},{-80,-20}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Pulse pul2(
    final width=0.3,
    final period=12.0,
    final shift=3.0)
    "Boolean pulse"
    annotation (Placement(transformation(extent={{20,20},{40,40}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul5(
    final width=0.9,
    final period=12,
    final shift=1) "Boolean pulse"
    annotation (Placement(transformation(extent={{20,-40},{40,-20}})));
equation
  connect(booPul2.y, ramUpDow.active) annotation (Line(points={{-78,-90},{-60,-90},
          {-60,-68},{-42,-68}}, color={255,0,255}));
  connect(booPul5.y, ramUpDow1.active) annotation (Line(points={{42,-30},{70,
          -30},{70,-8},{78,-8}},
                            color={255,0,255}));
  connect(pul.y, ramUp.u) annotation (Line(points={{-78,80},{-60,80},{-60,80},{-42,
          80}},     color={0,0,127}));
  connect(pul.y, ramUp1.u) annotation (Line(points={{-78,80},{-60,80},{-60,20},{
          -42,20}},  color={0,0,127}));
  connect(booPul1.y, ramUp.active) annotation (Line(points={{-78,30},{-70,30},{-70,
          72},{-42,72}},     color={255,0,255}));
  connect(booPul1.y, ramUp1.active) annotation (Line(points={{-78,30},{-70,30},{
          -70,12},{-42,12}},  color={255,0,255}));
  connect(pul1.y, ramUpDow.u) annotation (Line(points={{-78,-30},{-60,-30},{-60,
          -60},{-42,-60}}, color={0,0,127}));
  connect(pul2.y, ramUpDow1.u)
    annotation (Line(points={{42,30},{70,30},{70,0},{78,0}}, color={0,0,127}));
  annotation (
    experiment(
      StopTime=10.0,
      Tolerance=1e-06),
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/CDL/Continuous/Validation/Ramp.mos" "Simulate and plot"),
    Documentation(
      info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Controls.OBC.CDL.Continuous.Ramp\">
Buildings.Controls.OBC.CDL.Continuous.Ramp</a>.
</p>
<ul>
<li>
The instances <code>ramUp</code> and <code>ramUp1</code> shows ramping up the
input in different speed.
</li>
<li>
The instance <code>ramUpDow</code> shows ramping up and down the input in
the same speed. It also shows that the output will be the ramped input if
the boolean input <code>active</code> is <code>true</code>.
</li>
<li>
The instance <code>ramUpDow1</code> shows ramping up and down the input in
the different speed.
</li>
</ul>
</html>",
revisions="<html>
<ul>
<li>
November 16, 2022, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}}),
      graphics={
        Ellipse(
          lineColor={75,138,73},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          extent={{-100,-100},{100,100}}),
        Polygon(
          lineColor={0,0,255},
          fillColor={75,138,73},
          pattern=LinePattern.None,
          fillPattern=FillPattern.Solid,
          points={{-36,60},{64,0},{-36,-60},{-36,60}})}),
    Diagram(coordinateSystem(extent={{-120,-140},{120,140}})));
end Ramp;
