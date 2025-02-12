within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.HeadPressure.Subsequences.Validation;
model ControlLoop "Validate sequence of output head pressure control signal"
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.HeadPressure.Subsequences.ControlLoop
    chiHeaPreLoo
    "Output chiller head pressure control loop signal"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul(
    final width=0.7,
    final period=5,
    final shift=0.5) "Head pressure control enabling status"
    annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TChiWatSup(k=280.15)
    "Measured chilled water supply temperature"
    annotation (Placement(transformation(extent={{-60,-60},{-40,-40}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Pulse TConWatRet(
    final amplitude=-11,
    period=5,
    final offset=273.15 + 20)
    "Measured condenser water return temperature"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));

equation
  connect(TChiWatSup.y, chiHeaPreLoo.TChiWatSup)
    annotation (Line(points={{-38,-50},{0,-50},{0,-8},{38,-8}}, color={0,0,127}));
  connect(booPul.y, chiHeaPreLoo.uHeaPreEna)
    annotation (Line(points={{-38,50},{0,50},{0,8},{38,8}}, color={255,0,255}));
  connect(TConWatRet.y, chiHeaPreLoo.TConWatRet)
    annotation (Line(points={{-38,0},{38,0}}, color={0,0,127}));

annotation (
  experiment(StopTime=5.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/ChillerPlant/HeadPressure/Subsequences/Validation/ControlLoop.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.HeadPressure.Subsequences.ControlLoop\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.HeadPressure.Subsequences.ControlLoop</a>.
It demonstrates how the head pressure control loop
signal being generated.
</p>
<ul>
<li>
Before 0.5 seconds, the head pressure control loop is not enabled
(<code>uHeaPreEna=false</code>). The loop output is not valid
and will not be used.
</li>
<li>
At 0.5 seconds, the head pressure control loop is enabled. The
PID controller resets the output from 0.
</li>
<li>
From 0.5 seconds to 2.5 seconds, the difference between the
condenser water return temperature and the chilled water supply
temperature is 2 &deg;K and it is less than the minimum LIFT
(10 &deg;K). The reverse acting PID controller gradually increases
the output to 1.
</li>
<li>
From 2.5 seconds to 4 seconds, the difference between the
condenser water return temperature and the chilled water supply
temperature is 13 &deg;K and it is greater than the minimum LIFT
(10 &deg;K). The reverse acting PID controller gradually decreases
the output to 0.
</li>
<li>
After 4 seconds, the head pressure control loop becomes disabled
(<code>uHeaPreEna=false</code>). The loop output is not valid
and will not be used.
</li>
</ul>
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
