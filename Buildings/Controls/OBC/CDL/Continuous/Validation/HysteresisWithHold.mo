within Buildings.Controls.OBC.CDL.Continuous.Validation;
model HysteresisWithHold "Validation model for the HysteresisWithHold block"
  Modelica.Blocks.Sources.Sine pulse1(
    amplitude = 0.2,
    freqHz =    1/360)
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  Buildings.Controls.OBC.CDL.Continuous.HysteresisWithHold noHold(
    trueHoldDuration =  0,
    falseHoldDuration = 0,
    uLow =      0.05,
    uHigh =     0.15) "No true/false hold"
    annotation (Placement(transformation(extent={{20,50},{40,70}})));
  Buildings.Controls.OBC.CDL.Continuous.HysteresisWithHold onHold_30s(
    trueHoldDuration =  30,
    falseHoldDuration = 30,
    uLow =      0.05,
    uHigh =     0.15)
    "On/off signal are hold for short period"
    annotation (Placement(transformation(extent={{20,10},{40,30}})));
  Buildings.Controls.OBC.CDL.Continuous.HysteresisWithHold offHold_300s(
    trueHoldDuration =  30,
    falseHoldDuration = 300,
    uLow =      0.05,
    uHigh =     0.15)
    "Off signal being hold even when it should be on"
    annotation (Placement(transformation(extent={{20,-30},{40,-10}})));
  Buildings.Controls.OBC.CDL.Continuous.HysteresisWithHold onHold_150s(
    trueHoldDuration =  150,
    falseHoldDuration = 30,
    uLow =      0.05,
    uHigh =     0.15)
    "On signal being hold even when it should be off."
    annotation (Placement(transformation(extent={{20,-70},{40,-50}})));

equation
  connect(pulse1.y, onHold_150s.u)
    annotation (Line(points={{-19,0},{0,0},{0,-60},{18,-60}}, color={0,0,127}));
  connect(pulse1.y, noHold.u)
    annotation (Line(points={{-19,0},{0,0},{0,60},{18,60}}, color={0,0,127}));
  connect(pulse1.y, offHold_300s.u)
    annotation (Line(points={{-19,0},{-10,0},{0,0},{0,-20},{18,-20}}, color={0,0,127}));
  connect(pulse1.y, onHold_30s.u)
    annotation (Line(points={{-19,0},{0,0},{0,20},{18,20}}, color={0,0,127}));
  annotation (
  experiment(StopTime=1800,  Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/CDL/Continuous/Validation/HysteresisWithHold.mos"
        "Simulate and plot"),
  Documentation(info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Controls.OBC.CDL.Continuous.HysteresisWithHold\">
Buildings.Controls.OBC.CDL.Continuous.HysteresisWithHold</a>.
</p>
<p>
The hold durations are configured as follows:
</p>
<ul>
<li>
<code>true</code> hold duration time <code>trueHoldDuration=0</code>,
<code>false</code> hold duration time <code>falseHoldDuration=0</code>.
</li>
<li>
<code>true</code> hold duration time <code>trueHoldDuration=30</code>,
<code>false</code> hold duration time <code>falseHoldDuration=30</code>.
</li>
<li>
<code>true</code> hold duration time <code>trueHoldDuration=30</code>,
<code>false</code> hold duration time <code>falseHoldDuration=300</code>.
The <code>false</code> hold period covers
the instance when it should be on.
</li>
<li>
<code>true</code> hold duration time <code>trueHoldDuration</code>=150,
<code>false</code> hold duration time <code>falseHoldDuration=30</code>.
The <code>true</code> hold period covers
the instance when it should be off.
</li>
</ul>
</html>", revisions="<html>
<ul>
<li>
June 26, 2017, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(graphics={
        Ellipse(lineColor = {75,138,73},
                fillColor={255,255,255},
                fillPattern = FillPattern.Solid,
                extent = {{-100,-100},{100,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points = {{-36,60},{64,0},{-36,-60},{-36,60}})}));
end HysteresisWithHold;
