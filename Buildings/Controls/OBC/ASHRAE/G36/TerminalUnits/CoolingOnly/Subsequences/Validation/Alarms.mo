within Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.CoolingOnly.Subsequences.Validation;
model Alarms "Validation of model that generates alarms"

  Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.CoolingOnly.Subsequences.Alarms ala(
    final staPreMul=1,
    final VCooMax_flow=0.5,
    final floHys=0.01,
    final damPosHys=0.01) "Block outputs system alarms"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp disAirSet(
    final height=0.9,
    final duration=7200,
    final offset=0.1) "Discharge airflow rate setpoint"
    annotation (Placement(transformation(extent={{-40,40},{-20,60}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp disAirRate(
    final duration=7200,
    final offset=0.1,
    final height=0.3) "Discharge airflow rate"
    annotation (Placement(transformation(extent={{-80,70},{-60,90}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp damPos(
    final duration=7200,
    final height=0.7,
    final offset=0.3) "Damper position"
    annotation (Placement(transformation(extent={{-80,-90},{-60,-70}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse supFan(
    final width=0.75, final period=7500) "Supply fan status"
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea
    "Convert boolean input to real output"
    annotation (Placement(transformation(extent={{-40,-60},{-20,-40}})));
  Buildings.Controls.OBC.CDL.Continuous.Multiply mul
    "Damper position"
    annotation (Placement(transformation(extent={{0,-70},{20,-50}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse damSta(
    final width=0.5,
    final period=7500)
    "Damper open and close status"
    annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Pulse intPul(
    amplitude=6,
    width=0.1,
    period=8500,
    offset=1)
    "Operation mode"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
equation
  connect(disAirRate.y, ala.VDis_flow) annotation (Line(points={{-58,80},{40,80},
          {40,8},{58,8}},   color={0,0,127}));
  connect(disAirSet.y, ala.VActSet_flow) annotation (Line(points={{-18,50},{30,50},
          {30,4},{58,4}}, color={0,0,127}));
  connect(supFan.y, ala.u1Fan) annotation (Line(points={{-58,30},{10,30},{10,0},
          {58,0}},      color={255,0,255}));
  connect(booToRea.y, mul.u1) annotation (Line(points={{-18,-50},{-10,-50},{-10,
          -54},{-2,-54}}, color={0,0,127}));
  connect(damPos.y, mul.u2) annotation (Line(points={{-58,-80},{-20,-80},{-20,-66},
          {-2,-66}}, color={0,0,127}));
  connect(mul.y, ala.uDam) annotation (Line(points={{22,-60},{40,-60},{
          40,-8},{58,-8}}, color={0,0,127}));
  connect(damSta.y, booToRea.u)
    annotation (Line(points={{-58,-50},{-42,-50}}, color={255,0,255}));
  connect(intPul.y, ala.uOpeMod) annotation (Line(points={{-18,0},{0,0},{0,-4},{
          58,-4}}, color={255,127,0}));
annotation (
  experiment(StopTime=7200, Tolerance=1e-6),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/G36/TerminalUnits/CoolingOnly/Subsequences/Validation/Alarms.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.CoolingOnly.Subsequences.Alarms\">
Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.CoolingOnly.Subsequences.Alarms</a>
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
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
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
