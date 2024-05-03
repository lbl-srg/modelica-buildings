within Buildings.Controls.OBC.ASHRAE.G36.FanCoilUnit.Subsequences;
block PlantRequests
  "Output plant requests for fan coil unit"

  parameter Boolean have_hotWatCoi = true
    "True if the unit has a hot-water heating coil";

  parameter Boolean have_chiWatCoi = true
    "True if the unit has a chilled-water cooling coil";

  parameter Real cooSpe_max(
    final unit="1",
    displayUnit="1") = 1
    "Maximum cooling mode fan speed";

  parameter Real heaSpe_max(
    final unit="1",
    displayUnit="1") = 0.6
    "Maximum heating mode fan speed";

  parameter Real chiWatPlaReqLim0(
    final unit="1",
    displayUnit="1") = 0.1
    "Valve position limit below which zero chilled water plant requests are sent when one request was previously being sent"
    annotation(Dialog(tab="Request limits", group="Chilled water plant requests", enable=have_chiWatCoi));

  parameter Real chiWatResReqLim0(
    final unit="1",
    displayUnit="1") = 0.85
    "Valve position limit below which zero chilled water reset requests are sent when one request was previously being sent"
    annotation(Dialog(tab="Request limits", group="Chilled water reset requests", enable=have_chiWatCoi));

  parameter Real chiWatPlaReqLim1(
    final unit="1",
    displayUnit="1") = 0.95
    "Valve position limit above which one chilled water plant request is sent"
    annotation(Dialog(tab="Request limits", group="Chilled water plant requests", enable=have_chiWatCoi));

  parameter Real chiWatResReqLim1(
    final unit="1",
    displayUnit="1") = 0.95
    "Valve position limit above which one chilled water reset request is sent"
    annotation(Dialog(tab="Request limits", group="Chilled water reset requests", enable=have_chiWatCoi));

  parameter Real chiWatResReqLim2(
    final unit="K",
    final quantity="TemperatureDifference") = 2.78
    "Temperature difference limit between setpoint and supply air temperature above which two chilled water reset requests are sent"
    annotation(Dialog(tab="Request limits", group="Chilled water reset requests", enable=have_chiWatCoi));

  parameter Real chiWatResReqTimLim2(
    final unit="s",
    displayUnit="s",
    final quantity="Time") = 300
    "Time period for which chiWatResReqLim2 has to be exceeded before two chilled water reset requests are sent"
    annotation(Dialog(tab="Request limits", group="Chilled water reset requests", enable=have_chiWatCoi));

  parameter Real chiWatResReqLim3(
    final unit="K",
    final quantity="TemperatureDifference") = 5.56
    "Temperature difference limit between setpoint and supply air temperature above which three chilled water reset requests are sent"
    annotation(Dialog(tab="Request limits", group="Chilled water reset requests", enable=have_chiWatCoi));

  parameter Real chiWatResReqTimLim3(
    final unit="s",
    displayUnit="s",
    final quantity="Time") = 300
    "Time period for which chiWatResReqLim3 has to be exceeded before three chilled water reset requests are sent"
    annotation(Dialog(tab="Request limits", group="Chilled water reset requests", enable=have_chiWatCoi));

  parameter Real hotWatPlaReqLim0(
    final unit="1",
    displayUnit="1") = 0.1
    "Valve position limit below which zero hot water plant requests are sent when one request was previously being sent"
    annotation(Dialog(tab="Request limits", group="Hot water plant requests", enable=have_hotWatCoi));

  parameter Real hotWatResReqLim0(
    final unit="1",
    displayUnit="1") = 0.85
    "Valve position limit below which zero hot water reset requests are sent when one request was previously being sent"
    annotation(Dialog(tab="Request limits", group="Hot water reset requests", enable=have_hotWatCoi));

  parameter Real hotWatPlaReqLim1(
    final unit="1",
    displayUnit="1") = 0.95
    "Valve position limit above which one hot water plant request is sent"
    annotation(Dialog(tab="Request limits", group="Hot water plant requests", enable=have_hotWatCoi));

  parameter Real hotWatResReqLim1(
    final unit="1",
    displayUnit="1") = 0.95
    "Valve position limit above which one hot water reset request is sent"
    annotation(Dialog(tab="Request limits", group="Hot water reset requests", enable=have_hotWatCoi));

  parameter Real hotWatResReqLim2(
    final unit="K",
    final quantity="TemperatureDifference") = 8
    "Temperature difference limit between setpoint and supply air temperature above which two hot water reset requests are sent"
    annotation(Dialog(tab="Request limits", group="Hot water reset requests", enable=have_hotWatCoi));

  parameter Real hotWatResReqTimLim2(
    final unit="s",
    displayUnit="s",
    final quantity="Time") = 300
    "Time period for which hotWatResReqLim2 has to be exceeded before two hot water reset requests are sent"
    annotation(Dialog(tab="Request limits", group="Hot water reset requests", enable=have_hotWatCoi));

  parameter Real hotWatResReqLim3(
    final unit="K",
    final quantity="TemperatureDifference") = 17
    "Temperature difference limit between setpoint and supply air temperature above which three hot water reset requests are sent"
    annotation(Dialog(tab="Request limits", group="Hot water reset requests", enable=have_hotWatCoi));

  parameter Real hotWatResReqTimLim3(
    final unit="s",
    displayUnit="s",
    final quantity="Time") = 300
    "Time period for which hotWatResReqLim3 has to be exceeded before three hot water reset requests are sent"
    annotation(Dialog(tab="Request limits", group="Hot water reset requests", enable=have_hotWatCoi));

  parameter Real Thys(
    final unit="K",
    final quantity = "TemperatureDifference") = 0.1
    "Hysteresis for checking temperature difference"
    annotation(Dialog(tab="Advanced"));

  parameter Real dFanSpe(
    final unit="1",
    displayUnit="1") = 0.05
    "Fan speed hysteresis difference"
    annotation(Dialog(tab="Advanced"));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TAirSup(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Measured supply air temperature"
    annotation (Placement(transformation(extent={{-240,180},{-200,220}}),
        iconTransformation(extent={{-140,20},{-100,60}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TAirSupSet(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Supply air temperature setpoint"
    annotation (Placement(transformation(extent={{-240,140},{-200,180}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uCooCoiSet(
    final unit="1",
    final min=0,
    final max=1) if have_chiWatCoi "Commanded cooling coil position"
    annotation (Placement(transformation(extent={{-240,80},{-200,120}}),
        iconTransformation(extent={{-140,-58},{-100,-18}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uHeaCoiSet(
    final unit="1",
    final min=0,
    final max=1) if have_hotWatCoi "Commanded heating coil position"
    annotation (Placement(transformation(extent={{-240,-160},{-200,-120}}),
        iconTransformation(extent={{-140,-100},{-100,-60}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uFan(
    final unit="1",
    final min=0,
    final max=1)
    "Fan speed signal"
    annotation (Placement(transformation(extent={{-240,220},{-200,260}}),
      iconTransformation(extent={{-140,60},{-100,100}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yChiWatResReq if have_chiWatCoi
    "Chilled water reset request"
    annotation (Placement(transformation(extent={{200,220},{240,260}}),
        iconTransformation(extent={{100,40},{140,80}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yChiPlaReq if have_chiWatCoi
    "Chiller plant request"
    annotation (Placement(transformation(extent={{200,0},{240,40}}),
        iconTransformation(extent={{100,0},{140,40}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yHotWatResReq if have_hotWatCoi
    "Hot water reset request"
    annotation (Placement(transformation(extent={{200,-60},{240,-20}}),
        iconTransformation(extent={{100,-40},{140,0}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yHotWatPlaReq if have_hotWatCoi
    "Hot water plant request"
    annotation (Placement(transformation(extent={{200,-240},{240,-200}}),
        iconTransformation(extent={{100,-80},{140,-40}})));

protected
  Buildings.Controls.OBC.CDL.Reals.Hysteresis hysFanCoo(
    final uLow=cooSpe_max - 2*dFanSpe,
    final uHigh=cooSpe_max - dFanSpe) if have_chiWatCoi
    "Check if fan is at max cooling mode speed"
    annotation (Placement(transformation(extent={{-130,230},{-110,250}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToIntCoo if have_chiWatCoi
    "Output integer 1 when fan is at max cooling mode speed"
    annotation (Placement(transformation(extent={{-80,230},{-60,250}})));

  Buildings.Controls.OBC.CDL.Integers.Multiply mulIntCoo if have_chiWatCoi
    "Output reset requests only if fan is at max cooling mode speed"
    annotation (Placement(transformation(extent={{100,230},{120,250}})));

  Buildings.Controls.OBC.CDL.Reals.Hysteresis hysFanHea(
    final uLow=heaSpe_max - 2*dFanSpe,
    final uHigh=heaSpe_max - dFanSpe) if have_hotWatCoi
    "Check if fan is at max heating mode speed"
    annotation (Placement(transformation(extent={{-140,-20},{-120,0}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToIntHea if have_hotWatCoi
    "Output integer 1 when fan is at max heating mode speed"
    annotation (Placement(transformation(extent={{-90,-20},{-70,0}})));

  Buildings.Controls.OBC.CDL.Integers.Multiply mulIntHea if have_hotWatCoi
    "Output reset requests only if fan is at max heating mode speed"
    annotation (Placement(transformation(extent={{160,-20},{180,0}})));

  Buildings.Controls.OBC.CDL.Reals.Subtract cooSupTemDif
    "Find the cooling supply temperature difference to the setpoint"
    annotation (Placement(transformation(extent={{-140,190},{-120,210}})));

  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold greThr(
    final t=chiWatResReqLim3,
    final h=Thys) if have_chiWatCoi
    "Check if the supply temperature is greater than the setpoint by a threshold value for sending three reset requests"
    annotation (Placement(transformation(extent={{-80,190},{-60,210}})));

  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold greThr1(
    final t=chiWatResReqLim2,
    final h=Thys) if have_chiWatCoi
    "Check if the supply temperature is greater than the setpoint by a threshold value for sending two reset requests"
    annotation (Placement(transformation(extent={{-80,140},{-60,160}})));

  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel(
    final delayTime=chiWatResReqTimLim3) if have_chiWatCoi
    "Ensure condition for sending three chilled water reset requests is true for minimum threshold time period"
    annotation (Placement(transformation(extent={{-40,190},{-20,210}})));

  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel1(
    final delayTime=chiWatResReqTimLim2) if have_chiWatCoi
    "Ensure condition for sending two chilled water reset requests is true for minimum threshold time period"
    annotation (Placement(transformation(extent={{-40,140},{-20,160}})));

  Buildings.Controls.OBC.CDL.Reals.Hysteresis hys(
    final uLow=chiWatResReqLim0,
    final uHigh=chiWatResReqLim1) if have_chiWatCoi
    "Check chilled water valve position against threshold values for sending one reset request"
    annotation (Placement(transformation(extent={{-120,90},{-100,110}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant thr(
    final k=3)
    "Constant 3"
    annotation (Placement(transformation(extent={{0,222},{20,242}})));

  Buildings.Controls.OBC.CDL.Integers.Switch chiWatRes3 if have_chiWatCoi
    "Send 3 chilled water reset request"
    annotation (Placement(transformation(extent={{160,190},{180,210}})));

  Buildings.Controls.OBC.CDL.Integers.Switch chiWatRes2 if have_chiWatCoi
    "Send 2 chilled water reset request"
    annotation (Placement(transformation(extent={{120,140},{140,160}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant two(
    final k=2)
    "Constant 2"
    annotation (Placement(transformation(extent={{0,170},{20,190}})));

  Buildings.Controls.OBC.CDL.Integers.Switch chiWatRes1 if have_chiWatCoi
    "Send 1 chilled water reset request"
    annotation (Placement(transformation(extent={{80,90},{100,110}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant one(
    final k=1)
    "Constant 1"
    annotation (Placement(transformation(extent={{0,110},{20,130}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant zer(
    final k=0)
    "Constant 0"
    annotation (Placement(transformation(extent={{0,50},{20,70}})));

  Buildings.Controls.OBC.CDL.Integers.Switch intSwi3 if have_chiWatCoi
    "Send 1 chiller plant request"
    annotation (Placement(transformation(extent={{80,10},{100,30}})));

  Buildings.Controls.OBC.CDL.Reals.Subtract heaSupTemDif if have_hotWatCoi
    "Find the heating supply temperature difference to the setpoint"
    annotation (Placement(transformation(extent={{-140,-70},{-120,-50}})));

  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold greThr3(
    final t=hotWatResReqLim3,
    final h=Thys) if have_hotWatCoi
    "Check if the supply temperature is less than the setpoint by a threshold value for sending three reset requests"
    annotation (Placement(transformation(extent={{-80,-70},{-60,-50}})));

  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold greThr4(
    final t=hotWatResReqLim2,
    final h=Thys) if have_hotWatCoi
    "Check if the supply temperature is less than the setpoint by a threshold value for sending two reset requests"
    annotation (Placement(transformation(extent={{-80,-120},{-60,-100}})));

  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel2(
    final delayTime=hotWatResReqTimLim3) if have_hotWatCoi
    "Ensure condition for sending three hot water reset requests is true for minimum threshold time period"
    annotation (Placement(transformation(extent={{-40,-70},{-20,-50}})));

  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel3(
    final delayTime=hotWatResReqTimLim2) if have_hotWatCoi
    "Ensure condition for sending two hot water reset requests is true for minimum threshold time period"
    annotation (Placement(transformation(extent={{-40,-120},{-20,-100}})));

  Buildings.Controls.OBC.CDL.Integers.Switch hotWatRes3 if have_hotWatCoi
    "Send 3 hot water reset request"
    annotation (Placement(transformation(extent={{140,-70},{160,-50}})));

  Buildings.Controls.OBC.CDL.Integers.Switch hotWatRes2 if have_hotWatCoi
    "Send 2 hot water reset request"
    annotation (Placement(transformation(extent={{100,-120},{120,-100}})));

  Buildings.Controls.OBC.CDL.Integers.Switch hotWatRes1 if have_hotWatCoi
    "Send 1 hot water reset request"
    annotation (Placement(transformation(extent={{60,-150},{80,-130}})));

  Buildings.Controls.OBC.CDL.Integers.Switch intSwi1 if have_hotWatCoi
    "Send 1 hot water plant request"
    annotation (Placement(transformation(extent={{60,-230},{80,-210}})));

  Buildings.Controls.OBC.CDL.Reals.Hysteresis hys1(
    final uLow=chiWatPlaReqLim0,
    final uHigh=chiWatPlaReqLim1) if have_chiWatCoi
    "Check chilled water valve position against threshold values for sending one plant request"
    annotation (Placement(transformation(extent={{-120,10},{-100,30}})));

  Buildings.Controls.OBC.CDL.Reals.Hysteresis hys2(
    final uLow=hotWatResReqLim0,
    final uHigh=hotWatResReqLim1) if have_hotWatCoi
    "Check hot water valve position against threshold values for sending one reset request"
    annotation (Placement(transformation(extent={{-120,-150},{-100,-130}})));

  Buildings.Controls.OBC.CDL.Reals.Hysteresis hys3(
    final uLow=hotWatPlaReqLim0,
    final uHigh=hotWatPlaReqLim1) if have_hotWatCoi
    "Check hot water valve position against threshold values for sending one plant request"
    annotation (Placement(transformation(extent={{-120,-230},{-100,-210}})));

equation
  connect(TAirSup, cooSupTemDif.u1) annotation (Line(points={{-220,200},{-180,200},
          {-180,206},{-142,206}}, color={0,0,127}));

  connect(TAirSupSet, cooSupTemDif.u2) annotation (Line(points={{-220,160},{-190,
          160},{-190,194},{-142,194}}, color={0,0,127}));

  connect(cooSupTemDif.y, greThr.u)
    annotation (Line(points={{-118,200},{-82,200}}, color={0,0,127}));

  connect(greThr.y, truDel.u)
    annotation (Line(points={{-58,200},{-42,200}}, color={255,0,255}));

  connect(greThr1.y, truDel1.u)
    annotation (Line(points={{-58,150},{-42,150}}, color={255,0,255}));

  connect(cooSupTemDif.y, greThr1.u) annotation (Line(points={{-118,200},{-100,200},
          {-100,150},{-82,150}}, color={0,0,127}));

  connect(uCooCoiSet, hys.u)
    annotation (Line(points={{-220,100},{-122,100}}, color={0,0,127}));

  connect(truDel.y, chiWatRes3.u2)
    annotation (Line(points={{-18,200},{158,200}}, color={255,0,255}));

  connect(thr.y, chiWatRes3.u1) annotation (Line(points={{22,232},{60,232},{60,208},
          {158,208}}, color={255,127,0}));

  connect(truDel1.y, chiWatRes2.u2)
    annotation (Line(points={{-18,150},{118,150}}, color={255,0,255}));

  connect(two.y, chiWatRes2.u1) annotation (Line(points={{22,180},{50,180},{50,158},
          {118,158}}, color={255,127,0}));

  connect(one.y, chiWatRes1.u1) annotation (Line(points={{22,120},{40,120},{40,108},
          {78,108}}, color={255,127,0}));

  connect(chiWatRes1.y, chiWatRes2.u3) annotation (Line(points={{102,100},{110,100},
          {110,142},{118,142}}, color={255,127,0}));

  connect(chiWatRes2.y, chiWatRes3.u3) annotation (Line(points={{142,150},{150,150},
          {150,192},{158,192}}, color={255,127,0}));

  connect(zer.y, chiWatRes1.u3) annotation (Line(points={{22,60},{30,60},{30,92},
          {78,92}}, color={255,127,0}));

  connect(one.y, intSwi3.u1) annotation (Line(points={{22,120},{40,120},{40,28},
          {78,28}}, color={255,127,0}));

  connect(zer.y, intSwi3.u3) annotation (Line(points={{22,60},{30,60},{30,12},{78,
          12}}, color={255,127,0}));

  connect(intSwi3.y, yChiPlaReq)
    annotation (Line(points={{102,20},{220,20}}, color={255,127,0}));

  connect(TAirSup, heaSupTemDif.u2) annotation (Line(points={{-220,200},{-180,200},
          {-180,-66},{-142,-66}}, color={0,0,127}));

  connect(greThr3.y, truDel2.u)
    annotation (Line(points={{-58,-60},{-42,-60}}, color={255,0,255}));

  connect(greThr4.y, truDel3.u)
    annotation (Line(points={{-58,-110},{-42,-110}},
                                                   color={255,0,255}));

  connect(heaSupTemDif.y, greThr3.u)
    annotation (Line(points={{-118,-60},{-82,-60}}, color={0,0,127}));

  connect(heaSupTemDif.y, greThr4.u) annotation (Line(points={{-118,-60},{-100,-60},
          {-100,-110},{-82,-110}},
                                 color={0,0,127}));

  connect(truDel2.y, hotWatRes3.u2)
    annotation (Line(points={{-18,-60},{138,-60}}, color={255,0,255}));

  connect(thr.y, hotWatRes3.u1) annotation (Line(points={{22,232},{60,232},{60,-52},
          {138,-52}}, color={255,127,0}));

  connect(hotWatRes2.y, hotWatRes3.u3) annotation (Line(points={{122,-110},{130,
          -110},{130,-68},{138,-68}},
                                color={255,127,0}));

  connect(two.y, hotWatRes2.u1) annotation (Line(points={{22,180},{50,180},{50,-102},
          {98,-102}}, color={255,127,0}));

  connect(truDel3.y, hotWatRes2.u2)
    annotation (Line(points={{-18,-110},{98,-110}},color={255,0,255}));

  connect(one.y, hotWatRes1.u1) annotation (Line(points={{22,120},{40,120},{40,-132},
          {58,-132}}, color={255,127,0}));

  connect(zer.y, hotWatRes1.u3) annotation (Line(points={{22,60},{30,60},{30,-148},
          {58,-148}}, color={255,127,0}));

  connect(hotWatRes1.y, hotWatRes2.u3) annotation (Line(points={{82,-140},{90,-140},
          {90,-118},{98,-118}},       color={255,127,0}));

  connect(one.y, intSwi1.u1) annotation (Line(points={{22,120},{40,120},{40,-212},
          {58,-212}}, color={255,127,0}));

  connect(zer.y, intSwi1.u3) annotation (Line(points={{22,60},{30,60},{30,-228},
          {58,-228}}, color={255,127,0}));

  connect(intSwi1.y, yHotWatPlaReq)
    annotation (Line(points={{82,-220},{220,-220}},  color={255,127,0}));

  connect(yChiWatResReq, yChiWatResReq)
    annotation (Line(points={{220,240},{220,240}}, color={255,127,0}));

  connect(uFan, hysFanCoo.u)
    annotation (Line(points={{-220,240},{-132,240}}, color={0,0,127}));

  connect(hysFanCoo.y, booToIntCoo.u)
    annotation (Line(points={{-108,240},{-82,240}}, color={255,0,255}));

  connect(chiWatRes3.y, mulIntCoo.u2) annotation (Line(points={{182,200},{188,200},
          {188,220},{90,220},{90,234},{98,234}}, color={255,127,0}));

  connect(booToIntCoo.y, mulIntCoo.u1) annotation (Line(points={{-58,240},{-20,240},
          {-20,252},{60,252},{60,246},{98,246}}, color={255,127,0}));

  connect(mulIntCoo.y, yChiWatResReq) annotation (Line(points={{122,240},{220,240}},
                                color={255,127,0}));

  connect(hotWatRes3.y, mulIntHea.u2) annotation (Line(points={{162,-60},{170,-60},
          {170,-28},{152,-28},{152,-16},{158,-16}},
                                                  color={255,127,0}));

  connect(hysFanHea.y, booToIntHea.u)
    annotation (Line(points={{-118,-10},{-92,-10}}, color={255,0,255}));

  connect(booToIntHea.y, mulIntHea.u1) annotation (Line(points={{-68,-10},{46,-10},
          {46,-4},{158,-4}},color={255,127,0}));

  connect(uFan, hysFanHea.u) annotation (Line(points={{-220,240},{-170,240},{
          -170,-10},{-142,-10}}, color={0,0,127}));

  connect(mulIntHea.y, yHotWatResReq) annotation (Line(points={{182,-10},{192,-10},
          {192,-40},{220,-40}},color={255,127,0}));

  connect(TAirSupSet, heaSupTemDif.u1) annotation (Line(points={{-220,160},{-190,
          160},{-190,-54},{-142,-54}}, color={0,0,127}));

  connect(hys.y, chiWatRes1.u2)
    annotation (Line(points={{-98,100},{78,100}}, color={255,0,255}));
  connect(uCooCoiSet, hys1.u) annotation (Line(points={{-220,100},{-140,100},{-140,
          20},{-122,20}}, color={0,0,127}));
  connect(hys1.y, intSwi3.u2)
    annotation (Line(points={{-98,20},{78,20}}, color={255,0,255}));
  connect(uHeaCoiSet, hys2.u)
    annotation (Line(points={{-220,-140},{-122,-140}}, color={0,0,127}));
  connect(hys2.y, hotWatRes1.u2)
    annotation (Line(points={{-98,-140},{58,-140}}, color={255,0,255}));
  connect(hys3.y, intSwi1.u2)
    annotation (Line(points={{-98,-220},{58,-220}}, color={255,0,255}));
  connect(hys3.u, uHeaCoiSet) annotation (Line(points={{-122,-220},{-140,-220},{
          -140,-140},{-220,-140}}, color={0,0,127}));
annotation (
  defaultComponentName="fcuPlaReq",
  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
    graphics={
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-98,48},{-68,32}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TAirSup"),
        Text(
          extent={{-100,160},{100,120}},
          textColor={0,0,255},
          textString="%name"),
        Text(
          extent={{-98,8},{-50,-10}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TAirSupSet"),
        Text(
          extent={{-98,-32},{-40,-46}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          visible=have_chiWatCoi,
          textString="uCooCoiSet"),
        Text(
          extent={{34,72},{98,50}},
          textColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="yChiWatResReq",
          visible=have_chiWatCoi),
        Text(
          extent={{52,32},{98,10}},
          textColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="yChiPlaReq",
          visible=have_chiWatCoi),
        Text(
          extent={{34,-8},{98,-30}},
          textColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="yHotWatResReq",
          visible=have_hotWatCoi),
        Text(
          extent={{38,-48},{98,-70}},
          textColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="yHotWatPlaReq",
          visible=have_hotWatCoi),
        Text(
          extent={{-100,90},{-68,74}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="uFan"),
        Text(
          extent={{-100,-72},{-40,-86}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          visible=have_hotWatCoi,
          textString="uHeaCoiSet")}),
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-200,-260},{200,260}})),
Documentation(info="<html>
<p>
This sequence outputs the system reset requests for fan coil unit.
The implementation is according to the Section 5.22.8 of ASHRAE Guideline 36, 2021.
</p>
<h4>
If there is a chilled-water coil (<code>have_chiWatCoi=true</code>),
chilled water reset requests <code>yChiWatResReq</code>
</h4>
<ol>
<li>
If the supply air temperature <code>TAirSup</code> exceeds the supply air
temperature set point <code>TSupSet</code> by 5.56 &deg;C (10 &deg;F) for 5 minutes,
send 3 requests.
</li>
<li>
If the supply air temperature <code>TAirSup</code> exceeds <code>TSupSet</code>
by by 2.78 &deg;C (5 &deg;F) for 5 minutes, send 2 requests.
</li>
<li>
Else if the chilled water valve position <code>uCooCoi_actual</code> is greater
than 0.95, send 1 request until <code>uCooCoi_actual</code> is less than 0.85.
</li>
<li>
Else if the chilled water valve position <code>uCooCoi_actual</code> is less
than 0.85, send 0 requests.
</li>
</ol>
<h4>
If there is a chilled-water coil and chilled water plant, chiller plant
request <code>yChiPlaReq</code>
</h4>
<p>
Send the chiller plant that serves the system a chiller plant request as follows:
</p>
<ol>
<li>
If the chilled water valve position <code>uCooCoi_actual</code> is greater than
0.95, send 1 request until the <code>uCooCoi_actual</code> is less than 0.1.
</li>
<li>
Else if the chilled water valve position <code>uCooCoi_actual</code> is
less than 0.1, send 0 request
</li>
</ol>
<h4>
If there is a hot-water coil (<code>have_hotWatCoi=true</code>),
hot-water reset requests <code>yHotWatResReq</code>
</h4>
<ol>
<li>
If the supply air temperature <code>TAirSup</code> is 17 &deg;C (30 &deg;F)
less than the supply air temperature set point <code>TSupSet</code> for
5 minutes, send 3 requests.
</li>
<li>
Else if the supply air temperature <code>TAirSup</code> is 8 &deg;C (15 &deg;F)
less than <code>TSupSet</code> for 5 minutes, send 2 requests.
</li>
<li>
Else if the hot water valve position <code>uHeaCoi_actual</code> is greater
than 0.95, send 1 request until the <code>uHeaCoi_actual</code> is less than
0.85.
</li>
<li>
Else if the hot water valve position <code>uHeaCoi_actual</code> is less than
0.85, send 0 request.
</li>
</ol>
<h4>
If there is a hot-water coil and heating hot-water plant, heating hot-water
plant requests <code>yHotWatPlaReq</code>
</h4>
<p>
Send the heating hot-water plant that serves the air handling unit a heating
hot-water plant request as follows:
</p>
<ol>
<li>
If the hot water valve position <code>uHeaCoi_actual</code> is greater than
0.95, send 1 request until the hot water valve position is less than 0.1.
</li>
<li>
If the hot water valve position <code>uHeaCoi_actual</code> is less than 0.1,
send 0 requests.
</li>
</ol>
</html>", revisions="<html>
<ul>
<li>
May 6, 2022, by Karthik Devaprasad:<br/>
First implementation.
</li>
</ul>
</html>"));
end PlantRequests;
