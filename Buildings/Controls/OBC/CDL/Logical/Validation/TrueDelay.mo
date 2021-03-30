within Buildings.Controls.OBC.CDL.Logical.Validation;
model TrueDelay
  "Validation model for the TrueDelay block"
  Buildings.Controls.OBC.CDL.Logical.TrueDelay onDelay0(
    final delayTime=0)
    "Delay a rising edge of the input, but do not delay a falling edge."
    annotation (Placement(transformation(extent={{0,130},{20,150}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay onDelay1(
    final delayTime=0.5)
    "Delay a rising edge of the input, but do not delay a falling edge."
    annotation (Placement(transformation(extent={{60,130},{80,150}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay onDelay2(
    final delayTime=0.8)
    "Delay a rising edge of the input, but do not delay a falling edge."
    annotation (Placement(transformation(extent={{0,100},{20,120}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay onDelay4(
    final delayTime=0)
    "Delay a rising edge of the input, but do not delay a falling edge."
    annotation (Placement(transformation(extent={{0,40},{20,60}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay onDelay5(
    final delayTime=0.5)
    "Delay a rising edge of the input, but do not delay a falling edge."
    annotation (Placement(transformation(extent={{60,40},{80,60}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay onDelay6(
    final delayTime=0.8)
    "Delay a rising edge of the input, but do not delay a falling edge."
    annotation (Placement(transformation(extent={{0,10},{20,30}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1
    "Negation of input signal"
    annotation (Placement(transformation(extent={{-60,60},{-40,80}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay onDelay3(
    final delayTime=1.8)
    "Delay a rising edge of the input, but do not delay a falling edge."
    annotation (Placement(transformation(extent={{60,100},{80,120}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay onDelay7(
    final delayTime=1.8)
    "Delay a rising edge of the input, but do not delay a falling edge."
    annotation (Placement(transformation(extent={{60,10},{80,30}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay onDelay00(
    final delayTime=0,
    final delayOnInit=true)
    "Delay a rising edge of the input, but do not delay a falling edge."
    annotation (Placement(transformation(extent={{0,-50},{20,-30}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay onDelay11(
    final delayTime=0.5,
    final delayOnInit=true)
    "Delay a rising edge of the input, but do not delay a falling edge."
    annotation (Placement(transformation(extent={{60,-50},{80,-30}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay onDelay22(
    final delayTime=0.8,
    final delayOnInit=true)
    "Delay a rising edge of the input, but do not delay a falling edge."
    annotation (Placement(transformation(extent={{0,-80},{20,-60}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay onDelay44(
    final delayTime=0,
    final delayOnInit=true)
    "Delay a rising edge of the input, but do not delay a falling edge."
    annotation (Placement(transformation(extent={{0,-140},{20,-120}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay onDelay55(
    final delayTime=0.5,
    final delayOnInit=true)
    "Delay a rising edge of the input, but do not delay a falling edge."
    annotation (Placement(transformation(extent={{60,-140},{80,-120}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay onDelay66(
    final delayTime=0.8,
    final delayOnInit=true)
    "Delay a rising edge of the input, but do not delay a falling edge."
    annotation (Placement(transformation(extent={{0,-170},{20,-150}})));
  Buildings.Controls.OBC.CDL.Logical.Not not2
    "Negation of input signal"
    annotation (Placement(transformation(extent={{-60,-120},{-40,-100}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay onDelay33(
    final delayTime=1.8,
    final delayOnInit=true)
    "Delay a rising edge of the input, but do not delay a falling edge."
    annotation (Placement(transformation(extent={{60,-80},{80,-60}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay onDelay77(
    final delayTime=1.8,
    final delayOnInit=true)
    "Delay a rising edge of the input, but do not delay a falling edge."
    annotation (Placement(transformation(extent={{60,-170},{80,-150}})));

protected
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul(
    final width=0.5,
    final period=1.5)
    "Block that outputs cyclic on and off"
    annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul1(
    final width=0.5,
    final period=1.5)
    "Block that outputs cyclic on and off"
    annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));

equation
  connect(booPul.y,not1.u)
    annotation (Line(points={{-79,90},{-70,90},{-70,70},{-62,70}},color={255,0,255}));
  connect(booPul.y,onDelay0.u)
    annotation (Line(points={{-79,90},{-20,90},{-20,140},{-2,140}},color={255,0,255}));
  connect(booPul.y,onDelay2.u)
    annotation (Line(points={{-79,90},{-20,90},{-20,110},{-2,110}},color={255,0,255}));
  connect(booPul.y,onDelay1.u)
    annotation (Line(points={{-79,90},{40,90},{40,140},{58,140}},color={255,0,255}));
  connect(booPul.y,onDelay3.u)
    annotation (Line(points={{-79,90},{40,90},{40,110},{58,110}},color={255,0,255}));
  connect(not1.y,onDelay4.u)
    annotation (Line(points={{-39,70},{-20,70},{-20,50},{-2,50}},color={255,0,255}));
  connect(not1.y,onDelay6.u)
    annotation (Line(points={{-39,70},{-20,70},{-20,20},{-2,20}},color={255,0,255}));
  connect(not1.y,onDelay5.u)
    annotation (Line(points={{-39,70},{40,70},{40,50},{58,50}},color={255,0,255}));
  connect(not1.y,onDelay7.u)
    annotation (Line(points={{-39,70},{40,70},{40,20},{58,20}},color={255,0,255}));
  connect(booPul1.y,not2.u)
    annotation (Line(points={{-79,-90},{-70,-90},{-70,-110},{-62,-110}},color={255,0,255}));
  connect(booPul1.y,onDelay00.u)
    annotation (Line(points={{-79,-90},{-20,-90},{-20,-40},{-2,-40}},color={255,0,255}));
  connect(booPul1.y,onDelay22.u)
    annotation (Line(points={{-79,-90},{-20,-90},{-20,-70},{-2,-70}},color={255,0,255}));
  connect(booPul1.y,onDelay11.u)
    annotation (Line(points={{-79,-90},{40,-90},{40,-40},{58,-40}},color={255,0,255}));
  connect(booPul1.y,onDelay33.u)
    annotation (Line(points={{-79,-90},{40,-90},{40,-70},{58,-70}},color={255,0,255}));
  connect(not2.y,onDelay44.u)
    annotation (Line(points={{-39,-110},{-20,-110},{-20,-130},{-2,-130}},color={255,0,255}));
  connect(not2.y,onDelay66.u)
    annotation (Line(points={{-39,-110},{-20,-110},{-20,-160},{-2,-160}},color={255,0,255}));
  connect(not2.y,onDelay55.u)
    annotation (Line(points={{-39,-110},{40,-110},{40,-130},{58,-130}},color={255,0,255}));
  connect(not2.y,onDelay77.u)
    annotation (Line(points={{-39,-110},{40,-110},{40,-160},{58,-160}},color={255,0,255}));
  annotation (
    experiment(
      StopTime=5.0,
      Tolerance=1e-06),
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/CDL/Logical/Validation/TrueDelay.mos" "Simulate and plot"),
    Documentation(
      info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Controls.OBC.CDL.Logical.TrueDelay\">
Buildings.Controls.OBC.CDL.Logical.TrueDelay</a>.
</p>
</html>",
      revisions="<html>
<ul>
<li>
February 11, 2019, by Milica Grahovac:<br/>
Added tests for initial true input delay.
</li>
<li>
April 2, 2017, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(
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
    Diagram(
      coordinateSystem(
        extent={{-100,-180},{100,180}})));
end TrueDelay;
