within Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.ParallelFanVVF.Subsequences.Validation;
model DamperValves
  "Validate model for controlling damper and valve position"

  Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.ParallelFanVVF.Subsequences.DamperValves damValFan1(
    final VMin_flow=0.01,
    final VCooMax_flow=0.09,
    final minRat=0.01,
    final maxRat=0.1,
    final kDam=1) "Output signal for controlling damper position"
    annotation (Placement(transformation(extent={{80,-90},{100,-50}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp uCoo(
    final height=-1,
    final duration=3600,
    final offset=1,
    final startTime=900) "Cooling control signal"
    annotation (Placement(transformation(extent={{-100,90},{-80,110}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TZon(
    final k=273.15 + 22)
    "Zone temperature"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant VActMin_flow(
    final k=0.01) "Active minimum airflow setpoint"
    annotation (Placement(transformation(extent={{-100,10},{-80,30}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant VActCooMax_flow(
    final k=0.075)
    "Active cooling maximum airflow setpoint"
    annotation (Placement(transformation(extent={{-60,70},{-40,90}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TSupSet(
    final k=273.15 + 13)
    "AHU supply air temperature setpoint"
    annotation (Placement(transformation(extent={{-100,-30},{-80,-10}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp uHea(
    final height=1,
    final duration=3600,
    final offset=0,
    final startTime=5500) "Heating control signal"
    annotation (Placement(transformation(extent={{-100,-70},{-80,-50}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp disAir(
    final duration=7200,
    final offset=0.01,
    final height=0.06)
    "Discharge airflow rate"
    annotation (Placement(transformation(extent={{-60,110},{-40,130}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Sin TSup(
    final offset=273.15 + 13,
    final amplitude=1,
    final freqHz=1/3600)
    "Supply air temperature"
    annotation (Placement(transformation(extent={{-100,50},{-80,70}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant THeaSet(
    final k=273.15 + 20)
    "Zone heating setpoint"
    annotation (Placement(transformation(extent={{-60,-50},{-40,-30}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Sin TDis(
    final offset=273.15 + 13,
    final amplitude=1.2,
    final freqHz=1/3600) "Measured discharge air temperature"
    annotation (Placement(transformation(extent={{-60,-90},{-40,-70}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant VOAMin_flow(
    final k=0.005) "Minimum outdoor airflow setpoint"
    annotation (Placement(transformation(extent={{-60,-150},{-40,-130}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp opeMod(
    final offset=1,
    final height=3,
    final duration=90000) "Operation mode"
    annotation (Placement(transformation(extent={{-100,-120},{-80,-100}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt2
    "Convert real to integer"
    annotation (Placement(transformation(extent={{-20,-120},{0,-100}})));
  Buildings.Controls.OBC.CDL.Reals.Round round2(
    final n=0)
    "Round real number to given digits"
    annotation (Placement(transformation(extent={{-60,-120},{-40,-100}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp oveFlo(
    final height=3,
    final duration=2000,
    final startTime=1000) "Override flow setpoint"
    annotation (Placement(transformation(extent={{-100,130},{-80,150}})));
  Buildings.Controls.OBC.CDL.Reals.Round round1(final n=0)
    "Round real number to given digits"
    annotation (Placement(transformation(extent={{-20,130},{0,150}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt1
    "Convert real to integer"
    annotation (Placement(transformation(extent={{20,130},{40,150}})));
equation
  connect(VActMin_flow.y, damValFan1.VActMin_flow) annotation (Line(points={{-78,20},
          {44,20},{44,-69},{78,-69}},     color={0,0,127}));
  connect(TZon.y, damValFan1.TZon) annotation (Line(points={{-38,0},{48,0},{48,-66},
          {78,-66}},      color={0,0,127}));
  connect(VActCooMax_flow.y, damValFan1.VActCooMax_flow) annotation (Line(
        points={{-38,80},{56,80},{56,-60},{78,-60}}, color={0,0,127}));
  connect(uCoo.y, damValFan1.uCoo) annotation (Line(points={{-78,100},{60,100},{
          60,-57},{78,-57}}, color={0,0,127}));
  connect(uHea.y, damValFan1.uHea) annotation (Line(points={{-78,-60},{32,-60},{
          32,-78},{78,-78}}, color={0,0,127}));
  connect(disAir.y,damValFan1.VPri_flow)  annotation (Line(points={{-38,120},{64,
          120},{64,-54},{78,-54}}, color={0,0,127}));
  connect(TSupSet.y, damValFan1.TSupSet) annotation (Line(points={{-78,-20},{40,
          -20},{40,-72},{78,-72}}, color={0,0,127}));
  connect(TSup.y, damValFan1.TSup) annotation (Line(points={{-78,60},{52,60},{52,
          -63},{78,-63}}, color={0,0,127}));
  connect(THeaSet.y, damValFan1.THeaSet) annotation (Line(points={{-38,-40},{36,
          -40},{36,-75},{78,-75}},     color={0,0,127}));
  connect(TDis.y, damValFan1.TDis) annotation (Line(points={{-38,-80},{28,-80},{
          28,-81},{78,-81}}, color={0,0,127}));
  connect(opeMod.y,round2. u)
    annotation (Line(points={{-78,-110},{-62,-110}}, color={0,0,127}));
  connect(round2.y,reaToInt2. u)
    annotation (Line(points={{-38,-110},{-22,-110}},
      color={0,0,127}));
  connect(reaToInt2.y, damValFan1.uOpeMod) annotation (Line(points={{2,-110},{24,
          -110},{24,-89},{78,-89}}, color={255,127,0}));
  connect(VOAMin_flow.y, damValFan1.VOAMin_flow) annotation (Line(points={{-38,-140},
          {20,-140},{20,-84},{78,-84}}, color={0,0,127}));
  connect(oveFlo.y,round1. u)
    annotation (Line(points={{-78,140},{-22,140}}, color={0,0,127}));
  connect(round1.y,reaToInt1. u)
    annotation (Line(points={{2,140},{18,140}},    color={0,0,127}));
  connect(reaToInt1.y, damValFan1.oveFloSet) annotation (Line(points={{42,140},{
          68,140},{68,-51},{78,-51}}, color={255,127,0}));
annotation (
  experiment(StopTime=7200, Tolerance=1e-6),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/G36/TerminalUnits/ParallelFanVVF/Subsequences/Validation/DamperValves.mos"
        "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.ParallelFanVVF.Subsequences.DamperValves\">
BBuildings.Controls.OBC.ASHRAE.G36.TerminalUnits.ParallelFanVVF.Subsequences.DamperValves</a>
for damper and valve control of parallel fan powered unit.
</p>
</html>", revisions="<html>
<ul>
<li>
February 10, 2022, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}}),
         graphics={
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
          points={{-36,58},{64,-2},{-36,-62},{-36,58}})}),
    Diagram(coordinateSystem(extent={{-120,-160},{120,160}})));
end DamperValves;
