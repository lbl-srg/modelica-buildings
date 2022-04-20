within Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.SeriesFanCVF.Subsequences.Validation;
model DamperValves
  "Validate model for controlling damper and valve position"

  Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.SeriesFanCVF.Subsequences.DamperValves damValFan(
    final kDam=1,
    final V_flow_nominal=0.08) "Output signal for controlling damper position"
    annotation (Placement(transformation(extent={{80,0},{100,40}})));
  Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.SeriesFanCVF.Subsequences.DamperValves damValFan1(
    final have_preIndDam=false,
    final V_flow_nominal=0.08,
    final kDam=1) "Output signal for controlling damper position"
    annotation (Placement(transformation(extent={{80,-100},{100,-60}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp uCoo(
    final height=-1,
    final duration=3600,
    final offset=1,
    final startTime=900) "Cooling control signal"
    annotation (Placement(transformation(extent={{-100,100},{-80,120}})));
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
    annotation (Placement(transformation(extent={{-60,80},{-40,100}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse terFan(
    final width=0.75,
    final period=7200) "Terminal fan status"
    annotation (Placement(transformation(extent={{-100,-130},{-80,-110}})));
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
    annotation (Placement(transformation(extent={{-60,120},{-40,140}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine TSup(
    final offset=273.15 + 13,
    final amplitude=1,
    final freqHz=1/3600)
    "Supply air temperature"
    annotation (Placement(transformation(extent={{-100,60},{-80,80}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant THeaSet(
    final k=273.15 + 20)
    "Zone heating setpoint"
    annotation (Placement(transformation(extent={{-100,-30},{-80,-10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine TDis(
    final offset=273.15 + 13,
    final amplitude=1.2,
    final freqHz=1/3600) "Measured discharge air temperature"
    annotation (Placement(transformation(extent={{-100,-70},{-80,-50}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp opeMod(
    final offset=1,
    final height=3,
    final duration=90000) "Operation mode"
    annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt2
    "Convert real to integer"
    annotation (Placement(transformation(extent={{-20,-100},{0,-80}})));
  Buildings.Controls.OBC.CDL.Continuous.Round round2(
    final n=0)
    "Round real number to given digits"
    annotation (Placement(transformation(extent={{-60,-100},{-40,-80}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp damPos(
    final height=1,
    final duration=3600,
    final offset=0,
    final startTime=5500) "Damper position"
    annotation (Placement(transformation(extent={{-60,-150},{-40,-130}})));

equation
  connect(uCoo.y, damValFan.uCoo) annotation (Line(points={{-78,110},{60,110},{60,
          36},{78,36}}, color={0,0,127}));
  connect(TZon.y, damValFan.TZon) annotation (Line(points={{-78,20},{48,20},{48,
          27},{78,27}}, color={0,0,127}));
  connect(VActCooMax_flow.y, damValFan.VActCooMax_flow) annotation (Line(points={{-38,90},
          {56,90},{56,33},{78,33}},          color={0,0,127}));
  connect(VActMin_flow.y, damValFan.VActMin_flow) annotation (Line(points={{-38,40},
          {44,40},{44,24},{78,24}},     color={0,0,127}));
  connect(VActMin_flow.y, damValFan1.VActMin_flow) annotation (Line(points={{-38,40},
          {44,40},{44,-76},{78,-76}},     color={0,0,127}));
  connect(TZon.y, damValFan1.TZon) annotation (Line(points={{-78,20},{48,20},{48,
          -73},{78,-73}}, color={0,0,127}));
  connect(VActCooMax_flow.y, damValFan1.VActCooMax_flow) annotation (Line(
        points={{-38,90},{56,90},{56,-67},{78,-67}}, color={0,0,127}));
  connect(uCoo.y, damValFan1.uCoo) annotation (Line(points={{-78,110},{60,110},{
          60,-64},{78,-64}}, color={0,0,127}));
  connect(uHea.y, damValFan.uHea) annotation (Line(points={{-38,-40},{32,-40},{32,
          14},{78,14}}, color={0,0,127}));
  connect(uHea.y, damValFan1.uHea) annotation (Line(points={{-38,-40},{32,-40},{
          32,-86},{78,-86}}, color={0,0,127}));
  connect(disAir.y,damValFan.VPri_flow)  annotation (Line(points={{-38,130},{64,
          130},{64,39},{78,39}}, color={0,0,127}));
  connect(disAir.y,damValFan1.VPri_flow)  annotation (Line(points={{-38,130},{64,
          130},{64,-61},{78,-61}}, color={0,0,127}));
  connect(TSupSet.y, damValFan.TSupSet) annotation (Line(points={{-38,0},{40,0},
          {40,20},{78,20}}, color={0,0,127}));
  connect(TSupSet.y, damValFan1.TSupSet) annotation (Line(points={{-38,0},{40,0},
          {40,-80},{78,-80}},      color={0,0,127}));
  connect(TSup.y, damValFan.TSup) annotation (Line(points={{-78,70},{52,70},{52,
          30},{78,30}}, color={0,0,127}));
  connect(TSup.y, damValFan1.TSup) annotation (Line(points={{-78,70},{52,70},{52,
          -70},{78,-70}}, color={0,0,127}));
  connect(THeaSet.y, damValFan.THeaSet) annotation (Line(points={{-78,-20},
          {36,-20},{36,17},{78,17}}, color={0,0,127}));
  connect(THeaSet.y, damValFan1.THeaSet) annotation (Line(points={{-78,-20},
          {36,-20},{36,-83},{78,-83}}, color={0,0,127}));
  connect(TDis.y, damValFan.TDis) annotation (Line(points={{-78,-60},{28,-60},{28,
          11},{78,11}}, color={0,0,127}));
  connect(TDis.y, damValFan1.TDis) annotation (Line(points={{-78,-60},{28,-60},{
          28,-89},{78,-89}}, color={0,0,127}));
  connect(opeMod.y,round2. u)
    annotation (Line(points={{-78,-90},{-62,-90}},   color={0,0,127}));
  connect(round2.y,reaToInt2. u)
    annotation (Line(points={{-38,-90},{-22,-90}},
      color={0,0,127}));
  connect(reaToInt2.y, damValFan.uOpeMod) annotation (Line(points={{2,-90},{24,-90},
          {24,8},{78,8}},         color={255,127,0}));
  connect(reaToInt2.y, damValFan1.uOpeMod) annotation (Line(points={{2,-90},{24,
          -90},{24,-92},{78,-92}},  color={255,127,0}));
  connect(terFan.y, damValFan.u1Fan) annotation (Line(points={{-78,-120},{20,-120},
          {20,5},{78,5}}, color={255,0,255}));
  connect(terFan.y, damValFan1.u1Fan) annotation (Line(points={{-78,-120},{20,-120},
          {20,-95},{78,-95}}, color={255,0,255}));
  connect(damPos.y, damValFan.uDam_actual) annotation (Line(points={{-38,-140},
          {16,-140},{16,1},{78,1}}, color={0,0,127}));
  connect(damPos.y, damValFan1.uDam_actual) annotation (Line(points={{-38,-140},
          {16,-140},{16,-99},{78,-99}}, color={0,0,127}));
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
    Diagram(coordinateSystem(extent={{-120,-160},{120,160}})));
end DamperValves;
