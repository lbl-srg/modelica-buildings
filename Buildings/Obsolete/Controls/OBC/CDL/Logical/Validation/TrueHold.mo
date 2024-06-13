within Buildings.Controls.OBC.CDL.Logical.Validation;
model TrueHold
  "Validation model for the TrueHold block"
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul(
    period=9000,
    shift=300)
    "Boolean pulse input signal"
    annotation (Placement(transformation(extent={{-40,70},{-20,90}})));
  Buildings.Obsolete.Controls.OBC.CDL.Logical.TrueHold truHol(
    duration=3600)
    "Block that holds a signal on for a requested time period"
    annotation (Placement(transformation(extent={{20,70},{40,90}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul1(
    period=3600)
    "Boolean pulse input signal"
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));
  Buildings.Obsolete.Controls.OBC.CDL.Logical.TrueHold truHol1(
    duration=600)
    "Block that holds a signal on for a requested time period"
    annotation (Placement(transformation(extent={{20,20},{40,40}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul2(
    period=9000,
    shift=300)
    "Boolean pulse input signal"
    annotation (Placement(transformation(extent={{-40,-20},{-20,0}})));
  Buildings.Obsolete.Controls.OBC.CDL.Logical.TrueHold truHol2(
    duration=3600)
    "Block that holds a signal on for a requested time period"
    annotation (Placement(transformation(extent={{20,-20},{40,0}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul3(
    period=3600)
    "Boolean pulse input signal"
    annotation (Placement(transformation(extent={{-40,-70},{-20,-50}})));
  Buildings.Obsolete.Controls.OBC.CDL.Logical.TrueHold truHol3(
    duration=600)
    "Block that holds a signal on for a requested time period"
    annotation (Placement(transformation(extent={{20,-70},{40,-50}})));
  Buildings.Controls.OBC.CDL.Logical.Not not2
    "Negation of input signal"
    annotation (Placement(transformation(extent={{-10,-20},{10,0}})));
  Buildings.Controls.OBC.CDL.Logical.Not not3
    "Negation of input signal"
    annotation (Placement(transformation(extent={{-10,-70},{10,-50}})));

equation
  connect(booPul.y,truHol.u)
    annotation (Line(points={{-18,80},{-18,80},{18,80}},color={255,0,255}));
  connect(booPul1.y,truHol1.u)
    annotation (Line(points={{-18,30},{18,30}},color={255,0,255}));
  connect(booPul2.y,not2.u)
    annotation (Line(points={{-18,-10},{-12,-10}},color={255,0,255}));
  connect(not2.y,truHol2.u)
    annotation (Line(points={{12,-10},{18,-10}},color={255,0,255}));
  connect(booPul3.y,not3.u)
    annotation (Line(points={{-18,-60},{-12,-60}},color={255,0,255}));
  connect(not3.y,truHol3.u)
    annotation (Line(points={{12,-60},{18,-60}},color={255,0,255}));
  annotation (
    experiment(
      StopTime=15000.0,
      Tolerance=1e-06),
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/Obsolete/Controls/OBC/CDL/Logical/Validation/TrueHold.mos" "Simulate and plot"),
    Documentation(
      info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Obsolete.Controls.OBC.CDL.Logical.TrueHold\">
Buildings.Obsolete.Controls.OBC.CDL.Logical.TrueHold</a>.
</p>
<p>
The validation uses different instances to validate different hold durations, different lengths
of the input pulse, and different initial values for the input signal.
</p>
</html>",
      revisions="<html>
<ul>
<li>
June 14, 2017, by Michael Wetter:<br/>
Added more tests for different initial signals and different hold values.
</li>
<li>
May 24, 2017, by Milica Grahovac:<br/>
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
          points={{-36,60},{64,0},{-36,-60},{-36,60}})}));
end TrueHold;
