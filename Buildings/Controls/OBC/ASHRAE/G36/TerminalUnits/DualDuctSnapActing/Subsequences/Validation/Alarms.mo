within Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.DualDuctSnapActing.Subsequences.Validation;
model Alarms "Validation of model that generates alarms"

  Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.DualDuctSnapActing.Subsequences.Alarms ala(
    final have_duaSen=true,
    final staPreMul=1,
    final VCooMax_flow=1,
    final VHeaMax_flow=0.9,
    final floHys=0.01,
    final damPosHys=0.01) "Block outputs system alarms"
    annotation (Placement(transformation(extent={{80,40},{100,80}})));
  Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.DualDuctSnapActing.Subsequences.Alarms ala1(
    final have_duaSen=false,
    final staPreMul=1,
    final VCooMax_flow=1,
    final VHeaMax_flow=0.9,
    final floHys=0.01,
    final damPosHys=0.01) "Block outputs system alarms"
    annotation (Placement(transformation(extent={{80,-60},{100,-20}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp disAirSet(
    final height=0.9,
    final duration=7200,
    final offset=0.1) "Discharge airflow rate setpoint"
    annotation (Placement(transformation(extent={{-100,120},{-80,140}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp cooDisAir(
    final duration=7200,
    final offset=0.1,
    final height=0.3) "Cooling duct discharge airflow rate"
    annotation (Placement(transformation(extent={{-60,100},{-40,120}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp damPos(
    final duration=7200,
    final height=0.7,
    final offset=0.3) "Damper position"
    annotation (Placement(transformation(extent={{-100,-40},{-80,-20}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse supCooFan(
    final width=0.75,
    final period=7500) "Cooling supply fan status"
    annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea
    "Convert boolean input to real output"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Multiply mul
    "Damper position"
    annotation (Placement(transformation(extent={{-20,-20},{0,0}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse colDammSta(
    final width=0.5,
    final period=7500) "Cooling duct damper open and close status"
    annotation (Placement(transformation(extent={{-100,-10},{-80,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp damPos1(
    final duration=7200,
    final height=0.7,
    final offset=0.3) "Damper position"
    annotation (Placement(transformation(extent={{-100,-140},{-80,-120}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse supHeaFan(
    final width=0.75,
    final period=7500)
    "Heating supply fan status"
    annotation (Placement(transformation(extent={{-100,-80},{-80,-60}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea1
    "Convert boolean input to real output"
    annotation (Placement(transformation(extent={{-60,-110},{-40,-90}})));
  Buildings.Controls.OBC.CDL.Continuous.Multiply  mul1
    "Damper position"
    annotation (Placement(transformation(extent={{-20,-120},{0,-100}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse heaDammSta(
    final width=0.5,
    final period=7500)
    "Heating duct damper open and close status"
    annotation (Placement(transformation(extent={{-100,-110},{-80,-90}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp heaDisAir(
    final duration=7200,
    final offset=0.1,
    final height=0.3) "Heating duct discharge airflow rate"
    annotation (Placement(transformation(extent={{-60,-60},{-40,-40}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Pulse intPul(
    amplitude=6,
    width=0.1,
    period=8500,
    offset=1)
    "Operation mode"
    annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
equation
  connect(disAirSet.y, ala.VActSet_flow) annotation (Line(points={{-78,130},{60,
          130},{60,75},{78,75}}, color={0,0,127}));
  connect(booToRea.y, mul.u1) annotation (Line(points={{-38,0},{-30,0},{-30,-4},
          {-22,-4}},      color={0,0,127}));
  connect(damPos.y, mul.u2) annotation (Line(points={{-78,-30},{-40,-30},{-40,-16},
          {-22,-16}},color={0,0,127}));
  connect(colDammSta.y, booToRea.u)
    annotation (Line(points={{-78,0},{-62,0}},   color={255,0,255}));
  connect(booToRea1.y, mul1.u1) annotation (Line(points={{-38,-100},{-30,-100},{
          -30,-104},{-22,-104}}, color={0,0,127}));
  connect(damPos1.y, mul1.u2) annotation (Line(points={{-78,-130},{-40,-130},{-40,
          -116},{-22,-116}}, color={0,0,127}));
  connect(heaDammSta.y, booToRea1.u)
    annotation (Line(points={{-78,-100},{-62,-100}}, color={255,0,255}));
  connect(supCooFan.y, ala.u1CooFan) annotation (Line(points={{-78,90},{32,90},{
          32,65},{78,65}}, color={255,0,255}));
  connect(mul.y, ala.uCooDam) annotation (Line(points={{2,-10},{36,-10},{36,62},
          {78,62}},        color={0,0,127}));
  connect(supHeaFan.y, ala.u1HeaFan) annotation (Line(points={{-78,-70},{44,-70},
          {44,46},{78,46}}, color={255,0,255}));
  connect(mul1.y, ala.uHeaDam) annotation (Line(points={{2,-110},{48,-110},{48,43},
          {78,43}},         color={0,0,127}));
  connect(cooDisAir.y, ala.VColDucDis_flow) annotation (Line(points={{-38,110},{
          56,110},{56,68},{78,68}}, color={0,0,127}));
  connect(heaDisAir.y, ala.VHotDucDis_flow) annotation (Line(points={{-38,-50},{
          40,-50},{40,49},{78,49}}, color={0,0,127}));
  connect(supCooFan.y, ala1.u1CooFan) annotation (Line(points={{-78,90},{32,90},
          {32,-35},{78,-35}},color={255,0,255}));
  connect(mul.y, ala1.uCooDam) annotation (Line(points={{2,-10},{36,-10},{36,-38},
          {78,-38}},         color={0,0,127}));
  connect(supHeaFan.y, ala1.u1HeaFan) annotation (Line(points={{-78,-70},{44,-70},
          {44,-54},{78,-54}}, color={255,0,255}));
  connect(mul1.y, ala1.uHeaDam) annotation (Line(points={{2,-110},{48,-110},{48,
          -57},{78,-57}},     color={0,0,127}));
  connect(disAirSet.y, ala1.VActSet_flow) annotation (Line(points={{-78,130},{60,
          130},{60,-25},{78,-25}}, color={0,0,127}));
  connect(cooDisAir.y, ala1.VDis_flow) annotation (Line(points={{-38,110},{56,110},
          {56,-22},{78,-22}}, color={0,0,127}));
  connect(intPul.y, ala.uOpeMod) annotation (Line(points={{-38,50},{28,50},{28,72},
          {78,72}}, color={255,127,0}));
  connect(intPul.y, ala1.uOpeMod) annotation (Line(points={{-38,50},{28,50},{28,
          -28},{78,-28}}, color={255,127,0}));
annotation (
  experiment(StopTime=7200, Tolerance=1e-6),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/G36/TerminalUnits/DualDuctSnapActing/Subsequences/Validation/Alarms.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.DualDuctSnapActing.Subsequences.Alarms\">
Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.DualDuctSnapActing.Subsequences.Alarms</a>
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
