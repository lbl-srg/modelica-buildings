within Buildings.Controls.OBC.ASHRAE.G36_PR1.TerminalUnits.SetPoints.Validation;
model ZoneTemperatures "Validate block for zone set point"
  Buildings.Controls.OBC.ASHRAE.G36_PR1.TerminalUnits.SetPoints.ZoneTemperatures
    TZonSet(
    final have_occSen=true,
    final sinAdj=false,
    final cooAdj=true,
    final have_winSen=true,
    final heaAdj=true) "Block that determines the thermal zone setpoints"
    annotation (Placement(transformation(extent={{100,52},{120,80}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TZonCooSetOcc(
    final k=297.15)
    "Occupied cooling setpoint"
    annotation (Placement(transformation(extent={{-80,80},{-60,100}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TZonHeaSetOcc(
    final k=293.15)
    "Occupied heating setpoint"
    annotation (Placement(transformation(extent={{-40,80},{-20,100}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TZonCooSetUno(
    final k=303.15)
    "Unoccupied cooling setpoint"
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TZonHeaSetUno(
    final k=287.15)
    "Unoccupied heating setpoint"
    annotation (Placement(transformation(extent={{-40,40},{-20,60}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine cooSetAdj(
    final freqHz=1/28800)
    "Cooling setpoint adjustment"
    annotation (Placement(transformation(extent={{-80,10},{-60,30}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine heaSetAdj(
    final freqHz=1/28800,
    final amplitude=0.5)
    "Heating setpoint adjustment"
    annotation (Placement(transformation(extent={{-80,-30},{-60,-10}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant cooDemLimLev(
    final k=0)
    "Cooling demand limit level"
    annotation (Placement(transformation(extent={{-120,-70},{-100,-50}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant heaDemLimLev(
    final k=0)
    "Heating demand limit level"
    annotation (Placement(transformation(extent={{-40,-70},{-20,-50}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp ram(
    final duration=28800)
    "Generate ramp output"
    annotation (Placement(transformation(extent={{-120,-100},{-100,-80}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greThr(
    final t=0.75)
    "Check if input is greater than 0.75"
    annotation (Placement(transformation(extent={{-80,-100},{-60,-80}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt(
    final integerTrue=1,
    final integerFalse=7)
    "Convert boolean input to integer output"
    annotation (Placement(transformation(extent={{0,-100},{20,-80}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse winSta(
    final period=14400,
    final shift=1200)
    "Generate signal indicating window status"
    annotation (Placement(transformation(extent={{60,-30},{80,-10}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse occSta(
    final period=14400,
    final width=0.95)
    "Generate signal indicating occupancy status"
    annotation (Placement(transformation(extent={{60,10},{80,30}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1 "Logical not"
    annotation (Placement(transformation(extent={{-40,-100},{-20,-80}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zerAdj(
    final k=0)
    "Zero adjustment"
    annotation (Placement(transformation(extent={{-120,-10},{-100,10}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi1
    "Switch to zero adjustment when window is open"
    annotation (Placement(transformation(extent={{-20,-30},{0,-10}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi2
    "Switch to zero adjustment when window is open"
    annotation (Placement(transformation(extent={{-20,10},{0,30}})));

equation
  connect(ram.y, greThr.u)
    annotation (Line(points={{-98,-90},{-82,-90}},   color={0,0,127}));
  connect(greThr.y, not1.u)
    annotation (Line(points={{-58,-90},{-42,-90}}, color={255,0,255}));
  connect(not1.y, booToInt.u)
    annotation (Line(points={{-18,-90},{-2,-90}},  color={255,0,255}));
  connect(TZonCooSetOcc.y, TZonSet.TZonCooSetOcc) annotation (Line(points={{-58,90},
          {-52,90},{-52,108},{50,108},{50,75},{98,75}}, color={0,0,127}));
  connect(TZonHeaSetOcc.y, TZonSet.TZonHeaSetOcc) annotation (Line(points={{-18,90},
          {46,90},{46,70},{98,70}}, color={0,0,127}));
  connect(TZonCooSetUno.y, TZonSet.TZonCooSetUno) annotation (Line(points={{-58,50},
          {-52,50},{-52,73},{98,73}}, color={0,0,127}));
  connect(TZonHeaSetUno.y, TZonSet.TZonHeaSetUno) annotation (Line(points={{-18,50},
          {-12,50},{-12,68},{98,68}}, color={0,0,127}));
  connect(cooDemLimLev.y, TZonSet.uCooDemLimLev)
    annotation (Line(points={{-98,-60},{-80,-60},{-80,-40},{42,-40},{42,60},
      {98,60}}, color={255,127,0}));
  connect(heaDemLimLev.y, TZonSet.uHeaDemLimLev)
    annotation (Line(points={{-18,-60},{46,-60},{46,58},{98,58}},
      color={255,127,0}));
  connect(booToInt.y, TZonSet.uOpeMod)
    annotation (Line(points={{22,-90},{38,-90},{38,79},{98,79}},
      color={255,127,0}));
  connect(winSta.y, swi2.u2)
    annotation (Line(points={{82,-20},{92,-20},{92,0},{-40,0},{-40,20},{-22,20}},
      color={255,0,255}));
  connect(winSta.y, swi1.u2)
    annotation (Line(points={{82,-20},{92,-20},{92,0},{-40,0},{-40,-20},{-22,-20}},
      color={255,0,255}));
  connect(zerAdj.y, swi2.u1)
    annotation (Line(points={{-98,0},{-44,0},{-44,28},{-22,28}},
      color={0,0,127}));
  connect(zerAdj.y, swi1.u1)
    annotation (Line(points={{-98,0},{-44,0},{-44,-12},{-22,-12}},
      color={0,0,127}));
  connect(cooSetAdj.y, swi2.u3)
    annotation (Line(points={{-58,20},{-48,20},{-48,12},{-22,12}},
      color={0,0,127}));
  connect(heaSetAdj.y, swi1.u3)
    annotation (Line(points={{-58,-20},{-48,-20},{-48,-28},{-22,-28}},
      color={0,0,127}));
  connect(swi2.y, TZonSet.setAdj)
    annotation (Line(points={{2,20},{18,20},{18,65},{98,65}},
      color={0,0,127}));
  connect(swi1.y, TZonSet.heaSetAdj)
    annotation (Line(points={{2,-20},{22,-20},{22,63},{98,63}},
      color={0,0,127}));
  connect(occSta.y, TZonSet.uOccSen)
    annotation (Line(points={{82,20},{86,20},{86,55},{98,55}}, color={255,0,255}));
  connect(winSta.y, TZonSet.uWinSta)
    annotation (Line(points={{82,-20},{92,-20},{92,53},{98,53}}, color={255,0,255}));

annotation (
  experiment(StopTime=28800, Tolerance=1e-6),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/G36_PR1/TerminalUnits/SetPoints/Validation/ZoneTemperatures.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36_PR1.TerminalUnits.SetPoints.ZoneTemperatures\">
Buildings.Controls.OBC.ASHRAE.G36_PR1.TerminalUnits.SetPoints.ZoneTemperatures</a>
for a change of zone setpoint temperature.
</p>
</html>", revisions="<html>
<ul>
<li>
August 19, 2017, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(extent={{-140,-120},{140,120}})),
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
          points={{-36,58},{64,-2},{-36,-62},{-36,58}})}));
end ZoneTemperatures;
