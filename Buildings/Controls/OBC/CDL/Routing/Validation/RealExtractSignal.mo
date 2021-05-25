within Buildings.Controls.OBC.CDL.Routing.Validation;
model RealExtractSignal
  "Validation model for the extract signal block"
  Buildings.Controls.OBC.CDL.Routing.RealExtractSignal extSig(
    nin=5,
    nout=3,
    extract={1,2,5})
    "Block that extracts signals from an input signal vector"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp ram(
    height=5,
    duration=1,
    offset=-2)
    "Block that outputs ramp signal"
    annotation (Placement(transformation(extent={{-60,50},{-40,70}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp ram1(
    duration=1,
    height=4,
    offset=-1)
    "Block that outputs ramp signal"
    annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp ram2(
    duration=1,
    height=3,
    offset=-2)
    "Block that outputs ramp signal"
    annotation (Placement(transformation(extent={{-60,-70},{-40,-50}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Pulse pul(
    amplitude=0.5,
    period=0.2)
    "Generate pulse signal of type Real"
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Pulse pul1(
    period=0.2,
    amplitude=1.5,
    offset=-0.2)
    "Generate pulse signal of type Real"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));

equation
  connect(ram.y,extSig.u[1])
    annotation (Line(points={{-39,60},{-39,60},{-12,60},{-12,-1.6},{-2,-1.6}},color={0,0,127}));
  connect(pul.y,extSig.u[2])
    annotation (Line(points={{-39,30},{-39,30},{-16,30},{-16,-0.8},{-2,-0.8}},color={0,0,127}));
  connect(pul1.y,extSig.u[3])
    annotation (Line(points={{-39,0},{-20,0},{-2,0}},color={0,0,127}));
  connect(ram1.y,extSig.u[4])
    annotation (Line(points={{-39,-30},{-39,-30},{-20,-30},{-20,0.8},{-2,0.8}},color={0,0,127}));
  connect(ram2.y,extSig.u[5])
    annotation (Line(points={{-39,-60},{-24,-60},{-24,1.6},{-2,1.6}},color={0,0,127}));
  annotation (
    experiment(
      StopTime=1.0,
      Tolerance=1e-06),
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/CDL/Routing/Validation/RealExtractSignal.mos" "Simulate and plot"),
    Documentation(
      info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Controls.OBC.CDL.Routing.RealExtractSignal\">
Buildings.Controls.OBC.CDL.Routing.RealExtractSignal</a>.
</p>
</html>",
      revisions="<html>
<ul>
<li>
July 24, 2017, by Jianjun Hu:<br/>
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
end RealExtractSignal;
