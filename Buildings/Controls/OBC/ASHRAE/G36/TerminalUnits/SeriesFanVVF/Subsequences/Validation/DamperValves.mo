within Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.SeriesFanVVF.Subsequences.Validation;
model DamperValves
  "Validate model for controlling damper and valve position"

  Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.SeriesFanVVF.Subsequences.DamperValves damValFan1(
    final maxRat=0.1,
    final VMin_flow=0.01,
    final VCooMax_flow=0.09,
    final kDam=1) "Output signal for controlling damper position"
    annotation (Placement(transformation(extent={{80,-120},{100,-80}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp uCoo(
    final height=-1,
    final duration=3600,
    final offset=1,
    final startTime=900) "Cooling control signal"
    annotation (Placement(transformation(extent={{-100,90},{-80,110}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TZon(
    final k=273.15 + 22)
    "Zone temperature"
    annotation (Placement(transformation(extent={{-100,10},{-80,30}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant VActMin_flow(
    final k=0.01) "Active minimum airflow setpoint"
    annotation (Placement(transformation(extent={{-60,30},{-40,50}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant VActCooMax_flow(
    final k=0.075)
    "Active cooling maximum airflow setpoint"
    annotation (Placement(transformation(extent={{-60,70},{-40,90}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse terFan(
    final width=0.75,
    final period=7200) "Terminal fan status"
    annotation (Placement(transformation(extent={{-100,-150},{-80,-130}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TSupSet(
    final k=273.15 + 13)
    "AHU supply air temperature setpoint"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp uHea(
    final height=1,
    final duration=3600,
    final offset=0,
    final startTime=5500) "Heating control signal"
    annotation (Placement(transformation(extent={{-60,-50},{-40,-30}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp disAir(
    final duration=7200,
    final offset=0.01,
    final height=0.06)
    "Discharge airflow rate"
    annotation (Placement(transformation(extent={{-60,110},{-40,130}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Sin TSup(
    final offset=273.15 + 13,
    final amplitude=1,
    final freqHz=1/3600)
    "Supply air temperature"
    annotation (Placement(transformation(extent={{-100,50},{-80,70}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant THeaSet(
    final k=273.15 + 20)
    "Zone heating setpoint"
    annotation (Placement(transformation(extent={{-100,-30},{-80,-10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Sin TDis(
    final offset=273.15 + 13,
    final amplitude=1.2,
    final freqHz=1/3600) "Measured discharge air temperature"
    annotation (Placement(transformation(extent={{-100,-70},{-80,-50}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp opeMod(
    final offset=1,
    final height=3,
    final duration=90000) "Operation mode"
    annotation (Placement(transformation(extent={{-100,-120},{-80,-100}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt2
    "Convert real to integer"
    annotation (Placement(transformation(extent={{-20,-120},{0,-100}})));
  Buildings.Controls.OBC.CDL.Continuous.Round round2(
    final n=0)
    "Round real number to given digits"
    annotation (Placement(transformation(extent={{-60,-120},{-40,-100}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp damPos(
    final height=1,
    final duration=3600,
    final offset=0,
    final startTime=5500) "Damper position"
    annotation (Placement(transformation(extent={{-60,-170},{-40,-150}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant VMinOut_flow(
    final k=0.005)
    "Minimum outdoor airflow setpoint"
    annotation (Placement(transformation(extent={{-60,-90},{-40,-70}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp oveFlo(
    final height=3,
    final duration=2000,
    final startTime=1000) "Override flow setpoint"
    annotation (Placement(transformation(extent={{-100,150},{-80,170}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt1
    "Convert real to integer"
    annotation (Placement(transformation(extent={{-20,150},{0,170}})));
  Buildings.Controls.OBC.CDL.Continuous.Round round1(final n=0)
    "Round real number to given digits"
    annotation (Placement(transformation(extent={{-60,150},{-40,170}})));
equation
  connect(VActMin_flow.y, damValFan1.VActMin_flow) annotation (Line(points={{-38,40},
          {44,40},{44,-97},{78,-97}}, color={0,0,127}));
  connect(TZon.y, damValFan1.TZon) annotation (Line(points={{-78,20},{48,20},{48,
          -94},{78,-94}}, color={0,0,127}));
  connect(VActCooMax_flow.y, damValFan1.VActCooMax_flow) annotation (Line(
        points={{-38,80},{56,80},{56,-89},{78,-89}},   color={0,0,127}));
  connect(uCoo.y, damValFan1.uCoo) annotation (Line(points={{-78,100},{60,100},{
          60,-86},{78,-86}}, color={0,0,127}));
  connect(uHea.y, damValFan1.uHea) annotation (Line(points={{-38,-40},{32,-40},{
          32,-105},{78,-105}}, color={0,0,127}));
  connect(disAir.y, damValFan1.VPri_flow) annotation (Line(points={{-38,120},{64,
          120},{64,-83},{78,-83}}, color={0,0,127}));
  connect(TSupSet.y, damValFan1.TSupSet) annotation (Line(points={{-38,0},{40,0},
          {40,-100},{78,-100}},    color={0,0,127}));
  connect(TSup.y, damValFan1.TSup) annotation (Line(points={{-78,60},{52,60},{52,
          -92},{78,-92}}, color={0,0,127}));
  connect(THeaSet.y, damValFan1.THeaSet) annotation (Line(points={{-78,-20},{36,
          -20},{36,-102},{78,-102}},   color={0,0,127}));
  connect(TDis.y, damValFan1.TDis) annotation (Line(points={{-78,-60},{28,-60},{
          28,-108},{78,-108}}, color={0,0,127}));
  connect(opeMod.y,round2. u)
    annotation (Line(points={{-78,-110},{-62,-110}}, color={0,0,127}));
  connect(round2.y,reaToInt2. u)
    annotation (Line(points={{-38,-110},{-22,-110}},
      color={0,0,127}));
  connect(reaToInt2.y, damValFan1.uOpeMod) annotation (Line(points={{2,-110},{20,
          -110},{20,-114},{78,-114}}, color={255,127,0}));
  connect(terFan.y, damValFan1.u1Fan) annotation (Line(points={{-78,-140},{16,-140},
          {16,-117},{78,-117}}, color={255,0,255}));
  connect(damPos.y, damValFan1.uDam) annotation (Line(points={{-38,-160},
          {12,-160},{12,-119},{78,-119}}, color={0,0,127}));
  connect(VMinOut_flow.y, damValFan1.VOAMin_flow) annotation (Line(points={{-38,-80},
          {24,-80},{24,-111},{78,-111}},    color={0,0,127}));
  connect(oveFlo.y,round1. u)
    annotation (Line(points={{-78,160},{-62,160}}, color={0,0,127}));
  connect(round1.y,reaToInt1. u)
    annotation (Line(points={{-38,160},{-22,160}}, color={0,0,127}));
  connect(reaToInt1.y, damValFan1.oveFloSet) annotation (Line(points={{2,160},{68,
          160},{68,-81},{78,-81}}, color={255,127,0}));
annotation (
  experiment(StopTime=7200, Tolerance=1e-6),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/G36/TerminalUnits/SeriesFanVVF/Subsequences/Validation/DamperValves.mos"
        "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.SeriesFanVVF.Subsequences.DamperValves\">
BBuildings.Controls.OBC.ASHRAE.G36.TerminalUnits.SeriesFanVVF.Subsequences.DamperValves</a>
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
