within Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.DualDuctMixConDischargeSensor.Subsequences;
block SystemRequests
  "Output system requests for dual-duct unit using mixing control with discharge flow sensor"

  parameter Real thrTemDif(
    final unit="K",
    final quantity="TemperatureDifference")=3
    "Threshold difference between zone temperature and cooling setpoint for generating 3 cooling SAT reset requests"
    annotation (__cdl(ValueInReference=true));
  parameter Real twoTemDif(
    final unit="K",
    final quantity="TemperatureDifference")=2
    "Threshold difference between zone temperature and cooling setpoint for generating 2 cooling SAT reset requests"
    annotation (__cdl(ValueInReference=true));
  parameter Real durTimTem(
    final unit="s",
    final quantity="Time")=120
    "Duration time of zone temperature exceeds setpoint"
    annotation (__cdl(ValueInReference=true), Dialog(group="Duration times"));
  parameter Real durTimFlo(
    final unit="s",
    final quantity="Time")=60
    "Duration time of airflow rate less than setpoint"
    annotation(__cdl(ValueInReference=true), Dialog(group="Duration times"));
  parameter Real dTHys(
    final unit="K",
    final quantity="TemperatureDifference")=0.25
    "Near zero temperature difference, below which the difference will be seen as zero"
    annotation (__cdl(ValueInReference=false), Dialog(tab="Advanced"));
  parameter Real floHys(
    final quantity="VolumeFlowRate",
    final unit="m3/s")
    "Near zero flow rate, below which the flow rate or difference will be seen as zero"
    annotation (Dialog(tab="Advanced"));
  parameter Real looHys(unit="1")
    "Loop output hysteresis below which the output will be seen as zero"
    annotation (Dialog(tab="Advanced"));
  parameter Real damPosHys(
    final unit="1")
    "Near zero damper position, below which the damper will be seen as closed"
    annotation (Dialog(tab="Advanced"));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uAftSupCoo
    "After suppression period due to the cooling setpoint change"
    annotation (Placement(transformation(extent={{-240,400},{-200,440}}),
        iconTransformation(extent={{-140,170},{-100,210}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TCooSet(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Zone cooling setpoint temperature"
    annotation (Placement(transformation(extent={{-240,360},{-200,400}}),
        iconTransformation(extent={{-140,140},{-100,180}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TZon(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Zone temperature"
    annotation (Placement(transformation(extent={{-240,300},{-200,340}}),
        iconTransformation(extent={{-140,110},{-100,150}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uCoo(
    final min=0,
    final max=1,
    final unit="1") "Cooling loop signal"
    annotation (Placement(transformation(extent={{-240,270},{-200,310}}),
        iconTransformation(extent={{-140,80},{-100,120}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uAftSupHea
    "After suppression period due to the heating setpoint change"
    annotation (Placement(transformation(extent={{-240,210},{-200,250}}),
        iconTransformation(extent={{-140,30},{-100,70}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput THeaSet(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Zone heating setpoint temperature" annotation (Placement(transformation(
          extent={{-240,170},{-200,210}}), iconTransformation(extent={{-140,0},{
            -100,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uHea(
    final min=0,
    final max=1,
    final unit="1")
    "Heating loop signal"
    annotation (Placement(transformation(extent={{-240,80},{-200,120}}),
        iconTransformation(extent={{-140,-30},{-100,10}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VDis_flow_Set(
    final min=0,
    final unit="m3/s",
    quantity="VolumeFlowRate")
    "Discharge airflow rate setpoint"
    annotation (Placement(transformation(extent={{-240,20},{-200,60}}),
        iconTransformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VDis_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate")
    "Measured discharge airflow rate"
    annotation (Placement(transformation(extent={{-240,-70},{-200,-30}}),
        iconTransformation(extent={{-140,-110},{-100,-70}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uCooDam(
    final min=0,
    final max=1,
    final unit="1") "Cooling damper position setpoint" annotation (Placement(
        transformation(extent={{-240,-110},{-200,-70}}), iconTransformation(
          extent={{-140,-160},{-100,-120}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uHeaDam(
    final min=0,
    final max=1,
    final unit="1") "Heating damper position setpoint" annotation (Placement(
        transformation(extent={{-240,-360},{-200,-320}}), iconTransformation(
          extent={{-140,-190},{-100,-150}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yZonCooTemResReq
    "Zone cooling supply air temperature reset request"
    annotation (Placement(transformation(extent={{200,380},{240,420}}),
        iconTransformation(extent={{100,60},{140,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yColDucPreResReq
    "Cold duct static pressure reset requests"
    annotation (Placement(transformation(extent={{200,-80},{240,-40}}),
        iconTransformation(extent={{100,10},{140,50}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yZonHeaTemResReq
    "Zone heating supply air temperature reset request"
    annotation (Placement(transformation(extent={{200,190},{240,230}}),
        iconTransformation(extent={{100,-50},{140,-10}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yHotDucPreResReq
    "Hot duct static pressure reset requests"
    annotation (Placement(transformation(extent={{200,-350},{240,-310}}),
        iconTransformation(extent={{100,-100},{140,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yHeaFanReq
    "Heating fan request"
    annotation (Placement(transformation(extent={{200,-440},{240,-400}}),
        iconTransformation(extent={{100,-200},{140,-160}})));

protected
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greThr1(
    final t=thrTemDif,
    final h=dTHys)
    "Check if zone temperature is greater than cooling setpoint by threshold"
    annotation (Placement(transformation(extent={{-80,370},{-60,390}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greThr2(
    final t=twoTemDif,
    final h=dTHys)
    "Check if zone temperature is greater than cooling setpoint by threshold"
    annotation (Placement(transformation(extent={{-80,330},{-60,350}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greThr3(
    final t=0.95,
    final h=damPosHys)
    "Check if damper position is greater than 0.95"
    annotation (Placement(transformation(extent={{-160,-100},{-140,-80}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greThr(
    final t=0.95,
    final h=looHys)
    "Check if cooling loop signal is greater than 0.95"
    annotation (Placement(transformation(extent={{-80,280},{-60,300}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greThr4(
    final t=floHys,
    final h=0.5*floHys)
    "Check if discharge airflow setpoint is greater than 0"
    annotation (Placement(transformation(extent={{-140,30},{-120,50}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt
    "Convert boolean to integer"
    annotation (Placement(transformation(extent={{20,280},{40,300}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt1
    "Convert boolean to integer"
    annotation (Placement(transformation(extent={{20,-100},{40,-80}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiplyByParameter gai1(
    final k=0.5)
    "50% of setpoint"
    annotation (Placement(transformation(extent={{-140,0},{-120,20}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiplyByParameter gai2(
    final k=0.7)
    "70% of setpoint"
    annotation (Placement(transformation(extent={{-140,-40},{-120,-20}})));
  Buildings.Controls.OBC.CDL.Continuous.Subtract sub2
    "Calculate difference between zone temperature and cooling setpoint"
    annotation (Placement(transformation(extent={{-120,370},{-100,390}})));
  Buildings.Controls.OBC.CDL.Continuous.Subtract sub3
    "Calculate difference between zone temperature and cooling setpoint"
    annotation (Placement(transformation(extent={{-120,330},{-100,350}})));
  Buildings.Controls.OBC.CDL.Logical.And and1
    "Logical and"
    annotation (Placement(transformation(extent={{20,330},{40,350}})));
  Buildings.Controls.OBC.CDL.Logical.And and2
    "Logical and"
    annotation (Placement(transformation(extent={{20,390},{40,410}})));
  Buildings.Controls.OBC.CDL.Logical.And and3
    "Logical and"
    annotation (Placement(transformation(extent={{20,10},{40,30}})));
  Buildings.Controls.OBC.CDL.Logical.And and4
    "Logical and"
    annotation (Placement(transformation(extent={{20,-60},{40,-40}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant thrCooResReq(
    final k=3)
    "Constant 3"
    annotation (Placement(transformation(extent={{80,430},{100,450}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant twoCooResReq(
    final k=2) "Constant 2"
    annotation (Placement(transformation(extent={{20,430},{40,450}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant thrPreResReq(
    final k=3) "Constant 3"
    annotation (Placement(transformation(extent={{80,30},{100,50}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant twoPreResReq(
    final k=2)
    "Constant 2"
    annotation (Placement(transformation(extent={{20,-30},{40,-10}})));
  Buildings.Controls.OBC.CDL.Integers.Switch intSwi
    "Output 3 or other request "
    annotation (Placement(transformation(extent={{160,390},{180,410}})));
  Buildings.Controls.OBC.CDL.Integers.Switch intSwi1
    "Output 2 or other request "
    annotation (Placement(transformation(extent={{80,330},{100,350}})));
  Buildings.Controls.OBC.CDL.Integers.Switch swi4
    "Output 3 or other request "
    annotation (Placement(transformation(extent={{120,10},{140,30}})));
  Buildings.Controls.OBC.CDL.Integers.Switch swi5
    "Output 2 or other request "
    annotation (Placement(transformation(extent={{80,-60},{100,-40}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay tim1(
    final delayTime=durTimTem) "Check if it is more than threshold time"
    annotation (Placement(transformation(extent={{-40,370},{-20,390}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay tim2(
    final delayTime=durTimTem) "Check if it is more than threshold time"
    annotation (Placement(transformation(extent={{-40,330},{-20,350}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay tim3(
    final delayTime=durTimFlo) "Check if it is more than threshold time"
    annotation (Placement(transformation(extent={{-80,-80},{-60,-60}})));
  Buildings.Controls.OBC.CDL.Continuous.Greater greEqu(final h=floHys)
    "Check if discharge airflow is less than 50% of setpoint"
    annotation (Placement(transformation(extent={{-80,0},{-60,20}})));
  Buildings.Controls.OBC.CDL.Continuous.Greater greEqu1(final h=floHys)
    "Check if discharge airflow is less than 70% of setpoint"
    annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));
  Buildings.Controls.OBC.CDL.Logical.And and5
    "Logical and"
    annotation (Placement(transformation(extent={{-40,30},{-20,50}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greThr7(
    final t=thrTemDif,
    final h=dTHys)
    "Check if zone temperature is less than heating setpoint by threshold"
    annotation (Placement(transformation(extent={{-80,180},{-60,200}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greThr8(
    final t=twoTemDif,
    final h=dTHys)
    "Check if zone temperature is less than heating setpoint by threshold"
    annotation (Placement(transformation(extent={{-80,140},{-60,160}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greThr9(
    final t=0.95,
    final h=damPosHys)
    "Check if damper position is greater than 0.95"
    annotation (Placement(transformation(extent={{-180,-350},{-160,-330}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greThr10(
    final t=0.95,
    final h=looHys) "Check if heating loop signal is greater than 0.95"
    annotation (Placement(transformation(extent={{-80,90},{-60,110}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt4
    "Convert boolean to integer"
    annotation (Placement(transformation(extent={{20,90},{40,110}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt5
    "Convert boolean to integer"
    annotation (Placement(transformation(extent={{20,-350},{40,-330}})));
  Buildings.Controls.OBC.CDL.Continuous.Subtract sub1
    "Calculate difference between zone temperature and heating setpoint"
    annotation (Placement(transformation(extent={{-140,180},{-120,200}})));
  Buildings.Controls.OBC.CDL.Continuous.Subtract sub4
    "Calculate difference between zone temperature and heating setpoint"
    annotation (Placement(transformation(extent={{-140,140},{-120,160}})));
  Buildings.Controls.OBC.CDL.Logical.And and6
    "Logical and"
    annotation (Placement(transformation(extent={{20,140},{40,160}})));
  Buildings.Controls.OBC.CDL.Logical.And and7
    "Logical and"
    annotation (Placement(transformation(extent={{20,200},{40,220}})));
  Buildings.Controls.OBC.CDL.Logical.And and8
    "Logical and"
    annotation (Placement(transformation(extent={{20,-240},{40,-220}})));
  Buildings.Controls.OBC.CDL.Logical.And and9
    "Logical and"
    annotation (Placement(transformation(extent={{20,-310},{40,-290}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant thrCooResReq1(
    final k=3)
    "Constant 3"
    annotation (Placement(transformation(extent={{80,240},{100,260}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant twoCooResReq1(
    final k=2)
    "Constant 2"
    annotation (Placement(transformation(extent={{20,240},{40,260}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant thrPreResReq1(
    final k=3)
    "Constant 3"
    annotation (Placement(transformation(extent={{80,-220},{100,-200}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant twoPreResReq1(
    final k=2)
    "Constant 2"
    annotation (Placement(transformation(extent={{20,-280},{40,-260}})));
  Buildings.Controls.OBC.CDL.Integers.Switch intSwi4
    "Output 3 or other request "
    annotation (Placement(transformation(extent={{162,200},{182,220}})));
  Buildings.Controls.OBC.CDL.Integers.Switch intSwi5
    "Output 2 or other request "
    annotation (Placement(transformation(extent={{80,140},{100,160}})));
  Buildings.Controls.OBC.CDL.Integers.Switch swi1
    "Output 3 or other request "
    annotation (Placement(transformation(extent={{120,-240},{140,-220}})));
  Buildings.Controls.OBC.CDL.Integers.Switch swi2
    "Output 2 or other request "
    annotation (Placement(transformation(extent={{80,-310},{100,-290}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay tim6(
    final delayTime=durTimTem)
    "Check if it is more than threshold time"
    annotation (Placement(transformation(extent={{-40,180},{-20,200}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay tim7(
    final delayTime=durTimTem)
    "Check if it is more than threshold time"
    annotation (Placement(transformation(extent={{-40,140},{-20,160}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay tim8(
    final delayTime=durTimFlo)
    "Check if it is more than threshold time"
    annotation (Placement(transformation(extent={{-140,-330},{-120,-310}})));
  Buildings.Controls.OBC.CDL.Logical.And and10
    "Logical and"
    annotation (Placement(transformation(extent={{-100,-220},{-80,-200}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greThr12(
    final t=0.15,
    final h=looHys)
    "Check if heating loop signal is greater than 0.15"
    annotation (Placement(transformation(extent={{-80,-430},{-60,-410}})));
  Buildings.Controls.OBC.CDL.Logical.Latch lat "Hold the true input"
    annotation (Placement(transformation(extent={{0,-430},{20,-410}})));
  Buildings.Controls.OBC.CDL.Continuous.LessThreshold lesThr(
    final t=0.01,
    final h=looHys)
    "Check if the heating loop output is less than threshold"
    annotation (Placement(transformation(extent={{-80,-460},{-60,-440}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt6
    "Heating fan request"
    annotation (Placement(transformation(extent={{80,-430},{100,-410}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greThr5(
    final t=looHys,
    final h=0.5*looHys)
    "Check if it is heating state"
    annotation (Placement(transformation(extent={{-80,-380},{-60,-360}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greThr6(
    final t=looHys,
    final h=0.5*looHys)
    "Check if it is heating state"
    annotation (Placement(transformation(extent={{-160,-170},{-140,-150}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greThr13(
    final t=looHys,
    final h=0.5*looHys)
    "Check if it is cooling state"
    annotation (Placement(transformation(extent={{-160,-130},{-140,-110}})));
  Buildings.Controls.OBC.CDL.Logical.Or or2
    "Cooing or heating state"
    annotation (Placement(transformation(extent={{-100,-150},{-80,-130}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1
    "In deadband state"
    annotation (Placement(transformation(extent={{20,-150},{40,-130}})));
  Buildings.Controls.OBC.CDL.Logical.Or or1
    "Cooing or deadband state"
    annotation (Placement(transformation(extent={{60,-130},{80,-110}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt3
    "Convert boolean to integer"
    annotation (Placement(transformation(extent={{-20,-380},{0,-360}})));
  Buildings.Controls.OBC.CDL.Integers.Multiply mulInt2
    "Ensure zero request when the it is not in heating state"
    annotation (Placement(transformation(extent={{160,-340},{180,-320}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt2
    "Convert boolean to integer"
    annotation (Placement(transformation(extent={{100,-130},{120,-110}})));
  Buildings.Controls.OBC.CDL.Integers.Multiply mulInt1
    "Ensure zero request when it is in heating state"
    annotation (Placement(transformation(extent={{160,-70},{180,-50}})));

equation
  connect(sub2.y, greThr1.u)
    annotation (Line(points={{-98,380},{-82,380}}, color={0,0,127}));
  connect(and2.y, intSwi.u2)
    annotation (Line(points={{42,400},{158,400}},color={255,0,255}));
  connect(sub3.y, greThr2.u)
    annotation (Line(points={{-98,340},{-82,340}}, color={0,0,127}));
  connect(and1.y, intSwi1.u2)
    annotation (Line(points={{42,340},{78,340}}, color={255,0,255}));
  connect(and3.y, swi4.u2)
    annotation (Line(points={{42,20},{118,20}},  color={255,0,255}));
  connect(and4.y, swi5.u2)
    annotation (Line(points={{42,-50},{78,-50}},   color={255,0,255}));
  connect(greThr2.y, tim2.u)
    annotation (Line(points={{-58,340},{-42,340}}, color={255,0,255}));
  connect(tim2.y, and1.u2)
    annotation (Line(points={{-18,340},{-10,340},{-10,332},{18,332}},
      color={255,0,255}));
  connect(greThr1.y, tim1.u)
    annotation (Line(points={{-58,380},{-42,380}}, color={255,0,255}));
  connect(tim1.y, and2.u2)
    annotation (Line(points={{-18,380},{-10,380},{-10,392},{18,392}},
      color={255,0,255}));
  connect(greThr4.u, VDis_flow_Set)
    annotation (Line(points={{-142,40},{-220,40}}, color={0,0,127}));
  connect(greEqu.u1, gai1.y)
    annotation (Line(points={{-82,10},{-118,10}},  color={0,0,127}));
  connect(greEqu.y, and3.u2)
    annotation (Line(points={{-58,10},{-30,10},{-30,12},{18,12}},
      color={255,0,255}));
  connect(gai2.y, greEqu1.u1)
    annotation (Line(points={{-118,-30},{-82,-30}},
      color={0,0,127}));
  connect(greEqu1.y, and4.u2)
    annotation (Line(points={{-58,-30},{-20,-30},{-20,-58},{18,-58}},
      color={255,0,255}));
  connect(uCoo, greThr.u)
    annotation (Line(points={{-220,290},{-82,290}}, color={0,0,127}));
  connect(uAftSupCoo, and2.u1) annotation (Line(points={{-220,420},{0,420},{0,400},
          {18,400}},      color={255,0,255}));
  connect(uAftSupCoo, and1.u1) annotation (Line(points={{-220,420},{0,420},{0,340},
          {18,340}},      color={255,0,255}));
  connect(thrCooResReq.y, intSwi.u1) annotation (Line(points={{102,440},{120,440},
          {120,408},{158,408}},      color={255,127,0}));
  connect(twoCooResReq.y, intSwi1.u1) annotation (Line(points={{42,440},{60,440},
          {60,348},{78,348}}, color={255,127,0}));
  connect(intSwi1.y, intSwi.u3) annotation (Line(points={{102,340},{120,340},{120,
          392},{158,392}},     color={255,127,0}));
  connect(intSwi.y, yZonCooTemResReq)
    annotation (Line(points={{182,400},{220,400}}, color={255,127,0}));
  connect(greThr.y, booToInt.u)
    annotation (Line(points={{-58,290},{18,290}}, color={255,0,255}));
  connect(booToInt.y, intSwi1.u3) annotation (Line(points={{42,290},{60,290},{60,
          332},{78,332}},    color={255,127,0}));
  connect(uCooDam, greThr3.u)
    annotation (Line(points={{-220,-90},{-162,-90}}, color={0,0,127}));
  connect(VDis_flow_Set, gai1.u) annotation (Line(points={{-220,40},{-160,40},{-160,
          10},{-142,10}}, color={0,0,127}));
  connect(VDis_flow_Set, gai2.u) annotation (Line(points={{-220,40},{-160,40},{-160,
          -30},{-142,-30}}, color={0,0,127}));
  connect(VDis_flow, greEqu.u2) annotation (Line(points={{-220,-50},{-100,-50},{
          -100,2},{-82,2}}, color={0,0,127}));
  connect(VDis_flow, greEqu1.u2) annotation (Line(points={{-220,-50},{-100,-50},
          {-100,-38},{-82,-38}}, color={0,0,127}));
  connect(greThr3.y, tim3.u) annotation (Line(points={{-138,-90},{-100,-90},{-100,
          -70},{-82,-70}}, color={255,0,255}));
  connect(greThr4.y, and5.u1)
    annotation (Line(points={{-118,40},{-42,40}},   color={255,0,255}));
  connect(tim3.y, and5.u2) annotation (Line(points={{-58,-70},{-50,-70},{-50,32},
          {-42,32}},  color={255,0,255}));
  connect(and5.y, and3.u1) annotation (Line(points={{-18,40},{0,40},{0,20},{18,20}},
                 color={255,0,255}));
  connect(and5.y, and4.u1) annotation (Line(points={{-18,40},{0,40},{0,-50},{18,
          -50}},     color={255,0,255}));
  connect(greThr3.y, booToInt1.u) annotation (Line(points={{-138,-90},{18,-90}},
          color={255,0,255}));
  connect(booToInt1.y, swi5.u3) annotation (Line(points={{42,-90},{60,-90},{60,-58},
          {78,-58}},        color={255,127,0}));
  connect(twoPreResReq.y, swi5.u1) annotation (Line(points={{42,-20},{60,-20},{60,
          -42},{78,-42}},       color={255,127,0}));
  connect(thrPreResReq.y, swi4.u1) annotation (Line(points={{102,40},{110,40},{110,
          28},{118,28}},        color={255,127,0}));
  connect(swi5.y, swi4.u3) annotation (Line(points={{102,-50},{110,-50},{110,12},
          {118,12}},  color={255,127,0}));
  connect(TCooSet, sub3.u2) annotation (Line(points={{-220,380},{-160,380},{-160,
          334},{-122,334}}, color={0,0,127}));
  connect(TCooSet, sub2.u2) annotation (Line(points={{-220,380},{-160,380},{-160,
          374},{-122,374}}, color={0,0,127}));
  connect(TZon, sub2.u1) annotation (Line(points={{-220,320},{-180,320},{-180,386},
          {-122,386}}, color={0,0,127}));
  connect(TZon, sub3.u1) annotation (Line(points={{-220,320},{-180,320},{-180,346},
          {-122,346}}, color={0,0,127}));
  connect(sub1.y,greThr7. u)
    annotation (Line(points={{-118,190},{-82,190}},color={0,0,127}));
  connect(and7.y, intSwi4.u2)
    annotation (Line(points={{42,210},{160,210}},   color={255,0,255}));
  connect(sub4.y,greThr8. u)
    annotation (Line(points={{-118,150},{-82,150}},  color={0,0,127}));
  connect(and6.y,intSwi5. u2)
    annotation (Line(points={{42,150},{78,150}},   color={255,0,255}));
  connect(and8.y,swi1. u2)
    annotation (Line(points={{42,-230},{118,-230}}, color={255,0,255}));
  connect(and9.y,swi2. u2)
    annotation (Line(points={{42,-300},{78,-300}}, color={255,0,255}));
  connect(greThr8.y,tim7. u)
    annotation (Line(points={{-58,150},{-42,150}},   color={255,0,255}));
  connect(tim7.y,and6. u2)
    annotation (Line(points={{-18,150},{-10,150},{-10,142},{18,142}},
      color={255,0,255}));
  connect(greThr7.y,tim6. u)
    annotation (Line(points={{-58,190},{-42,190}}, color={255,0,255}));
  connect(tim6.y,and7. u2)
    annotation (Line(points={{-18,190},{-10,190},{-10,202},{18,202}},
      color={255,0,255}));
  connect(uHea, greThr10.u)
    annotation (Line(points={{-220,100},{-82,100}},   color={0,0,127}));
  connect(uAftSupHea, and7.u1) annotation (Line(points={{-220,230},{0,230},{0,210},
          {18,210}},  color={255,0,255}));
  connect(uAftSupHea, and6.u1) annotation (Line(points={{-220,230},{0,230},{0,150},
          {18,150}},   color={255,0,255}));
  connect(thrCooResReq1.y, intSwi4.u1) annotation (Line(points={{102,250},{120,250},
          {120,218},{160,218}}, color={255,127,0}));
  connect(twoCooResReq1.y, intSwi5.u1) annotation (Line(points={{42,250},{60,250},
          {60,158},{78,158}},   color={255,127,0}));
  connect(intSwi5.y, intSwi4.u3) annotation (Line(points={{102,150},{120,150},{120,
          202},{160,202}},        color={255,127,0}));
  connect(intSwi4.y, yZonHeaTemResReq)
    annotation (Line(points={{184,210},{220,210}},   color={255,127,0}));
  connect(greThr10.y, booToInt4.u)
    annotation (Line(points={{-58,100},{18,100}},   color={255,0,255}));
  connect(booToInt4.y, intSwi5.u3) annotation (Line(points={{42,100},{60,100},{60,
          142},{78,142}},       color={255,127,0}));
  connect(uHeaDam, greThr9.u)
    annotation (Line(points={{-220,-340},{-182,-340}}, color={0,0,127}));
  connect(greThr9.y,tim8. u) annotation (Line(points={{-158,-340},{-150,-340},{-150,
          -320},{-142,-320}},color={255,0,255}));
  connect(tim8.y, and10.u2) annotation (Line(points={{-118,-320},{-110,-320},{-110,
          -218},{-102,-218}},color={255,0,255}));
  connect(and10.y, and8.u1) annotation (Line(points={{-78,-210},{0,-210},{0,-230},
          {18,-230}}, color={255,0,255}));
  connect(and10.y, and9.u1) annotation (Line(points={{-78,-210},{0,-210},{0,-300},
          {18,-300}}, color={255,0,255}));
  connect(greThr9.y,booToInt5. u) annotation (Line(points={{-158,-340},{18,-340}},
          color={255,0,255}));
  connect(booToInt5.y,swi2. u3) annotation (Line(points={{42,-340},{60,-340},{60,
          -308},{78,-308}}, color={255,127,0}));
  connect(twoPreResReq1.y, swi2.u1) annotation (Line(points={{42,-270},{60,-270},
          {60,-292},{78,-292}}, color={255,127,0}));
  connect(thrPreResReq1.y, swi1.u1) annotation (Line(points={{102,-210},{110,-210},
          {110,-222},{118,-222}}, color={255,127,0}));
  connect(swi2.y,swi1. u3) annotation (Line(points={{102,-300},{110,-300},{110,-238},
          {118,-238}},color={255,127,0}));
  connect(THeaSet, sub1.u1) annotation (Line(points={{-220,190},{-160,190},{-160,
          196},{-142,196}}, color={0,0,127}));
  connect(THeaSet, sub4.u1) annotation (Line(points={{-220,190},{-160,190},{-160,
          156},{-142,156}}, color={0,0,127}));
  connect(TZon, sub1.u2) annotation (Line(points={{-220,320},{-180,320},{-180,184},
          {-142,184}},  color={0,0,127}));
  connect(TZon, sub4.u2) annotation (Line(points={{-220,320},{-180,320},{-180,144},
          {-142,144}},  color={0,0,127}));
  connect(uHea, greThr12.u) annotation (Line(points={{-220,100},{-190,100},{-190,
          -420},{-82,-420}}, color={0,0,127}));
  connect(greThr12.y, lat.u)
    annotation (Line(points={{-58,-420},{-2,-420}}, color={255,0,255}));
  connect(uHea, lesThr.u) annotation (Line(points={{-220,100},{-190,100},{-190,-450},
          {-82,-450}},       color={0,0,127}));
  connect(lesThr.y, lat.clr) annotation (Line(points={{-58,-450},{-20,-450},{-20,
          -426},{-2,-426}}, color={255,0,255}));
  connect(lat.y, booToInt6.u)
    annotation (Line(points={{22,-420},{78,-420}}, color={255,0,255}));
  connect(booToInt6.y, yHeaFanReq)
    annotation (Line(points={{102,-420},{220,-420}}, color={255,127,0}));
  connect(uHea, greThr5.u) annotation (Line(points={{-220,100},{-190,100},{-190,
          -370},{-82,-370}}, color={0,0,127}));
  connect(greThr5.y, booToInt3.u)
    annotation (Line(points={{-58,-370},{-22,-370}}, color={255,0,255}));
  connect(booToInt3.y, mulInt2.u2) annotation (Line(points={{2,-370},{150,-370},
          {150,-336},{158,-336}}, color={255,127,0}));
  connect(swi1.y, mulInt2.u1) annotation (Line(points={{142,-230},{150,-230},{150,
          -324},{158,-324}}, color={255,127,0}));
  connect(mulInt2.y, yHotDucPreResReq)
    annotation (Line(points={{182,-330},{220,-330}}, color={255,127,0}));
  connect(uHea, greThr6.u) annotation (Line(points={{-220,100},{-190,100},{-190,
          -160},{-162,-160}}, color={0,0,127}));
  connect(uCoo, greThr13.u) annotation (Line(points={{-220,290},{-170,290},{-170,
          -120},{-162,-120}}, color={0,0,127}));
  connect(greThr13.y, or2.u1) annotation (Line(points={{-138,-120},{-120,-120},{
          -120,-140},{-102,-140}}, color={255,0,255}));
  connect(greThr6.y, or2.u2) annotation (Line(points={{-138,-160},{-120,-160},{-120,
          -148},{-102,-148}}, color={255,0,255}));
  connect(or2.y, not1.u)
    annotation (Line(points={{-78,-140},{18,-140}}, color={255,0,255}));
  connect(greThr13.y, or1.u1)
    annotation (Line(points={{-138,-120},{58,-120}}, color={255,0,255}));
  connect(not1.y, or1.u2) annotation (Line(points={{42,-140},{50,-140},{50,-128},
          {58,-128}}, color={255,0,255}));
  connect(or1.y, booToInt2.u)
    annotation (Line(points={{82,-120},{98,-120}}, color={255,0,255}));
  connect(swi4.y, mulInt1.u1) annotation (Line(points={{142,20},{150,20},{150,-54},
          {158,-54}},      color={255,127,0}));
  connect(booToInt2.y, mulInt1.u2) annotation (Line(points={{122,-120},{150,-120},
          {150,-66},{158,-66}}, color={255,127,0}));
  connect(mulInt1.y, yColDucPreResReq)
    annotation (Line(points={{182,-60},{220,-60}}, color={255,127,0}));
  connect(greThr4.y, and10.u1) annotation (Line(points={{-118,40},{-110,40},{-110,
          -210},{-102,-210}}, color={255,0,255}));
  connect(greEqu.y, and8.u2) annotation (Line(points={{-58,10},{-30,10},{-30,-238},
          {18,-238}}, color={255,0,255}));
  connect(greEqu1.y, and9.u2) annotation (Line(points={{-58,-30},{-20,-30},{-20,
          -308},{18,-308}}, color={255,0,255}));

annotation (
  defaultComponentName="sysReq",
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-200,-480},{200,480}}),
      graphics={
        Rectangle(
          extent={{-198,458},{198,282}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-198,58},{198,-178}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Text(
          extent={{-166,454},{-44,430}},
          textColor={0,0,255},
          horizontalAlignment=TextAlignment.Left,
          textString="Cooling SAT reset requests"),
        Text(
          extent={{10,-148},{170,-174}},
          textColor={0,0,255},
          horizontalAlignment=TextAlignment.Left,
          textString="Cold duct static pressure reset requests"),
        Rectangle(
          extent={{-198,258},{198,82}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-198,-202},{198,-378}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Text(
          extent={{66,104},{188,80}},
          textColor={0,0,255},
          horizontalAlignment=TextAlignment.Left,
          textString="Heating SAT reset requests"),
        Text(
          extent={{18,-348},{178,-374}},
          textColor={0,0,255},
          horizontalAlignment=TextAlignment.Left,
          textString="Hot duct static pressure reset requests"),
        Rectangle(
          extent={{-198,-402},{198,-458}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None)}),
     Icon(coordinateSystem(extent={{-100,-200},{100,200}}),
          graphics={
        Text(
          extent={{-100,240},{100,200}},
          textColor={0,0,255},
          textString="%name"),
        Rectangle(
        extent={{-100,-200},{100,200}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-98,168},{-64,152}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TCooSet"),
        Text(
          extent={{-100,138},{-72,126}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TZon"),
        Text(
          extent={{-98,108},{-74,94}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="uCoo"),
        Text(
          extent={{-96,-52},{-40,-70}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VDis_flow_Set"),
        Text(
          extent={{-96,-132},{-28,-146}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="uCooDam"),
        Text(
          extent={{20,92},{98,70}},
          textColor={255,127,0},
          pattern=LinePattern.Dash,
          horizontalAlignment=TextAlignment.Right,
          textString="yZonCooTemResReq"),
        Text(
          extent={{-96,200},{-44,182}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="uAftSupCoo"),
        Text(
          extent={{40,-170},{98,-186}},
          textColor={255,127,0},
          pattern=LinePattern.Dash,
          horizontalAlignment=TextAlignment.Right,
          textString="yHeaFanReq"),
        Text(
          extent={{24,42},{98,22}},
          textColor={255,127,0},
          pattern=LinePattern.Dash,
          horizontalAlignment=TextAlignment.Right,
          textString="yColDucPreResReq"),
        Text(
          extent={{24,-66},{98,-86}},
          textColor={255,127,0},
          pattern=LinePattern.Dash,
          horizontalAlignment=TextAlignment.Right,
          textString="yHotDucPreResReq"),
        Text(
          extent={{20,-16},{98,-38}},
          textColor={255,127,0},
          pattern=LinePattern.Dash,
          horizontalAlignment=TextAlignment.Right,
          textString="yZonHeaTemResReq"),
        Text(
          extent={{-100,-82},{-52,-96}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VDis_flow"),
        Text(
          extent={{-96,60},{-44,42}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="uAftSupHea"),
        Text(
          extent={{-96,30},{-60,14}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="THeaSet"),
        Text(
          extent={{-98,-2},{-74,-16}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="uHea"),
        Text(
          extent={{-96,-162},{-28,-176}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="uHeaDam")}),
  Documentation(info="<html>
<p>
This sequence outputs the system reset requests for dual-duct terminal unit using
mixing control with discharge flow sensor. The implementation is according to the Section
5.13.8 of ASHRAE Guideline 36, May 2020. 
</p>
<h4>Cooling SAT reset requests <code>yZonCooTemResReq</code></h4>
<ol>
<li>
If the zone temperature <code>TZon</code> exceeds the zone cooling setpoint
<code>TCooSet</code> by 3 &deg;C (5 &deg;F)) for 2 minutes and after suppression
period (<code>uAftSupCoo=true</code>) due to setpoint change per G36 Part 5.1.20,
send 3 requests (<code>yZonCooTemResReq=3</code>).
</li>
<li>
Else if the zone temperature <code>TZon</code> exceeds the zone cooling setpoint
<code>TCooSet</code> by 2 &deg;C (3 &deg;F) for 2 minutes and after suppression
period (<code>uAftSupCoo=true</code>) due to setpoint change per G36 Part 5.1.20,
send 2 requests (<code>yZonCooTemResReq=3</code>).
</li>
<li>
Else if the cooling loop <code>uCoo</code> is greater than 95%, send 1 request
(<code>yZonCooTemResReq=1</code>) until <code>uCoo</code> is less than 85%.
</li>
<li>
Else if <code>uCoo</code> is less than 95%, send 0 request (<code>yZonCooTemResReq=0</code>).
</li>
</ol>
<h4>Cold-duct static pressure reset requests <code>yColDucPreResReq</code></h4>
<p>
When the zone is in cooling or deadband state:
</p>
<ol>
<li>
If the measured airflow <code>VDis_flow</code> is less than 50% of setpoint
<code>VDis_flow_Set</code> while the setpoint is greater than zero and the damper position
<code>uCooDam</code> is greater than 95% for 1 minute, send 3 requests (<code>yColDucPreResReq=3</code>).
</li>
<li>
Else if the measured airflow <code>VDis_flow</code> is less than 70% of setpoint
<code>VDis_flow_Set</code> while the setpoint is greater than zero and the damper position
<code>uCooDam</code> is greater than 95% for 1 minute, send 2 requests (<code>yColDucPreResReq=2</code>).
</li>
<li>
Else if the damper position <code>uCooDam</code> is greater than 95%, send 1 request
(<code>yColDucPreResReq=1</code>) until <code>uDam</code> is less than 85%.
</li>
<li>
Else if the damper position <code>uCooDam</code> is less than 95%, send 0 request
(<code>yColDucPreResReq=0</code>).
</li>
</ol>
<h4>Heating SAT reset requests <code>yZonHeaTemResReq</code></h4>
<ol>
<li>
If the zone temperature <code>TZon</code> is below the zone heating setpoint
<code>THeaSet</code> by 3 &deg;C (5 &deg;F)) for 2 minutes and after suppression
period (<code>uAftSupHea=true</code>) due to setpoint change per G36 Part 5.1.20,
send 3 requests (<code>yZonHeaTemResReq=3</code>).
</li>
<li>
Else if the zone temperature <code>TZon</code> is below the zone heating setpoint
<code>THeaSet</code> by 2 &deg;C (3 &deg;F) for 2 minutes and after suppression
period (<code>uAftSupHea=true</code>) due to setpoint change per G36 Part 5.1.20,
send 2 requests (<code>yZonHeaTemResReq=3</code>).
</li>
<li>
Else if the heating loop <code>uHea</code> is greater than 95%, send 1 request
(<code>yZonHeaTemResReq=1</code>) until <code>uHea</code> is less than 85%.
</li>
<li>
Else if <code>uHea</code> is less than 95%, send 0 request (<code>yZonHeaTemResReq=0</code>).
</li>
</ol>
<h4>Hot-duct static pressure reset requests <code>yHotDucPreResReq</code></h4>
<p>
When the zone is in heating state:
</p>
<ol>
<li>
If the measured airflow <code>VDis_flow</code> is less than 50% of setpoint
<code>VDis_flow_Set</code> while the setpoint is greater than zero and the damper position
<code>uHeaDam</code> is greater than 95% for 1 minute, send 3 requests (<code>yHotDucPreResReq=3</code>).
</li>
<li>
Else if the measured airflow <code>VDis_flow</code> is less than 70% of setpoint
<code>VDis_flow_Set</code> while the setpoint is greater than zero and the damper position
<code>uHeaDam</code> is greater than 95% for 1 minute, send 2 requests (<code>yHotDucPreResReq=2</code>).
</li>
<li>
Else if the damper position <code>uHeaDam</code> is greater than 95%, send 1 request
(<code>yHotDucPreResReq=1</code>) until <code>uHeaDam</code> is less than 85%.
</li>
<li>
Else if the damper position <code>uHeaDam</code> is less than 95%, send 0 request
(<code>yHotDucPreResReq=0</code>).
</li>
</ol>
<h4>Heating-fan requests</h4>
<p>
Send the heating fan that serves the zone a heating-fan request as follows:
</p>
<ol>
<li>
If the heating loop is greater than 15%, send 1 request until the heating loop is
less than 1%.
</li>
<li>
Else if the heatling loop is less than 15%, send 0 requests.
</li>
</ol>
</html>", revisions="<html>
<ul>
<li>
August 1, 2020, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end SystemRequests;
