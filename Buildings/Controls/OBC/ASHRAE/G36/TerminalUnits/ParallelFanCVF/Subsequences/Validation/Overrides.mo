within Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.ParallelFanCVF.Subsequences.Validation;
model Overrides "Validation of model that overrides control"

  Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.ParallelFanCVF.Subsequences.Overrides ove
    "Block outputs system requests"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp damPos(
    final duration=3600,
    final height=0.5,
    final offset=0.5) "Damper position setpoint"
    annotation (Placement(transformation(extent={{-40,50},{-20,70}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp oveDam(
    final height=2,
    final duration=2000,
    final startTime=1000) "Override damper position"
    annotation (Placement(transformation(extent={{-80,90},{-60,110}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt1
    "Convert real to integer"
    annotation (Placement(transformation(extent={{0,90},{20,110}})));
  Buildings.Controls.OBC.CDL.Reals.Round round1(
    final n=0)
    "Round real number to given digits"
    annotation (Placement(transformation(extent={{-40,90},{-20,110}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp heaValPos(
    final duration=3600,
    final height=0.5,
    final offset=0.5) "Heating valve position"
    annotation (Placement(transformation(extent={{-40,-30},{-20,-10}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp oveDam1(
    final height=2,
    final duration=2000,
    final startTime=1000) "Override damper position"
    annotation (Placement(transformation(extent={{-80,-70},{-60,-50}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt3
    "Convert real to integer"
    annotation (Placement(transformation(extent={{0,-70},{20,-50}})));
  Buildings.Controls.OBC.CDL.Reals.Round round3(
    final n=0)
    "Round real number to given digits"
    annotation (Placement(transformation(extent={{-40,-70},{-20,-50}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse heaOff(
    final width=0.75,
    final period=3600)
    "Close heating valve"
    annotation (Placement(transformation(extent={{-80,10},{-60,30}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant terFan(
    final k=true)
    "Terminal fan status"
    annotation (Placement(transformation(extent={{0,-110},{20,-90}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1
    "Logical not"
    annotation (Placement(transformation(extent={{-20,10},{0,30}})));
equation
  connect(oveDam.y, round1.u)
    annotation (Line(points={{-58,100},{-42,100}}, color={0,0,127}));
  connect(round1.y, reaToInt1.u)
    annotation (Line(points={{-18,100},{-2,100}}, color={0,0,127}));
  connect(oveDam1.y, round3.u)
    annotation (Line(points={{-58,-60},{-42,-60}}, color={0,0,127}));
  connect(round3.y,reaToInt3. u)
    annotation (Line(points={{-18,-60},{-2,-60}}, color={0,0,127}));
  connect(reaToInt1.y, ove.oveDamPos) annotation (Line(points={{22,100},{40,100},
          {40,9},{58,9}},  color={255,127,0}));
  connect(damPos.y, ove.uDam) annotation (Line(points={{-18,60},{30,60},{30,7},{
          58,7}},   color={0,0,127}));
  connect(heaValPos.y, ove.uVal) annotation (Line(points={{-18,-20},{20,-20},{20,
          -1},{58,-1}},          color={0,0,127}));
  connect(reaToInt3.y, ove.oveFan) annotation (Line(points={{22,-60},{30,-60},{30,
          -7},{58,-7}},   color={255,127,0}));
  connect(terFan.y, ove.u1Fan) annotation (Line(points={{22,-100},{40,-100},{40,
          -9},{58,-9}}, color={255,0,255}));
  connect(heaOff.y, not1.u)
    annotation (Line(points={{-58,20},{-22,20}},   color={255,0,255}));
  connect(not1.y, ove.uHeaOff) annotation (Line(points={{2,20},{20,20},{20,1},{58,
          1}}, color={255,0,255}));
annotation (
  experiment(StopTime=3600, Tolerance=1e-6),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/G36/TerminalUnits/ParallelFanCVF/Subsequences/Validation/Overrides.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.ParallelFanCVF.Subsequences.Overrides\">
Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.ParallelFanCVF.Subsequences.Overrides</a>
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
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-120},{100,120}})),
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
