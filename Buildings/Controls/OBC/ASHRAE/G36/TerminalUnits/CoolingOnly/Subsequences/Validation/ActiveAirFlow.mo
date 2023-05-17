within Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.CoolingOnly.Subsequences.Validation;
model ActiveAirFlow
  "Validate the model for calculating active airflow setpoint for VAV cooling only unit"
  Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.CoolingOnly.Subsequences.ActiveAirFlow actAirSet(final
      VCooMax_flow=0.5) "Output the active airflow setpoint for terminal unit"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Sin minFlo(
    final amplitude=0.3,
    final freqHz=1/3600,
    final offset=0.2) "Occupied zone minimum flow"
    annotation (Placement(transformation(extent={{-80,-50},{-60,-30}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp opeMod(
    final offset=1,
    final height=5,
    final duration=3600)
    "Operation mode"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt2
    "Convert real to integer"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Round round2(final n=0)
    "Round real number to given digits"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));

equation
  connect(opeMod.y,round2. u)
    annotation (Line(points={{-58,0},{-42,0}}, color={0,0,127}));
  connect(round2.y,reaToInt2. u)
    annotation (Line(points={{-18,0},{-2,0}},
      color={0,0,127}));
  connect(reaToInt2.y, actAirSet.uOpeMod)
    annotation (Line(points={{22,0},{58,0}}, color={255,127,0}));
  connect(minFlo.y, actAirSet.VOccMin_flow) annotation (Line(points={{-58,-40},
          {40,-40},{40,-6},{58,-6}}, color={0,0,127}));

annotation (
  experiment(StopTime=3600, Tolerance=1e-6),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/G36/TerminalUnits/CoolingOnly/Subsequences/Validation/ActiveAirFlow.mos"
        "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.CoolingOnly.Subsequences.ActiveAirFlow\">
Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.CoolingOnly.Subsequences.ActiveAirFlow</a>
for calculating active minimum and maximum airflow setpoint used in cooling only unit control.
</p>
</html>", revisions="<html>
<ul>
<li>
February 7, 2022, by Jianjun Hu:<br/>
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
                points = {{-36,60},{64,0},{-36,-60},{-36,60}}),
                   Ellipse(
          lineColor={75,138,73},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          extent={{-100,-100},{100,100}}), Polygon(
          lineColor={0,0,255},
          fillColor={75,138,73},
          pattern=LinePattern.None,
          fillPattern=FillPattern.Solid,
          points={{-36,58},{64,-2},{-36,-62},{-36,58}})}));
end ActiveAirFlow;
