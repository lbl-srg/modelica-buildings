within Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.DualDuctSnapActing.Subsequences;
block SystemRequests "Output system requests for VAV terminal unit with reheat"

  parameter Boolean have_hotWatCoi
    "True: the system has hot water coil";
  parameter Real thrTemDif(
    final unit="K",
    final quantity="TemperatureDifference")=3
    "Threshold difference between zone temperature and cooling setpoint for generating 3 cooling SAT reset requests";
  parameter Real twoTemDif(
    final unit="K",
    final quantity="TemperatureDifference")=2
    "Threshold difference between zone temperature and cooling setpoint for generating 2 cooling SAT reset requests";
  parameter Real thrTDis_1(
    final unit="K",
    final quantity="TemperatureDifference")=17
    "Threshold difference between discharge air temperature and its setpoint for generating 3 hot water reset requests"
    annotation(Dialog(enable=have_hotWatCoi));
  parameter Real thrTDis_2(
    final unit="K",
    final quantity="TemperatureDifference")=8
    "Threshold difference between discharge air temperature and its setpoint for generating 2 hot water reset requests"
    annotation(Dialog(enable=have_hotWatCoi));
  parameter Real durTimTem(
    final unit="s",
    final quantity="Time")=120
    "Duration time of zone temperature exceeds setpoint"
    annotation(Dialog(group="Duration times"));
  parameter Real durTimFlo(
    final unit="s",
    final quantity="Time")=60
    "Duration time of airflow rate less than setpoint"
    annotation(Dialog(group="Duration times"));
  parameter Real durTimDisAir(
    final unit="s",
    final quantity="Time")=300
    "Duration time of discharge air temperature less than setpoint"
    annotation(Dialog(group="Duration times", enable=have_hotWatCoi));
  parameter Real dTHys(
    final unit="K",
    final quantity="TemperatureDifference")=0.25
    "Near zero temperature difference, below which the difference will be seen as zero"
    annotation (Dialog(tab="Advanced", enable=have_hotWatCoi));
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
  parameter Real valPosHys(
    final unit="1")
    "Near zero valve position, below which the valve will be seen as closed"
    annotation (Dialog(tab="Advanced", enable=have_hotWatCoi));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uAftSupCoo
    "After suppression period due to the cooling setpoint change"
    annotation (Placement(transformation(extent={{-220,360},{-180,400}}),
        iconTransformation(extent={{-140,160},{-100,200}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TZonCooSet(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Zone cooling setpoint temperature"
    annotation (Placement(transformation(extent={{-220,320},{-180,360}}),
        iconTransformation(extent={{-140,130},{-100,170}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TZon(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Zone temperature"
    annotation (Placement(transformation(extent={{-220,260},{-180,300}}),
        iconTransformation(extent={{-140,100},{-100,140}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uCoo(
    final min=0,
    final max=1,
    final unit="1") "Cooling loop signal"
    annotation (Placement(transformation(extent={{-220,230},{-180,270}}),
        iconTransformation(extent={{-140,70},{-100,110}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VColDuc_flow_Set(
    final min=0,
    final unit="m3/s",
    quantity="VolumeFlowRate") "Cold duct discharge airflow rate setpoint"
    annotation (Placement(transformation(extent={{-220,180},{-180,220}}),
        iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VColDucDis_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate")
    "Measured cold duct discharge airflow rate"
    annotation (Placement(transformation(extent={{-220,90},{-180,130}}),
        iconTransformation(extent={{-140,10},{-100,50}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uCooDam(
    final min=0,
    final max=1,
    final unit="1") "Actual cooling damper position"
    annotation (Placement(transformation(extent={{-220,50},{-180,90}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uAftSupHea
    "After suppression period due to the heating setpoint change"
    annotation (Placement(transformation(extent={{-220,-40},{-180,0}}),
        iconTransformation(extent={{-140,-50},{-100,-10}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TZonHeaSet(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Zone heating setpoint temperature"
    annotation (Placement(transformation(extent={{-220,-80},{-180,-40}}),
        iconTransformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uHea(
    final min=0,
    final max=1,
    final unit="1")
    "Heating loop signal"
    annotation (Placement(transformation(extent={{-220,-170},{-180,-130}}),
        iconTransformation(extent={{-140,-110},{-100,-70}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VHotDuc_flow_Set(
    final min=0,
    final unit="m3/s",
    quantity="VolumeFlowRate")
    "Hot duct discharge airflow rate setpoint"
    annotation (Placement(transformation(extent={{-220,-220},{-180,-180}}),
        iconTransformation(extent={{-140,-140},{-100,-100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VHotDucDis_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate")
    "Measured hot duct discharge airflow rate"
    annotation (Placement(transformation(extent={{-220,-310},{-180,-270}}),
        iconTransformation(extent={{-140,-170},{-100,-130}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uHeaDam(
    final min=0,
    final max=1,
    final unit="1")
    "Actual heating damper position"
    annotation (Placement(transformation(extent={{-220,-350},{-180,-310}}),
        iconTransformation(extent={{-140,-200},{-100,-160}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yZonCooTemResReq
    "Zone cooling supply air temperature reset request"
    annotation (Placement(transformation(extent={{180,340},{220,380}}),
        iconTransformation(extent={{100,60},{140,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yColDucPreResReq
    "Cold duct static pressure reset requests"
    annotation (Placement(transformation(extent={{180,160},{220,200}}),
        iconTransformation(extent={{100,10},{140,50}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yZonHeaTemResReq
    "Zone heating supply air temperature reset request"
    annotation (Placement(transformation(extent={{180,-60},{220,-20}}),
        iconTransformation(extent={{100,-50},{140,-10}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yHotDucPreResReq
    "Hot duct static pressure reset requests"
    annotation (Placement(transformation(extent={{180,-240},{220,-200}}),
        iconTransformation(extent={{100,-100},{140,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yHeaFanReq
    "Heating fan request"
    annotation (Placement(transformation(extent={{180,-410},{220,-370}}),
        iconTransformation(extent={{100,-200},{140,-160}})));

protected
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greThr1(
    final t=thrTemDif,
    final h=dTHys)
    "Check if zone temperature is greater than cooling setpoint by threshold"
    annotation (Placement(transformation(extent={{-60,330},{-40,350}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greThr2(
    final t=twoTemDif,
    final h=dTHys)
    "Check if zone temperature is greater than cooling setpoint by threshold"
    annotation (Placement(transformation(extent={{-60,290},{-40,310}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greThr3(
    final t=0.95,
    final h=damPosHys)
    "Check if damper position is greater than 0.95"
    annotation (Placement(transformation(extent={{-140,60},{-120,80}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greThr(
    final t=0.95, final h=looHys)
    "Check if cooling loop signal is greater than 0.95"
    annotation (Placement(transformation(extent={{-60,240},{-40,260}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greThr4(
    final t=floHys,
    final h=0.5*floHys)
    "Check if discharge airflow setpoint is greater than 0"
    annotation (Placement(transformation(extent={{-120,190},{-100,210}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt
    "Convert boolean to integer"
    annotation (Placement(transformation(extent={{40,240},{60,260}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt1
    "Convert boolean to integer"
    annotation (Placement(transformation(extent={{40,60},{60,80}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiplyByParameter gai1(
    final k=0.5)
    "50% of setpoint"
    annotation (Placement(transformation(extent={{-120,160},{-100,180}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiplyByParameter gai2(
    final k=0.7)
    "70% of setpoint"
    annotation (Placement(transformation(extent={{-120,120},{-100,140}})));
  Buildings.Controls.OBC.CDL.Continuous.Subtract sub2
    "Calculate difference between zone temperature and cooling setpoint"
    annotation (Placement(transformation(extent={{-100,330},{-80,350}})));
  Buildings.Controls.OBC.CDL.Continuous.Subtract sub3
    "Calculate difference between zone temperature and cooling setpoint"
    annotation (Placement(transformation(extent={{-100,290},{-80,310}})));
  Buildings.Controls.OBC.CDL.Logical.And and1
    "Logical and"
    annotation (Placement(transformation(extent={{40,290},{60,310}})));
  Buildings.Controls.OBC.CDL.Logical.And and2
    "Logical and"
    annotation (Placement(transformation(extent={{40,350},{60,370}})));
  Buildings.Controls.OBC.CDL.Logical.And and3
    "Logical and"
    annotation (Placement(transformation(extent={{40,170},{60,190}})));
  Buildings.Controls.OBC.CDL.Logical.And and4
    "Logical and"
    annotation (Placement(transformation(extent={{40,100},{60,120}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant thrCooResReq(
    final k=3)
    "Constant 3"
    annotation (Placement(transformation(extent={{100,390},{120,410}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant twoCooResReq(
    final k=2) "Constant 2"
    annotation (Placement(transformation(extent={{40,390},{60,410}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant thrPreResReq(
    final k=3)
    "Constant 3"
    annotation (Placement(transformation(extent={{100,190},{120,210}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant twoPreResReq(
    final k=2)
    "Constant 2"
    annotation (Placement(transformation(extent={{40,130},{60,150}})));
  Buildings.Controls.OBC.CDL.Integers.Switch intSwi
    "Output 3 or other request "
    annotation (Placement(transformation(extent={{140,350},{160,370}})));
  Buildings.Controls.OBC.CDL.Integers.Switch intSwi1
    "Output 2 or other request "
    annotation (Placement(transformation(extent={{100,290},{120,310}})));
  Buildings.Controls.OBC.CDL.Integers.Switch swi4
    "Output 3 or other request "
    annotation (Placement(transformation(extent={{140,170},{160,190}})));
  Buildings.Controls.OBC.CDL.Integers.Switch swi5
    "Output 2 or other request "
    annotation (Placement(transformation(extent={{100,100},{120,120}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay tim1(
    final delayTime=durTimTem) "Check if it is more than threshold time"
    annotation (Placement(transformation(extent={{-20,330},{0,350}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay tim2(
    final delayTime=durTimTem) "Check if it is more than threshold time"
    annotation (Placement(transformation(extent={{-20,290},{0,310}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay tim3(
    final delayTime=durTimFlo) "Check if it is more than threshold time"
    annotation (Placement(transformation(extent={{-60,80},{-40,100}})));
  Buildings.Controls.OBC.CDL.Continuous.Greater greEqu
    "Check if discharge airflow is less than 50% of setpoint"
    annotation (Placement(transformation(extent={{-60,160},{-40,180}})));
  Buildings.Controls.OBC.CDL.Continuous.Greater greEqu1
    "Check if discharge airflow is less than 70% of setpoint"
    annotation (Placement(transformation(extent={{-60,120},{-40,140}})));
  Buildings.Controls.OBC.CDL.Logical.And and5
    "Logical and"
    annotation (Placement(transformation(extent={{-20,190},{0,210}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greThr7(
    final t=thrTemDif,
    final h=dTHys)
    "Check if zone temperature is less than heating setpoint by threshold"
    annotation (Placement(transformation(extent={{-60,-70},{-40,-50}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greThr8(
    final t=twoTemDif,
    final h=dTHys)
    "Check if zone temperature is less than heating setpoint by threshold"
    annotation (Placement(transformation(extent={{-60,-110},{-40,-90}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greThr9(
    final t=0.95,
    final h=damPosHys)
    "Check if damper position is greater than 0.95"
    annotation (Placement(transformation(extent={{-160,-340},{-140,-320}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greThr10(
    final t=0.95,
    final h=looHys) "Check if heating loop signal is greater than 0.95"
    annotation (Placement(transformation(extent={{-60,-160},{-40,-140}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greThr11(
    final t=floHys,
    final h=0.5*floHys)
    "Check if discharge airflow setpoint is greater than 0"
    annotation (Placement(transformation(extent={{-140,-210},{-120,-190}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt4
    "Convert boolean to integer"
    annotation (Placement(transformation(extent={{40,-160},{60,-140}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt5
    "Convert boolean to integer"
    annotation (Placement(transformation(extent={{40,-340},{60,-320}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiplyByParameter gai3(
    final k=0.5)
    "50% of setpoint"
    annotation (Placement(transformation(extent={{-140,-240},{-120,-220}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiplyByParameter gai4(
    final k=0.7)
    "70% of setpoint"
    annotation (Placement(transformation(extent={{-140,-280},{-120,-260}})));
  Buildings.Controls.OBC.CDL.Continuous.Subtract sub1
    "Calculate difference between zone temperature and heating setpoint"
    annotation (Placement(transformation(extent={{-100,-70},{-80,-50}})));
  Buildings.Controls.OBC.CDL.Continuous.Subtract sub4
    "Calculate difference between zone temperature and heating setpoint"
    annotation (Placement(transformation(extent={{-100,-110},{-80,-90}})));
  Buildings.Controls.OBC.CDL.Logical.And and6
    "Logical and"
    annotation (Placement(transformation(extent={{40,-110},{60,-90}})));
  Buildings.Controls.OBC.CDL.Logical.And and7
    "Logical and"
    annotation (Placement(transformation(extent={{40,-50},{60,-30}})));
  Buildings.Controls.OBC.CDL.Logical.And and8
    "Logical and"
    annotation (Placement(transformation(extent={{40,-230},{60,-210}})));
  Buildings.Controls.OBC.CDL.Logical.And and9
    "Logical and"
    annotation (Placement(transformation(extent={{40,-300},{60,-280}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant thrCooResReq1(
    final k=3)
    "Constant 3"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant twoCooResReq1(
    final k=2)
    "Constant 2"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant thrPreResReq1(
    final k=3)
    "Constant 3"
    annotation (Placement(transformation(extent={{100,-210},{120,-190}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant twoPreResReq1(
    final k=2)
    "Constant 2"
    annotation (Placement(transformation(extent={{40,-270},{60,-250}})));
  Buildings.Controls.OBC.CDL.Integers.Switch intSwi4
    "Output 3 or other request "
    annotation (Placement(transformation(extent={{140,-50},{160,-30}})));
  Buildings.Controls.OBC.CDL.Integers.Switch intSwi5
    "Output 2 or other request "
    annotation (Placement(transformation(extent={{100,-110},{120,-90}})));
  Buildings.Controls.OBC.CDL.Integers.Switch swi1
    "Output 3 or other request "
    annotation (Placement(transformation(extent={{140,-230},{160,-210}})));
  Buildings.Controls.OBC.CDL.Integers.Switch swi2
    "Output 2 or other request "
    annotation (Placement(transformation(extent={{100,-300},{120,-280}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay tim6(
    final delayTime=durTimTem)
    "Check if it is more than threshold time"
    annotation (Placement(transformation(extent={{-20,-70},{0,-50}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay tim7(
    final delayTime=durTimTem)
    "Check if it is more than threshold time"
    annotation (Placement(transformation(extent={{-20,-110},{0,-90}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay tim8(
    final delayTime=durTimFlo)
    "Check if it is more than threshold time"
    annotation (Placement(transformation(extent={{-60,-320},{-40,-300}})));
  Buildings.Controls.OBC.CDL.Continuous.Greater greEqu2
    "Check if discharge airflow is less than 50% of setpoint"
    annotation (Placement(transformation(extent={{-60,-240},{-40,-220}})));
  Buildings.Controls.OBC.CDL.Continuous.Greater greEqu3
    "Check if discharge airflow is less than 70% of setpoint"
    annotation (Placement(transformation(extent={{-60,-280},{-40,-260}})));
  Buildings.Controls.OBC.CDL.Logical.And and10
    "Logical and"
    annotation (Placement(transformation(extent={{-20,-210},{0,-190}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greThr12(
    final t=0.15,
    final h=looHys)
    "Check if heating loop signal is greater than 0.15"
    annotation (Placement(transformation(extent={{-60,-400},{-40,-380}})));
  Buildings.Controls.OBC.CDL.Logical.Latch lat "Hold the true input"
    annotation (Placement(transformation(extent={{20,-400},{40,-380}})));
  Buildings.Controls.OBC.CDL.Continuous.LessThreshold lesThr(
    final t=0.01,
    final h=looHys)
    "Check if the heating loop output is less than threshold"
    annotation (Placement(transformation(extent={{-60,-430},{-40,-410}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt6
    "Heating fan request"
    annotation (Placement(transformation(extent={{100,-400},{120,-380}})));

equation
  connect(sub2.y, greThr1.u)
    annotation (Line(points={{-78,340},{-62,340}}, color={0,0,127}));
  connect(and2.y, intSwi.u2)
    annotation (Line(points={{62,360},{138,360}},color={255,0,255}));
  connect(sub3.y, greThr2.u)
    annotation (Line(points={{-78,300},{-62,300}}, color={0,0,127}));
  connect(and1.y, intSwi1.u2)
    annotation (Line(points={{62,300},{98,300}}, color={255,0,255}));
  connect(and3.y, swi4.u2)
    annotation (Line(points={{62,180},{138,180}},color={255,0,255}));
  connect(and4.y, swi5.u2)
    annotation (Line(points={{62,110},{98,110}},   color={255,0,255}));
  connect(greThr2.y, tim2.u)
    annotation (Line(points={{-38,300},{-22,300}}, color={255,0,255}));
  connect(tim2.y, and1.u2)
    annotation (Line(points={{2,300},{10,300},{10,292},{38,292}},
      color={255,0,255}));
  connect(greThr1.y, tim1.u)
    annotation (Line(points={{-38,340},{-22,340}}, color={255,0,255}));
  connect(tim1.y, and2.u2)
    annotation (Line(points={{2,340},{10,340},{10,352},{38,352}},
      color={255,0,255}));
  connect(greThr4.u, VColDuc_flow_Set)
    annotation (Line(points={{-122,200},{-200,200}}, color={0,0,127}));
  connect(greEqu.u1, gai1.y)
    annotation (Line(points={{-62,170},{-98,170}}, color={0,0,127}));
  connect(greEqu.y, and3.u2)
    annotation (Line(points={{-38,170},{0,170},{0,172},{38,172}},
      color={255,0,255}));
  connect(gai2.y, greEqu1.u1)
    annotation (Line(points={{-98,130},{-62,130}},
      color={0,0,127}));
  connect(greEqu1.y, and4.u2)
    annotation (Line(points={{-38,130},{0,130},{0,102},{38,102}},
      color={255,0,255}));
  connect(uCoo, greThr.u)
    annotation (Line(points={{-200,250},{-62,250}}, color={0,0,127}));
  connect(uAftSupCoo, and2.u1) annotation (Line(points={{-200,380},{20,380},{20,
          360},{38,360}}, color={255,0,255}));
  connect(uAftSupCoo, and1.u1) annotation (Line(points={{-200,380},{20,380},{20,
          300},{38,300}}, color={255,0,255}));
  connect(thrCooResReq.y, intSwi.u1) annotation (Line(points={{122,400},{130,400},
          {130,368},{138,368}},      color={255,127,0}));
  connect(twoCooResReq.y, intSwi1.u1) annotation (Line(points={{62,400},{80,400},
          {80,308},{98,308}}, color={255,127,0}));
  connect(intSwi1.y, intSwi.u3) annotation (Line(points={{122,300},{130,300},{130,
          352},{138,352}},     color={255,127,0}));
  connect(intSwi.y, yZonCooTemResReq)
    annotation (Line(points={{162,360},{200,360}}, color={255,127,0}));
  connect(greThr.y, booToInt.u)
    annotation (Line(points={{-38,250},{38,250}}, color={255,0,255}));
  connect(booToInt.y, intSwi1.u3) annotation (Line(points={{62,250},{80,250},{80,
          292},{98,292}},    color={255,127,0}));
  connect(uCooDam, greThr3.u)
    annotation (Line(points={{-200,70},{-142,70}},   color={0,0,127}));
  connect(VColDuc_flow_Set, gai1.u) annotation (Line(points={{-200,200},{-140,200},
          {-140,170},{-122,170}}, color={0,0,127}));
  connect(VColDuc_flow_Set, gai2.u) annotation (Line(points={{-200,200},{-140,200},
          {-140,130},{-122,130}}, color={0,0,127}));
  connect(VColDucDis_flow, greEqu.u2) annotation (Line(points={{-200,110},{-80,110},
          {-80,162},{-62,162}}, color={0,0,127}));
  connect(VColDucDis_flow, greEqu1.u2) annotation (Line(points={{-200,110},{-80,
          110},{-80,122},{-62,122}}, color={0,0,127}));
  connect(greThr3.y, tim3.u) annotation (Line(points={{-118,70},{-80,70},{-80,90},
          {-62,90}}, color={255,0,255}));
  connect(greThr4.y, and5.u1)
    annotation (Line(points={{-98,200},{-22,200}},  color={255,0,255}));
  connect(tim3.y, and5.u2) annotation (Line(points={{-38,90},{-30,90},{-30,192},
          {-22,192}}, color={255,0,255}));
  connect(and5.y, and3.u1) annotation (Line(points={{2,200},{20,200},{20,180},{38,
          180}}, color={255,0,255}));
  connect(and5.y, and4.u1) annotation (Line(points={{2,200},{20,200},{20,110},{38,
          110}},     color={255,0,255}));
  connect(greThr3.y, booToInt1.u) annotation (Line(points={{-118,70},{38,70}},
          color={255,0,255}));
  connect(booToInt1.y, swi5.u3) annotation (Line(points={{62,70},{80,70},{80,102},
          {98,102}},        color={255,127,0}));
  connect(twoPreResReq.y, swi5.u1) annotation (Line(points={{62,140},{80,140},{80,
          118},{98,118}},       color={255,127,0}));
  connect(thrPreResReq.y, swi4.u1) annotation (Line(points={{122,200},{130,200},
          {130,188},{138,188}}, color={255,127,0}));
  connect(swi5.y, swi4.u3) annotation (Line(points={{122,110},{130,110},{130,172},
          {138,172}}, color={255,127,0}));
  connect(swi4.y, yColDucPreResReq)
    annotation (Line(points={{162,180},{200,180}}, color={255,127,0}));
  connect(TZonCooSet, sub3.u2) annotation (Line(points={{-200,340},{-140,340},{-140,
          294},{-102,294}}, color={0,0,127}));
  connect(TZonCooSet, sub2.u2) annotation (Line(points={{-200,340},{-140,340},{-140,
          334},{-102,334}}, color={0,0,127}));
  connect(TZon, sub2.u1) annotation (Line(points={{-200,280},{-160,280},{-160,346},
          {-102,346}}, color={0,0,127}));
  connect(TZon, sub3.u1) annotation (Line(points={{-200,280},{-160,280},{-160,306},
          {-102,306}}, color={0,0,127}));
  connect(sub1.y,greThr7. u)
    annotation (Line(points={{-78,-60},{-62,-60}}, color={0,0,127}));
  connect(and7.y, intSwi4.u2)
    annotation (Line(points={{62,-40},{138,-40}},   color={255,0,255}));
  connect(sub4.y,greThr8. u)
    annotation (Line(points={{-78,-100},{-62,-100}}, color={0,0,127}));
  connect(and6.y,intSwi5. u2)
    annotation (Line(points={{62,-100},{98,-100}}, color={255,0,255}));
  connect(and8.y,swi1. u2)
    annotation (Line(points={{62,-220},{138,-220}}, color={255,0,255}));
  connect(and9.y,swi2. u2)
    annotation (Line(points={{62,-290},{98,-290}}, color={255,0,255}));
  connect(greThr8.y,tim7. u)
    annotation (Line(points={{-38,-100},{-22,-100}}, color={255,0,255}));
  connect(tim7.y,and6. u2)
    annotation (Line(points={{2,-100},{10,-100},{10,-108},{38,-108}},
      color={255,0,255}));
  connect(greThr7.y,tim6. u)
    annotation (Line(points={{-38,-60},{-22,-60}}, color={255,0,255}));
  connect(tim6.y,and7. u2)
    annotation (Line(points={{2,-60},{10,-60},{10,-48},{38,-48}},
      color={255,0,255}));
  connect(greThr11.u, VHotDuc_flow_Set)
    annotation (Line(points={{-142,-200},{-200,-200}}, color={0,0,127}));
  connect(greEqu2.u1, gai3.y)
    annotation (Line(points={{-62,-230},{-118,-230}}, color={0,0,127}));
  connect(greEqu2.y, and8.u2) annotation (Line(points={{-38,-230},{0,-230},{0,-228},
          {38,-228}}, color={255,0,255}));
  connect(gai4.y,greEqu3. u1)
    annotation (Line(points={{-118,-270},{-62,-270}},
      color={0,0,127}));
  connect(greEqu3.y,and9. u2)
    annotation (Line(points={{-38,-270},{0,-270},{0,-298},{38,-298}},
      color={255,0,255}));
  connect(uHea, greThr10.u)
    annotation (Line(points={{-200,-150},{-62,-150}}, color={0,0,127}));
  connect(uAftSupHea, and7.u1) annotation (Line(points={{-200,-20},{20,-20},{20,
          -40},{38,-40}},   color={255,0,255}));
  connect(uAftSupHea, and6.u1) annotation (Line(points={{-200,-20},{20,-20},{20,
          -100},{38,-100}}, color={255,0,255}));
  connect(thrCooResReq1.y, intSwi4.u1) annotation (Line(points={{122,0},{130,0},
          {130,-32},{138,-32}},         color={255,127,0}));
  connect(twoCooResReq1.y, intSwi5.u1) annotation (Line(points={{62,0},{80,0},{80,
          -92},{98,-92}},       color={255,127,0}));
  connect(intSwi5.y, intSwi4.u3) annotation (Line(points={{122,-100},{130,-100},
          {130,-48},{138,-48}},   color={255,127,0}));
  connect(intSwi4.y, yZonHeaTemResReq)
    annotation (Line(points={{162,-40},{200,-40}},   color={255,127,0}));
  connect(greThr10.y, booToInt4.u)
    annotation (Line(points={{-38,-150},{38,-150}}, color={255,0,255}));
  connect(booToInt4.y, intSwi5.u3) annotation (Line(points={{62,-150},{80,-150},
          {80,-108},{98,-108}}, color={255,127,0}));
  connect(uHeaDam, greThr9.u)
    annotation (Line(points={{-200,-330},{-162,-330}}, color={0,0,127}));
  connect(VHotDuc_flow_Set, gai3.u) annotation (Line(points={{-200,-200},{-160,-200},
          {-160,-230},{-142,-230}}, color={0,0,127}));
  connect(VHotDuc_flow_Set, gai4.u) annotation (Line(points={{-200,-200},{-160,-200},
          {-160,-270},{-142,-270}}, color={0,0,127}));
  connect(VHotDucDis_flow, greEqu2.u2) annotation (Line(points={{-200,-290},{-100,
          -290},{-100,-238},{-62,-238}}, color={0,0,127}));
  connect(VHotDucDis_flow, greEqu3.u2) annotation (Line(points={{-200,-290},{-100,
          -290},{-100,-278},{-62,-278}}, color={0,0,127}));
  connect(greThr9.y,tim8. u) annotation (Line(points={{-138,-330},{-80,-330},{-80,
          -310},{-62,-310}}, color={255,0,255}));
  connect(greThr11.y, and10.u1)
    annotation (Line(points={{-118,-200},{-22,-200}}, color={255,0,255}));
  connect(tim8.y, and10.u2) annotation (Line(points={{-38,-310},{-30,-310},{-30,
          -208},{-22,-208}}, color={255,0,255}));
  connect(and10.y, and8.u1) annotation (Line(points={{2,-200},{20,-200},{20,-220},
          {38,-220}}, color={255,0,255}));
  connect(and10.y, and9.u1) annotation (Line(points={{2,-200},{20,-200},{20,-290},
          {38,-290}}, color={255,0,255}));
  connect(greThr9.y,booToInt5. u) annotation (Line(points={{-138,-330},{38,-330}},
          color={255,0,255}));
  connect(booToInt5.y,swi2. u3) annotation (Line(points={{62,-330},{80,-330},{80,
          -298},{98,-298}}, color={255,127,0}));
  connect(twoPreResReq1.y, swi2.u1) annotation (Line(points={{62,-260},{80,-260},
          {80,-282},{98,-282}}, color={255,127,0}));
  connect(thrPreResReq1.y, swi1.u1) annotation (Line(points={{122,-200},{130,-200},
          {130,-212},{138,-212}}, color={255,127,0}));
  connect(swi2.y,swi1. u3) annotation (Line(points={{122,-290},{130,-290},{130,-228},
          {138,-228}},color={255,127,0}));
  connect(swi1.y, yHotDucPreResReq)
    annotation (Line(points={{162,-220},{200,-220}}, color={255,127,0}));
  connect(TZonHeaSet, sub1.u1) annotation (Line(points={{-200,-60},{-140,-60},{-140,
          -54},{-102,-54}},         color={0,0,127}));
  connect(TZonHeaSet, sub4.u1) annotation (Line(points={{-200,-60},{-140,-60},{-140,
          -94},{-102,-94}},         color={0,0,127}));
  connect(TZon, sub1.u2) annotation (Line(points={{-200,280},{-160,280},{-160,-66},
          {-102,-66}},  color={0,0,127}));
  connect(TZon, sub4.u2) annotation (Line(points={{-200,280},{-160,280},{-160,-106},
          {-102,-106}}, color={0,0,127}));
  connect(uHea, greThr12.u) annotation (Line(points={{-200,-150},{-90,-150},{-90,
          -390},{-62,-390}}, color={0,0,127}));
  connect(greThr12.y, lat.u)
    annotation (Line(points={{-38,-390},{18,-390}}, color={255,0,255}));
  connect(uHea, lesThr.u) annotation (Line(points={{-200,-150},{-90,-150},{-90,-420},
          {-62,-420}}, color={0,0,127}));
  connect(lesThr.y, lat.clr) annotation (Line(points={{-38,-420},{0,-420},{0,-396},
          {18,-396}}, color={255,0,255}));
  connect(lat.y, booToInt6.u)
    annotation (Line(points={{42,-390},{98,-390}}, color={255,0,255}));
  connect(booToInt6.y, yHeaFanReq)
    annotation (Line(points={{122,-390},{200,-390}}, color={255,127,0}));

annotation (
  defaultComponentName="sysReq",
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-180,-440},{180,440}}),
      graphics={
        Rectangle(
          extent={{-178,418},{178,242}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-178,218},{178,42}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Text(
          extent={{-146,414},{-24,390}},
          lineColor={0,0,255},
          horizontalAlignment=TextAlignment.Left,
          textString="Cooling SAT reset requests"),
        Text(
          extent={{-134,64},{26,38}},
          lineColor={0,0,255},
          horizontalAlignment=TextAlignment.Left,
          textString="Cold duct static pressure reset requests"),
        Rectangle(
          extent={{-178,18},{178,-158}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-178,-182},{178,-358}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Text(
          extent={{-146,14},{-24,-10}},
          lineColor={0,0,255},
          horizontalAlignment=TextAlignment.Left,
          textString="Heating SAT reset requests"),
        Text(
          extent={{-134,-336},{26,-362}},
          lineColor={0,0,255},
          horizontalAlignment=TextAlignment.Left,
          textString="Hot duct static pressure reset requests"),
        Rectangle(
          extent={{-178,-382},{178,-438}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None)}),
     Icon(coordinateSystem(extent={{-100,-200},{100,200}}),
          graphics={
        Text(
          extent={{-100,240},{100,200}},
          lineColor={0,0,255},
          textString="%name"),
        Rectangle(
        extent={{-100,-200},{100,200}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-98,160},{-52,142}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TZonCooSet"),
        Text(
          extent={{-100,128},{-72,116}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TZon"),
        Text(
          extent={{-98,98},{-74,84}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="uCoo"),
        Text(
          extent={{-96,70},{-28,52}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VColDuc_flow_Set"),
        Text(
          extent={{-96,8},{-56,-6}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="uCooDam"),
        Text(
          extent={{20,92},{98,70}},
          lineColor={255,127,0},
          pattern=LinePattern.Dash,
          horizontalAlignment=TextAlignment.Right,
          textString="yZonCooTemResReq"),
        Text(
          extent={{-96,190},{-44,172}},
          lineColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="uAftSupCoo"),
        Text(
          visible=have_hotWatCoi,
          extent={{40,-170},{98,-186}},
          lineColor={255,127,0},
          pattern=LinePattern.Dash,
          horizontalAlignment=TextAlignment.Right,
          textString="yHeaFanReq"),
        Text(
          extent={{24,42},{98,22}},
          lineColor={255,127,0},
          pattern=LinePattern.Dash,
          horizontalAlignment=TextAlignment.Right,
          textString="yColDucPreResReq"),
        Text(
          extent={{24,-66},{98,-86}},
          lineColor={255,127,0},
          pattern=LinePattern.Dash,
          horizontalAlignment=TextAlignment.Right,
          textString="yHotDucPreResReq"),
        Text(
          extent={{20,-16},{98,-38}},
          lineColor={255,127,0},
          pattern=LinePattern.Dash,
          horizontalAlignment=TextAlignment.Right,
          textString="yZonHeaTemResReq"),
        Text(
          extent={{-96,40},{-30,22}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VColDucDis_flow"),
        Text(
          extent={{-96,-20},{-44,-38}},
          lineColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="uAftSupHea"),
        Text(
          extent={{-96,-50},{-50,-68}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TZonHeaSet"),
        Text(
          extent={{-96,-82},{-72,-96}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="uHea"),
        Text(
          extent={{-94,-112},{-26,-130}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VHotDuc_flow_Set"),
        Text(
          extent={{-94,-142},{-28,-160}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VHotDucDis_flow"),
        Text(
          extent={{-96,-172},{-56,-186}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="uHeaDam")}),
  Documentation(info="<html>
<p>
This sequence outputs the system reset requests for snap-acting controlled dual-duct
terminal unit. The implementation is according to the Section 5.11.8 of ASHRAE
Guideline 36, May 2020. 
</p>
<h4>Cooling SAT reset requests <code>yZonCooTemResReq</code></h4>
<ol>
<li>
If the zone temperature <code>TZon</code> exceeds the zone cooling setpoint
<code>TZonCooSet</code> by 3 &deg;C (5 &deg;F)) for 2 minutes and after suppression
period (<code>uAftSupCoo=true</code>) due to setpoint change per G36 Part 5.1.20,
send 3 requests (<code>yZonCooTemResReq=3</code>).
</li>
<li>
Else if the zone temperature <code>TZon</code> exceeds the zone cooling setpoint
<code>TZonCooSet</code> by 2 &deg;C (3 &deg;F) for 2 minutes and after suppression
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
<ol>
<li>
If the measured airflow <code>VColDucDis_flow</code> is less than 50% of setpoint
<code>VColDuc_flow_Set</code> while the setpoint is greater than zero and the damper position
<code>uCooDam</code> is greater than 95% for 1 minute, send 3 requests (<code>yColDucPreResReq=3</code>).
</li>
<li>
Else if the measured airflow <code>VColDucDis_flow</code> is less than 70% of setpoint
<code>VColDuc_flow_Set</code> while the setpoint is greater than zero and the damper position
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
<code>TZonHeaSet</code> by 3 &deg;C (5 &deg;F)) for 2 minutes and after suppression
period (<code>uAftSupHea=true</code>) due to setpoint change per G36 Part 5.1.20,
send 3 requests (<code>yZonHeaTemResReq=3</code>).
</li>
<li>
Else if the zone temperature <code>TZon</code> is below the zone heating setpoint
<code>TZonHeaSet</code> by 2 &deg;C (3 &deg;F) for 2 minutes and after suppression
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
<ol>
<li>
If the measured airflow <code>VHotDucDis_flow</code> is less than 50% of setpoint
<code>VHotDuc_flow_Set</code> while the setpoint is greater than zero and the damper position
<code>uHotDam</code> is greater than 95% for 1 minute, send 3 requests (<code>yHotDucPreResReq=3</code>).
</li>
<li>
Else if the measured airflow <code>VHotDucDis_flow</code> is less than 70% of setpoint
<code>VHotDuc_flow_Set</code> while the setpoint is greater than zero and the damper position
<code>uHotDam</code> is greater than 95% for 1 minute, send 2 requests (<code>yHotDucPreResReq=2</code>).
</li>
<li>
Else if the damper position <code>uHotDam</code> is greater than 95%, send 1 request
(<code>yHotDucPreResReq=1</code>) until <code>uHeaDam</code> is less than 85%.
</li>
<li>
Else if the damper position <code>uHotDam</code> is less than 95%, send 0 request
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
