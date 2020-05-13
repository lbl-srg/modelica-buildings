within Buildings.Controls.OBC.CDL.Integers.Validation;
model Change "Validation model for the Change block"
  Buildings.Controls.OBC.CDL.Integers.Change cha
    "Check if the integer input changes value"
    annotation (Placement(transformation(extent={{0,-50},{20,-30}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp ramp2(
    offset=0,
    height=20,
    duration=1) "Block that generates ramp signal"
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));
  Buildings.Controls.OBC.CDL.Discrete.TriggeredSampler changeSampler
    "Triggered sampler"
    annotation (Placement(transformation(extent={{60,20},{80,40}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt
    "Convert real to integer"
    annotation (Placement(transformation(extent={{-40,-50},{-20,-30}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.TimeTable timTabLin(
    smoothness=Buildings.Controls.OBC.CDL.Types.Smoothness.ConstantSegments,
    table=[0,-1;0.3,0.5; 0.5,0; 0.7,1; 1,0])
    "Time table with smoothness method of constant segments"
    annotation (Placement(transformation(extent={{-80,-50},{-60,-30}})));
  Buildings.Controls.OBC.CDL.Discrete.TriggeredSampler increaseSampler
    "Increase sampler"
    annotation (Placement(transformation(extent={{60,60},{80,80}})));
  Buildings.Controls.OBC.CDL.Discrete.TriggeredSampler decreaseSampler
    "Decrease sampler"
    annotation (Placement(transformation(extent={{60,-20},{80,0}})));

equation
  connect(ramp2.y, changeSampler.u)
    annotation (Line(points={{-18,30},{58,30}}, color={0,0,127}));
  connect(timTabLin.y[1], reaToInt.u)
    annotation (Line(points={{-58,-40},{-42,-40}}, color={0,0,127}));
  connect(reaToInt.y, cha.u)
    annotation (Line(points={{-18,-40},{-2,-40}}, color={255,127,0}));
  connect(ramp2.y, increaseSampler.u)
    annotation (Line(points={{-18,30},{40,30},{40,70},{58,70}},
      color={0,0,127}));
  connect(ramp2.y, decreaseSampler.u)
    annotation (Line(points={{-18,30},{40,30},{40,-10},{58,-10}},
      color={0,0,127}));
  connect(cha.up, increaseSampler.trigger)
    annotation (Line(points={{22,-34},{30,-34},{30,52},{70,52},{70,58.2}},
      color={255,0,255}));
  connect(cha.y, changeSampler.trigger)
    annotation (Line(points={{22,-40},{46,-40},{46,12},{70,12},{70,18.2}},
      color={255,0,255}));
  connect(cha.down, decreaseSampler.trigger)
    annotation (Line(points={{22,-46},{70,-46},{70,-21.8}}, color={255,0,255}));

annotation (
experiment(StopTime=1.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/CDL/Integers/Validation/Change.mos"
        "Simulate and plot"),
Documentation(info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Controls.OBC.CDL.Integers.Change\">
Buildings.Controls.OBC.CDL.Integers.Change</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
July 13, 2018, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"),
Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Ellipse(lineColor = {75,138,73},
                fillColor={255,255,255},
                fillPattern = FillPattern.Solid,
                extent = {{-100,-100},{100,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points = {{-36,60},{64,0},{-36,-60},{-36,60}})}),
Diagram(coordinateSystem(preserveAspectRatio=false)));
end Change;
