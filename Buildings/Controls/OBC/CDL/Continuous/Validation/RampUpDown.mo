within Buildings.Controls.OBC.CDL.Continuous.Validation;
model RampUpDown
    "Validation model for the RampUpDown block"

  Buildings.Controls.OBC.CDL.Continuous.RampUpDown ramUp(raisingSlewRate=1/30)
    "Ramp up when the active input becomes true later than the changes of the real input"
    annotation (Placement(transformation(extent={{-40,70},{-20,90}})));
  Buildings.Controls.OBC.CDL.Continuous.RampUpDown ramUp1(raisingSlewRate=1/50)
    "Ramp up when the real input changes later than active input"
    annotation (Placement(transformation(extent={{-40,10},{-20,30}})));
  Buildings.Controls.OBC.CDL.Continuous.RampUpDown ramUpDow(raisingSlewRate=1/5)
    "Limit the increase and decrease of the input"
    annotation (Placement(transformation(extent={{-40,-70},{-20,-50}})));
  Buildings.Controls.OBC.CDL.Continuous.RampUpDown ramDow(raisingSlewRate=1/30,
      Td=0.001)
    "Ramp down from initial moment"
    annotation (Placement(transformation(extent={{80,50},{100,70}})));
  Buildings.Controls.OBC.CDL.Continuous.RampUpDown ramDowUp(raisingSlewRate=1/
        30, fallingSlewRate=1/50)
    "Different increase and decrease slew rate limits"
    annotation (Placement(transformation(extent={{80,-70},{100,-50}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul1(
    final width=0.9,
    final period=12,
    final shift=1) "Boolean pulse"
    annotation (Placement(transformation(extent={{-100,20},{-80,40}})));
  Sources.Pulse                                    pul(
    final width=0.8,
    final period=12,
    final shift=2) "Boolean pulse"
    annotation (Placement(transformation(extent={{-100,70},{-80,90}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul2(
    final width=0.9,
    final period=12,
    final shift=1) "Boolean pulse"
    annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));
  Sources.Pulse                                    pul1(
    final width=0.2,
    final period=12,
    final shift=1.5) "Boolean pulse"
    annotation (Placement(transformation(extent={{-100,-40},{-80,-20}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con(
    final k=true)
    "Boolean true"
    annotation (Placement(transformation(extent={{20,10},{40,30}})));
  Sources.Pulse                                    pul2(
    final width=0.3,
    final period=12,
    final shift=3)
    "Boolean pulse"
    annotation (Placement(transformation(extent={{20,-40},{40,-20}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul5(
    final width=0.9,
    final period=12,
    final shift=1) "Boolean pulse"
    annotation (Placement(transformation(extent={{20,-100},{40,-80}})));
  Sources.Pulse                                    pul3(
    final width=0.3,
    final period=12,
    final shift=3)
    "Boolean pulse"
    annotation (Placement(transformation(extent={{20,70},{40,90}})));
equation
  connect(booPul2.y, ramUpDow.active) annotation (Line(points={{-78,-90},{-60,-90},
          {-60,-66},{-42,-66}}, color={255,0,255}));
  connect(con.y, ramDow.active) annotation (Line(points={{42,20},{60,20},{60,54},
          {78,54}}, color={255,0,255}));
  connect(booPul5.y, ramDowUp.active) annotation (Line(points={{42,-90},{60,-90},
          {60,-66},{78,-66}}, color={255,0,255}));
  connect(pul.y, ramUp.u) annotation (Line(points={{-78,80},{-60,80},{-60,86},{
          -42,86}}, color={0,0,127}));
  connect(pul.y, ramUp1.u) annotation (Line(points={{-78,80},{-60,80},{-60,26},
          {-42,26}}, color={0,0,127}));
  connect(booPul1.y, ramUp.active) annotation (Line(points={{-78,30},{-70,30},{
          -70,74},{-42,74}}, color={255,0,255}));
  connect(booPul1.y, ramUp1.active) annotation (Line(points={{-78,30},{-70,30},
          {-70,14},{-42,14}}, color={255,0,255}));
  connect(pul1.y, ramUpDow.u) annotation (Line(points={{-78,-30},{-60,-30},{-60,
          -54},{-42,-54}}, color={0,0,127}));
  connect(pul2.y, ramDowUp.u) annotation (Line(points={{42,-30},{60,-30},{60,
          -54},{78,-54}}, color={0,0,127}));
  connect(pul3.y, ramDow.u) annotation (Line(points={{42,80},{60,80},{60,66},{
          78,66}}, color={0,0,127}));
  annotation (
    experiment(
      StopTime=10.0,
      Tolerance=1e-06),
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/CDL/Continuous/Validation/RampUpDown.mos" "Simulate and plot"),
    Documentation(
      info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Controls.OBC.CDL.Continuous.RampUpDown\">
Buildings.Controls.OBC.CDL.Continuous.RampUpDown</a>.
</p>
<ul>
<li>
The instances <code>ramUp</code>, <code>ramUp1</code> and <code>ramUp2</code>
show how to ramp up the outputs when giving different <code>ramp</code> and
<code>activate</code> inputs. It shows when to ramp up the output in different
scenarios.
</li>
<li>
The instance <code>ramDow</code> shows how to ramp down the output when
setting a non-zero initial output and activating the ramp down at the
initial moment.
</li>
<li>
The instances <code>ramUpDown</code> and <code>ramDowUp</code> shows how
to ramp the output when the ramping inputs changes from up to down,
and from down to up.
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
end RampUpDown;
