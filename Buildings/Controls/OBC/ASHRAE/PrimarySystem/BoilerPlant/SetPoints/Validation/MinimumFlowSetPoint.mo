within Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.SetPoints.Validation;
model MinimumFlowSetPoint "Validation model for MinimumFlowSetPoint sequence"

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.SetPoints.MinimumFlowSetPoint
    minBoiFloSet(
    final nBoi=2,
    final nSta=3,
    final staMat={{1,0},{0,1},{1,1}},
    final minFloSet={0.1,0.3},
    final maxFloSet={0.25,0.9},
    bypSetRat=0.1)
    "Test minimum flow setpoint reset for stage-up process"
    annotation (Placement(transformation(extent={{70,50},{90,70}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.SetPoints.MinimumFlowSetPoint
    minBoiFloSet1(
    final nBoi=2,
    final nSta=3,
    final staMat={{1,0},{0,1},{1,1}},
    final minFloSet={0.1,0.3},
    final maxFloSet={0.25,0.9},
    bypSetRat=0.1)
    "Test minimum flow setpoint reset for stage-down process"
    annotation (Placement(transformation(extent={{70,-70},{90,-50}})));

  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold truFalHol(
    final trueHoldDuration=5,
    final falseHoldDuration=0)
    "Hold pulse signal for visualization and to generate end of stage change signal"
    annotation (Placement(transformation(extent={{0,30},{20,50}})));

  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold truFalHol1(
    final trueHoldDuration=5,
    final falseHoldDuration=0)
    "Hold pulse signal for visualization and to generate end of stage change signal"
    annotation (Placement(transformation(extent={{0,-90},{20,-70}})));

protected
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Generic.ZeroIndexCorrection
    zerStaIndCor
    "Block to resolve zero index errors"
    annotation (Placement(transformation(extent={{-80,50},{-60,70}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Generic.ZeroIndexCorrection
    zerStaIndCor1
    "Block to resolve zero index errors"
    annotation (Placement(transformation(extent={{-90,-190},{-70,-170}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Generic.ZeroIndexCorrection
    zerStaIndCor2
    "Block to resolve zero index errors"
    annotation (Placement(transformation(extent={{-20,-60},{0,-40}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp ram(
    final height=3,
    final duration=45,
    final offset=0,
    final startTime=0)
    "Ramp source for stage setpoint"
    annotation (Placement(transformation(extent={{-90,10},{-70,30}})));

  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt
    "Real to Integer conversion"
    annotation (Placement(transformation(extent={{-60,10},{-40,30}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con1[3](
    final k={0,1,0})
    "Last boiler being disabled during stage change"
    annotation (Placement(transformation(extent={{-90,90},{-70,110}})));

  Buildings.Controls.OBC.CDL.Routing.RealExtractor extIndSig(
    final nin=3)
    "Extract scalar out of vector"
    annotation (Placement(transformation(extent={{-60,90},{-40,110}})));

  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt1
    "Real to Integer conversion"
    annotation (Placement(transformation(extent={{20,90},{40,110}})));

  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold greThr
    "Check if current stage setpoint involves boilers being turned on and off"
    annotation (Placement(transformation(extent={{-30,60},{-10,80}})));

  Buildings.Controls.OBC.CDL.Integers.Change cha1
    "Detect change in setpoint"
    annotation (Placement(transformation(extent={{-30,30},{-10,50}})));

  Buildings.Controls.OBC.CDL.Logical.FallingEdge falEdg
    "Generate end of stage change signal at end of hold period"
    annotation (Placement(transformation(extent={{30,30},{50,50}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp ram1(
    final height=-3,
    final duration=45,
    final offset=4,
    final startTime=0) "Ramp source for stage setpoint"
    annotation (Placement(transformation(extent={{-90,-110},{-70,-90}})));

  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt2
    "Real to Integer conversion"
    annotation (Placement(transformation(extent={{-60,-110},{-40,-90}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con2[3](
    final k={2,1,0})
    "Last boiler being disabled during stage change"
    annotation (Placement(transformation(extent={{-90,-150},{-70,-130}})));

  Buildings.Controls.OBC.CDL.Routing.RealExtractor extIndSig1(
    final nin=3)
    "Extract scalar out of vector"
    annotation (Placement(transformation(extent={{-60,-150},{-40,-130}})));

  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt3
    "Real to Integer conversion"
    annotation (Placement(transformation(extent={{20,-150},{40,-130}})));

  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold greThr1
    "Check if current stage setpoint involves boilers being turned on and off"
    annotation (Placement(transformation(extent={{20,-30},{40,-10}})));

  Buildings.Controls.OBC.CDL.Integers.Change cha2
    "Detect change in setpoint"
    annotation (Placement(transformation(extent={{-30,-90},{-10,-70}})));

  Buildings.Controls.OBC.CDL.Logical.FallingEdge falEdg1
    "Generate end of stage change signal at end of hold period"
    annotation (Placement(transformation(extent={{30,-90},{50,-70}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con3[3](
    final k={1,0,0})
    "Vector indicating if stage change involves boilers being turned on and off"
    annotation (Placement(transformation(extent={{-90,-30},{-70,-10}})));

  Buildings.Controls.OBC.CDL.Routing.RealExtractor extIndSig2(
    final nin=3)
    "Extract scalar out of vector"
    annotation (Placement(transformation(extent={{-30,-30},{-10,-10}})));

equation
  connect(ram.y, reaToInt.u)
    annotation (Line(points={{-68,20},{-62,20}}, color={0,0,127}));

  connect(reaToInt.y, minBoiFloSet.uStaSet) annotation (Line(points={{-38,20},{64,
          20},{64,54},{68,54}},       color={255,127,0}));

  connect(con1.y, extIndSig.u)
    annotation (Line(points={{-68,100},{-62,100}}, color={0,0,127}));

  connect(reaToInt1.y, minBoiFloSet.uLasDisBoi) annotation (Line(points={{42,100},
          {66,100},{66,66},{68,66}}, color={255,127,0}));

  connect(greThr.y, minBoiFloSet.uOnOff) annotation (Line(points={{-8,70},{60,70},
          {60,62},{68,62}}, color={255,0,255}));

  connect(reaToInt.y, cha1.u) annotation (Line(points={{-38,20},{-36,20},{-36,40},
          {-32,40}}, color={255,127,0}));

  connect(cha1.y, truFalHol.u)
    annotation (Line(points={{-8,40},{-2,40}}, color={255,0,255}));

  connect(truFalHol.y, falEdg.u)
    annotation (Line(points={{22,40},{28,40}}, color={255,0,255}));

  connect(falEdg.y, minBoiFloSet.uStaChaPro) annotation (Line(points={{52,40},{60,
          40},{60,58},{68,58}}, color={255,0,255}));

  connect(ram1.y, reaToInt2.u)
    annotation (Line(points={{-68,-100},{-62,-100}}, color={0,0,127}));

  connect(reaToInt2.y, minBoiFloSet1.uStaSet) annotation (Line(points={{-38,-100},
          {64,-100},{64,-66},{68,-66}}, color={255,127,0}));

  connect(con2.y, extIndSig1.u)
    annotation (Line(points={{-68,-140},{-62,-140}},
                                                   color={0,0,127}));

  connect(reaToInt3.y, minBoiFloSet1.uLasDisBoi) annotation (Line(points={{42,-140},
          {56,-140},{56,-54},{68,-54}},color={255,127,0}));

  connect(greThr1.y, minBoiFloSet1.uOnOff) annotation (Line(points={{42,-20},{60,
          -20},{60,-58},{68,-58}}, color={255,0,255}));

  connect(reaToInt2.y, cha2.u) annotation (Line(points={{-38,-100},{-36,-100},{-36,
          -80},{-32,-80}}, color={255,127,0}));

  connect(cha2.y, truFalHol1.u)
    annotation (Line(points={{-8,-80},{-2,-80}}, color={255,0,255}));

  connect(truFalHol1.y, falEdg1.u)
    annotation (Line(points={{22,-80},{28,-80}}, color={255,0,255}));

  connect(falEdg1.y, minBoiFloSet1.uStaChaPro) annotation (Line(points={{52,-80},
          {60,-80},{60,-62},{68,-62}}, color={255,0,255}));

  connect(con3.y, extIndSig2.u)
    annotation (Line(points={{-68,-20},{-32,-20}}, color={0,0,127}));

  connect(reaToInt.y, zerStaIndCor.uInd) annotation (Line(points={{-38,20},{64,20},
          {64,84},{-90,84},{-90,64},{-82,64}}, color={255,127,0}));
  connect(zerStaIndCor.yIndMod, extIndSig.index)
    annotation (Line(points={{-58,64},{-50,64},{-50,88}}, color={255,127,0}));
  connect(zerStaIndCor.yCapMod, reaToInt1.u) annotation (Line(points={{-58,56},{
          -34,56},{-34,100},{18,100}}, color={0,0,127}));
  connect(zerStaIndCor.yCapMod, greThr.u) annotation (Line(points={{-58,56},{-34,
          56},{-34,70},{-32,70}}, color={0,0,127}));
  connect(extIndSig.y, zerStaIndCor.uCap) annotation (Line(points={{-38,100},{-36,
          100},{-36,80},{-86,80},{-86,56},{-82,56}}, color={0,0,127}));
  connect(reaToInt2.y, zerStaIndCor1.uInd) annotation (Line(points={{-38,-100},{
          -30,-100},{-30,-120},{-96,-120},{-96,-176},{-92,-176}}, color={255,127,
          0}));
  connect(zerStaIndCor1.yIndMod, extIndSig1.index) annotation (Line(points={{-68,
          -176},{-50,-176},{-50,-152}}, color={255,127,0}));
  connect(zerStaIndCor1.yCapMod, reaToInt3.u) annotation (Line(points={{-68,-184},
          {0,-184},{0,-140},{18,-140}}, color={0,0,127}));
  connect(extIndSig1.y, zerStaIndCor1.uCap) annotation (Line(points={{-38,-140},
          {-30,-140},{-30,-196},{-96,-196},{-96,-184},{-92,-184}}, color={0,0,127}));
  connect(reaToInt2.y, zerStaIndCor2.uInd) annotation (Line(points={{-38,-100},{
          -36,-100},{-36,-46},{-22,-46}}, color={255,127,0}));
  connect(zerStaIndCor2.yIndMod, extIndSig2.index) annotation (Line(points={{2,-46},
          {8,-46},{8,-34},{-20,-34},{-20,-32}}, color={255,127,0}));
  connect(extIndSig2.y, zerStaIndCor2.uCap) annotation (Line(points={{-8,-20},{-4,
          -20},{-4,0},{-40,0},{-40,-54},{-22,-54}}, color={0,0,127}));
  connect(zerStaIndCor2.yCapMod, greThr1.u) annotation (Line(points={{2,-54},{12,
          -54},{12,-20},{18,-20}}, color={0,0,127}));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={Ellipse(
                  lineColor = {75,138,73},
                  fillColor={255,255,255},
                  fillPattern = FillPattern.Solid,
                  extent={{-100,-100},{100,100}}),
                Polygon(
                  lineColor = {0,0,255},
                  fillColor = {75,138,73},
                  pattern = LinePattern.None,
                  fillPattern = FillPattern.Solid,
                  points={{-36,60},{64,0},{-36,-60},{-36,60}})}),
    Diagram(coordinateSystem(
      preserveAspectRatio=false, extent={{-100,-220},{100,120}})),
    experiment(
      StopTime=10,
      Interval=1,
      Tolerance=1e-06),
      __Dymola_Commands(file="./Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/BoilerPlant/SetPoints/Validation/MinimumFlowSetPoint.mos"
        "Simulate and plot"),
    Documentation(info="<html>
      <p>
      This example validates
      <a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.SetPoints.MinimumFlowSetPoint\">
      Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.SetPoints.MinimumFlowSetPoint</a>.
      </p>
      </html>", revisions="<html>
      <ul>
      <li>
      September 9, 2020, by Karthik Devaprasad:<br/>
      First implementation.
      </li>
      </ul>
      </html>"));
end MinimumFlowSetPoint;
