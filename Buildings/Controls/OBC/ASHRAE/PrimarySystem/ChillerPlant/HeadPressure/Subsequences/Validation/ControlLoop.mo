within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.HeadPressure.Subsequences.Validation;
model ControlLoop "Validate sequence of output head pressure control signal"

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.HeadPressure.Subsequences.ControlLoop
    chiHeaPreLoo(minChiLif=25)
    annotation (Placement(transformation(extent={{20,40},{40,60}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul(period=5, startTime=1.5)
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine TConWatRet(
    final amplitude=2,
    final freqHz=1/10,
    final offset=273.15 + 30) "Measured condenser water return temperature"
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine TChiWatSup(
    final amplitude=1,
    final freqHz=1/5,
    final offset=273.15 + 7) "Measured chilled water supply temperature"
    annotation (Placement(transformation(extent={{-80,-30},{-60,-10}})));

equation
  connect(booPul.y, chiHeaPreLoo.uHeaPreEna)
    annotation (Line(points={{-59,70},{0,70},{0,58},{18,58}}, color={255,0,255}));
  connect(TConWatRet.y, chiHeaPreLoo.TConWatRet)
    annotation (Line(points={{-59,30},{-20,30},{-20,50},{18,50}}, color={0,0,127}));
  connect(TChiWatSup.y, chiHeaPreLoo.TChiWatSup)
    annotation (Line(points={{-59,-20},{0,-20},{0,42},{18,42}}, color={0,0,127}));

annotation (
  experiment(StopTime=5.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/ChillerPlant/HeadPressure/Subsequences/Validation/ControlLoop.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.HeadPressure.Subsequences.ControlLoop\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.HeadPressure.Subsequences.ControlLoop</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
March 22, 2019, by Jianjun Hu:<br/>
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
                points = {{-36,60},{64,0},{-36,-60},{-36,60}})}), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end ControlLoop;
