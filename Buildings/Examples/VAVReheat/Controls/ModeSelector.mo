within Buildings.Examples.VAVReheat.Controls;
model ModeSelector "Finite State Machine for the operational modes"
  Modelica.StateGraph.InitialStep initialStep
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  Modelica.StateGraph.Transition start "Starts the system"
    annotation (Placement(transformation(extent={{-50,20},{-30,40}})));
  State unOccOff(
    mode=Buildings.Examples.VAVReheat.Controls.OperationModes.unoccupiedOff,
    nIn=3,
    nOut=4) "Unoccupied off mode, no coil protection"
    annotation (Placement(transformation(extent={{-20,20},{0,40}})));
  State unOccNigSetBac(
    nOut=2,
    mode=Buildings.Examples.VAVReheat.Controls.OperationModes.unoccupiedNightSetBack,
    nIn=1) "Unoccupied night set back"
    annotation (Placement(transformation(extent={{80,20},{100,40}})));
  Modelica.StateGraph.Transition t2(
    enableTimer=true,
    waitTime=60,
    condition=TRooMinErrHea.y > delTRooOnOff/2)
    annotation (Placement(transformation(extent={{28,20},{48,40}})));
  parameter Modelica.SIunits.TemperatureDifference delTRooOnOff(min=0.1)=1
    "Deadband in room temperature between occupied on and occupied off";
  parameter Modelica.SIunits.Temperature TRooSetHeaOcc=293.15
    "Set point for room air temperature during heating mode";
  parameter Modelica.SIunits.Temperature TRooSetCooOcc=299.15
    "Set point for room air temperature during cooling mode";
  parameter Modelica.SIunits.Temperature TSetHeaCoiOut=303.15
    "Set point for air outlet temperature at central heating coil";
  Modelica.StateGraph.Transition t1(condition=delTRooOnOff/2 < -TRooMinErrHea.y,
    enableTimer=true,
    waitTime=30*60)
    annotation (Placement(transformation(extent={{50,70},{30,90}})));
  inner Modelica.StateGraph.StateGraphRoot stateGraphRoot
    annotation (Placement(transformation(extent={{160,160},{180,180}})));
  ControlBus cb
    annotation (Placement(transformation(extent={{-168,130},{-148,150}}),
        iconTransformation(extent={{-176,124},{-124,176}})));
  Modelica.Blocks.Routing.RealPassThrough TRooSetHea
    "Current heating setpoint temperature"
    annotation (Placement(transformation(extent={{-80,170},{-60,190}})));
  State morWarUp(mode=Buildings.Examples.VAVReheat.Controls.OperationModes.unoccupiedWarmUp,
                                                                            nIn=2,
    nOut=1) "Morning warm up"
    annotation (Placement(transformation(extent={{-40,-100},{-20,-80}})));
  Modelica.StateGraph.TransitionWithSignal t6(enableTimer=true, waitTime=60)
    annotation (Placement(transformation(extent={{-76,-100},{-56,-80}})));
  Modelica.Blocks.Logical.LessEqualThreshold occThrSho(threshold=1800)
    "Signal to allow transition into morning warmup"
    annotation (Placement(transformation(extent={{-140,-190},{-120,-170}})));
  Modelica.StateGraph.TransitionWithSignal t5
    annotation (Placement(transformation(extent={{118,20},{138,40}})));
  State occ(       mode=Buildings.Examples.VAVReheat.Controls.OperationModes.occupied,
                                                                      nIn=3)
    "Occupied mode"
    annotation (Placement(transformation(extent={{60,-100},{80,-80}})));
  Modelica.Blocks.Routing.RealPassThrough TRooMin
    annotation (Placement(transformation(extent={{-80,140},{-60,160}})));
  Modelica.Blocks.Math.Feedback TRooMinErrHea "Room control error for heating"
    annotation (Placement(transformation(extent={{-40,170},{-20,190}})));
  Modelica.StateGraph.Transition t3(condition=TRooMin.y + delTRooOnOff/2 >
        TRooSetHeaOcc or occupied.y)
    annotation (Placement(transformation(extent={{10,-100},{30,-80}})));
  Modelica.Blocks.Routing.BooleanPassThrough occupied
    "outputs true if building is occupied"
    annotation (Placement(transformation(extent={{-80,80},{-60,100}})));
  Modelica.StateGraph.TransitionWithSignal t4(enableTimer=false)
    annotation (Placement(transformation(extent={{118,120},{98,140}})));
  State morPreCoo(                                                        nIn=2,
    mode=Buildings.Examples.VAVReheat.Controls.OperationModes.unoccupiedPreCool,
    nOut=1) "Pre-cooling mode"
    annotation (Placement(transformation(extent={{-40,-140},{-20,-120}})));
  Modelica.StateGraph.Transition t7(condition=TRooMin.y - delTRooOnOff/2 <
        TRooSetCooOcc or occupied.y)
    annotation (Placement(transformation(extent={{10,-140},{30,-120}})));
  Modelica.Blocks.Logical.And and1
    annotation (Placement(transformation(extent={{-100,-200},{-80,-180}})));
  Modelica.Blocks.Routing.RealPassThrough TRooAve "Average room temperature"
    annotation (Placement(transformation(extent={{-80,110},{-60,130}})));
  Modelica.Blocks.Sources.BooleanExpression booleanExpression(y=TRooAve.y <
        TRooSetCooOcc)
    annotation (Placement(transformation(extent={{-198,-224},{-122,-200}})));
  PreCoolingStarter preCooSta(TRooSetCooOcc=TRooSetCooOcc)
    "Model to start pre-cooling"
    annotation (Placement(transformation(extent={{-140,-160},{-120,-140}})));
  Modelica.StateGraph.TransitionWithSignal t9
    annotation (Placement(transformation(extent={{-90,-140},{-70,-120}})));
  Modelica.Blocks.Logical.Not not1
    annotation (Placement(transformation(extent={{-48,-180},{-28,-160}})));
  Modelica.Blocks.Logical.And and2
    annotation (Placement(transformation(extent={{80,100},{100,120}})));
  Modelica.Blocks.Logical.Not not2
    annotation (Placement(transformation(extent={{0,100},{20,120}})));
  Modelica.StateGraph.TransitionWithSignal t8
    "changes to occupied in case precooling is deactivated"
    annotation (Placement(transformation(extent={{30,-30},{50,-10}})));
  Modelica.Blocks.MathInteger.Sum sum(nu=5)
    annotation (Placement(transformation(extent={{-186,134},{-174,146}})));
  Modelica.Blocks.Interfaces.BooleanOutput yFan
    "True if the fans are to be switched on"
    annotation (Placement(transformation(extent={{220,-10},{240,10}})));
  Modelica.Blocks.MathBoolean.Or or1(nu=4)
    annotation (Placement(transformation(extent={{184,-6},{196,6}})));
