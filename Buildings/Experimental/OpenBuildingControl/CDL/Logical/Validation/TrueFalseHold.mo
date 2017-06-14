within Buildings.Experimental.OpenBuildingControl.CDL.Logical.Validation;
model TrueFalseHold "Validation model for the TrueFalseHold block"
extends Modelica.Icons.Example;

  Sources.BooleanPulse booPul(
    startTime=0,
    period=1500)
    "Boolean pulse input signal"
    annotation (Placement(transformation(extent={{-140,60},{-120,80}})));
  Logical.TrueFalseHold truFalHol(holdDuration=1000)
    "The block introduces a minimal offset between the input signal rising and falling edge"
    annotation (Placement(transformation(extent={{-40,60},{-20,80}})));
  Sources.BooleanPulse booPul1(
    startTime=0,
    period=1000,
    width=0.25)
    "Boolean pulse input signal"
    annotation (Placement(transformation(extent={{-140,20},{-120,40}})));
  Logical.TrueFalseHold truFalHol1(holdDuration=1000)
    "The block introduces a minimal offset between the input signal rising and falling edge"
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));
  Sources.BooleanPulse booPul2(
    startTime=0,
    period=1500)
    "Boolean pulse input signal"
    annotation (Placement(transformation(extent={{-140,-20},{-120,0}})));
  Logical.TrueFalseHold truFalHol2(holdDuration=1000)
    "The block introduces a minimal offset between the input signal rising and falling edge"
    annotation (Placement(transformation(extent={{-40,-20},{-20,0}})));
  Sources.BooleanPulse booPul3(
    startTime=0,
    period=1000,
    width=0.25)
    "Boolean pulse input signal"
    annotation (Placement(transformation(extent={{-140,-60},{-120,-40}})));
  Logical.TrueFalseHold truFalHol3(holdDuration=1000)
    "The block introduces a minimal offset between the input signal rising and falling edge"
    annotation (Placement(transformation(extent={{-40,-60},{-20,-40}})));
  Logical.Not not1 "Negation of input signal"
    annotation (Placement(transformation(extent={{-90,-20},{-70,0}})));
  Logical.Not not3 "Negation of input signal"
    annotation (Placement(transformation(extent={{-90,-60},{-70,-40}})));
  Sources.BooleanPulse booPul4(
    startTime=100,
    period=1500)
    "Boolean pulse input signal"
    annotation (Placement(transformation(extent={{20,60},{40,80}})));
  Logical.TrueFalseHold truFalHol4(holdDuration=1000)
    "The block introduces a minimal offset between the input signal rising and falling edge"
    annotation (Placement(transformation(extent={{120,60},{140,80}})));
  Sources.BooleanPulse booPul5(
    startTime=100,
    period=1000,
    width=0.25)
    "Boolean pulse input signal"
    annotation (Placement(transformation(extent={{20,20},{40,40}})));
  Logical.TrueFalseHold truFalHol5(holdDuration=1000)
    "The block introduces a minimal offset between the input signal rising and falling edge"
    annotation (Placement(transformation(extent={{120,20},{140,40}})));
  Sources.BooleanPulse booPul6(
    startTime=100,
    period=1500)
    "Boolean pulse input signal"
    annotation (Placement(transformation(extent={{20,-20},{40,0}})));
  Logical.TrueFalseHold truFalHol6(holdDuration=1000)
    "The block introduces a minimal offset between the input signal rising and falling edge"
    annotation (Placement(transformation(extent={{120,-20},{140,0}})));
  Sources.BooleanPulse booPul7(
    startTime=100,
    period=1000,
    width=0.25)
    "Boolean pulse input signal"
    annotation (Placement(transformation(extent={{20,-60},{40,-40}})));
  Logical.TrueFalseHold truFalHol7(holdDuration=1000)
    "The block introduces a minimal offset between the input signal rising and falling edge"
    annotation (Placement(transformation(extent={{120,-60},{140,-40}})));
  Logical.Not not2 "Negation of input signal"
    annotation (Placement(transformation(extent={{70,-20},{90,0}})));
  Logical.Not not4 "Negation of input signal"
    annotation (Placement(transformation(extent={{70,-60},{90,-40}})));
equation
  connect(booPul.y, truFalHol.u)
    annotation (Line(points={{-119,70},{-41.2,70}},   color={255,0,255}));
  connect(booPul1.y, truFalHol1.u)
    annotation (Line(points={{-119,30},{-41.2,30}}, color={255,0,255}));
  connect(booPul2.y, not1.u)
    annotation (Line(points={{-119,-10},{-92,-10}}, color={255,0,255}));
  connect(not1.y, truFalHol2.u)
    annotation (Line(points={{-69,-10},{-41.2,-10}}, color={255,0,255}));
  connect(booPul3.y, not3.u)
    annotation (Line(points={{-119,-50},{-92,-50}}, color={255,0,255}));
  connect(not3.y, truFalHol3.u)
    annotation (Line(points={{-69,-50},{-41.2,-50}}, color={255,0,255}));
  connect(booPul4.y, truFalHol4.u)
    annotation (Line(points={{41,70},{118.8,70}}, color={255,0,255}));
  connect(booPul5.y, truFalHol5.u)
    annotation (Line(points={{41,30},{118.8,30}}, color={255,0,255}));
  connect(booPul6.y, not2.u)
    annotation (Line(points={{41,-10},{68,-10}}, color={255,0,255}));
  connect(not2.y, truFalHol6.u)
    annotation (Line(points={{91,-10},{118.8,-10}}, color={255,0,255}));
  connect(booPul7.y, not4.u)
    annotation (Line(points={{41,-50},{68,-50}}, color={255,0,255}));
  connect(not4.y, truFalHol7.u)
    annotation (Line(points={{91,-50},{118.8,-50}}, color={255,0,255}));
  annotation (
  experiment(StopTime=7200.0, Tolerance=1e-06),
  __Dymola_Commands(
  file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/OpenBuildingControl/CDL/Logical/Validation/TrueFalseHold.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Experimental.OpenBuildingControl.CDL.Logical.TrueFalseHold\">
Buildings.Experimental.OpenBuildingControl.CDL.Logical.TrueFalseHold</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
May 24, 2017, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(extent={{-160,-100},{160,100}})));
end TrueFalseHold;
