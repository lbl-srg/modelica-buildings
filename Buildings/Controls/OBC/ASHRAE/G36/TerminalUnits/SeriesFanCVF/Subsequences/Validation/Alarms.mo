within Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.SeriesFanCVF.Subsequences.Validation;
model Alarms "Validation of model that generates alarms"

  Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.SeriesFanCVF.Subsequences.Alarms ala(
    final staPreMul=1,
    final hotWatRes=1,
    final VCooMax_flow=1,
    final floHys=0.01,
    final damPosHys=0.01) "Block outputs system alarms"
    annotation (Placement(transformation(extent={{80,40},{100,60}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp disAirSet(
    final height=0.9,
    final duration=7200,
    final offset=0.1) "Discharge airflow rate setpoint"
    annotation (Placement(transformation(extent={{-60,110},{-40,130}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp disAir(
    final duration=7200,
    final offset=0.1,
    final height=0.3) "Discharge airflow rate"
    annotation (Placement(transformation(extent={{-100,130},{-80,150}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp damPos(
    final duration=7200,
    final height=0.7,
    final offset=0.3) "Damper position"
    annotation (Placement(transformation(extent={{-100,-40},{-80,-20}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse supFan(
    final width=0.75,
    final period=7500) "AHU supply fan status"
    annotation (Placement(transformation(extent={{-100,90},{-80,110}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea
    "Convert boolean input to real output"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Buildings.Controls.OBC.CDL.Reals.Multiply mul
    "Damper position"
    annotation (Placement(transformation(extent={{-20,-20},{0,0}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse damSta(
    final width=0.5,
    final period=7500) "Damper open and close status"
    annotation (Placement(transformation(extent={{-100,-10},{-80,10}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse hotPla(
    final width=0.9,
    final period=7500) "Hot water plant status"
    annotation (Placement(transformation(extent={{-60,-100},{-40,-80}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp TDis(
    final duration=3600,
    final offset=273.15 + 20,
    final height=-5) "Discharge air temperature"
    annotation (Placement(transformation(extent={{-100,-130},{-80,-110}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse terFanComOn(
    final width=0.5,
    final period=7500)
    "Terminal fan command on status"
    annotation (Placement(transformation(extent={{-60,70},{-40,90}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse terFanOn(
    final width=0.5,
    final period=7500,
    shift=1000) "Terminal fan status"
    annotation (Placement(transformation(extent={{-100,50},{-80,70}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp valPos(
    final duration=2000,
    final height=-0.7,
    final offset=0.7,
    final startTime=3600) "Valve position"
    annotation (Placement(transformation(extent={{-60,-60},{-40,-40}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TSup(
    final k=273.15 + 13)
    "AHU supply air temperature"
    annotation (Placement(transformation(extent={{-100,-80},{-80,-60}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TDisSet(
    final k=273.15 + 30)
    "Discharge airflow temperature setpoint"
    annotation (Placement(transformation(extent={{-60,-150},{-40,-130}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Pulse intPul(
    amplitude=6,
    width=0.1,
    period=8500,
    offset=1)
    "Operation mode"
    annotation (Placement(transformation(extent={{-60,30},{-40,50}})));
equation
  connect(disAirSet.y, ala.VActSet_flow) annotation (Line(points={{-38,120},{44,
          120},{44,59},{78,59}}, color={0,0,127}));
  connect(booToRea.y, mul.u1) annotation (Line(points={{-38,0},{-30,0},{-30,-4},
          {-22,-4}},      color={0,0,127}));
  connect(damPos.y, mul.u2) annotation (Line(points={{-78,-30},{-40,-30},{-40,-16},
          {-22,-16}},color={0,0,127}));
  connect(damSta.y, booToRea.u)
    annotation (Line(points={{-78,0},{-62,0}},   color={255,0,255}));
  connect(disAir.y,ala.VPri_flow)  annotation (Line(points={{-78,140},{48,140},
          {48,61},{78,61}},color={0,0,127}));
  connect(supFan.y, ala.u1Fan) annotation (Line(points={{-78,100},{40,100},{40,57},
          {78,57}}, color={255,0,255}));
  connect(terFanComOn.y, ala.u1FanCom) annotation (Line(points={{-38,80},{36,80},
          {36,55},{78,55}}, color={255,0,255}));
  connect(terFanOn.y, ala.u1TerFan) annotation (Line(points={{-78,60},{32,60},{
          32,53},{78,53}}, color={255,0,255}));
  connect(mul.y, ala.uDam)
    annotation (Line(points={{2,-10},{40,-10},{40,49},{78,49}}, color={0,0,127}));
  connect(valPos.y, ala.uVal) annotation (Line(points={{-38,-50},{44,-50},{44,
          47},{78,47}},
                    color={0,0,127}));
  connect(TSup.y, ala.TSup) annotation (Line(points={{-78,-70},{48,-70},{48,45},
          {78,45}}, color={0,0,127}));
  connect(hotPla.y, ala.u1HotPla) annotation (Line(points={{-38,-90},{52,-90},{
          52,43},{78,43}}, color={255,0,255}));
  connect(TDis.y, ala.TDis) annotation (Line(points={{-78,-120},{56,-120},{56,
          41},{78,41}},
                    color={0,0,127}));
  connect(TDisSet.y, ala.TDisSet) annotation (Line(points={{-38,-140},{60,-140},
          {60,39},{78,39}}, color={0,0,127}));
  connect(intPul.y, ala.uOpeMod) annotation (Line(points={{-38,40},{36,40},{36,51},
          {78,51}}, color={255,127,0}));
annotation (
  experiment(StopTime=7200, Tolerance=1e-6),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/G36/TerminalUnits/SeriesFanCVF/Subsequences/Validation/Alarms.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.SeriesFanCVF.Subsequences.Alarms\">
Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.SeriesFanCVF.Subsequences.Alarms</a>
for generating system alarms.
</p>
</html>", revisions="<html>
<ul>
<li>
February 10, 2022, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"),
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-120,-160},{120,160}})),
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
end Alarms;
