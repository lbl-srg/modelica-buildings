within Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.DualDuctColdDuctMin.Subsequences.Validation;
model Alarms "Validation of model that generates alarms"

  Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.DualDuctColdDuctMin.Subsequences.Alarms ala(
    final staPreMul=1,
    final VCooMax_flow=1,
    final VHeaMax_flow=0.9,
    final floHys=0.01,
    final damPosHys=0.01) "Block outputs system alarms"
    annotation (Placement(transformation(extent={{60,30},{80,50}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp disAirSet(
    final height=0.9,
    final duration=7200,
    final offset=0.1) "Discharge airflow rate setpoint"
    annotation (Placement(transformation(extent={{-80,130},{-60,150}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp cooDisAir(
    final duration=7200,
    final offset=0.1,
    final height=0.3) "Cooling duct discharge airflow rate"
    annotation (Placement(transformation(extent={{-80,70},{-60,90}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp damPos(
    final duration=7200,
    final height=0.7,
    final offset=0.3) "Damper position"
    annotation (Placement(transformation(extent={{-80,-30},{-60,-10}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse supCooFan(
    final width=0.75,
    final period=7500) "Cooling supply fan status"
    annotation (Placement(transformation(extent={{-40,100},{-20,120}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea
    "Convert boolean input to real output"
    annotation (Placement(transformation(extent={{-40,10},{-20,30}})));
  Buildings.Controls.OBC.CDL.Reals.Multiply mul
    "Damper position"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse colDammSta(
    final width=0.5,
    final period=7500) "Cooling duct damper open and close status"
    annotation (Placement(transformation(extent={{-80,10},{-60,30}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp damPos1(
    final duration=7200,
    final height=0.7,
    final offset=0.3) "Damper position"
    annotation (Placement(transformation(extent={{-80,-150},{-60,-130}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse supHeaFan(
    final width=0.75,
    final period=7500)
    "Heating supply fan status"
    annotation (Placement(transformation(extent={{-80,-70},{-60,-50}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea1
    "Convert boolean input to real output"
    annotation (Placement(transformation(extent={{-40,-110},{-20,-90}})));
  Buildings.Controls.OBC.CDL.Reals.Multiply  mul1
    "Damper position"
    annotation (Placement(transformation(extent={{0,-130},{20,-110}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse heaDammSta(
    final width=0.5,
    final period=7500)
    "Heating duct damper open and close status"
    annotation (Placement(transformation(extent={{-80,-110},{-60,-90}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp heaDisAir(
    final duration=7200,
    final offset=0.1,
    final height=0.3) "Heating duct discharge airflow rate"
    annotation (Placement(transformation(extent={{-40,-50},{-20,-30}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Pulse intPul(
    amplitude=6,
    width=0.1,
    period=8500,
    offset=1)
    "Operation mode"
    annotation (Placement(transformation(extent={{-40,50},{-20,70}})));
equation
  connect(disAirSet.y, ala.VActSet_flow) annotation (Line(points={{-58,140},{40,
          140},{40,49},{58,49}}, color={0,0,127}));
  connect(booToRea.y, mul.u1) annotation (Line(points={{-18,20},{-10,20},{-10,6},
          {-2,6}},        color={0,0,127}));
  connect(damPos.y, mul.u2) annotation (Line(points={{-58,-20},{-20,-20},{-20,-6},
          {-2,-6}},  color={0,0,127}));
  connect(colDammSta.y, booToRea.u)
    annotation (Line(points={{-58,20},{-42,20}}, color={255,0,255}));
  connect(booToRea1.y, mul1.u1) annotation (Line(points={{-18,-100},{-10,-100},
          {-10,-114},{-2,-114}},
                          color={0,0,127}));
  connect(damPos1.y, mul1.u2) annotation (Line(points={{-58,-140},{-20,-140},{
          -20,-126},{-2,-126}},
                            color={0,0,127}));
  connect(heaDammSta.y, booToRea1.u)
    annotation (Line(points={{-58,-100},{-42,-100}},
                                                   color={255,0,255}));
  connect(supCooFan.y, ala.u1CooFan) annotation (Line(points={{-18,110},{32,110},
          {32,44},{58,44}}, color={255,0,255}));
  connect(mul.y, ala.uCooDam) annotation (Line(points={{22,0},{32,0},{32,38},{58,
          38}},     color={0,0,127}));
  connect(supHeaFan.y, ala.u1HeaFan) annotation (Line(points={{-58,-60},{40,-60},
          {40,34},{58,34}}, color={255,0,255}));
  connect(mul1.y, ala.uHeaDam) annotation (Line(points={{22,-120},{44,-120},{44,
          32},{58,32}}, color={0,0,127}));
  connect(cooDisAir.y, ala.VColDucDis_flow) annotation (Line(points={{-58,80},{
          36,80},{36,46},{58,46}},  color={0,0,127}));
  connect(heaDisAir.y, ala.VHotDucDis_flow) annotation (Line(points={{-18,-40},{
          36,-40},{36,36},{58,36}}, color={0,0,127}));
  connect(intPul.y, ala.uOpeMod) annotation (Line(points={{-18,60},{20,60},{20,
          41},{58,41}},
                    color={255,127,0}));
annotation (
  experiment(StopTime=7200, Tolerance=1e-6),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/G36/TerminalUnits/DualDuctColdDuctMin/Subsequences/Validation/Alarms.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.DualDuctColdDuctMin.Subsequences.Alarms\">
Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.DualDuctColdDuctMin.Subsequences.Alarms</a>
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
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-160},{100,160}})),
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
