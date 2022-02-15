within Buildings.Controls.OBC.ASHRAE.FanCoilUnit.Subsequences;
block FanSpeed

  parameter Real deaSpe = 0.1
    "Deadband mode fan speed";

  parameter Real heaSpeMin = 0.1
    "Deadband mode fan speed";

  parameter Real heaPerMin
    "Minimum heating loop signal at which fan speed";

  CDL.Interfaces.BooleanInput uFanPro "Fan proven on signal"
    annotation (Placement(transformation(extent={{-140,0},{-100,40}})));
  CDL.Interfaces.IntegerInput opeMod "System operating mode"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}})));
  CDL.Interfaces.BooleanOutput yFan "Fan enable signal"
    annotation (Placement(transformation(extent={{120,20},{160,60}})));
  CDL.Integers.Equal intEqu "Check if zone is unoccupied"
    annotation (Placement(transformation(extent={{-40,50},{-20,70}})));
  CDL.Integers.Sources.Constant conInt(k=Buildings.Controls.OBC.ASHRAE.G36_PR1.Types.OperationModes.unoccupied)
    "Constant unoccupied mode signal"
    annotation (Placement(transformation(extent={{-80,30},{-60,50}})));
  CDL.Logical.Not not1 "Enable only if zone is not in unoccupied mode"
    annotation (Placement(transformation(extent={{-10,50},{10,70}})));
  CDL.Continuous.Switch swi
    annotation (Placement(transformation(extent={{80,-10},{100,10}})));
  CDL.Conversions.BooleanToReal booToRea "Convert fan enable signal to Real"
    annotation (Placement(transformation(extent={{50,-30},{70,-10}})));
  CDL.Interfaces.RealInput uHea "Heating loop signal"
    annotation (Placement(transformation(extent={{-140,-40},{-100,0}})));
  CDL.Interfaces.RealInput uCoo "Cooling loop signal"
    annotation (Placement(transformation(extent={{-140,-120},{-100,-80}})));
  CDL.Continuous.Line lin "Heating fan speed signal"
    annotation (Placement(transformation(extent={{-30,-30},{-10,-10}})));
  CDL.Continuous.Sources.Constant con[2](k={heaPerMin,heaPerMax})
    "Heating loop signal support points"
    annotation (Placement(transformation(extent={{-80,-50},{-60,-30}})));
  CDL.Continuous.Sources.Constant con1[2](k={heaSpeMin,heaSpeMax})
    "Heating fan speed signals"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  CDL.Continuous.Sources.Constant con2[2](k={minCooSpe,maxCooSpe})
    "Cooling fan speed signals"
    annotation (Placement(transformation(extent={{-80,-90},{-60,-70}})));
  CDL.Continuous.Line lin1 "Cooling fan speed signal"
    annotation (Placement(transformation(extent={{-30,-110},{-10,-90}})));
  CDL.Continuous.Sources.Constant con3[2](k={cooLooPerMin,cooLooPerMax})
    "Cooling loop signal support points"
    annotation (Placement(transformation(extent={{-80,-130},{-60,-110}})));
  CDL.Continuous.Sources.Constant con4(k=deaSpe)
    "Deadband mode fan speed signal"
    annotation (Placement(transformation(extent={{-30,-70},{-10,-50}})));
  CDL.Continuous.Hysteresis hys(uLow=heaDea - deaHysLim, uHigh=heaDea)
    "Hysteresis for switching between deadband mode and heating mode"
    annotation (Placement(transformation(extent={{0,-50},{20,-30}})));
  CDL.Continuous.Switch swi1
    "Switch for turning on heating mode from deadband mode"
    annotation (Placement(transformation(extent={{30,-70},{50,-50}})));
  CDL.Continuous.Hysteresis hys1(uLow=cooDea - deaHysLim, uHigh=cooDea)
    "Hysteresis for switching on cooling mode from deadband mode"
    annotation (Placement(transformation(extent={{0,-90},{20,-70}})));
  CDL.Continuous.Switch swi2
    "Switch for turning on cooling mode from deadband mode"
    annotation (Placement(transformation(extent={{60,-110},{80,-90}})));
  CDL.Continuous.Multiply mul "Multiply fan speed signal by fan enable signal"
    annotation (Placement(transformation(extent={{90,-50},{110,-30}})));
  CDL.Interfaces.RealOutput yFanSpe "Fan speed signal"
    annotation (Placement(transformation(extent={{120,-20},{160,20}})));
