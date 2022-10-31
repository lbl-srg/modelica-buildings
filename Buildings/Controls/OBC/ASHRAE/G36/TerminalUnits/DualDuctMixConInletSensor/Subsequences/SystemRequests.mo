within Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.DualDuctMixConInletSensor.Subsequences;
block SystemRequests "Output system requests for dual-duct unit using mixing control with inlet flow sensor"

  parameter Real thrTemDif(
    final unit="K",
    final quantity="TemperatureDifference")=3
    "Threshold difference between zone temperature and cooling setpoint for generating 3 cooling SAT reset requests";
  parameter Real twoTemDif(
    final unit="K",
    final quantity="TemperatureDifference")=2
    "Threshold difference between zone temperature and cooling setpoint for generating 2 cooling SAT reset requests";
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
  parameter Real dTHys(
    final unit="K",
    final quantity="TemperatureDifference")=0.25
    "Near zero temperature difference, below which the difference will be seen as zero"
    annotation (Dialog(tab="Advanced"));
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
    annotation (Placement(transformation(extent={{-240,360},{-200,400}}),
        iconTransformation(extent={{-140,170},{-100,210}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TCooSet(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Zone cooling setpoint temperature"
    annotation (Placement(transformation(extent={{-240,320},{-200,360}}),
        iconTransformation(extent={{-140,140},{-100,180}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TZon(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Zone temperature"
    annotation (Placement(transformation(extent={{-240,260},{-200,300}}),
        iconTransformation(extent={{-140,110},{-100,150}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uCoo(
    final min=0,
    final max=1,
    final unit="1") "Cooling loop signal"
    annotation (Placement(transformation(extent={{-240,230},{-200,270}}),
        iconTransformation(extent={{-140,80},{-100,120}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VColDuc_flow_Set(
    final min=0,
    final unit="m3/s",
    quantity="VolumeFlowRate") "Cold duct discharge airflow rate setpoint"
    annotation (Placement(transformation(extent={{-240,180},{-200,220}}),
        iconTransformation(extent={{-140,50},{-100,90}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VColDucDis_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate")
    "Measured cold duct discharge airflow rate"
    annotation (Placement(transformation(extent={{-240,90},{-200,130}}),
        iconTransformation(extent={{-140,30},{-100,70}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uCooDam(
    final min=0,
    final max=1,
    final unit="1")
    "Cooling damper position setpoint"
    annotation (Placement(transformation(extent={{-240,50},{-200,90}}),
        iconTransformation(extent={{-140,0},{-100,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uAftSupHea
    "After suppression period due to the heating setpoint change"
    annotation (Placement(transformation(extent={{-240,-40},{-200,0}}),
        iconTransformation(extent={{-140,-50},{-100,-10}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput THeaSet(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Zone heating setpoint temperature"
    annotation (Placement(transformation(extent={{-240,-80},{-200,-40}}),
        iconTransformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uHea(
    final min=0,
    final max=1,
    final unit="1")
    "Heating loop signal"
    annotation (Placement(transformation(extent={{-240,-170},{-200,-130}}),
        iconTransformation(extent={{-140,-110},{-100,-70}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VHotDuc_flow_Set(
    final min=0,
    final unit="m3/s",
    quantity="VolumeFlowRate")
    "Hot duct discharge airflow rate setpoint"
    annotation (Placement(transformation(extent={{-240,-220},{-200,-180}}),
        iconTransformation(extent={{-140,-140},{-100,-100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VHotDucDis_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate")
    "Measured hot duct discharge airflow rate"
    annotation (Placement(transformation(extent={{-240,-310},{-200,-270}}),
        iconTransformation(extent={{-140,-160},{-100,-120}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uHeaDam(
    final min=0,
    final max=1,
    final unit="1")
    "Heating damper position setpoint"
    annotation (Placement(transformation(extent={{-240,-350},{-200,-310}}),
        iconTransformation(extent={{-140,-190},{-100,-150}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yZonCooTemResReq
    "Zone cooling supply air temperature reset request"
    annotation (Placement(transformation(extent={{200,340},{240,380}}),
        iconTransformation(extent={{100,60},{140,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yColDucPreResReq
    "Cold duct static pressure reset requests"
    annotation (Placement(transformation(extent={{200,160},{240,200}}),
        iconTransformation(extent={{100,10},{140,50}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yZonHeaTemResReq
    "Zone heating supply air temperature reset request"
    annotation (Placement(transformation(extent={{200,-60},{240,-20}}),
        iconTransformation(extent={{100,-50},{140,-10}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yHotDucPreResReq
    "Hot duct static pressure reset requests"
    annotation (Placement(transformation(extent={{200,-240},{240,-200}}),
        iconTransformation(extent={{100,-100},{140,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yHeaFanReq
    "Heating fan request"
    annotation (Placement(transformation(extent={{200,-410},{240,-370}}),
        iconTransformation(extent={{100,-200},{140,-160}})));

protected
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greThr1(
    final t=thrTemDif,
    final h=dTHys)
    "Check if zone temperature is greater than cooling setpoint by threshold"
    annotation (Placement(transformation(extent={{-80,330},{-60,350}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greThr2(
    final t=twoTemDif,
    final h=dTHys)
    "Check if zone temperature is greater than cooling setpoint by threshold"
    annotation (Placement(transformation(extent={{-80,290},{-60,310}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greThr3(
    final t=0.95,
    final h=damPosHys)
    "Check if damper position is greater than 0.95"
    annotation (Placement(transformation(extent={{-160,60},{-140,80}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greThr(
    final t=0.95,
    final h=looHys)
    "Check if cooling loop signal is greater than 0.95"
    annotation (Placement(transformation(extent={{-80,240},{-60,260}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greThr4(
    final t=floHys,
    final h=0.5*floHys)
    "Check if discharge airflow setpoint is greater than 0"
    annotation (Placement(transformation(extent={{-140,190},{-120,210}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt
    "Convert boolean to integer"
    annotation (Placement(transformation(extent={{20,240},{40,260}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt1
    "Convert boolean to integer"
    annotation (Placement(transformation(extent={{20,60},{40,80}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiplyByParameter gai1(
    final k=0.5)
    "50% of setpoint"
    annotation (Placement(transformation(extent={{-140,160},{-120,180}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiplyByParameter gai2(
    final k=0.7)
    "70% of setpoint"
    annotation (Placement(transformation(extent={{-140,120},{-120,140}})));
  Buildings.Controls.OBC.CDL.Continuous.Subtract sub2
    "Calculate difference between zone temperature and cooling setpoint"
    annotation (Placement(transformation(extent={{-120,330},{-100,350}})));
  Buildings.Controls.OBC.CDL.Continuous.Subtract sub3
    "Calculate difference between zone temperature and cooling setpoint"
    annotation (Placement(transformation(extent={{-120,290},{-100,310}})));
  Buildings.Controls.OBC.CDL.Logical.And and1
    "Logical and"
    annotation (Placement(transformation(extent={{20,290},{40,310}})));
  Buildings.Controls.OBC.CDL.Logical.And and2
    "Logical and"
    annotation (Placement(transformation(extent={{20,350},{40,370}})));
  Buildings.Controls.OBC.CDL.Logical.And and3
    "Logical and"
    annotation (Placement(transformation(extent={{20,170},{40,190}})));
  Buildings.Controls.OBC.CDL.Logical.And and4
    "Logical and"
    annotation (Placement(transformation(extent={{20,100},{40,120}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant thrCooResReq(
    final k=3)
    "Constant 3"
    annotation (Placement(transformation(extent={{80,390},{100,410}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant twoCooResReq(
    final k=2) "Constant 2"
    annotation (Placement(transformation(extent={{20,390},{40,410}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant thrPreResReq(
    final k=3) "Constant 3"
    annotation (Placement(transformation(extent={{80,190},{100,210}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant twoPreResReq(
    final k=2)
    "Constant 2"
    annotation (Placement(transformation(extent={{20,130},{40,150}})));
  Buildings.Controls.OBC.CDL.Integers.Switch intSwi
    "Output 3 or other request "
    annotation (Placement(transformation(extent={{160,350},{180,370}})));
  Buildings.Controls.OBC.CDL.Integers.Switch intSwi1
    "Output 2 or other request "
    annotation (Placement(transformation(extent={{80,290},{100,310}})));
  Buildings.Controls.OBC.CDL.Integers.Switch swi4
    "Output 3 or other request "
    annotation (Placement(transformation(extent={{120,170},{140,190}})));
  Buildings.Controls.OBC.CDL.Integers.Switch swi5
    "Output 2 or other request "
    annotation (Placement(transformation(extent={{80,100},{100,120}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay tim1(
    final delayTime=durTimTem) "Check if it is more than threshold time"
    annotation (Placement(transformation(extent={{-40,330},{-20,350}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay tim2(
    final delayTime=durTimTem) "Check if it is more than threshold time"
    annotation (Placement(transformation(extent={{-40,290},{-20,310}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay tim3(
    final delayTime=durTimFlo) "Check if it is more than threshold time"
    annotation (Placement(transformation(extent={{-80,80},{-60,100}})));
  Buildings.Controls.OBC.CDL.Continuous.Greater greEqu(final h=floHys)
    "Check if discharge airflow is less than 50% of setpoint"
    annotation (Placement(transformation(extent={{-80,160},{-60,180}})));
  Buildings.Controls.OBC.CDL.Continuous.Greater greEqu1(final h=floHys)
    "Check if discharge airflow is less than 70% of setpoint"
    annotation (Placement(transformation(extent={{-80,120},{-60,140}})));
  Buildings.Controls.OBC.CDL.Logical.And and5
    "Logical and"
    annotation (Placement(transformation(extent={{-40,190},{-20,210}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greThr7(
    final t=thrTemDif,
    final h=dTHys)
    "Check if zone temperature is less than heating setpoint by threshold"
    annotation (Placement(transformation(extent={{-80,-70},{-60,-50}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greThr8(
    final t=twoTemDif,
    final h=dTHys)
    "Check if zone temperature is less than heating setpoint by threshold"
    annotation (Placement(transformation(extent={{-80,-110},{-60,-90}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greThr9(
    final t=0.95,
    final h=damPosHys)
    "Check if damper position is greater than 0.95"
    annotation (Placement(transformation(extent={{-180,-340},{-160,-320}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greThr10(
    final t=0.95,
    final h=looHys) "Check if heating loop signal is greater than 0.95"
    annotation (Placement(transformation(extent={{-80,-160},{-60,-140}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greThr11(
    final t=floHys,
    final h=0.5*floHys)
    "Check if discharge airflow setpoint is greater than 0"
    annotation (Placement(transformation(extent={{-160,-210},{-140,-190}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt4
    "Convert boolean to integer"
    annotation (Placement(transformation(extent={{20,-160},{40,-140}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt5
    "Convert boolean to integer"
    annotation (Placement(transformation(extent={{20,-340},{40,-320}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiplyByParameter gai3(
    final k=0.5)
    "50% of setpoint"
    annotation (Placement(transformation(extent={{-160,-240},{-140,-220}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiplyByParameter gai4(
    final k=0.7)
    "70% of setpoint"
    annotation (Placement(transformation(extent={{-160,-280},{-140,-260}})));
  Buildings.Controls.OBC.CDL.Continuous.Subtract sub1
    "Calculate difference between zone temperature and heating setpoint"
    annotation (Placement(transformation(extent={{-120,-70},{-100,-50}})));
  Buildings.Controls.OBC.CDL.Continuous.Subtract sub4
    "Calculate difference between zone temperature and heating setpoint"
    annotation (Placement(transformation(extent={{-120,-110},{-100,-90}})));
  Buildings.Controls.OBC.CDL.Logical.And and6
    "Logical and"
    annotation (Placement(transformation(extent={{20,-110},{40,-90}})));
  Buildings.Controls.OBC.CDL.Logical.And and7
    "Logical and"
    annotation (Placement(transformation(extent={{20,-50},{40,-30}})));
  Buildings.Controls.OBC.CDL.Logical.And and8
    "Logical and"
    annotation (Placement(transformation(extent={{20,-230},{40,-210}})));
  Buildings.Controls.OBC.CDL.Logical.And and9
    "Logical and"
    annotation (Placement(transformation(extent={{20,-300},{40,-280}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant thrCooResReq1(
    final k=3)
    "Constant 3"
    annotation (Placement(transformation(extent={{80,-10},{100,10}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant twoCooResReq1(
    final k=2)
    "Constant 2"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant thrPreResReq1(
    final k=3)
    "Constant 3"
    annotation (Placement(transformation(extent={{80,-210},{100,-190}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant twoPreResReq1(
    final k=2)
    "Constant 2"
    annotation (Placement(transformation(extent={{20,-270},{40,-250}})));
  Buildings.Controls.OBC.CDL.Integers.Switch intSwi4
    "Output 3 or other request "
    annotation (Placement(transformation(extent={{162,-50},{182,-30}})));
  Buildings.Controls.OBC.CDL.Integers.Switch intSwi5
    "Output 2 or other request "
    annotation (Placement(transformation(extent={{80,-110},{100,-90}})));
  Buildings.Controls.OBC.CDL.Integers.Switch swi1
    "Output 3 or other request "
    annotation (Placement(transformation(extent={{120,-230},{140,-210}})));
  Buildings.Controls.OBC.CDL.Integers.Switch swi2
    "Output 2 or other request "
    annotation (Placement(transformation(extent={{80,-300},{100,-280}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay tim6(
    final delayTime=durTimTem)
    "Check if it is more than threshold time"
    annotation (Placement(transformation(extent={{-40,-70},{-20,-50}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay tim7(
    final delayTime=durTimTem)
    "Check if it is more than threshold time"
    annotation (Placement(transformation(extent={{-40,-110},{-20,-90}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay tim8(
    final delayTime=durTimFlo)
    "Check if it is more than threshold time"
    annotation (Placement(transformation(extent={{-80,-320},{-60,-300}})));
  Buildings.Controls.OBC.CDL.Continuous.Greater greEqu2(final h=floHys)
    "Check if discharge airflow is less than 50% of setpoint"
    annotation (Placement(transformation(extent={{-80,-240},{-60,-220}})));
  Buildings.Controls.OBC.CDL.Continuous.Greater greEqu3(final h=floHys)
    "Check if discharge airflow is less than 70% of setpoint"
    annotation (Placement(transformation(extent={{-80,-280},{-60,-260}})));
  Buildings.Controls.OBC.CDL.Logical.And and10
    "Logical and"
    annotation (Placement(transformation(extent={{-40,-210},{-20,-190}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greThr12(
    final t=0.15,
    final h=looHys)
    "Check if heating loop signal is greater than 0.15"
    annotation (Placement(transformation(extent={{-80,-400},{-60,-380}})));
  Buildings.Controls.OBC.CDL.Logical.Latch lat "Hold the true input"
    annotation (Placement(transformation(extent={{0,-400},{20,-380}})));
  Buildings.Controls.OBC.CDL.Continuous.LessThreshold lesThr(
    final t=0.01,
    final h=looHys)
    "Check if the heating loop output is less than threshold"
    annotation (Placement(transformation(extent={{-80,-430},{-60,-410}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt6
    "Heating fan request"
    annotation (Placement(transformation(extent={{80,-400},{100,-380}})));

equation
  connect(sub2.y, greThr1.u)
    annotation (Line(points={{-98,340},{-82,340}}, color={0,0,127}));
  connect(and2.y, intSwi.u2)
    annotation (Line(points={{42,360},{158,360}},color={255,0,255}));
  connect(sub3.y, greThr2.u)
    annotation (Line(points={{-98,300},{-82,300}}, color={0,0,127}));
  connect(and1.y, intSwi1.u2)
    annotation (Line(points={{42,300},{78,300}}, color={255,0,255}));
  connect(and3.y, swi4.u2)
    annotation (Line(points={{42,180},{118,180}},color={255,0,255}));
  connect(and4.y, swi5.u2)
    annotation (Line(points={{42,110},{78,110}},   color={255,0,255}));
  connect(greThr2.y, tim2.u)
    annotation (Line(points={{-58,300},{-42,300}}, color={255,0,255}));
  connect(tim2.y, and1.u2)
    annotation (Line(points={{-18,300},{-10,300},{-10,292},{18,292}},
      color={255,0,255}));
  connect(greThr1.y, tim1.u)
    annotation (Line(points={{-58,340},{-42,340}}, color={255,0,255}));
  connect(tim1.y, and2.u2)
    annotation (Line(points={{-18,340},{-10,340},{-10,352},{18,352}},
      color={255,0,255}));
  connect(greThr4.u, VColDuc_flow_Set)
    annotation (Line(points={{-142,200},{-220,200}}, color={0,0,127}));
  connect(greEqu.u1, gai1.y)
    annotation (Line(points={{-82,170},{-118,170}},color={0,0,127}));
  connect(greEqu.y, and3.u2)
    annotation (Line(points={{-58,170},{-20,170},{-20,172},{18,172}},
      color={255,0,255}));
  connect(gai2.y, greEqu1.u1)
    annotation (Line(points={{-118,130},{-82,130}},
      color={0,0,127}));
  connect(greEqu1.y, and4.u2)
    annotation (Line(points={{-58,130},{-20,130},{-20,102},{18,102}},
      color={255,0,255}));
  connect(uCoo, greThr.u)
    annotation (Line(points={{-220,250},{-82,250}}, color={0,0,127}));
  connect(uAftSupCoo, and2.u1) annotation (Line(points={{-220,380},{0,380},{0,360},
          {18,360}},      color={255,0,255}));
  connect(uAftSupCoo, and1.u1) annotation (Line(points={{-220,380},{0,380},{0,300},
          {18,300}},      color={255,0,255}));
  connect(thrCooResReq.y, intSwi.u1) annotation (Line(points={{102,400},{120,400},
          {120,368},{158,368}},      color={255,127,0}));
  connect(twoCooResReq.y, intSwi1.u1) annotation (Line(points={{42,400},{60,400},
          {60,308},{78,308}}, color={255,127,0}));
  connect(intSwi1.y, intSwi.u3) annotation (Line(points={{102,300},{120,300},{120,
          352},{158,352}},     color={255,127,0}));
  connect(intSwi.y, yZonCooTemResReq)
    annotation (Line(points={{182,360},{220,360}}, color={255,127,0}));
  connect(greThr.y, booToInt.u)
    annotation (Line(points={{-58,250},{18,250}}, color={255,0,255}));
  connect(booToInt.y, intSwi1.u3) annotation (Line(points={{42,250},{60,250},{60,
          292},{78,292}},    color={255,127,0}));
  connect(uCooDam, greThr3.u)
    annotation (Line(points={{-220,70},{-162,70}}, color={0,0,127}));
  connect(VColDuc_flow_Set, gai1.u) annotation (Line(points={{-220,200},{-160,200},
          {-160,170},{-142,170}}, color={0,0,127}));
  connect(VColDuc_flow_Set, gai2.u) annotation (Line(points={{-220,200},{-160,200},
          {-160,130},{-142,130}}, color={0,0,127}));
  connect(VColDucDis_flow, greEqu.u2) annotation (Line(points={{-220,110},{-100,
          110},{-100,162},{-82,162}}, color={0,0,127}));
  connect(VColDucDis_flow, greEqu1.u2) annotation (Line(points={{-220,110},{-100,
          110},{-100,122},{-82,122}},color={0,0,127}));
  connect(greThr3.y, tim3.u) annotation (Line(points={{-138,70},{-100,70},{-100,
          90},{-82,90}}, color={255,0,255}));
  connect(greThr4.y, and5.u1)
    annotation (Line(points={{-118,200},{-42,200}}, color={255,0,255}));
  connect(tim3.y, and5.u2) annotation (Line(points={{-58,90},{-50,90},{-50,192},
          {-42,192}}, color={255,0,255}));
  connect(and5.y, and3.u1) annotation (Line(points={{-18,200},{0,200},{0,180},{18,
          180}}, color={255,0,255}));
  connect(and5.y, and4.u1) annotation (Line(points={{-18,200},{0,200},{0,110},{18,
          110}},     color={255,0,255}));
  connect(greThr3.y, booToInt1.u) annotation (Line(points={{-138,70},{18,70}},
          color={255,0,255}));
  connect(booToInt1.y, swi5.u3) annotation (Line(points={{42,70},{60,70},{60,102},
          {78,102}},        color={255,127,0}));
  connect(twoPreResReq.y, swi5.u1) annotation (Line(points={{42,140},{60,140},{60,
          118},{78,118}},       color={255,127,0}));
  connect(thrPreResReq.y, swi4.u1) annotation (Line(points={{102,200},{110,200},
          {110,188},{118,188}}, color={255,127,0}));
  connect(swi5.y, swi4.u3) annotation (Line(points={{102,110},{110,110},{110,172},
          {118,172}}, color={255,127,0}));
  connect(TCooSet, sub3.u2) annotation (Line(points={{-220,340},{-160,340},{-160,
          294},{-122,294}}, color={0,0,127}));
  connect(TCooSet, sub2.u2) annotation (Line(points={{-220,340},{-160,340},{-160,
          334},{-122,334}}, color={0,0,127}));
  connect(TZon, sub2.u1) annotation (Line(points={{-220,280},{-180,280},{-180,346},
          {-122,346}}, color={0,0,127}));
  connect(TZon, sub3.u1) annotation (Line(points={{-220,280},{-180,280},{-180,306},
          {-122,306}}, color={0,0,127}));
  connect(sub1.y,greThr7. u)
    annotation (Line(points={{-98,-60},{-82,-60}}, color={0,0,127}));
  connect(and7.y, intSwi4.u2)
    annotation (Line(points={{42,-40},{160,-40}},   color={255,0,255}));
  connect(sub4.y,greThr8. u)
    annotation (Line(points={{-98,-100},{-82,-100}}, color={0,0,127}));
  connect(and6.y,intSwi5. u2)
    annotation (Line(points={{42,-100},{78,-100}}, color={255,0,255}));
  connect(and8.y,swi1. u2)
    annotation (Line(points={{42,-220},{118,-220}}, color={255,0,255}));
  connect(and9.y,swi2. u2)
    annotation (Line(points={{42,-290},{78,-290}}, color={255,0,255}));
  connect(greThr8.y,tim7. u)
    annotation (Line(points={{-58,-100},{-42,-100}}, color={255,0,255}));
  connect(tim7.y,and6. u2)
    annotation (Line(points={{-18,-100},{-10,-100},{-10,-108},{18,-108}},
      color={255,0,255}));
  connect(greThr7.y,tim6. u)
    annotation (Line(points={{-58,-60},{-42,-60}}, color={255,0,255}));
  connect(tim6.y,and7. u2)
    annotation (Line(points={{-18,-60},{-10,-60},{-10,-48},{18,-48}},
      color={255,0,255}));
  connect(greThr11.u, VHotDuc_flow_Set)
    annotation (Line(points={{-162,-200},{-220,-200}}, color={0,0,127}));
  connect(greEqu2.u1, gai3.y)
    annotation (Line(points={{-82,-230},{-138,-230}}, color={0,0,127}));
  connect(greEqu2.y, and8.u2) annotation (Line(points={{-58,-230},{-20,-230},{-20,
          -228},{18,-228}}, color={255,0,255}));
  connect(gai4.y,greEqu3. u1)
    annotation (Line(points={{-138,-270},{-82,-270}},
      color={0,0,127}));
  connect(greEqu3.y,and9. u2)
    annotation (Line(points={{-58,-270},{-20,-270},{-20,-298},{18,-298}},
      color={255,0,255}));
  connect(uHea, greThr10.u)
    annotation (Line(points={{-220,-150},{-82,-150}}, color={0,0,127}));
  connect(uAftSupHea, and7.u1) annotation (Line(points={{-220,-20},{0,-20},{0,-40},
          {18,-40}},        color={255,0,255}));
  connect(uAftSupHea, and6.u1) annotation (Line(points={{-220,-20},{0,-20},{0,-100},
          {18,-100}},       color={255,0,255}));
  connect(thrCooResReq1.y, intSwi4.u1) annotation (Line(points={{102,0},{120,0},
          {120,-32},{160,-32}},         color={255,127,0}));
  connect(twoCooResReq1.y, intSwi5.u1) annotation (Line(points={{42,0},{60,0},{60,
          -92},{78,-92}},       color={255,127,0}));
  connect(intSwi5.y, intSwi4.u3) annotation (Line(points={{102,-100},{120,-100},
          {120,-48},{160,-48}},   color={255,127,0}));
  connect(intSwi4.y, yZonHeaTemResReq)
    annotation (Line(points={{184,-40},{220,-40}},   color={255,127,0}));
  connect(greThr10.y, booToInt4.u)
    annotation (Line(points={{-58,-150},{18,-150}}, color={255,0,255}));
  connect(booToInt4.y, intSwi5.u3) annotation (Line(points={{42,-150},{60,-150},
          {60,-108},{78,-108}}, color={255,127,0}));
  connect(uHeaDam, greThr9.u)
    annotation (Line(points={{-220,-330},{-182,-330}}, color={0,0,127}));
  connect(VHotDuc_flow_Set, gai3.u) annotation (Line(points={{-220,-200},{-180,-200},
          {-180,-230},{-162,-230}}, color={0,0,127}));
  connect(VHotDuc_flow_Set, gai4.u) annotation (Line(points={{-220,-200},{-180,-200},
          {-180,-270},{-162,-270}}, color={0,0,127}));
  connect(VHotDucDis_flow, greEqu2.u2) annotation (Line(points={{-220,-290},{-120,
          -290},{-120,-238},{-82,-238}}, color={0,0,127}));
  connect(VHotDucDis_flow, greEqu3.u2) annotation (Line(points={{-220,-290},{-120,
          -290},{-120,-278},{-82,-278}}, color={0,0,127}));
  connect(greThr9.y,tim8. u) annotation (Line(points={{-158,-330},{-100,-330},{-100,
          -310},{-82,-310}}, color={255,0,255}));
  connect(greThr11.y, and10.u1)
    annotation (Line(points={{-138,-200},{-42,-200}}, color={255,0,255}));
  connect(tim8.y, and10.u2) annotation (Line(points={{-58,-310},{-50,-310},{-50,
          -208},{-42,-208}}, color={255,0,255}));
  connect(and10.y, and8.u1) annotation (Line(points={{-18,-200},{0,-200},{0,-220},
          {18,-220}}, color={255,0,255}));
  connect(and10.y, and9.u1) annotation (Line(points={{-18,-200},{0,-200},{0,-290},
          {18,-290}}, color={255,0,255}));
  connect(greThr9.y,booToInt5. u) annotation (Line(points={{-158,-330},{18,-330}},
          color={255,0,255}));
  connect(booToInt5.y,swi2. u3) annotation (Line(points={{42,-330},{60,-330},{60,
          -298},{78,-298}}, color={255,127,0}));
  connect(twoPreResReq1.y, swi2.u1) annotation (Line(points={{42,-260},{60,-260},
          {60,-282},{78,-282}}, color={255,127,0}));
  connect(thrPreResReq1.y, swi1.u1) annotation (Line(points={{102,-200},{110,-200},
          {110,-212},{118,-212}}, color={255,127,0}));
  connect(swi2.y,swi1. u3) annotation (Line(points={{102,-290},{110,-290},{110,-228},
          {118,-228}},color={255,127,0}));
  connect(THeaSet, sub1.u1) annotation (Line(points={{-220,-60},{-160,-60},{-160,
          -54},{-122,-54}}, color={0,0,127}));
  connect(THeaSet, sub4.u1) annotation (Line(points={{-220,-60},{-160,-60},{-160,
          -94},{-122,-94}}, color={0,0,127}));
  connect(TZon, sub1.u2) annotation (Line(points={{-220,280},{-180,280},{-180,-66},
          {-122,-66}},  color={0,0,127}));
  connect(TZon, sub4.u2) annotation (Line(points={{-220,280},{-180,280},{-180,-106},
          {-122,-106}}, color={0,0,127}));
  connect(uHea, greThr12.u) annotation (Line(points={{-220,-150},{-110,-150},{-110,
          -390},{-82,-390}}, color={0,0,127}));
  connect(greThr12.y, lat.u)
    annotation (Line(points={{-58,-390},{-2,-390}}, color={255,0,255}));
  connect(uHea, lesThr.u) annotation (Line(points={{-220,-150},{-110,-150},{-110,
          -420},{-82,-420}}, color={0,0,127}));
  connect(lesThr.y, lat.clr) annotation (Line(points={{-58,-420},{-20,-420},{-20,
          -396},{-2,-396}}, color={255,0,255}));
  connect(lat.y, booToInt6.u)
    annotation (Line(points={{22,-390},{78,-390}}, color={255,0,255}));
  connect(booToInt6.y, yHeaFanReq)
    annotation (Line(points={{102,-390},{220,-390}}, color={255,127,0}));
  connect(swi1.y, yHotDucPreResReq)
    annotation (Line(points={{142,-220},{220,-220}}, color={255,127,0}));
  connect(swi4.y, yColDucPreResReq)
    annotation (Line(points={{142,180},{220,180}}, color={255,127,0}));

annotation (
  defaultComponentName="sysReq",
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-200,-440},{200,440}}),
      graphics={
        Rectangle(
          extent={{-198,418},{198,242}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-198,218},{198,42}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Text(
          extent={{-166,414},{-44,390}},
          textColor={0,0,255},
          horizontalAlignment=TextAlignment.Left,
          textString="Cooling SAT reset requests"),
        Text(
          extent={{-154,64},{6,38}},
          textColor={0,0,255},
          horizontalAlignment=TextAlignment.Left,
          textString="Cold duct static pressure reset requests"),
        Rectangle(
          extent={{-198,18},{198,-158}},
          textColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-198,-182},{198,-360}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Text(
          extent={{-166,14},{-44,-10}},
          textColor={0,0,255},
          horizontalAlignment=TextAlignment.Left,
          textString="Heating SAT reset requests"),
        Text(
          extent={{-154,-336},{6,-362}},
          textColor={0,0,255},
          horizontalAlignment=TextAlignment.Left,
          textString="Hot duct static pressure reset requests"),
        Rectangle(
          extent={{-198,-382},{198,-438}},
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
          extent={{-98,170},{-62,152}},
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
          extent={{-96,80},{-28,62}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VColDuc_flow_Set"),
        Text(
          extent={{-96,28},{-26,6}},
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
          extent={{-96,60},{-30,42}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VColDucDis_flow"),
        Text(
          extent={{-96,-20},{-44,-38}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="uAftSupHea"),
        Text(
          extent={{-96,-50},{-58,-66}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="THeaSet"),
        Text(
          extent={{-96,-82},{-72,-96}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="uHea"),
        Text(
          extent={{-94,-112},{-26,-130}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VHotDuc_flow_Set"),
        Text(
          extent={{-94,-132},{-28,-150}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VHotDucDis_flow"),
        Text(
          extent={{-96,-162},{-26,-184}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="uHeaDam")}),
  Documentation(info="<html>
<p>
This sequence outputs the system reset requests for dual-duct terminal unit using
mixing control with inlet flow sensor. The implementation is according to the Section 5.12.8 of ASHRAE
Guideline 36, May 2020. 
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
<ol>
<li>
If the measured airflow <code>VHotDucDis_flow</code> is less than 50% of setpoint
<code>VHotDuc_flow_Set</code> while the setpoint is greater than zero and the damper position
<code>uHeaDam</code> is greater than 95% for 1 minute, send 3 requests (<code>yHotDucPreResReq=3</code>).
</li>
<li>
Else if the measured airflow <code>VHotDucDis_flow</code> is less than 70% of setpoint
<code>VHotDuc_flow_Set</code> while the setpoint is greater than zero and the damper position
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