equation
  connect(start.outPort, unOccOff.inPort[1]) annotation (Line(
      points={{-38.5,30},{-29.75,30},{-29.75,30.6667},{-21,30.6667}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(initialStep.outPort[1], start.inPort) annotation (Line(
      points={{-59.5,30},{-44,30}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(unOccOff.outPort[1], t2.inPort)         annotation (Line(
      points={{0.5,30.375},{8.25,30.375},{8.25,30},{34,30}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(t2.outPort, unOccNigSetBac.inPort[1])  annotation (Line(
      points={{39.5,30},{79,30}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(unOccNigSetBac.outPort[1], t1.inPort)   annotation (Line(
      points={{100.5,30.25},{112,30.25},{112,80},{44,80}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(t1.outPort, unOccOff.inPort[2])          annotation (Line(
      points={{38.5,80},{-30,80},{-30,30},{-21,30}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(cb.dTNexOcc, occThrSho.u)             annotation (Line(
      points={{-158,140},{-150,140},{-150,-180},{-142,-180}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(t6.outPort, morWarUp.inPort[1]) annotation (Line(
      points={{-64.5,-90},{-41,-90},{-41,-89.5}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(t5.outPort, morWarUp.inPort[2]) annotation (Line(
      points={{129.5,30},{140,30},{140,-60},{-48,-60},{-48,-90.5},{-41,-90.5}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(unOccNigSetBac.outPort[2], t5.inPort)
                                         annotation (Line(
      points={{100.5,29.75},{113.25,29.75},{113.25,30},{124,30}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(cb.TRooMin, TRooMin.u) annotation (Line(
      points={{-158,140},{-92,140},{-92,150},{-82,150}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(TRooSetHea.y, TRooMinErrHea.u1)
                                    annotation (Line(
      points={{-59,180},{-38,180}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TRooMin.y, TRooMinErrHea.u2)
                                    annotation (Line(
      points={{-59,150},{-30,150},{-30,172}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(unOccOff.outPort[2], t6.inPort) annotation (Line(
      points={{0.5,30.125},{12,30.125},{12,-48},{-80,-48},{-80,-90},{-70,-90}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(morWarUp.outPort[1], t3.inPort) annotation (Line(
      points={{-19.5,-90},{16,-90}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(cb.occupied, occupied.u) annotation (Line(
      points={{-158,140},{-120,140},{-120,90},{-82,90}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(occ.outPort[1], t4.inPort) annotation (Line(
      points={{80.5,-90},{150,-90},{150,130},{112,130}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(t4.outPort, unOccOff.inPort[3]) annotation (Line(
      points={{106.5,130},{-30,130},{-30,29.3333},{-21,29.3333}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(occThrSho.y, and1.u1) annotation (Line(
      points={{-119,-180},{-110,-180},{-110,-190},{-102,-190}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(and1.y, t6.condition) annotation (Line(
      points={{-79,-190},{-66,-190},{-66,-102}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(and1.y, t5.condition) annotation (Line(
      points={{-79,-190},{128,-190},{128,18}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(cb.TRooAve, TRooAve.u) annotation (Line(
      points={{-158,140},{-100,140},{-100,120},{-82,120}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(booleanExpression.y, and1.u2) annotation (Line(
      points={{-118.2,-212},{-110.1,-212},{-110.1,-198},{-102,-198}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(preCooSta.y, t9.condition) annotation (Line(
      points={{-119,-150},{-80,-150},{-80,-142}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(t9.outPort, morPreCoo.inPort[1]) annotation (Line(
      points={{-78.5,-130},{-59.75,-130},{-59.75,-129.5},{-41,-129.5}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(unOccOff.outPort[3], t9.inPort) annotation (Line(
      points={{0.5,29.875},{12,29.875},{12,0},{-100,0},{-100,-130},{-84,-130}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(cb, preCooSta.controlBus) annotation (Line(
      points={{-158,140},{-150,140},{-150,-144},{-136.2,-144}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(morPreCoo.outPort[1], t7.inPort) annotation (Line(
      points={{-19.5,-130},{16,-130}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(t7.outPort, occ.inPort[2]) annotation (Line(
      points={{21.5,-130},{30,-130},{30,-128},{46,-128},{46,-90},{59,-90}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(t3.outPort, occ.inPort[1]) annotation (Line(
      points={{21.5,-90},{42,-90},{42,-89.3333},{59,-89.3333}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(occThrSho.y, not1.u) annotation (Line(
      points={{-119,-180},{-110,-180},{-110,-170},{-50,-170}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(not1.y, and2.u2) annotation (Line(
      points={{-27,-170},{144,-170},{144,84},{66,84},{66,102},{78,102}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(and2.y, t4.condition) annotation (Line(
      points={{101,110},{108,110},{108,118}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(occupied.y, not2.u) annotation (Line(
      points={{-59,90},{-20,90},{-20,110},{-2,110}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(not2.y, and2.u1) annotation (Line(
      points={{21,110},{78,110}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(cb.TRooSetHea, TRooSetHea.u) annotation (Line(
      points={{-158,140},{-92,140},{-92,180},{-82,180}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(t8.outPort, occ.inPort[3]) annotation (Line(
      points={{41.5,-20},{52,-20},{52,-90.6667},{59,-90.6667}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(unOccOff.outPort[4], t8.inPort) annotation (Line(
      points={{0.5,29.625},{12,29.625},{12,-20},{36,-20}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(occupied.y, t8.condition) annotation (Line(
      points={{-59,90},{-50,90},{-50,-40},{40,-40},{40,-32}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(morPreCoo.y, sum.u[1]) annotation (Line(
      points={{-19,-136},{-8,-136},{-8,-68},{-192,-68},{-192,143.36},{-186,
          143.36}},
      color={255,127,0},
      smooth=Smooth.None));
  connect(morWarUp.y, sum.u[2]) annotation (Line(
      points={{-19,-96},{-8,-96},{-8,-68},{-192,-68},{-192,141.68},{-186,141.68}},
      color={255,127,0},
      smooth=Smooth.None));
  connect(occ.y, sum.u[3]) annotation (Line(
      points={{81,-96},{100,-96},{100,-108},{-192,-108},{-192,140},{-186,140}},
      color={255,127,0},
      smooth=Smooth.None));
  connect(unOccOff.y, sum.u[4]) annotation (Line(
      points={{1,24},{6,24},{6,8},{-192,8},{-192,138.32},{-186,138.32}},
      color={255,127,0},
      smooth=Smooth.None));
  connect(unOccNigSetBac.y, sum.u[5]) annotation (Line(
      points={{101,24},{112,24},{112,8},{-192,8},{-192,136.64},{-186,136.64}},
      color={255,127,0},
      smooth=Smooth.None));
  connect(sum.y, cb.controlMode) annotation (Line(
      points={{-173.1,140},{-158,140}},
      color={255,127,0},
      smooth=Smooth.None), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(yFan, or1.y)
    annotation (Line(points={{230,0},{196.9,0}}, color={255,0,255}));
  connect(unOccNigSetBac.active, or1.u[1]) annotation (Line(points={{90,19},{90,
          3.15},{184,3.15}}, color={255,0,255}));
  connect(occ.active, or1.u[2]) annotation (Line(points={{70,-101},{70,-104},{
          168,-104},{168,1.05},{184,1.05}}, color={255,0,255}));
  connect(morWarUp.active, or1.u[3]) annotation (Line(points={{-30,-101},{-30,
          -112},{170,-112},{170,-1.05},{184,-1.05}}, color={255,0,255}));
  connect(morPreCoo.active, or1.u[4]) annotation (Line(points={{-30,-141},{-30,
          -150},{174,-150},{174,-3.15},{184,-3.15}}, color={255,0,255}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-220,
            -220},{220,220}})), Icon(coordinateSystem(
          preserveAspectRatio=true, extent={{-220,-220},{220,220}}), graphics={
          Rectangle(
          extent={{-200,200},{200,-200}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Solid,
          fillColor={215,215,215}), Text(
          extent={{-176,80},{192,-84}},
          lineColor={0,0,255},
          textString="%name")}));
end ModeSelector;
