within Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.Reheat.Subsequences.Validation;
model Alarms "Validation of model that generates alarms"

  Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.Reheat.Subsequences.Alarms ala(
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
    annotation (Placement(transformation(extent={{-60,90},{-40,110}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp disAir(
    final duration=7200,
    final offset=0.1,
    final height=0.3) "Discharge airflow rate"
    annotation (Placement(transformation(extent={{-100,110},{-80,130}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp damPos(
    final duration=7200,
    final height=0.7,
    final offset=0.3) "Damper position"
    annotation (Placement(transformation(extent={{-100,-30},{-80,-10}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse supFan(
    final width=0.75,
    final period=7500) "AHU supply fan status"
    annotation (Placement(transformation(extent={{-100,70},{-80,90}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea
    "Convert boolean input to real output"
    annotation (Placement(transformation(extent={{-60,0},{-40,20}})));
  Buildings.Controls.OBC.CDL.Reals.Multiply mul
    "Damper position"
    annotation (Placement(transformation(extent={{-20,-10},{0,10}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse damSta(
    final width=0.5,
    final period=7500) "Damper open and close status"
    annotation (Placement(transformation(extent={{-100,0},{-80,20}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse hotPla(
    final width=0.9,
    final period=7500) "Hot water plant status"
    annotation (Placement(transformation(extent={{-60,-90},{-40,-70}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp TDis(
    final duration=3600,
    final offset=273.15 + 20,
    final height=-5) "Discharge air temperature"
    annotation (Placement(transformation(extent={{-100,-110},{-80,-90}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp valPos(
    final duration=2000,
    final height=-0.7,
    final offset=0.7,
    final startTime=3600) "Valve position"
    annotation (Placement(transformation(extent={{-60,-50},{-40,-30}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TSup(
    final k=273.15 + 13)
    "AHU supply air temperature"
    annotation (Placement(transformation(extent={{-100,-70},{-80,-50}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TDisSet(
    final k=273.15 + 30)
    "Discharge airflow temperature setpoint"
    annotation (Placement(transformation(extent={{-60,-130},{-40,-110}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Pulse intPul(
    amplitude=6,
    width=0.1,
    period=8500,
    offset=1)
    "Operation mode"
    annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
equation
  connect(disAirSet.y, ala.VActSet_flow) annotation (Line(points={{-38,100},{44,
          100},{44,57},{78,57}}, color={0,0,127}));
  connect(booToRea.y, mul.u1) annotation (Line(points={{-38,10},{-30,10},{-30,6},
          {-22,6}},       color={0,0,127}));
  connect(damPos.y, mul.u2) annotation (Line(points={{-78,-20},{-40,-20},{-40,-6},
          {-22,-6}}, color={0,0,127}));
  connect(damSta.y, booToRea.u)
    annotation (Line(points={{-78,10},{-62,10}}, color={255,0,255}));
  connect(disAir.y, ala.VDis_flow) annotation (Line(points={{-78,120},{48,120},{
          48,59},{78,59}}, color={0,0,127}));
  connect(supFan.y, ala.u1Fan) annotation (Line(points={{-78,80},{40,80},{40,55},
          {78,55}}, color={255,0,255}));
  connect(mul.y, ala.uDam)
    annotation (Line(points={{2,0},{40,0},{40,51},{78,51}}, color={0,0,127}));
  connect(valPos.y, ala.uVal) annotation (Line(points={{-38,-40},{44,-40},{44,49},
          {78,49}},         color={0,0,127}));
  connect(TSup.y, ala.TSup) annotation (Line(points={{-78,-60},{48,-60},{48,47},
          {78,47}}, color={0,0,127}));
  connect(hotPla.y, ala.u1HotPla) annotation (Line(points={{-38,-80},{52,-80},{52,
          45},{78,45}},    color={255,0,255}));
  connect(TDis.y, ala.TDis) annotation (Line(points={{-78,-100},{56,-100},{56,43},
          {78,43}}, color={0,0,127}));
  connect(TDisSet.y, ala.TDisSet) annotation (Line(points={{-38,-120},{60,-120},
          {60,41},{78,41}}, color={0,0,127}));
  connect(intPul.y, ala.uOpeMod) annotation (Line(points={{-38,50},{36,50},{36,53},
          {78,53}}, color={255,127,0}));
annotation (
  experiment(StopTime=7200, Tolerance=1e-6),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/G36/TerminalUnits/Reheat/Subsequences/Validation/Alarms.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.Reheat.Subsequences.Alarms\">
Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.Reheat.Subsequences.Alarms</a>
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
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-120,-140},{120,140}})),
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
