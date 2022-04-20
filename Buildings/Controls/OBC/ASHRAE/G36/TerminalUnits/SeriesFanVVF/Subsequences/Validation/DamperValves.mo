within Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.SeriesFanVVF.Subsequences.Validation;
model DamperValves
  "Validate model for controlling damper and valve position"

  Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.SeriesFanVVF.Subsequences.DamperValves damValFan(
    final maxRat=0.1,
    final kDam=1,
    final V_flow_nominal=0.08) "Output signal for controlling damper position"
    annotation (Placement(transformation(extent={{80,0},{100,40}})));
  Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.SeriesFanVVF.Subsequences.DamperValves damValFan1(
    final maxRat=0.1,
    final have_preIndDam=false,
    final V_flow_nominal=0.08,
    final kDam=1) "Output signal for controlling damper position"
    annotation (Placement(transformation(extent={{80,-100},{100,-60}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp uCoo(
    final height=-1,
    final duration=3600,
    final offset=1,
    final startTime=900) "Cooling control signal"
    annotation (Placement(transformation(extent={{-100,110},{-80,130}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TZon(
    final k=273.15 + 22)
    "Zone temperature"
    annotation (Placement(transformation(extent={{-100,30},{-80,50}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant VActMin_flow(
    final k=0.01) "Active minimum airflow setpoint"
    annotation (Placement(transformation(extent={{-60,50},{-40,70}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant VActCooMax_flow(
    final k=0.075)
    "Active cooling maximum airflow setpoint"
    annotation (Placement(transformation(extent={{-60,90},{-40,110}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse terFan(
    final width=0.75,
    final period=7200) "Terminal fan status"
    annotation (Placement(transformation(extent={{-100,-130},{-80,-110}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TSupSet(
    final k=273.15 + 13)
    "AHU supply air temperature setpoint"
    annotation (Placement(transformation(extent={{-60,10},{-40,30}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp uHea(
    final height=1,
    final duration=3600,
    final offset=0,
    final startTime=5500) "Heating control signal"
    annotation (Placement(transformation(extent={{-60,-30},{-40,-10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp disAir(
    final duration=7200,
    final offset=0.01,
    final height=0.06)
    "Discharge airflow rate"
    annotation (Placement(transformation(extent={{-60,130},{-40,150}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine TSup(
    final offset=273.15 + 13,
    final amplitude=1,
    final freqHz=1/3600)
    "Supply air temperature"
    annotation (Placement(transformation(extent={{-100,70},{-80,90}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant THeaSet(
    final k=273.15 + 20)
    "Zone heating setpoint"
    annotation (Placement(transformation(extent={{-100,-10},{-80,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine TDis(
    final offset=273.15 + 13,
    final amplitude=1.2,
    final freqHz=1/3600) "Measured discharge air temperature"
    annotation (Placement(transformation(extent={{-100,-50},{-80,-30}})));
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
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant VMinOut_flow(
    final k=0.005)
    "Minimum outdoor airflow setpoint"
    annotation (Placement(transformation(extent={{-60,-70},{-40,-50}})));

equation
  connect(uCoo.y, damValFan.uCoo) annotation (Line(points={{-78,120},{60,120},{60,
          36},{78,36}}, color={0,0,127}));
  connect(TZon.y, damValFan.TZon) annotation (Line(points={{-78,40},{48,40},{48,
          27},{78,27}}, color={0,0,127}));
  connect(VActCooMax_flow.y, damValFan.VActCooMax_flow) annotation (Line(points={{-38,100},
          {56,100},{56,33},{78,33}},         color={0,0,127}));
  connect(VActMin_flow.y, damValFan.VActMin_flow) annotation (Line(points={{-38,60},
          {44,60},{44,24},{78,24}},     color={0,0,127}));
  connect(VActMin_flow.y, damValFan1.VActMin_flow) annotation (Line(points={{-38,60},
          {44,60},{44,-76},{78,-76}},     color={0,0,127}));
  connect(TZon.y, damValFan1.TZon) annotation (Line(points={{-78,40},{48,40},{48,
          -73},{78,-73}}, color={0,0,127}));
  connect(VActCooMax_flow.y, damValFan1.VActCooMax_flow) annotation (Line(
        points={{-38,100},{56,100},{56,-67},{78,-67}}, color={0,0,127}));
  connect(uCoo.y, damValFan1.uCoo) annotation (Line(points={{-78,120},{60,120},{
          60,-64},{78,-64}}, color={0,0,127}));
  connect(uHea.y, damValFan.uHea) annotation (Line(points={{-38,-20},{32,-20},{32,
          15},{78,15}}, color={0,0,127}));
  connect(uHea.y, damValFan1.uHea) annotation (Line(points={{-38,-20},{32,-20},{
          32,-85},{78,-85}}, color={0,0,127}));
  connect(disAir.y, damValFan.VPri_flow) annotation (Line(points={{-38,140},{64,
          140},{64,39},{78,39}}, color={0,0,127}));
  connect(disAir.y, damValFan1.VPri_flow) annotation (Line(points={{-38,140},{64,
          140},{64,-61},{78,-61}}, color={0,0,127}));
  connect(TSupSet.y, damValFan.TSupSet) annotation (Line(points={{-38,20},{40,20},
          {40,21},{78,21}}, color={0,0,127}));
  connect(TSupSet.y, damValFan1.TSupSet) annotation (Line(points={{-38,20},{40,20},
          {40,-79},{78,-79}},      color={0,0,127}));
  connect(TSup.y, damValFan.TSup) annotation (Line(points={{-78,80},{52,80},{52,
          30},{78,30}}, color={0,0,127}));
  connect(TSup.y, damValFan1.TSup) annotation (Line(points={{-78,80},{52,80},{52,
          -70},{78,-70}}, color={0,0,127}));
  connect(THeaSet.y, damValFan.THeaSet) annotation (Line(points={{-78,0},{
          36,0},{36,18},{78,18}},    color={0,0,127}));
  connect(THeaSet.y, damValFan1.THeaSet) annotation (Line(points={{-78,0},
          {36,0},{36,-82},{78,-82}},   color={0,0,127}));
  connect(TDis.y, damValFan.TDis) annotation (Line(points={{-78,-40},{28,-40},{28,
          12},{78,12}}, color={0,0,127}));
  connect(TDis.y, damValFan1.TDis) annotation (Line(points={{-78,-40},{28,-40},{
          28,-88},{78,-88}}, color={0,0,127}));
  connect(opeMod.y,round2. u)
    annotation (Line(points={{-78,-90},{-62,-90}},   color={0,0,127}));
  connect(round2.y,reaToInt2. u)
    annotation (Line(points={{-38,-90},{-22,-90}},
      color={0,0,127}));
  connect(reaToInt2.y, damValFan.uOpeMod) annotation (Line(points={{2,-90},{20,-90},
          {20,6},{78,6}},         color={255,127,0}));
  connect(reaToInt2.y, damValFan1.uOpeMod) annotation (Line(points={{2,-90},{20,
          -90},{20,-94},{78,-94}},  color={255,127,0}));
  connect(terFan.y, damValFan.u1Fan) annotation (Line(points={{-78,-120},{16,-120},
          {16,3},{78,3}}, color={255,0,255}));
  connect(terFan.y, damValFan1.u1Fan) annotation (Line(points={{-78,-120},{16,-120},
          {16,-97},{78,-97}}, color={255,0,255}));
  connect(damPos.y, damValFan.uDam_actual) annotation (Line(points={{-38,-140},{
          12,-140},{12,1},{78,1}}, color={0,0,127}));
  connect(damPos.y, damValFan1.uDam_actual) annotation (Line(points={{-38,-140},
          {12,-140},{12,-99},{78,-99}}, color={0,0,127}));
  connect(VMinOut_flow.y, damValFan.VOAMin_flow) annotation (Line(points={{-38,-60},
          {24,-60},{24,9},{78,9}}, color={0,0,127}));
  connect(VMinOut_flow.y, damValFan1.VOAMin_flow) annotation (Line(points={{-38,
          -60},{24,-60},{24,-91},{78,-91}}, color={0,0,127}));
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
    Diagram(coordinateSystem(extent={{-120,-160},{120,160}})));
end DamperValves;
