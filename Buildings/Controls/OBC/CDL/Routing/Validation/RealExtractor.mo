within Buildings.Controls.OBC.CDL.Routing.Validation;
model RealExtractor
  "Validation model for the extractor block"
  Buildings.Controls.OBC.CDL.Routing.RealExtractor extIndSig(
    nin=5)
    "Block that extracts signal from an input signal vector"
    annotation (Placement(transformation(extent={{40,70},{60,90}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp ram(
    height=5,
    duration=1,
    offset=-2)
    "Block that outputs ramp signal"
    annotation (Placement(transformation(extent={{-80,70},{-60,90}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp ram1(
    duration=1,
    height=4,
    offset=-1)
    "Block that outputs ramp signal"
    annotation (Placement(transformation(extent={{-80,-20},{-60,0}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp ram2(
    duration=1,
    height=3,
    offset=-2)
    "Block that outputs ramp signal"
    annotation (Placement(transformation(extent={{-80,-50},{-60,-30}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Pulse pul(
    amplitude=0.5,
    period=0.2)
    "Generate pulse signal of type Real"
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Pulse pul1(
    period=0.2,
    amplitude=1.5,
    offset=-0.2)
    "Generate pulse signal of type Real"
    annotation (Placement(transformation(extent={{-80,10},{-60,30}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt(
    k=2)
    "Index to extract input signal"
    annotation (Placement(transformation(extent={{20,20},{40,40}})));
  Buildings.Controls.OBC.CDL.Routing.RealExtractor extIndSig1(
    nin=5)
    "Block that extracts signal from an input signal vector"
    annotation (Placement(transformation(extent={{40,-50},{60,-30}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt1(
    k=6)
    "Index to extract input signal"
    annotation (Placement(transformation(extent={{20,-90},{40,-70}})));

equation
  connect(ram.y,extIndSig.u[1])
    annotation (Line(points={{-59,80},{8,80},{8,78.4},{38,78.4}},color={0,0,127}));
  connect(pul.y,extIndSig.u[2])
    annotation (Line(points={{-59,50},{4,50},{4,79.2},{38,79.2}},color={0,0,127}));
  connect(pul1.y,extIndSig.u[3])
    annotation (Line(points={{-59,20},{-10,20},{-10,80},{38,80}},color={0,0,127}));
  connect(ram1.y,extIndSig.u[4])
    annotation (Line(points={{-59,-10},{0,-10},{0,80.8},{38,80.8}},color={0,0,127}));
  connect(ram2.y,extIndSig.u[5])
    annotation (Line(points={{-59,-40},{-4,-40},{-4,81.6},{38,81.6}},color={0,0,127}));
  connect(conInt.y,extIndSig.index)
    annotation (Line(points={{41,30},{50,30},{50,68}},color={255,127,0}));
  connect(conInt1.y,extIndSig1.index)
    annotation (Line(points={{41,-80},{50,-80},{50,-52}},color={255,127,0}));
  connect(ram.y,extIndSig1.u[1])
    annotation (Line(points={{-59,80},{8,80},{8,-41.6},{38,-41.6}},color={0,0,127}));
  connect(pul.y,extIndSig1.u[2])
    annotation (Line(points={{-59,50},{4,50},{4,-40.8},{38,-40.8}},color={0,0,127}));
  connect(pul1.y,extIndSig1.u[3])
    annotation (Line(points={{-59,20},{-10,20},{-10,-40},{38,-40}},color={0,0,127}));
  connect(ram1.y,extIndSig1.u[4])
    annotation (Line(points={{-59,-10},{0,-10},{0,-39.2},{38,-39.2}},color={0,0,127}));
  connect(ram2.y,extIndSig1.u[5])
    annotation (Line(points={{-59,-40},{-4,-40},{-4,-38.4},{38,-38.4}},color={0,0,127}));
  annotation (
    experiment(
      StopTime=1.0,
      Tolerance=1e-06),
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/CDL/Routing/Validation/RealExtractor.mos" "Simulate and plot"),
    Documentation(
      info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Controls.OBC.CDL.Routing.RealExtractor\">
Buildings.Controls.OBC.CDL.Routing.RealExtractor</a>.
</p>
</html>",
      revisions="<html>
<ul>
<li>
July 19, 2018, by Jianjun Hu:<br/>
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
end RealExtractor;
