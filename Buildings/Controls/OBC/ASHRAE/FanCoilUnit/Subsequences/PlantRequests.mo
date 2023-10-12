within Buildings.Controls.OBC.ASHRAE.FanCoilUnit.Subsequences;
block PlantRequests
  "Output plant requests for fan coil unit"

  parameter Boolean have_hotWatCoi = true
    "Does the fan coil unit have a hot-water heating coil? True: Yes, False: No";

  parameter Boolean have_chiWatCoi = true
    "Does the fan coil unit have a chilled-water cooling coil? True: Yes, False: No";

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
    annotation(Dialog(tab="Request limits", group="Chilled water requests", enable=have_chiWatCoi));

  parameter Real chiWatResReqLim0(
    final unit="1",
    displayUnit="1") = 0.85
    "Valve position limit below which zero chilled water reset requests are sent when one request was previously being sent"
    annotation(Dialog(tab="Request limits", group="Chilled water requests", enable=have_chiWatCoi));

  parameter Real chiWatPlaReqLim1(
    final unit="1",
    displayUnit="1") = 0.95
    "Valve position limit above which one chilled water plant request is sent"
    annotation(Dialog(tab="Request limits", group="Chilled water requests", enable=have_chiWatCoi));

  parameter Real chiWatResReqLim2(
    final unit="K",
    final quantity="TemperatureDifference") = 2.78
    "Temperature difference limit between setpoint and supply air temperature above which two chilled water reset requests are sent"
    annotation(Dialog(tab="Request limits", group="Chilled water requests", enable=have_chiWatCoi));

  parameter Real chiWatResReqTimLim2(
    final unit="s",
    displayUnit="s",
    final quantity="Time") = 300
    "Time period for which chiWatResReqLim2 has to be exceeded before two chilled water reset requests are sent"
    annotation(Dialog(tab="Request limits", group="Chilled water requests", enable=have_chiWatCoi));

  parameter Real chiWatResReqLim3(
    final unit="K",
    final quantity="TemperatureDifference") = 5.56
    "Temperature difference limit between setpoint and supply air temperature above which three chilled water reset requests are sent"
    annotation(Dialog(tab="Request limits", group="Chilled water requests", enable=have_chiWatCoi));

  parameter Real chiWatResReqTimLim3(
    final unit="s",
    displayUnit="s",
    final quantity="Time") = 300
    "Time period for which chiWatResReqLim3 has to be exceeded before three chilled water reset requests are sent"
    annotation(Dialog(tab="Request limits", group="Chilled water requests", enable=have_chiWatCoi));

  parameter Real hotWatPlaReqLim0(
    final unit="1",
    displayUnit="1") = 0.1
    "Valve position limit below which zero hot water plant requests are sent when one request was previously being sent"
    annotation(Dialog(tab="Request limits", group="Hot water requests", enable=have_hotWatCoi));

  parameter Real hotWatResReqLim0(
    final unit="1",
    displayUnit="1") = 0.85
    "Valve position limit below which zero hot water reset requests are sent when one request was previously being sent"
    annotation(Dialog(tab="Request limits", group="Hot water requests", enable=have_hotWatCoi));

  parameter Real hotWatPlaReqLim1(
    final unit="1",
    displayUnit="1") = 0.95
    "Valve position limit above which one hot water plant request is sent"
    annotation(Dialog(tab="Request limits", group="Hot water requests", enable=have_hotWatCoi));

  parameter Real hotWatResReqLim2(
    final unit="K",
    final quantity="TemperatureDifference") = 8
    "Temperature difference limit between setpoint and supply air temperature above which two hot water reset requests are sent"
    annotation(Dialog(tab="Request limits", group="Hot water requests", enable=have_hotWatCoi));

  parameter Real hotWatResReqTimLim2(
    final unit="s",
    displayUnit="s",
    final quantity="Time") = 300
    "Time period for which hotWatResReqLim2 has to be exceeded before two hot water reset requests are sent"
    annotation(Dialog(tab="Request limits", group="Hot water requests", enable=have_hotWatCoi));

  parameter Real hotWatResReqLim3(
    final unit="K",
    final quantity="TemperatureDifference") = 17
    "Temperature difference limit between setpoint and supply air temperature above which three hot water reset requests are sent"
    annotation(Dialog(tab="Request limits", group="Hot water requests", enable=have_hotWatCoi));

  parameter Real hotWatResReqTimLim3(
    final unit="s",
    displayUnit="s",
    final quantity="Time") = 300
    "Time period for which hotWatResReqLim3 has to be exceeded before three hot water reset requests are sent"
    annotation(Dialog(tab="Request limits", group="Hot water requests", enable=have_hotWatCoi));

  parameter Real Thys(
    final unit="K",
    final quantity = "TemperatureDifference") = 0.1
    "Hysteresis for checking temperature difference"
    annotation(Dialog(tab="Advanced"));

  parameter Real posHys(
    final unit="1",
    displayUnit="1") = 0.05
    "Hysteresis for checking valve position difference"
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

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSupSet(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Supply air temperature setpoint"
    annotation (Placement(transformation(extent={{-240,140},{-200,180}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uCooCoi_actual(
    final unit="1",
    final min=0,
    final max=1) if have_chiWatCoi
    "Actual cooling coil control action"
    annotation (Placement(transformation(extent={{-240,80},{-200,120}}),
        iconTransformation(extent={{-140,-58},{-100,-18}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uHeaCoi_actual(
    final unit="1",
    final min=0,
    final max=1) if have_hotWatCoi
    "Actual heating coil control action"
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
    annotation (Placement(transformation(extent={{200,180},{240,220}}),
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
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hysFanCoo(
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

  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hysFanHea(
    final uLow=heaSpe_max - 2*dFanSpe,
    final uHigh=heaSpe_max - dFanSpe) if have_hotWatCoi
    "Check if fan is at max heating mode speed"
    annotation (Placement(transformation(extent={{-140,-20},{-120,0}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToIntHea if have_hotWatCoi
    "Output integer 1 when fan is at max heating mode speed"
    annotation (Placement(transformation(extent={{-90,-20},{-70,0}})));

  Buildings.Controls.OBC.CDL.Integers.Multiply mulIntHea if have_hotWatCoi
    "Output reset requests only if fan is at max heating mode speed"
    annotation (Placement(transformation(extent={{110,-10},{130,10}})));

  Buildings.Controls.OBC.CDL.Continuous.Subtract cooSupTemDif
    "Find the cooling supply temperature difference to the setpoint"
    annotation (Placement(transformation(extent={{-140,190},{-120,210}})));

  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greThr(
    final t=chiWatResReqLim3,
    final h=Thys) if have_chiWatCoi
    "Check if the supply temperature is greater than the setpoint by a threshold value"
    annotation (Placement(transformation(extent={{-80,190},{-60,210}})));

  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greThr1(
    final t=chiWatResReqLim2,
    final h=Thys) if have_chiWatCoi
    "Check if the supply temperature is greater than the setpoint by a threshold value"
    annotation (Placement(transformation(extent={{-80,140},{-60,160}})));

  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel(
    final delayTime=chiWatResReqTimLim3) if have_chiWatCoi
    "Check if the input has been true for a certain time"
    annotation (Placement(transformation(extent={{-40,190},{-20,210}})));

  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel1(
    final delayTime=chiWatResReqTimLim2) if have_chiWatCoi
    "Check if the input has been true for a certain time"
    annotation (Placement(transformation(extent={{-40,140},{-20,160}})));

  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greThr2(
    final t=chiWatPlaReqLim1,
    final h=posHys) if have_chiWatCoi
    "Check if the chilled water valve position is greater than a threshold value"
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

  Buildings.Controls.OBC.CDL.Continuous.LessThreshold lesThr(
    final t=chiWatResReqLim0,
    final h=posHys) if have_chiWatCoi
    "Check if the chilled water valve position is less than a threshold value"
    annotation (Placement(transformation(extent={{-120,50},{-100,70}})));

  Buildings.Controls.OBC.CDL.Logical.Latch lat if have_chiWatCoi
    "Keep true signal until other condition becomes true"
    annotation (Placement(transformation(extent={{-40,90},{-20,110}})));

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

  Buildings.Controls.OBC.CDL.Logical.Latch lat1 if have_chiWatCoi
    "Keep true signal until other condition becomes true"
    annotation (Placement(transformation(extent={{-40,10},{-20,30}})));

  Buildings.Controls.OBC.CDL.Continuous.LessThreshold lesThr1(
    final t=chiWatPlaReqLim0,
    final h=posHys) if have_chiWatCoi
    "Check if the chilled water valve position is less than a threshold value"
    annotation (Placement(transformation(extent={{-120,4},{-100,24}})));

  Buildings.Controls.OBC.CDL.Integers.Switch intSwi3 if have_chiWatCoi
    "Send 1 chiller plant request"
    annotation (Placement(transformation(extent={{80,10},{100,30}})));

  Buildings.Controls.OBC.CDL.Continuous.Subtract heaSupTemDif if have_hotWatCoi
    "Find the heating supply temperature difference to the setpoint"
    annotation (Placement(transformation(extent={{-140,-50},{-120,-30}})));

  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greThr3(
    final t=hotWatResReqLim3,
    final h=Thys) if have_hotWatCoi
    "Check if the supply temperature is less than the setpoint by a threshold value"
    annotation (Placement(transformation(extent={{-80,-50},{-60,-30}})));

  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greThr4(
    final t=hotWatResReqLim2,
    final h=Thys) if have_hotWatCoi
    "Check if the supply temperature is less than the setpoint by a threshold value"
    annotation (Placement(transformation(extent={{-80,-100},{-60,-80}})));

  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel2(
    final delayTime=hotWatResReqTimLim3) if have_hotWatCoi
    "Check if the input has been true for a certain time"
    annotation (Placement(transformation(extent={{-40,-50},{-20,-30}})));

  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel3(
    final delayTime=hotWatResReqTimLim2) if have_hotWatCoi
    "Check if the input has been true for a certain time"
    annotation (Placement(transformation(extent={{-40,-100},{-20,-80}})));

  Buildings.Controls.OBC.CDL.Integers.Switch hotWatRes3 if have_hotWatCoi
    "Send 3 hot water reset request"
    annotation (Placement(transformation(extent={{160,-50},{180,-30}})));

  Buildings.Controls.OBC.CDL.Integers.Switch hotWatRes2 if have_hotWatCoi
    "Send 2 hot water reset request"
    annotation (Placement(transformation(extent={{120,-100},{140,-80}})));

  Buildings.Controls.OBC.CDL.Continuous.LessThreshold lesThr2(
    final t=hotWatResReqLim0,
    final h=posHys) if have_hotWatCoi
    "Check if the hot water valve position is less than a threshold value"
    annotation (Placement(transformation(extent={{-120,-190},{-100,-170}})));

  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greThr5(
    final t=hotWatPlaReqLim1,
    final h=posHys) if have_hotWatCoi
    "Check if the hot water valve position is greater than a threshold value"
    annotation (Placement(transformation(extent={{-120,-150},{-100,-130}})));

  Buildings.Controls.OBC.CDL.Logical.Latch lat2 if have_hotWatCoi
    "Keep true signal until other condition becomes true"
    annotation (Placement(transformation(extent={{-40,-150},{-20,-130}})));

  Buildings.Controls.OBC.CDL.Integers.Switch hotWatRes1 if have_hotWatCoi
    "Send 1 hot water reset request"
    annotation (Placement(transformation(extent={{80,-150},{100,-130}})));

  Buildings.Controls.OBC.CDL.Continuous.LessThreshold lesThr3(
    final t=hotWatPlaReqLim0,
    final h=posHys) if have_hotWatCoi
    "Check if the hot water valve position is less than a threshold value"
    annotation (Placement(transformation(extent={{-120,-236},{-100,-216}})));

  Buildings.Controls.OBC.CDL.Logical.Latch lat3 if have_hotWatCoi
    "Keep true signal until other condition becomes true"
    annotation (Placement(transformation(extent={{-40,-230},{-20,-210}})));

  Buildings.Controls.OBC.CDL.Integers.Switch intSwi1 if have_hotWatCoi
    "Send 1 hot water plant request"
    annotation (Placement(transformation(extent={{80,-230},{100,-210}})));

equation
  connect(TAirSup, cooSupTemDif.u1) annotation (Line(points={{-220,200},{-180,200},
          {-180,206},{-142,206}}, color={0,0,127}));

  connect(TSupSet, cooSupTemDif.u2) annotation (Line(points={{-220,160},{-190,160},
          {-190,194},{-142,194}}, color={0,0,127}));

  connect(cooSupTemDif.y, greThr.u)
    annotation (Line(points={{-118,200},{-82,200}}, color={0,0,127}));

  connect(greThr.y, truDel.u)
    annotation (Line(points={{-58,200},{-42,200}}, color={255,0,255}));

  connect(greThr1.y, truDel1.u)
    annotation (Line(points={{-58,150},{-42,150}}, color={255,0,255}));

  connect(cooSupTemDif.y, greThr1.u) annotation (Line(points={{-118,200},{-100,200},
          {-100,150},{-82,150}}, color={0,0,127}));

  connect(uCooCoi_actual, greThr2.u)
    annotation (Line(points={{-220,100},{-122,100}}, color={0,0,127}));

  connect(truDel.y, chiWatRes3.u2)
    annotation (Line(points={{-18,200},{158,200}}, color={255,0,255}));

  connect(thr.y, chiWatRes3.u1) annotation (Line(points={{22,232},{60,232},{60,208},
          {158,208}}, color={255,127,0}));

  connect(truDel1.y, chiWatRes2.u2)
    annotation (Line(points={{-18,150},{118,150}}, color={255,0,255}));

  connect(two.y, chiWatRes2.u1) annotation (Line(points={{22,180},{50,180},{50,158},
          {118,158}}, color={255,127,0}));

  connect(greThr2.y, lat.u)
    annotation (Line(points={{-98,100},{-42,100}}, color={255,0,255}));

  connect(uCooCoi_actual, lesThr.u) annotation (Line(points={{-220,100},{-140,100},
          {-140,60},{-122,60}}, color={0,0,127}));

  connect(lesThr.y, lat.clr) annotation (Line(points={{-98,60},{-60,60},{-60,94},
          {-42,94}}, color={255,0,255}));

  connect(one.y, chiWatRes1.u1) annotation (Line(points={{22,120},{40,120},{40,108},
          {78,108}}, color={255,127,0}));

  connect(lat.y, chiWatRes1.u2)
    annotation (Line(points={{-18,100},{78,100}}, color={255,0,255}));

  connect(chiWatRes1.y, chiWatRes2.u3) annotation (Line(points={{102,100},{110,100},
          {110,142},{118,142}}, color={255,127,0}));

  connect(chiWatRes2.y, chiWatRes3.u3) annotation (Line(points={{142,150},{150,150},
          {150,192},{158,192}}, color={255,127,0}));

  connect(zer.y, chiWatRes1.u3) annotation (Line(points={{22,60},{30,60},{30,92},
          {78,92}}, color={255,127,0}));

  connect(greThr2.y, lat1.u) annotation (Line(points={{-98,100},{-80,100},{-80,20},
          {-42,20}}, color={255,0,255}));

  connect(uCooCoi_actual, lesThr1.u) annotation (Line(points={{-220,100},{-140,100},
          {-140,14},{-122,14}}, color={0,0,127}));

  connect(lesThr1.y, lat1.clr)
    annotation (Line(points={{-98,14},{-42,14}}, color={255,0,255}));

  connect(lat1.y, intSwi3.u2)
    annotation (Line(points={{-18,20},{78,20}}, color={255,0,255}));

  connect(one.y, intSwi3.u1) annotation (Line(points={{22,120},{40,120},{40,28},
          {78,28}}, color={255,127,0}));

  connect(zer.y, intSwi3.u3) annotation (Line(points={{22,60},{30,60},{30,12},{78,
          12}}, color={255,127,0}));

  connect(intSwi3.y, yChiPlaReq)
    annotation (Line(points={{102,20},{220,20}}, color={255,127,0}));

  connect(TAirSup, heaSupTemDif.u2) annotation (Line(points={{-220,200},{-180,200},
          {-180,-46},{-142,-46}}, color={0,0,127}));

  connect(greThr3.y, truDel2.u)
    annotation (Line(points={{-58,-40},{-42,-40}}, color={255,0,255}));

  connect(greThr4.y, truDel3.u)
    annotation (Line(points={{-58,-90},{-42,-90}}, color={255,0,255}));

  connect(heaSupTemDif.y, greThr3.u)
    annotation (Line(points={{-118,-40},{-82,-40}}, color={0,0,127}));

  connect(heaSupTemDif.y, greThr4.u) annotation (Line(points={{-118,-40},{-100,-40},
          {-100,-90},{-82,-90}}, color={0,0,127}));

  connect(truDel2.y, hotWatRes3.u2)
    annotation (Line(points={{-18,-40},{158,-40}}, color={255,0,255}));

  connect(thr.y, hotWatRes3.u1) annotation (Line(points={{22,232},{60,232},{60,-32},
          {158,-32}}, color={255,127,0}));

  connect(hotWatRes2.y, hotWatRes3.u3) annotation (Line(points={{142,-90},{150,-90},
          {150,-48},{158,-48}}, color={255,127,0}));

  connect(two.y, hotWatRes2.u1) annotation (Line(points={{22,180},{50,180},{50,-82},
          {118,-82}}, color={255,127,0}));

  connect(truDel3.y, hotWatRes2.u2)
    annotation (Line(points={{-18,-90},{118,-90}}, color={255,0,255}));

  connect(uHeaCoi_actual, greThr5.u)
    annotation (Line(points={{-220,-140},{-122,-140}}, color={0,0,127}));

  connect(greThr5.y, lat2.u)
    annotation (Line(points={{-98,-140},{-42,-140}}, color={255,0,255}));

  connect(uHeaCoi_actual, lesThr2.u) annotation (Line(points={{-220,-140},{-140,
          -140},{-140,-180},{-122,-180}}, color={0,0,127}));

  connect(lesThr2.y, lat2.clr) annotation (Line(points={{-98,-180},{-60,-180},{-60,
          -146},{-42,-146}}, color={255,0,255}));

  connect(lat2.y, hotWatRes1.u2)
    annotation (Line(points={{-18,-140},{78,-140}}, color={255,0,255}));

  connect(one.y, hotWatRes1.u1) annotation (Line(points={{22,120},{40,120},{40,-132},
          {78,-132}}, color={255,127,0}));

  connect(zer.y, hotWatRes1.u3) annotation (Line(points={{22,60},{30,60},{30,-148},
          {78,-148}}, color={255,127,0}));

  connect(hotWatRes1.y, hotWatRes2.u3) annotation (Line(points={{102,-140},{110,
          -140},{110,-98},{118,-98}}, color={255,127,0}));

  connect(uHeaCoi_actual, lesThr3.u) annotation (Line(points={{-220,-140},{-140,
          -140},{-140,-226},{-122,-226}}, color={0,0,127}));

  connect(lesThr3.y, lat3.clr)
    annotation (Line(points={{-98,-226},{-42,-226}}, color={255,0,255}));

  connect(greThr5.y, lat3.u) annotation (Line(points={{-98,-140},{-80,-140},{-80,
          -220},{-42,-220}}, color={255,0,255}));

  connect(lat3.y, intSwi1.u2)
    annotation (Line(points={{-18,-220},{78,-220}}, color={255,0,255}));

  connect(one.y, intSwi1.u1) annotation (Line(points={{22,120},{40,120},{40,-212},
          {78,-212}}, color={255,127,0}));

  connect(zer.y, intSwi1.u3) annotation (Line(points={{22,60},{30,60},{30,-228},
          {78,-228}}, color={255,127,0}));

  connect(intSwi1.y, yHotWatPlaReq)
    annotation (Line(points={{102,-220},{220,-220}}, color={255,127,0}));

  connect(yChiWatResReq, yChiWatResReq)
    annotation (Line(points={{220,200},{220,200}}, color={255,127,0}));

  connect(uFan, hysFanCoo.u)
    annotation (Line(points={{-220,240},{-132,240}}, color={0,0,127}));

  connect(hysFanCoo.y, booToIntCoo.u)
    annotation (Line(points={{-108,240},{-82,240}}, color={255,0,255}));

  connect(chiWatRes3.y, mulIntCoo.u2) annotation (Line(points={{182,200},{188,200},
          {188,220},{90,220},{90,234},{98,234}}, color={255,127,0}));

  connect(booToIntCoo.y, mulIntCoo.u1) annotation (Line(points={{-58,240},{-20,240},
          {-20,252},{60,252},{60,246},{98,246}}, color={255,127,0}));

  connect(mulIntCoo.y, yChiWatResReq) annotation (Line(points={{122,240},{194,240},
          {194,200},{220,200}}, color={255,127,0}));

  connect(hotWatRes3.y, mulIntHea.u2) annotation (Line(points={{182,-40},{186,-40},
          {186,-20},{104,-20},{104,-6},{108,-6}}, color={255,127,0}));

  connect(hysFanHea.y, booToIntHea.u)
    annotation (Line(points={{-118,-10},{-92,-10}}, color={255,0,255}));

  connect(booToIntHea.y, mulIntHea.u1) annotation (Line(points={{-68,-10},{100,-10},
          {100,6},{108,6}}, color={255,127,0}));

  connect(uFan, hysFanHea.u) annotation (Line(points={{-220,240},{-170,240},{
          -170,-10},{-142,-10}}, color={0,0,127}));

  connect(mulIntHea.y, yHotWatResReq) annotation (Line(points={{132,0},{192,0},{
          192,-40},{220,-40}}, color={255,127,0}));

  connect(TSupSet, heaSupTemDif.u1) annotation (Line(points={{-220,160},{-190,160},
          {-190,-34},{-142,-34}}, color={0,0,127}));

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
          extent={{-98,48},{-76,32}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TSup"),
        Text(
          extent={{-100,160},{100,120}},
          textColor={0,0,255},
          textString="%name"),
        Text(
          extent={{-98,10},{-60,-8}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TSupSet"),
        Text(
          extent={{-98,-32},{-24,-46}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="uCooCoi_actual",
          visible=have_chiWatCoi),
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
          extent={{-100,86},{-72,76}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="uFan"),
        Text(
          extent={{-98,-72},{-24,-86}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="uHeaCoi_actual",
          visible=have_hotWatCoi)}),
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-200,-260},{200,260}})),
  Documentation(info="<html>
<p>This sequence outputs the system reset requests for fan coil unit. The implementation is according to the Section 5.22.8 of ASHRAE Guideline 36, 2021. </p>
<p><b>If there is a chilled-water coil (<span style=\"font-family: Courier New;\">have_chiWatCoi=true</span>), chilled water reset requests <span style=\"font-family: Courier New;\">yChiWatResReq</span></b></p>
<ol>
<li>If the supply air temperature <span style=\"font-family: Courier New;\">TAirSup</span> exceeds the supply air temperature set point <span style=\"font-family: Courier New;\">TSupSet</span> by 5.56 &deg;C (10 &deg;F) for 5 minutes, send 3 requests. </li>
<li>If the supply air temperature <span style=\"font-family: Courier New;\">TAirSup</span> exceeds <span style=\"font-family: Courier New;\">TSupSet</span> by by 2.78 &deg;C (5 &deg;F) for 5 minutes, send 2 requests. </li>
<li>Else if the chilled water valve position <span style=\"font-family: Courier New;\">uCooCoi_actual</span> is greater than 0.95, send 1 request until <span style=\"font-family: Courier New;\">uCooCoi_actual</span> is less than 0.85. </li>
<li>Else if the chilled water valve position <span style=\"font-family: Courier New;\">uCooCoi_actual</span> is less than 0.85, send 0 requests. </li>
</ol>
<p><b>If there is a chilled-water coil and chilled water plant, chiller plant request <span style=\"font-family: Courier New;\">yChiPlaReq</span></b></p>
<p>Send the chiller plant that serves the system a chiller plant request as follows: </p>
<ol>
<li>If the chilled water valve position <span style=\"font-family: Courier New;\">uCooCoi_actual</span> is greater than 0.95, send 1 request until the <span style=\"font-family: Courier New;\">uCooCoi_actual</span> is less than 0.1. </li>
<li>Else if the chilled water valve position <span style=\"font-family: Courier New;\">uCooCoi_actual</span> is less than 0.1, send 0 request. </li>
</ol>
<p><b>If there is a hot-water coil (<span style=\"font-family: Courier New;\">have_hotWatCoi=true</span>), hot-water reset requests <span style=\"font-family: Courier New;\">yHotWatResReq</span></b></p>
<ol>
<li>If the supply air temperature <span style=\"font-family: Courier New;\">TAirSup</span> is 17 &deg;C (30 &deg;F) less than the supply air temperature set point <span style=\"font-family: Courier New;\">TSupSet</span> for 5 minutes, send 3 requests. </li>
<li>Else if the supply air temperature <span style=\"font-family: Courier New;\">TAirSup</span> is 8 &deg;C (15 &deg;F) less than <span style=\"font-family: Courier New;\">TSupSet</span> for 5 minutes, send 2 requests. </li>
<li>Else if the hot water valve position <span style=\"font-family: Courier New;\">uHeaCoi_actual</span> is greater than 0.95, send 1 request until the <span style=\"font-family: Courier New;\">uHeaCoi_actual</span> is less than 0.85. </li>
<li>Else if the hot water valve position <span style=\"font-family: Courier New;\">uHeaCoi_actual</span> is less than 0.85, send 0 request. </li>
</ol>
<p><b>If there is a hot-water coil and heating hot-water plant, heating hot-water plant requests <span style=\"font-family: Courier New;\">yHotWatPlaReq</span></b></p>
<p>Send the heating hot-water plant that serves the air handling unit a heating hot-water plant request as follows: </p>
<ol>
<li>If the hot water valve position <span style=\"font-family: Courier New;\">uHeaCoi_actual</span> is greater than 0.95, send 1 request until the hot water valve position is less than 0.1. </li>
<li>If the hot water valve position <span style=\"font-family: Courier New;\">uHeaCoi_actual</span> is less than 0.1, send 0 requests. </li>
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
