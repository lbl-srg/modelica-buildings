within Buildings.Obsolete.Controls.OBC.ASHRAE.G36_PR1.TerminalUnits.Reheat;
block SystemRequests
  "Output system requests for VAV reheat terminal unit control"

  parameter Real samplePeriod(
    final unit="s",
    final quantity="Time")=120
    "Sample period of component, set to the same value as the trim and respond that process yPreSetReq";

  parameter Boolean have_heaWatCoi
    "Flag, true if there is a hot water coil";
  parameter Boolean have_heaPla "Flag, true if there is a boiler plant";

  parameter Real errTZonCoo_1(
    final unit="K",
    final displayUnit="K",
    final quantity="TemperatureDifference")=2.8
    "Limit value of difference between zone temperature and cooling setpoint
    for generating 3 cooling SAT reset requests";
  parameter Real errTZonCoo_2(
    final unit="K",
    final displayUnit="K",
    final quantity="TemperatureDifference")=1.7
    "Limit value of difference between zone temperature and cooling setpoint
    for generating 2 cooling SAT reset requests";
  parameter Real errTDis_1(
    final unit="K",
    final displayUnit="K",
    final quantity="TemperatureDifference")=17
    "Limit value of difference between discharge air temperature and its setpoint
    for generating 3 hot water reset requests";
  parameter Real errTDis_2(
    final unit="K",
    final displayUnit="K",
    final quantity="TemperatureDifference")=8.3
    "Limit value of difference between discharge air temperature and its setpoint
    for generating 2 hot water reset requests";

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
    "Duration time of discharge air temperature is less than setpoint"
    annotation(Dialog(group="Duration times"));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TZon(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Zone temperature"
    annotation (Placement(transformation(extent={{-220,150},{-180,190}}),
        iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TZonCooSet(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Zone cooling setpoint temperature"
    annotation (Placement(transformation(extent={{-220,420},{-180,460}}),
        iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uCoo(
    final min=0,
    final max=1,
    final unit="1")
    "Cooling loop signal"
    annotation (Placement(transformation(extent={{-220,70},{-180,110}}),
        iconTransformation(extent={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VDis_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate") "Measured discharge airflow rate"
    annotation (Placement(transformation(extent={{-220,-90},{-180,-50}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VDisSet_flow(
    final min=0,
    final unit="m3/s",
    quantity="VolumeFlowRate")
    "Discharge airflow rate setpoint"
    annotation (Placement(transformation(extent={{-220,10},{-180,50}}),
        iconTransformation(extent={{-140,0},{-100,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput yDam_actual(
    final min=0,
    final max=1,
    final unit="1") "Actual damper position"
    annotation (Placement(transformation(extent={{-220,-170},{-180,-130}}),
        iconTransformation(extent={{-140,-40},{-100,0}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TDisHeaSet(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature") if have_heaWatCoi
    "Discharge airflow setpoint temperature for heating"
    annotation (Placement(transformation(extent={{-220,-230},{-180,-190}}),
        iconTransformation(extent={{-140,-60},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TDis(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature") if have_heaWatCoi
    "Measured discharge airflow temperature"
    annotation (Placement(transformation(extent={{-220,-310},{-180,-270}}),
        iconTransformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uHeaVal(
    final min=0,
    final max=1,
    final unit="1") if have_heaWatCoi "Heating valve position"
    annotation (Placement(transformation(extent={{-220,-370},{-180,-330}}),
        iconTransformation(extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yZonPreResReq
    "Zone static pressure reset requests"
    annotation (Placement(transformation(extent={{180,-60},{220,-20}}),
        iconTransformation(extent={{100,0},{140,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yZonTemResReq
    "Zone cooling supply air temperature reset request"
    annotation (Placement(transformation(extent={{180,180},{220,220}}),
        iconTransformation(extent={{100,50},{140,90}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yHeaValResReq if have_heaWatCoi
    "Hot water reset requests"
    annotation (Placement(transformation(extent={{180,-260},{220,-220}}),
        iconTransformation(extent={{100,-60},{140,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yHeaPlaReq if (have_heaWatCoi and have_heaPla)
    "Heating plant request"
    annotation (Placement(transformation(extent={{180,-450},{220,-410}}),
        iconTransformation(extent={{100,-110},{140,-70}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys(
    final uLow=errTZonCoo_1 - 0.1,
    final uHigh=errTZonCoo_1 + 0.1)
    "Check if zone temperature is greater than cooling setpoint by errTZonCoo_1"
    annotation (Placement(transformation(extent={{-60,190},{-40,210}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys3(
    final uLow=errTZonCoo_2 - 0.1,
    final uHigh=errTZonCoo_2 + 0.1)
    "Check if zone temperature is greater than cooling setpoint by errTZonCoo_2"
    annotation (Placement(transformation(extent={{-60,130},{-40,150}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys4(
    final uLow=0.85,
    final uHigh=0.95)
    "Check if damper position is greater than 0.95"
    annotation (Placement(transformation(extent={{-60,-160},{-40,-140}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys5(
    final uLow=0.85,
    final uHigh=0.95)
    "Check if cooling loop signal is greater than 0.95"
    annotation (Placement(transformation(extent={{-60,80},{-40,100}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys7(
    final uHigh=0.01,
    final uLow=0.005)
    "Check if discharge airflow setpoint is greater than 0"
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys8(
    final uLow=-0.1,
    final uHigh=0.1) if have_heaWatCoi
    "Check if discharge air temperature is errTDis_1 less than setpoint"
    annotation (Placement(transformation(extent={{-40,-250},{-20,-230}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys9(
    final uLow=-0.1,
    final uHigh=0.1) if have_heaWatCoi
    "Check if discharge air temperature is errTDis_2 less than setpoint"
    annotation (Placement(transformation(extent={{-40,-310},{-20,-290}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys10(
    final uLow=0.85,
    final uHigh=0.95) if have_heaWatCoi
    "Check if valve position is greater than 0.95"
    annotation (Placement(transformation(extent={{-140,-360},{-120,-340}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys11(
    final uHigh=0.95,
    final uLow=0.1) if (have_heaWatCoi and have_heaPla)
    "Check if valve position is greater than 0.95"
    annotation (Placement(transformation(extent={{-140,-440},{-120,-420}})));

protected
  Buildings.Controls.OBC.CDL.Discrete.Sampler samTZonCooSet(
    final samplePeriod=samplePeriod)
    "Sample current cooling setpoint"
    annotation (Placement(transformation(extent={{-160,430},{-140,450}})));
  Buildings.Controls.OBC.CDL.Discrete.UnitDelay uniDel(
    final samplePeriod=samplePeriod)
    "Delay value to record input value"
    annotation (Placement(transformation(extent={{-80,450},{-60,470}})));
  Buildings.Controls.OBC.CDL.Continuous.Abs abs "Absolute change of the setpoint temperature"
    annotation (Placement(transformation(extent={{100,400},{120,420}})));
  Buildings.Controls.OBC.CDL.Discrete.TriggeredSampler triSam
    "Sample the setpoint changed value when there is change"
    annotation (Placement(transformation(extent={{-120,270},{-100,290}})));
  Buildings.Controls.OBC.CDL.Logical.Edge edg "Instants when input becomes true"
    annotation (Placement(transformation(extent={{-60,290},{-40,310}})));
  Buildings.Controls.OBC.CDL.Logical.Latch lat "Maintains an on signal until conditions changes"
    annotation (Placement(transformation(extent={{-60,330},{-40,350}})));
  Buildings.Controls.OBC.CDL.Logical.Latch lat1 "Maintains an on signal until conditions changes"
    annotation (Placement(transformation(extent={{60,260},{80,280}})));
  Buildings.Controls.OBC.CDL.Logical.Timer tim "Calculate time"
    annotation (Placement(transformation(extent={{0,330},{20,350}})));
  Buildings.Controls.OBC.CDL.Continuous.Greater gre1
    "Check if current model time is greater than the sample period"
    annotation (Placement(transformation(extent={{-80,400},{-60,420}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys2(
    final uLow=0.05,
    final uHigh=0.15)
    "Check if there is setpoint change"
    annotation (Placement(transformation(extent={{-120,330},{-100,350}})));
  Buildings.Controls.OBC.CDL.Continuous.Min supTim "Suppression time"
    annotation (Placement(transformation(extent={{0,270},{20,290}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.ModelTime modTim "Time of the model"
    annotation (Placement(transformation(extent={{-140,400},{-120,420}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiplyByParameter gai(final k=540)
    "Convert change of degC to change of degF and find out suppression time (5 min/degF))"
    annotation (Placement(transformation(extent={{-80,270},{-60,290}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiplyByParameter gai1(final k=0.5)
    "50% of setpoint"
    annotation (Placement(transformation(extent={{-100,-50},{-80,-30}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiplyByParameter gai2(final k=0.7)
    "70% of setpoint"
    annotation (Placement(transformation(extent={{-100,-98},{-80,-78}})));
  Buildings.Controls.OBC.CDL.Continuous.Subtract sub1
    "Calculate difference of previous and current setpoints"
    annotation (Placement(transformation(extent={{-20,424},{0,444}})));
  Buildings.Controls.OBC.CDL.Continuous.Subtract sub2
    "Calculate difference between zone temperature and cooling setpoint"
    annotation (Placement(transformation(extent={{-100,190},{-80,210}})));
  Buildings.Controls.OBC.CDL.Continuous.Subtract sub3
    "Calculate difference between zone temperature and cooling setpoint"
    annotation (Placement(transformation(extent={{-100,130},{-80,150}})));
  Buildings.Controls.OBC.CDL.Continuous.Subtract sub6 if have_heaWatCoi
    "Calculate difference of discharge temperature (plus errTDis_1) and its setpoint"
    annotation (Placement(transformation(extent={{-80,-250},{-60,-230}})));
  Buildings.Controls.OBC.CDL.Continuous.Subtract sub7 if have_heaWatCoi
    "Calculate difference of discharge temperature (plus errTDis_2) and its setpoint"
    annotation (Placement(transformation(extent={{-80,-310},{-60,-290}})));
  Buildings.Controls.OBC.CDL.Continuous.AddParameter addPar(
    final p=errTDis_1) if have_heaWatCoi
    "Discharge temperature plus errTDis_1"
    annotation (Placement(transformation(extent={{-140,-272},{-120,-252}})));
  Buildings.Controls.OBC.CDL.Continuous.AddParameter addPar1(
    final p=errTDis_2) if have_heaWatCoi
    "Discharge temperature plus errTDis_2"
    annotation (Placement(transformation(extent={{-140,-330},{-120,-310}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt "Convert real to integer value"
    annotation (Placement(transformation(extent={{140,190},{160,210}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt1 "Convert real to integer value"
    annotation (Placement(transformation(extent={{140,-50},{160,-30}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt2 if have_heaWatCoi
    "Convert real to integer value"
    annotation (Placement(transformation(extent={{140,-250},{160,-230}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt3 if (have_heaWatCoi and
    have_heaPla)
    "Convert real to integer value"
    annotation (Placement(transformation(extent={{140,-440},{160,-420}})));
  Buildings.Controls.OBC.CDL.Logical.And and1 "Logical and"
    annotation (Placement(transformation(extent={{40,130},{60,150}})));
  Buildings.Controls.OBC.CDL.Logical.And and2 "Logical and"
    annotation (Placement(transformation(extent={{40,190},{60,210}})));
  Buildings.Controls.OBC.CDL.Logical.And and3 "Logical and"
    annotation (Placement(transformation(extent={{40,-50},{60,-30}})));
  Buildings.Controls.OBC.CDL.Logical.And and4 "Logical and"
    annotation (Placement(transformation(extent={{40,-110},{60,-90}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con(
    final k=samplePeriod) "Sample period time"
    annotation (Placement(transformation(extent={{-140,370},{-120,390}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant conZer(final k=0.0)
               "Constant zero"
    annotation (Placement(transformation(extent={{-20,370},{0,390}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant thrCooResReq(final k=
        3.0)   "Constant 3"
    annotation (Placement(transformation(extent={{40,220},{60,240}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant twoCooResReq(final k=
        2.0)   "Constant 2"
    annotation (Placement(transformation(extent={{40,160},{60,180}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant oneCooResReq(final k=1.0)
               "Constant 1"
    annotation (Placement(transformation(extent={{40,100},{60,120}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zerCooReq(final k=0.0)
               "Constant 0"
    annotation (Placement(transformation(extent={{40,60},{60,80}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant thrPreResReq(final k=
        3.0)   "Constant 3"
    annotation (Placement(transformation(extent={{40,-20},{60,0}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant twoPreResReq(final k=
        2.0)   "Constant 2"
    annotation (Placement(transformation(extent={{40,-80},{60,-60}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zerPreResReq(final k=
        0.0)   "Constant 0"
    annotation (Placement(transformation(extent={{40,-180},{60,-160}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant onePreResReq(final k=
        1.0)   "Constant 1"
    annotation (Placement(transformation(extent={{40,-140},{60,-120}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant thrHeaResReq(
    final k=3) if have_heaWatCoi
    "Constant 3"
    annotation (Placement(transformation(extent={{40,-220},{60,-200}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant twoHeaResReq(
    final k=2) if have_heaWatCoi
    "Constant 2"
    annotation (Placement(transformation(extent={{40,-280},{60,-260}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant oneHeaResReq(final k=
        1.0)   if have_heaWatCoi
    "Constant 1"
    annotation (Placement(transformation(extent={{40,-340},{60,-320}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zerHeaResReq(final k=
        0.0)   if have_heaWatCoi
    "Constant 0"
    annotation (Placement(transformation(extent={{40,-380},{60,-360}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zerBoiPlaReq(final k=
        0.0)   if (have_heaWatCoi
     and have_heaPla)
    "Constant 0"
    annotation (Placement(transformation(extent={{40,-460},{60,-440}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant oneBoiPlaReq(final k=
        1.0)   if (have_heaWatCoi and have_heaPla)
    "Constant 1"
    annotation (Placement(transformation(extent={{40,-420},{60,-400}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant maxSupTim(k=1800)
    "Maximum suppression time 30 minutes"
    annotation (Placement(transformation(extent={{-80,240},{-60,260}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con5(k=true) "Constant true"
    annotation (Placement(transformation(extent={{60,290},{80,310}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swi
    "Use setpoint different value when half sample period time has passed"
    annotation (Placement(transformation(extent={{40,400},{60,420}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swi1 "Output 3 or other request "
    annotation (Placement(transformation(extent={{100,190},{120,210}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swi2 "Output 2 or other request "
    annotation (Placement(transformation(extent={{100,130},{120,150}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swi3 "Output 0 or 1 request "
    annotation (Placement(transformation(extent={{100,80},{120,100}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swi4 "Output 3 or other request "
    annotation (Placement(transformation(extent={{100,-50},{120,-30}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swi5 "Output 2 or other request "
    annotation (Placement(transformation(extent={{100,-110},{120,-90}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swi6 "Output 0 or 1 request "
    annotation (Placement(transformation(extent={{100,-160},{120,-140}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swi7 if have_heaWatCoi
    "Output 3 or other request "
    annotation (Placement(transformation(extent={{100,-250},{120,-230}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swi8 if have_heaWatCoi
    "Output 2 or other request "
    annotation (Placement(transformation(extent={{100,-310},{120,-290}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swi9 if have_heaWatCoi
    "Output 0 or 1 request "
    annotation (Placement(transformation(extent={{100,-360},{120,-340}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swi10 if (have_heaWatCoi and
    have_heaPla)
    "Output 0 or 1 request "
    annotation (Placement(transformation(extent={{100,-440},{120,-420}})));
  Buildings.Controls.OBC.CDL.Logical.TrueHoldWithReset truHol(duration=samplePeriod)
    "Hold true signal for sample period of time"
    annotation (Placement(transformation(extent={{120,330},{140,350}})));
  Buildings.Controls.OBC.CDL.Logical.Switch logSwi "Logical switch"
    annotation (Placement(transformation(extent={{120,300},{140,280}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay tim1(delayTime=durTimTem)
    "Check if it is more than durTimTem"
    annotation (Placement(transformation(extent={{-20,190},{0,210}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay tim2(delayTime=durTimTem)
    "Check if it is more than durTimTem"
    annotation (Placement(transformation(extent={{-20,130},{0,150}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay tim3(delayTime=durTimFlo)
    "Check if it is more than durTimFlo"
    annotation (Placement(transformation(extent={{-20,20},{0,40}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay tim4(delayTime=durTimDisAir) if have_heaWatCoi
    "Check if it is more than durTimDisAir"
    annotation (Placement(transformation(extent={{0,-250},{20,-230}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay tim5(delayTime=durTimDisAir) if have_heaWatCoi
    "Check if it is more than durTimDisAir"
    annotation (Placement(transformation(extent={{0,-310},{20,-290}})));
  Buildings.Controls.OBC.CDL.Discrete.Sampler sampler(
    final samplePeriod=samplePeriod)
    "Sample input signal, as the output signal will go to the trim and respond which also samples at samplePeriod"
    annotation (Placement(transformation(extent={{-160,-50},{-140,-30}})));
  Buildings.Controls.OBC.CDL.Discrete.Sampler sampler1(
    final samplePeriod=samplePeriod)
    "Sample input signal, as the output signal will go to the trim and respond which also samples at samplePeriod"
    annotation (Placement(transformation(extent={{-160,-80},{-140,-60}})));
  Buildings.Controls.OBC.CDL.Discrete.Sampler sampler2(
    final samplePeriod=samplePeriod)
    "Sample input signal, as the output signal will go to the trim and respond which also samples at samplePeriod"
    annotation (Placement(transformation(extent={{-160,-160},{-140,-140}})));
  Buildings.Controls.OBC.CDL.Discrete.Sampler sampler4(
    final samplePeriod=samplePeriod)
    "Sample input signal, as the output signal will go to the trim and respond which also samples at samplePeriod"
    annotation (Placement(transformation(extent={{-160,80},{-140,100}})));
  Buildings.Controls.OBC.CDL.Continuous.Greater greVDis50
    "Check if discharge airflow is less than 50% of setpoint"
    annotation (Placement(transformation(extent={{-60,-50},{-40,-30}})));
  Buildings.Controls.OBC.CDL.Continuous.Greater greVDis70
    "Check if discharge airflow is less than 70% of setpoint"
    annotation (Placement(transformation(extent={{-60,-110},{-40,-90}})));
  Buildings.Controls.OBC.CDL.Continuous.Less les
    "Check if the suppression time has not yet passed"
    annotation (Placement(transformation(extent={{38,330},{58,350}})));
  Buildings.Controls.OBC.CDL.Logical.Not notLes
    "Inversion of output signal"
    annotation (Placement(transformation(extent={{76,330},{96,350}})));

equation
  connect(sub2.y, hys.u)
    annotation (Line(points={{-78,200},{-62,200}},   color={0,0,127}));
  connect(TZonCooSet, samTZonCooSet.u)
    annotation (Line(points={{-200,440},{-162,440}}, color={0,0,127}));
  connect(samTZonCooSet.y, uniDel.u)
    annotation (Line(points={{-138,440},{-100,440},{-100,460},{-82,460}},
      color={0,0,127}));
  connect(triSam.y, gai.u)
    annotation (Line(points={{-98,280},{-82,280}},color={0,0,127}));
  connect(hys2.y, lat.u)
    annotation (Line(points={{-98,340},{-62,340}}, color={255,0,255}));
  connect(lat.y, tim.u)
    annotation (Line(points={{-38,340},{-2,340}}, color={255,0,255}));
  connect(edg.y, triSam.trigger)
    annotation (Line(points={{-38,300},{-20,300},{-20,264},{-110,264},{-110,268}},
      color={255,0,255}));
  connect(lat.y, edg.u)
    annotation (Line(points={{-38,340},{-20,340},{-20,318},{-80,318},{-80,300},
      {-62,300}}, color={255,0,255}));
  connect(edg.y, lat1.clr)
    annotation (Line(points={{-38,300},{-20,300},{-20,264},{58,264}}, color={255,0,255}));
  connect(modTim.y, gre1.u1)
    annotation (Line(points={{-118,410},{-82,410}},  color={0,0,127}));
  connect(con.y, gre1.u2)
    annotation (Line(points={{-118,380},{-100,380},{-100,402},{-82,402}},
      color={0,0,127}));
  connect(gre1.y, swi.u2)
    annotation (Line(points={{-58,410},{38,410}}, color={255,0,255}));
  connect(sub1.y, swi.u1)
    annotation (Line(points={{2,434},{20,434},{20,418},{38,418}},
      color={0,0,127}));
  connect(conZer.y, swi.u3)
    annotation (Line(points={{2,380},{20,380},{20,402},{38,402}}, color={0,0,127}));
  connect(swi.y, abs.u)
    annotation (Line(points={{62,410},{98,410}},
      color={0,0,127}));
  connect(abs.y, triSam.u)
    annotation (Line(points={{122,410},{140,410},{140,360},{-140,360},{-140,280},
          {-122,280}}, color={0,0,127}));
  connect(abs.y, hys2.u)
    annotation (Line(points={{122,410},{140,410},{140,360},{-140,360},{-140,340},
          {-122,340}}, color={0,0,127}));
  connect(and2.y, swi1.u2)
    annotation (Line(points={{62,200},{98,200}}, color={255,0,255}));
  connect(thrCooResReq.y, swi1.u1)
    annotation (Line(points={{62,230},{80,230},{80,208},{98,208}}, color={0,0,127}));
  connect(sub3.y, hys3.u)
    annotation (Line(points={{-78,140},{-62,140}}, color={0,0,127}));
  connect(twoCooResReq.y, swi2.u1)
    annotation (Line(points={{62,170},{80,170},{80,148},{98,148}},
      color={0,0,127}));
  connect(swi2.y, swi1.u3)
    annotation (Line(points={{122,140},{140,140},{140,180},{80,180},{80,192},{98,
          192}}, color={0,0,127}));
  connect(and1.y, swi2.u2)
    annotation (Line(points={{62,140},{98,140}}, color={255,0,255}));
  connect(hys5.y, swi3.u2)
    annotation (Line(points={{-38,90},{98,90}}, color={255,0,255}));
  connect(oneCooResReq.y, swi3.u1)
    annotation (Line(points={{62,110},{80,110},{80,98},{98,98}},
      color={0,0,127}));
  connect(swi3.y, swi2.u3)
    annotation (Line(points={{122,90},{140,90},{140,120},{80,120},{80,132},{98,132}},
                 color={0,0,127}));
  connect(zerCooReq.y, swi3.u3)
    annotation (Line(points={{62,70},{80,70},{80,82},{98,82}},
      color={0,0,127}));
  connect(swi1.y, reaToInt.u)
    annotation (Line(points={{122,200},{138,200}}, color={0,0,127}));
  connect(reaToInt.y, yZonTemResReq)
    annotation (Line(points={{162,200},{200,200}}, color={255,127,0}));
  connect(and3.y, swi4.u2)
    annotation (Line(points={{62,-40},{98,-40}}, color={255,0,255}));
  connect(thrPreResReq.y, swi4.u1)
    annotation (Line(points={{62,-10},{80,-10},{80,-32},{98,-32}},
      color={0,0,127}));
  connect(and4.y, swi5.u2)
    annotation (Line(points={{62,-100},{98,-100}}, color={255,0,255}));
  connect(twoPreResReq.y, swi5.u1)
    annotation (Line(points={{62,-70},{80,-70},{80,-92},{98,-92}},
      color={0,0,127}));
  connect(swi5.y, swi4.u3)
    annotation (Line(points={{122,-100},{140,-100},{140,-60},{80,-60},{80,-48},{
          98,-48}},
                 color={0,0,127}));
  connect(hys4.y, swi6.u2)
    annotation (Line(points={{-38,-150},{98,-150}},  color={255,0,255}));
  connect(onePreResReq.y, swi6.u1)
    annotation (Line(points={{62,-130},{80,-130},{80,-142},{98,-142}},
      color={0,0,127}));
  connect(zerPreResReq.y, swi6.u3)
    annotation (Line(points={{62,-170},{80,-170},{80,-158},{98,-158}},
      color={0,0,127}));
  connect(swi6.y, swi5.u3)
    annotation (Line(points={{122,-150},{140,-150},{140,-120},{80,-120},{80,-108},
          {98,-108}},
                  color={0,0,127}));
  connect(swi4.y, reaToInt1.u)
    annotation (Line(points={{122,-40},{138,-40}}, color={0,0,127}));
  connect(reaToInt1.y, yZonPreResReq)
    annotation (Line(points={{162,-40},{200,-40}}, color={255,127,0}));
  connect(TDis, addPar.u)
    annotation (Line(points={{-200,-290},{-160,-290},{-160,-262},{-142,-262}},
      color={0,0,127}));
  connect(addPar.y, sub6.u2)
    annotation (Line(points={{-118,-262},{-108,-262},{-108,-246},{-82,-246}},
      color={0,0,127}));
  connect(TDisHeaSet, sub6.u1)
    annotation (Line(points={{-200,-210},{-100,-210},{-100,-234},{-82,-234}},
      color={0,0,127}));
  connect(sub6.y, hys8.u)
    annotation (Line(points={{-58,-240},{-42,-240}}, color={0,0,127}));
  connect(addPar1.y, sub7.u2)
    annotation (Line(points={{-118,-320},{-108,-320},{-108,-306},{-82,-306}},
      color={0,0,127}));
  connect(sub7.y, hys9.u)
    annotation (Line(points={{-58,-300},{-42,-300}}, color={0,0,127}));
  connect(hys9.y, tim5.u)
    annotation (Line(points={{-18,-300},{-2,-300}}, color={255,0,255}));
  connect(thrHeaResReq.y, swi7.u1)
    annotation (Line(points={{62,-210},{80,-210},{80,-232},{98,-232}},
      color={0,0,127}));
  connect(twoHeaResReq.y, swi8.u1)
    annotation (Line(points={{62,-270},{80,-270},{80,-292},{98,-292}},
      color={0,0,127}));
  connect(swi8.y, swi7.u3)
    annotation (Line(points={{122,-300},{140,-300},{140,-260},{80,-260},{80,-248},
          {98,-248}},
                  color={0,0,127}));
  connect(TDis, addPar1.u)
    annotation (Line(points={{-200,-290},{-160,-290},{-160,-320},{-142,-320}},
      color={0,0,127}));
  connect(TDisHeaSet, sub7.u1)
    annotation (Line(points={{-200,-210},{-100,-210},{-100,-294},{-82,-294}},
      color={0,0,127}));
  connect(uHeaVal, hys10.u)
    annotation (Line(points={{-200,-350},{-142,-350}}, color={0,0,127}));
  connect(hys10.y, swi9.u2)
    annotation (Line(points={{-118,-350},{98,-350}}, color={255,0,255}));
  connect(oneHeaResReq.y, swi9.u1)
    annotation (Line(points={{62,-330},{80,-330},{80,-342},{98,-342}},
      color={0,0,127}));
  connect(zerHeaResReq.y, swi9.u3)
    annotation (Line(points={{62,-370},{80,-370},{80,-358},{98,-358}},
      color={0,0,127}));
  connect(swi9.y, swi8.u3)
    annotation (Line(points={{122,-350},{140,-350},{140,-320},{80,-320},{80,-308},
          {98,-308}},
                  color={0,0,127}));
  connect(swi7.y, reaToInt2.u)
    annotation (Line(points={{122,-240},{138,-240}}, color={0,0,127}));
  connect(reaToInt2.y, yHeaValResReq)
    annotation (Line(points={{162,-240},{200,-240}}, color={255,127,0}));
  connect(uHeaVal, hys11.u)
    annotation (Line(points={{-200,-350},{-160,-350},{-160,-430},{-142,-430}},
      color={0,0,127}));
  connect(hys11.y, swi10.u2)
    annotation (Line(points={{-118,-430},{98,-430}}, color={255,0,255}));
  connect(oneBoiPlaReq.y, swi10.u1)
    annotation (Line(points={{62,-410},{80,-410},{80,-422},{98,-422}},
      color={0,0,127}));
  connect(zerBoiPlaReq.y, swi10.u3)
    annotation (Line(points={{62,-450},{80,-450},{80,-438},{98,-438}},
      color={0,0,127}));
  connect(swi10.y, reaToInt3.u)
    annotation (Line(points={{122,-430},{138,-430}}, color={0,0,127}));
  connect(reaToInt3.y,yHeaPlaReq)
    annotation (Line(points={{162,-430},{200,-430}}, color={255,127,0}));
  connect(truHol.y, lat.clr)
    annotation (Line(points={{142,340},{160,340},{160,320},{-80,320},{-80,334},{
          -62,334}},        color={255,0,255}));
  connect(lat.y, logSwi.u2)
    annotation (Line(points={{-38,340},{-20,340},{-20,318},{100,318},{100,290},{
          118,290}},
                  color={255,0,255}));
  connect(con5.y, logSwi.u3)
    annotation (Line(points={{82,300},{104,300},{104,298},{118,298}},
      color={255,0,255}));
  connect(lat1.y, logSwi.u1)
    annotation (Line(points={{82,270},{100,270},{100,282},{118,282}},
      color={255,0,255}));
  connect(logSwi.y, and2.u1)
    annotation (Line(points={{142,290},{160,290},{160,258},{20,258},{20,200},{38,
          200}}, color={255,0,255}));
  connect(logSwi.y, and1.u1)
    annotation (Line(points={{142,290},{160,290},{160,258},{20,258},{20,140},{38,
          140}}, color={255,0,255}));
  connect(gai.y, supTim.u1)
    annotation (Line(points={{-58,280},{-40,280},{-40,286},{-2,286}},
      color={0,0,127}));
  connect(maxSupTim.y, supTim.u2)
    annotation (Line(points={{-58,250},{-40,250},{-40,274},{-2,274}},
      color={0,0,127}));
  connect(tim5.y, swi8.u2)
    annotation (Line(points={{22,-300},{98,-300}}, color={255,0,255}));
  connect(hys8.y, tim4.u)
    annotation (Line(points={{-18,-240},{-2,-240}}, color={255,0,255}));
  connect(tim4.y, swi7.u2)
    annotation (Line(points={{22,-240},{98,-240}}, color={255,0,255}));
  connect(hys7.y, tim3.u)
    annotation (Line(points={{-38,30},{-22,30}},  color={255,0,255}));
  connect(tim3.y, and3.u1)
    annotation (Line(points={{2,30},{20,30},{20,-40},{38,-40}},
      color={255,0,255}));
  connect(tim3.y, and4.u1)
    annotation (Line(points={{2,30},{20,30},{20,-100},{38,-100}},
      color={255,0,255}));
  connect(hys3.y, tim2.u)
    annotation (Line(points={{-38,140},{-22,140}}, color={255,0,255}));
  connect(tim2.y, and1.u2)
    annotation (Line(points={{2,140},{12,140},{12,132},{38,132}},
      color={255,0,255}));
  connect(hys.y, tim1.u)
    annotation (Line(points={{-38,200},{-22,200}}, color={255,0,255}));
  connect(tim1.y, and2.u2)
    annotation (Line(points={{2,200},{10,200},{10,192},{38,192}},
      color={255,0,255}));
  connect(sampler.u, VDisSet_flow)
    annotation (Line(points={{-162,-40},{-170,-40},{-170,30},{-200,30}},
      color={0,0,127}));
  connect(sampler.y, gai1.u)
    annotation (Line(points={{-138,-40},{-102,-40}}, color={0,0,127}));
  connect(sampler.y, gai2.u)
    annotation (Line(points={{-138,-40},{-128,-40},{-128,-88},{-102,-88}},
      color={0,0,127}));
  connect(sampler1.u, VDis_flow)
    annotation (Line(points={{-162,-70},{-200,-70}}, color={0,0,127}));
  connect(yDam_actual, sampler2.u)
    annotation (Line(points={{-200,-150},{-162,-150}}, color={0,0,127}));
  connect(sampler2.y, hys4.u)
    annotation (Line(points={{-138,-150},{-62,-150}},  color={0,0,127}));
  connect(uCoo, sampler4.u)
    annotation (Line(points={{-200,90},{-162,90}}, color={0,0,127}));
  connect(sampler4.y, hys5.u)
    annotation (Line(points={{-138,90},{-62,90}}, color={0,0,127}));
  connect(hys7.u, VDisSet_flow)
    annotation (Line(points={{-62,30},{-200,30}}, color={0,0,127}));
  connect(greVDis50.u1, gai1.y)
    annotation (Line(points={{-62,-40},{-78,-40}}, color={0,0,127}));
  connect(greVDis50.u2, sampler1.y) annotation (Line(points={{-62,-48},{-72,-48},
          {-72,-70},{-138,-70}}, color={0,0,127}));
  connect(greVDis50.y, and3.u2) annotation (Line(points={{-38,-40},{0,-40},{0,-48},
          {38,-48}}, color={255,0,255}));
  connect(gai2.y, greVDis70.u1) annotation (Line(points={{-78,-88},{-76,-88},{-76,
          -100},{-62,-100}}, color={0,0,127}));
  connect(sampler1.y, greVDis70.u2) annotation (Line(points={{-138,-70},{-132,-70},
          {-132,-108},{-62,-108}}, color={0,0,127}));
  connect(greVDis70.y, and4.u2) annotation (Line(points={{-38,-100},{0,-100},{0,
          -108},{38,-108}}, color={255,0,255}));
  connect(tim.y, les.u1)
    annotation (Line(points={{22,340},{36,340}}, color={0,0,127}));
  connect(supTim.y, les.u2) annotation (Line(points={{22,280},{32,280},{32,332},
          {36,332}}, color={0,0,127}));
  connect(notLes.y, truHol.u)
    annotation (Line(points={{98,340},{118,340}}, color={255,0,255}));
  connect(lat1.u, notLes.y) annotation (Line(points={{58,270},{46,270},{46,326},
          {108,326},{108,340},{98,340}}, color={255,0,255}));
  connect(les.y, notLes.u)
    annotation (Line(points={{60,340},{74,340}}, color={255,0,255}));
  connect(samTZonCooSet.y, sub2.u2) annotation (Line(points={{-138,440},{-128,440},
          {-128,426},{-150,426},{-150,194},{-102,194}}, color={0,0,127}));
  connect(TZon, sub2.u1) annotation (Line(points={{-200,170},{-140,170},{-140,206},
          {-102,206}}, color={0,0,127}));
  connect(TZon, sub3.u1) annotation (Line(points={{-200,170},{-140,170},{-140,146},
          {-102,146}}, color={0,0,127}));
  connect(samTZonCooSet.y, sub3.u2) annotation (Line(points={{-138,440},{-128,440},
          {-128,426},{-150,426},{-150,134},{-102,134}}, color={0,0,127}));
  connect(samTZonCooSet.y, sub1.u1)
    annotation (Line(points={{-138,440},{-22,440}}, color={0,0,127}));
  connect(uniDel.y, sub1.u2) annotation (Line(points={{-58,460},{-50,460},{-50,428},
          {-22,428}}, color={0,0,127}));

annotation (
  defaultComponentName="sysReqRehBox",
  Diagram(coordinateSystem(preserveAspectRatio=
            false, extent={{-180,-460},{180,480}}),
      graphics={
        Rectangle(
          extent={{-158,478},{158,262}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-158,238},{158,62}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-158,38},{158,-178}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-158,-202},{158,-378}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-158,-402},{158,-458}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Text(
          extent={{18,480},{140,456}},
          textColor={0,0,255},
          horizontalAlignment=TextAlignment.Left,
          textString="Time-based suppression"),
        Text(
          extent={{-150,82},{-28,58}},
          textColor={0,0,255},
          horizontalAlignment=TextAlignment.Left,
          textString="Cooling SAT reset requests"),
        Text(
          extent={{-152,-156},{-8,-184}},
          textColor={0,0,255},
          horizontalAlignment=TextAlignment.Left,
          textString="Static pressure reset requests"),
        Text(
          extent={{-152,-360},{-26,-380}},
          textColor={0,0,255},
          horizontalAlignment=TextAlignment.Left,
          textString="Hot water reset requests"),
        Text(
          extent={{-150,-440},{-12,-462}},
          textColor={0,0,255},
          horizontalAlignment=TextAlignment.Left,
          textString="Boiler plant reset requests")}),
     Icon(graphics={
        Text(
          extent={{-100,140},{100,100}},
          textColor={0,0,255},
          textString="%name"),
        Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-98,90},{-62,76}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TZonCooSet"),
        Text(
          extent={{-100,66},{-72,56}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TZon"),
        Text(
          extent={{-100,46},{-72,36}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="uCoo"),
        Text(
          extent={{-98,30},{-52,14}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VDisSet_flow"),
        Text(
          extent={{-98,6},{-64,-4}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VDis_flow"),
        Text(
          extent={{-98,-14},{-70,-24}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="uDam"),
        Text(
          extent={{-98,-32},{-52,-48}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          visible = (have_heaWatCoi or have_heaPla),
          textString="TDisHeaSet"),
        Text(
          extent={{-98,-56},{-64,-66}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          visible = (have_heaWatCoi or have_heaPla),
          textString="TDis"),
        Text(
          extent={{-98,-76},{-64,-86}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          visible = (have_heaWatCoi or have_heaPla),
          textString="uHeaVal"),
        Text(
          extent={{42,82},{98,62}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          horizontalAlignment=TextAlignment.Right,
          textString="yZonTemResReq"),
        Text(
          extent={{42,32},{98,12}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          horizontalAlignment=TextAlignment.Right,
          textString="yZonPreResReq"),
        Text(
          extent={{42,-28},{98,-48}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          horizontalAlignment=TextAlignment.Right,
          visible = have_heaWatCoi,
          textString="yHeaValResReq"),
        Text(
          extent={{58,-84},{98,-100}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          horizontalAlignment=TextAlignment.Right,
          visible = (have_heaWatCoi and have_heaPla),
          textString="yHeaPlaReq")}),
  Documentation(info="<html>
<p>
This sequence outputs the system reset requests, i.e.,
</p>
<ul>
<li>
the cooling supply air temperature
reset requests <code>yZonTemResReq</code>,
</li>
<li>
the static pressure reset requests
<code>yZonPreResReq</code>,
</li>
<li>
the hot water reset requests <code>yHeaValResReq</code>, and
</li>
<li>
the boiler plant reset requests <code>yHeaPlaReq</code>.
</li>
</ul>
<p>
The calculations are according to ASHRAE
Guideline 36 (G36), PART 5.E.9, in the steps shown below.
</p>
<h4>a. Cooling SAT reset requests <code>yZonTemResReq</code></h4>
<ol>
<li>
If the zone temperature <code>TZon</code> exceeds the zone cooling setpoint
<code>TZonCooSet</code> by 2.8 &deg;C (5 &deg;F)) for 2 minutes and after suppression
period due to setpoint change per G36 Part 5.A.20, send 3 requests
(<code>yZonTemResReq=3</code>).
</li>
<li>
Else if the zone temperature <code>TZon</code> exceeds the zone cooling setpoint
<code>TZonCooSet</code> by 1.7 &deg;C (3 &deg;F) for 2 minutes and after suppression
period due to setpoint change per G36 Part 5.A.20, send 2 requests
(<code>yZonTemResReq=3</code>).
</li>
<li>
Else if the cooling loop <code>uCoo</code> is greater than 95%, send 1 request
(<code>yZonTemResReq=1</code>) until <code>uCoo</code> is less than 85%.
</li>
<li>
Else if <code>uCoo</code> is less than 95%, send 0 request (<code>yZonTemResReq=0</code>).
</li>
</ol>
<h4>b. Static pressure reset requests <code>yZonPreResReq</code></h4>
<ol>
<li>
If the measured airflow <code>VDis_flow</code> is less than 50% of setpoint
<code>VDisSet_flow</code> while it is greater than zero for 1 minute, send 3 requests
(<code>yZonPreResReq=3</code>).
</li>
<li>
Else if the measured airflow <code>VDis_flow</code> is less than 70% of setpoint
<code>VDisSet_flow</code> while it is greater than zero for 1 minute, send 2 requests
(<code>yZonPreResReq=2</code>).
</li>
<li>
Else if the damper position <code>uDam</code> is greater than 95%, send 1 request
(<code>yZonPreResReq=1</code>) until <code>uDam</code> is less than 85%.
</li>
<li>
Else if <code>uDam</code> is less than 95%, send 0 request (<code>yZonPreResReq=0</code>).
</li>
</ol>
<h4>c. If there is a hot water coil (<code>have_heaWatCoi=true</code>),
hot water reset requests <code>yHeaValResReq</code></h4>
<ol>
<li>
If the discharge air temperature <code>TDis</code> is 17 &deg;C (30 &deg;F)
less than the setpoint <code>TDisHeaSet</code> for 5 minutes, send 3 requests
(<code>yHeaValResReq=3</code>).
</li>
<li>
Else if the discharge air temperature <code>TDis</code> is 8.3 &deg;C (15 &deg;F)
less than the setpoint <code>TDisHeaSet</code> for 5 minutes, send 2 requests
(<code>yHeaValResReq=2</code>).
</li>
<li>
Else if the hot water valve position <code>uHeaVal</code> is greater than 95%, send 1 request
(<code>yHeaValResReq=1</code>) until <code>uHeaVal</code> is less than 85%.
</li>
<li>
Else if <code>uHeaVal</code> is less than 95%, send 0 request (<code>yHeaValResReq=0</code>).
</li>
</ol>
<h4>d. If there is hot water coil (<code>have_heaWatCoi=true</code>) and a boiler plant
(<code>have_boiPla=true</code>), send the boiler plant that serves the zone a boiler
plant requests <code>yHeaPlaReq</code> as follows:</h4>
<ol>
<li>
If the hot water valve position <code>uHeaVal</code> is greater than 95%, send 1 request
(<code>yHeaPlaReq=1</code>) until <code>uHeaVal</code> is less than 10%.
</li>
<li>
Else if <code>uHeaVal</code> is less than 95%, send 0 request (<code>yHeaPlaReq=0</code>).
</li>
</ol>
<h4>Implementation</h4>
<p>
Some input signals are time sampled, because the output that is generated
from these inputs are used in the trim and respond logic, which
is also time sampled. However, signals that use a delay are not
sampled, as sampling were to change the dynamic response.
</p>
</html>", revisions="<html>
<ul>
<li>
March 1, 2023, by Michael Wetter:<br/>
Changed constants from <code>0</code> to <code>0.0</code> and <code>1</code> to <code>1.0</code>.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/pull/3267#issuecomment-1450587671\">#3267</a>.
</li>
<li>
September 13, 2017, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end SystemRequests;
