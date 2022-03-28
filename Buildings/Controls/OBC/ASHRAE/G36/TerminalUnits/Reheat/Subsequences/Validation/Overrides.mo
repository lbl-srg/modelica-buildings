within Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.Reheat.Subsequences.Validation;
model Overrides "Validation of model that overrides control"

  Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.Reheat.Subsequences.Overrides ove(
    final VZonMin_flow=0.1,
    final VZonCooMax_flow=0.9,
    final VZonHeaMax_flow=0.8) "Block outputs system requests"
    annotation (Placement(transformation(extent={{60,-20},{80,0}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp disAirSet(
    final height=0.9,
    final duration=7200,
    final offset=0.1) "Discharge airflow rate setpoint"
    annotation (Placement(transformation(extent={{-40,50},{-20,70}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp damPos(
    final duration=3600,
    final height=0.5,
    final offset=0.5) "Damper position setpoint"
    annotation (Placement(transformation(extent={{-40,-22},{-20,-2}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp oveFlo(
    final height=3,
    final duration=2000,
    final startTime=1000) "Override flow setpoint"
    annotation (Placement(transformation(extent={{-80,80},{-60,100}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt2
    "Convert real to integer"
    annotation (Placement(transformation(extent={{0,80},{20,100}})));
  Buildings.Controls.OBC.CDL.Continuous.Round round2(
    final n=0)
    "Round real number to given digits"
    annotation (Placement(transformation(extent={{-40,80},{-20,100}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp oveDam(
    final height=2,
    final duration=2000,
    final startTime=1000) "Override damper position"
    annotation (Placement(transformation(extent={{-80,10},{-60,30}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt1
    "Convert real to integer"
    annotation (Placement(transformation(extent={{0,10},{20,30}})));
  Buildings.Controls.OBC.CDL.Continuous.Round round1(
    final n=0)
    "Round real number to given digits"
    annotation (Placement(transformation(extent={{-40,10},{-20,30}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp heaValPos(
    final duration=3600,
    final height=0.5,
    final offset=0.5) "Heating valve position"
    annotation (Placement(transformation(extent={{-40,-100},{-20,-80}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse heaOff(
    final width=0.75,
    final period=3600)
    "Close heating valve"
    annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1
    "Logical not"
    annotation (Placement(transformation(extent={{-20,-60},{0,-40}})));
equation
  connect(oveDam.y, round1.u)
    annotation (Line(points={{-58,20},{-42,20}},   color={0,0,127}));
  connect(round1.y, reaToInt1.u)
    annotation (Line(points={{-18,20},{-2,20}},   color={0,0,127}));
  connect(oveFlo.y, round2.u)
    annotation (Line(points={{-58,90},{-42,90}},   color={0,0,127}));
  connect(round2.y, reaToInt2.u)
    annotation (Line(points={{-18,90},{-2,90}},    color={0,0,127}));
  connect(reaToInt2.y, ove.oveFloSet) annotation (Line(points={{22,90},{40,90},
          {40,-2},{58,-2}}, color={255,127,0}));
  connect(disAirSet.y, ove.VActSet_flow) annotation (Line(points={{-18,60},{36,
          60},{36,-5},{58,-5}},
                            color={0,0,127}));
  connect(reaToInt1.y, ove.oveDamPos) annotation (Line(points={{22,20},{32,20},
          {32,-8},{58,-8}},color={255,127,0}));
  connect(damPos.y, ove.uDamSet) annotation (Line(points={{-18,-12},{58,-12}},
                    color={0,0,127}));
  connect(heaValPos.y, ove.uValSet) annotation (Line(points={{-18,-90},{40,-90},
          {40,-19},{58,-19}},     color={0,0,127}));
  connect(heaOff.y, not1.u)
    annotation (Line(points={{-58,-50},{-22,-50}}, color={255,0,255}));
  connect(not1.y, ove.uHeaOff) annotation (Line(points={{2,-50},{36,-50},{36,
          -16},{58,-16}},
                       color={255,0,255}));
annotation (
  experiment(StopTime=3600, Tolerance=1e-6),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/G36/TerminalUnits/Reheat/Subsequences/Validation/Overrides.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.Reheat.Subsequences.Overrides\">
Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.Reheat.Subsequences.Overrides</a>
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