equation
  connect(conInt.y, intEqu.u2) annotation (Line(points={{-58,40},{-50,40},{-50,
          52},{-42,52}}, color={255,127,0}));
  connect(opeMod, intEqu.u1)
    annotation (Line(points={{-120,60},{-42,60}}, color={255,127,0}));
  connect(intEqu.y, not1.u)
    annotation (Line(points={{-18,60},{-12,60}}, color={255,0,255}));
  connect(not1.y, yFan) annotation (Line(points={{12,60},{20,60},{20,40},{140,
          40}}, color={255,0,255}));
  connect(uFanPro, swi.u2) annotation (Line(points={{-120,20},{10,20},{10,0},{
          78,0}}, color={255,0,255}));
  connect(not1.y, booToRea.u) annotation (Line(points={{12,60},{20,60},{20,-20},
          {48,-20}}, color={255,0,255}));
  connect(booToRea.y, swi.u3) annotation (Line(points={{72,-20},{74,-20},{74,-8},
          {78,-8}}, color={0,0,127}));
  connect(uHea, lin.u)
    annotation (Line(points={{-120,-20},{-32,-20}}, color={0,0,127}));
  connect(con[1].y, lin.x1) annotation (Line(points={{-58,-40},{-50,-40},{-50,
          -12},{-32,-12}}, color={0,0,127}));
  connect(con[2].y, lin.x2) annotation (Line(points={{-58,-40},{-50,-40},{-50,
          -24},{-32,-24}}, color={0,0,127}));
  connect(con1[1].y, lin.f1) annotation (Line(points={{-58,0},{-40,0},{-40,-16},
          {-32,-16}}, color={0,0,127}));
  connect(con1[2].y, lin.f2) annotation (Line(points={{-58,0},{-40,0},{-40,-28},
          {-32,-28}}, color={0,0,127}));
  connect(con3[2].y, lin1.x2) annotation (Line(points={{-58,-120},{-50,-120},{
          -50,-104},{-32,-104}}, color={0,0,127}));
  connect(con3[1].y, lin1.x1) annotation (Line(points={{-58,-120},{-50,-120},{
          -50,-92},{-32,-92}}, color={0,0,127}));
  connect(con2[2].y, lin1.f2) annotation (Line(points={{-58,-80},{-40,-80},{-40,
          -108},{-32,-108}}, color={0,0,127}));
  connect(con2[1].y, lin1.f1) annotation (Line(points={{-58,-80},{-40,-80},{-40,
          -96},{-32,-96}}, color={0,0,127}));
  connect(uCoo, lin1.u)
    annotation (Line(points={{-120,-100},{-32,-100}}, color={0,0,127}));
  connect(uHea, hys.u) annotation (Line(points={{-120,-20},{-44,-20},{-44,-40},
          {-2,-40}}, color={0,0,127}));
  connect(hys.y, swi1.u2) annotation (Line(points={{22,-40},{26,-40},{26,-60},{
          28,-60}}, color={255,0,255}));
  connect(con4.y, swi1.u3) annotation (Line(points={{-8,-60},{20,-60},{20,-68},
          {28,-68}}, color={0,0,127}));
  connect(lin.y, swi1.u1) annotation (Line(points={{-8,-20},{-4,-20},{-4,-52},{
          28,-52}}, color={0,0,127}));
  connect(hys1.y, swi2.u2) annotation (Line(points={{22,-80},{26,-80},{26,-100},
          {58,-100}}, color={255,0,255}));
  connect(uCoo, hys1.u) annotation (Line(points={{-120,-100},{-44,-100},{-44,
          -84},{-20,-84},{-20,-80},{-2,-80}}, color={0,0,127}));
  connect(lin1.y, swi2.u1) annotation (Line(points={{-8,-100},{20,-100},{20,-92},
          {58,-92}}, color={0,0,127}));
  connect(swi1.y, swi2.u3) annotation (Line(points={{52,-60},{54,-60},{54,-108},
          {58,-108}}, color={0,0,127}));
  connect(booToRea.y, mul.u1) annotation (Line(points={{72,-20},{74,-20},{74,
          -34},{88,-34}}, color={0,0,127}));
  connect(swi2.y, mul.u2) annotation (Line(points={{82,-100},{84,-100},{84,-46},
          {88,-46}}, color={0,0,127}));
  connect(mul.y, swi.u1) annotation (Line(points={{112,-40},{114,-40},{114,20},
          {74,20},{74,8},{78,8}}, color={0,0,127}));
  connect(swi.y, yFanSpe)
    annotation (Line(points={{102,0},{140,0}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -140},{120,100}})), Diagram(coordinateSystem(preserveAspectRatio=
            false, extent={{-100,-140},{120,100}})));
end FanSpeed;
