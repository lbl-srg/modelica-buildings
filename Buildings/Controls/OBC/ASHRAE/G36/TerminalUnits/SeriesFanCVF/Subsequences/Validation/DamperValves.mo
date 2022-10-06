within Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.SeriesFanCVF.Subsequences.Validation;
model DamperValves
  "Validate model for controlling damper and valve position"

  Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.SeriesFanCVF.Subsequences.DamperValves damValFan(
    final VMin_flow=0.01,
    final VCooMax_flow=0.09,
    final kDam=1) "Output signal for controlling damper position"
    annotation (Placement(transformation(extent={{80,-10},{100,30}})));
  Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.SeriesFanCVF.Subsequences.DamperValves damValFan1(
    final VMin_flow=0.01,
    final VCooMax_flow=0.09,
    final have_preIndDam=false,
    final kDam=1) "Output signal for controlling damper position"
    annotation (Placement(transformation(extent={{80,-110},{100,-70}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp uCoo(
    final height=-1,
    final duration=3600,
    final offset=1,
    final startTime=900) "Cooling control signal"
    annotation (Placement(transformation(extent={{-100,90},{-80,110}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TZon(
    final k=273.15 + 22)
    "Zone temperature"
    annotation (Placement(transformation(extent={{-100,0},{-80,20}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant VActMin_flow(
    final k=0.01) "Active minimum airflow setpoint"
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant VActCooMax_flow(
    final k=0.075)
    "Active cooling maximum airflow setpoint"
    annotation (Placement(transformation(extent={{-60,70},{-40,90}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse terFan(
    final width=0.75,
    final period=7200) "Terminal fan status"
    annotation (Placement(transformation(extent={{-100,-140},{-80,-120}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TSupSet(
    final k=273.15 + 13)
    "AHU supply air temperature setpoint"
    annotation (Placement(transformation(extent={{-60,-20},{-40,0}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp uHea(
    final height=1,
    final duration=3600,
    final offset=0,
    final startTime=5500) "Heating control signal"
    annotation (Placement(transformation(extent={{-60,-60},{-40,-40}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp disAir(
    final duration=7200,
    final offset=0.01,
    final height=0.06)
    "Discharge airflow rate"
    annotation (Placement(transformation(extent={{-60,110},{-40,130}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine TSup(
    final offset=273.15 + 13,
    final amplitude=1,
    final freqHz=1/3600)
    "Supply air temperature"
    annotation (Placement(transformation(extent={{-100,50},{-80,70}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant THeaSet(
    final k=273.15 + 20)
    "Zone heating setpoint"
    annotation (Placement(transformation(extent={{-100,-40},{-80,-20}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine TDis(
    final offset=273.15 + 13,
    final amplitude=1.2,
    final freqHz=1/3600) "Measured discharge air temperature"
    annotation (Placement(transformation(extent={{-100,-80},{-80,-60}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp opeMod(
    final offset=1,
    final height=3,
    final duration=90000) "Operation mode"
    annotation (Placement(transformation(extent={{-100,-110},{-80,-90}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt2
    "Convert real to integer"
    annotation (Placement(transformation(extent={{-20,-110},{0,-90}})));
  Buildings.Controls.OBC.CDL.Continuous.Round round2(
    final n=0)
    "Round real number to given digits"
    annotation (Placement(transformation(extent={{-60,-110},{-40,-90}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp damPos(
    final height=1,
    final duration=3600,
    final offset=0,
    final startTime=5500) "Damper position"
    annotation (Placement(transformation(extent={{-60,-160},{-40,-140}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp oveFlo(
    final height=3,
    final duration=2000,
    final startTime=1000) "Override flow setpoint"
    annotation (Placement(transformation(extent={{-100,140},{-80,160}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt1
    "Convert real to integer"
    annotation (Placement(transformation(extent={{-20,140},{0,160}})));
  Buildings.Controls.OBC.CDL.Continuous.Round round1(final n=0)
    "Round real number to given digits"
    annotation (Placement(transformation(extent={{-60,140},{-40,160}})));
equation
  connect(uCoo.y, damValFan.uCoo) annotation (Line(points={{-78,100},{60,100},{60,
          22},{78,22}}, color={0,0,127}));
  connect(TZon.y, damValFan.TZon) annotation (Line(points={{-78,10},{48,10},{48,
          14},{78,14}}, color={0,0,127}));
  connect(VActCooMax_flow.y, damValFan.VActCooMax_flow) annotation (Line(points={{-38,80},
          {56,80},{56,19},{78,19}},          color={0,0,127}));
  connect(VActMin_flow.y, damValFan.VActMin_flow) annotation (Line(points={{-38,30},
          {44,30},{44,11},{78,11}},     color={0,0,127}));
  connect(VActMin_flow.y, damValFan1.VActMin_flow) annotation (Line(points={{-38,30},
          {44,30},{44,-89},{78,-89}},     color={0,0,127}));
  connect(TZon.y, damValFan1.TZon) annotation (Line(points={{-78,10},{48,10},{48,
          -86},{78,-86}}, color={0,0,127}));
  connect(VActCooMax_flow.y, damValFan1.VActCooMax_flow) annotation (Line(
        points={{-38,80},{56,80},{56,-81},{78,-81}}, color={0,0,127}));
  connect(uCoo.y, damValFan1.uCoo) annotation (Line(points={{-78,100},{60,100},{
          60,-78},{78,-78}}, color={0,0,127}));
  connect(uHea.y, damValFan.uHea) annotation (Line(points={{-38,-50},{32,-50},{32,
          3},{78,3}},   color={0,0,127}));
  connect(uHea.y, damValFan1.uHea) annotation (Line(points={{-38,-50},{32,-50},{
          32,-97},{78,-97}}, color={0,0,127}));
  connect(disAir.y,damValFan.VPri_flow)  annotation (Line(points={{-38,120},{64,
          120},{64,25},{78,25}}, color={0,0,127}));
  connect(disAir.y,damValFan1.VPri_flow)  annotation (Line(points={{-38,120},{64,
          120},{64,-75},{78,-75}}, color={0,0,127}));
  connect(TSupSet.y, damValFan.TSupSet) annotation (Line(points={{-38,-10},{40,-10},
          {40,8},{78,8}},   color={0,0,127}));
  connect(TSupSet.y, damValFan1.TSupSet) annotation (Line(points={{-38,-10},{40,
          -10},{40,-92},{78,-92}}, color={0,0,127}));
  connect(TSup.y, damValFan.TSup) annotation (Line(points={{-78,60},{52,60},{52,
          16},{78,16}}, color={0,0,127}));
  connect(TSup.y, damValFan1.TSup) annotation (Line(points={{-78,60},{52,60},{52,
          -84},{78,-84}}, color={0,0,127}));
  connect(THeaSet.y, damValFan.THeaSet) annotation (Line(points={{-78,-30},{36,-30},
          {36,6},{78,6}},            color={0,0,127}));
  connect(THeaSet.y, damValFan1.THeaSet) annotation (Line(points={{-78,-30},{36,
          -30},{36,-94},{78,-94}},     color={0,0,127}));
  connect(TDis.y, damValFan.TDis) annotation (Line(points={{-78,-70},{28,-70},{28,
          0},{78,0}},   color={0,0,127}));
  connect(TDis.y, damValFan1.TDis) annotation (Line(points={{-78,-70},{28,-70},{
          28,-100},{78,-100}}, color={0,0,127}));
  connect(opeMod.y,round2. u)
    annotation (Line(points={{-78,-100},{-62,-100}}, color={0,0,127}));
  connect(round2.y,reaToInt2. u)
    annotation (Line(points={{-38,-100},{-22,-100}},
      color={0,0,127}));
  connect(reaToInt2.y, damValFan.uOpeMod) annotation (Line(points={{2,-100},{24,
          -100},{24,-3},{78,-3}}, color={255,127,0}));
  connect(reaToInt2.y, damValFan1.uOpeMod) annotation (Line(points={{2,-100},{24,
          -100},{24,-103},{78,-103}}, color={255,127,0}));
  connect(terFan.y, damValFan.u1Fan) annotation (Line(points={{-78,-130},{20,-130},
          {20,-6},{78,-6}}, color={255,0,255}));
  connect(terFan.y, damValFan1.u1Fan) annotation (Line(points={{-78,-130},{20,-130},
          {20,-106},{78,-106}}, color={255,0,255}));
  connect(damPos.y, damValFan.uDam) annotation (Line(points={{-38,-150},{
          16,-150},{16,-9},{78,-9}},color={0,0,127}));
  connect(damPos.y, damValFan1.uDam) annotation (Line(points={{-38,-150},
          {16,-150},{16,-109},{78,-109}}, color={0,0,127}));
  connect(oveFlo.y,round1. u)
    annotation (Line(points={{-78,150},{-62,150}}, color={0,0,127}));
  connect(round1.y,reaToInt1. u)
    annotation (Line(points={{-38,150},{-22,150}}, color={0,0,127}));
  connect(reaToInt1.y, damValFan.oveFloSet) annotation (Line(points={{2,150},{68,
          150},{68,29},{78,29}}, color={255,127,0}));
  connect(reaToInt1.y, damValFan1.oveFloSet) annotation (Line(points={{2,150},{68,
          150},{68,-71},{78,-71}}, color={255,127,0}));
annotation (
  experiment(StopTime=7200, Tolerance=1e-6),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/G36/TerminalUnits/SeriesFanCVF/Subsequences/Validation/DamperValves.mos"
        "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.SeriesFanCVF.Subsequences.DamperValves\">
BBuildings.Controls.OBC.ASHRAE.G36.TerminalUnits.SeriesFanCVF.Subsequences.DamperValves</a>
for damper and valve control of series fan powered unit.
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
    Diagram(coordinateSystem(extent={{-120,-180},{120,180}})));
end DamperValves;
