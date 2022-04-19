within Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.CoolingOnly.Subsequences.Validation;
model Overrides "Validation of model that overrides control"

  Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.CoolingOnly.Subsequences.Overrides ove(final
      VMin_flow=0.1, final VCooMax_flow=0.9)
    "Block outputs system requests"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp disAirSet(
    final height=0.9,
    final duration=7200,
    final offset=0.1) "Discharge airflow rate setpoint"
    annotation (Placement(transformation(extent={{-40,30},{-20,50}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp damPos(
    final duration=3600,
    final height=0.5,
    final offset=0.5) "Damper position setpoint"
    annotation (Placement(transformation(extent={{-40,-70},{-20,-50}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp oveFlo(
    final height=3,
    final duration=2000,
    startTime=1000) "Override flow setpoint"
    annotation (Placement(transformation(extent={{-80,70},{-60,90}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt2
    "Convert real to integer"
    annotation (Placement(transformation(extent={{0,70},{20,90}})));
  Buildings.Controls.OBC.CDL.Continuous.Round round2(
    final n=0)
    "Round real number to given digits"
    annotation (Placement(transformation(extent={{-40,70},{-20,90}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp oveDam(
    final height=2,
    final duration=2000,
    startTime=1000) "Override damper position"
    annotation (Placement(transformation(extent={{-80,-30},{-60,-10}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt1
    "Convert real to integer"
    annotation (Placement(transformation(extent={{0,-30},{20,-10}})));
  Buildings.Controls.OBC.CDL.Continuous.Round round1(
    final n=0)
    "Round real number to given digits"
    annotation (Placement(transformation(extent={{-40,-30},{-20,-10}})));
equation
  connect(oveDam.y, round1.u)
    annotation (Line(points={{-58,-20},{-42,-20}}, color={0,0,127}));
  connect(round1.y, reaToInt1.u)
    annotation (Line(points={{-18,-20},{-2,-20}}, color={0,0,127}));
  connect(oveFlo.y, round2.u)
    annotation (Line(points={{-58,80},{-42,80}}, color={0,0,127}));
  connect(round2.y, reaToInt2.u)
    annotation (Line(points={{-18,80},{-2,80}}, color={0,0,127}));
  connect(reaToInt2.y, ove.oveFloSet) annotation (Line(points={{22,80},{40,80},{
          40,8},{58,8}}, color={255,127,0}));
  connect(disAirSet.y, ove.VActSet_flow) annotation (Line(points={{-18,40},{30,40},
          {30,4},{58,4}}, color={0,0,127}));
  connect(reaToInt1.y, ove.oveDamPos) annotation (Line(points={{22,-20},{30,-20},
          {30,-4},{58,-4}}, color={255,127,0}));
  connect(damPos.y, ove.uDam) annotation (Line(points={{-18,-60},{40,-60},{40,-8},
          {58,-8}}, color={0,0,127}));
annotation (
  experiment(StopTime=3600, Tolerance=1e-6),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/G36/TerminalUnits/CoolingOnly/Subsequences/Validation/Overrides.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.CoolingOnly.Subsequences.Overrides\">
Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.CoolingOnly.Subsequences.Overrides</a>
for overrideing controls.
</p>
</html>", revisions="<html>
<ul>
<li>
February 10, 2022, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"),
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}}), graphics={
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
end Overrides;
