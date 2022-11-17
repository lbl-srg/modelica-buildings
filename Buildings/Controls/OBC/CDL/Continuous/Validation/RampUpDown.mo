within Buildings.Controls.OBC.CDL.Continuous.Validation;
model RampUpDown
    "Validation model for the RampUpDown block"

  Buildings.Controls.OBC.CDL.Continuous.RampUpDown ramUp(
    final upDuration=5)
    "Ramp up when the activate input becomes true later than ramping input"
    annotation (Placement(transformation(extent={{-40,70},{-20,90}})));
  Buildings.Controls.OBC.CDL.Continuous.RampUpDown ramUp1(
    final upDuration=5)
    "Ramp up when the ramping input becomes true later than activate input"
    annotation (Placement(transformation(extent={{-40,10},{-20,30}})));
  Buildings.Controls.OBC.CDL.Continuous.RampUpDown ramUpDow(
    final upDuration=5)
    "Ramp up and then down"
    annotation (Placement(transformation(extent={{-40,-70},{-20,-50}})));
  Buildings.Controls.OBC.CDL.Continuous.RampUpDown ramUp2(
    final upDuration=5)
    "Ramp up from initial moment"
    annotation (Placement(transformation(extent={{80,70},{100,90}})));
  Buildings.Controls.OBC.CDL.Continuous.RampUpDown ramDow(
    final upDuration=5,
    final y_start=0.5)
    "Ramp down from initial moment"
    annotation (Placement(transformation(extent={{80,10},{100,30}})));
  Buildings.Controls.OBC.CDL.Continuous.RampUpDown ramDowUp(
    final upDuration=5,
    final y_start=1)
    "Ramp down from initial moment and then ram up"
    annotation (Placement(transformation(extent={{80,-70},{100,-50}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul1(
    final width=0.9,
    final period=12,
    final shift=1) "Boolean pulse"
    annotation (Placement(transformation(extent={{-100,90},{-80,110}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul(
    final width=0.8,
    final period=12,
    final shift=2) "Boolean pulse"
    annotation (Placement(transformation(extent={{-100,50},{-80,70}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul2(
    final width=0.9,
    final period=12,
    final shift=1) "Boolean pulse"
    annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul3(
    final width=0.2,
    final period=12,
    final shift=1.5) "Boolean pulse"
    annotation (Placement(transformation(extent={{-100,-40},{-80,-20}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con(
    final k=true)
    "Boolean true"
    annotation (Placement(transformation(extent={{20,90},{40,110}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con1(
    final k=false)
    "Boolean false"
    annotation (Placement(transformation(extent={{20,30},{40,50}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con2(
    final k=true)
    "Boolean true"
    annotation (Placement(transformation(extent={{20,-100},{40,-80}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul4(
    final width=0.3,
    final period=12,
    final shift=3)
    "Boolean pulse"
    annotation (Placement(transformation(extent={{20,-40},{40,-20}})));

equation
  connect(booPul1.y, ramUp.ramp) annotation (Line(points={{-78,100},{-70,100},{-70,
          86},{-42,86}}, color={255,0,255}));
  connect(booPul.y, ramUp.activate) annotation (Line(points={{-78,60},{-60,60},{
          -60,74},{-42,74}}, color={255,0,255}));
  connect(booPul1.y, ramUp1.activate) annotation (Line(points={{-78,100},{-70,100},
          {-70,14},{-42,14}}, color={255,0,255}));
  connect(booPul.y, ramUp1.ramp) annotation (Line(points={{-78,60},{-60,60},{-60,
          26},{-42,26}}, color={255,0,255}));
  connect(booPul2.y, ramUpDow.activate) annotation (Line(points={{-78,-90},{-60,
          -90},{-60,-66},{-42,-66}}, color={255,0,255}));
  connect(booPul3.y, ramUpDow.ramp) annotation (Line(points={{-78,-30},{-60,-30},
          {-60,-54},{-42,-54}},color={255,0,255}));
  connect(con.y, ramUp2.ramp) annotation (Line(points={{42,100},{60,100},{60,86},
          {78,86}}, color={255,0,255}));
  connect(con.y, ramUp2.activate) annotation (Line(points={{42,100},{60,100},{60,
          74},{78,74}}, color={255,0,255}));
  connect(con.y, ramDow.activate) annotation (Line(points={{42,100},{60,100},{60,
          14},{78,14}}, color={255,0,255}));
  connect(con1.y, ramDow.ramp) annotation (Line(points={{42,40},{70,40},{70,26},
          {78,26}}, color={255,0,255}));
  connect(con2.y, ramDowUp.activate) annotation (Line(points={{42,-90},{60,-90},
          {60,-66},{78,-66}}, color={255,0,255}));
  connect(booPul4.y, ramDowUp.ramp) annotation (Line(points={{42,-30},{60,-30},{
          60,-54},{78,-54}}, color={255,0,255}));
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
