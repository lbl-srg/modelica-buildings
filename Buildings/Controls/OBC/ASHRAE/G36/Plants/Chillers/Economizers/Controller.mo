within Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Economizers;
block Controller "Waterside economizer (WSE) enable/disable status"

  parameter Boolean have_byPasValCon=true
    "True: chilled water flow through economizer is controlled using heat exchanger bypass valve";

  parameter Boolean have_priOnl=true
    "True: the primary-only plant; False: the primary-secondary plant";

  parameter Boolean have_parChi=true
    "True: the plant has parallel chillers";

  parameter Integer nChi=2
    "Number of chillers in the plant";

  parameter Integer nSta = 3
    "Number of chiller stages";

  parameter Real holdPeriod(
    final unit="s",
    final quantity="Time")=1200
    "WSE minimum on or off time"
  annotation(Dialog(group="Enable parameters"));

  parameter Real delDis(
    final unit="s",
    final quantity="Time")=120
  "Delay disable time period"
  annotation(Dialog(group="Enable parameters"));

  parameter Real TOffsetEna(
    final unit="K",
    final quantity="TemperatureDifference")=2
    "Temperature offset between the chilled water return upstream of WSE and the predicted WSE output"
  annotation(Dialog(group="Enable parameters"));

  parameter Real TOffsetDis(
    final unit="K",
    final quantity="TemperatureDifference")=1
    "Temperature offset between the chilled water return upstream and downstream WSE"
  annotation(Dialog(group="Enable parameters"));

  parameter Real heaExcAppDes(
    final unit="K",
    final quantity="TemperatureDifference")=2
    "Design heat exchanger approach"
    annotation(Dialog(group="Design parameters"));

  parameter Real cooTowAppDes(
    final unit="K",
    final quantity="TemperatureDifference")=2
    "Design cooling tower approach"
    annotation(Dialog(group="Design parameters"));

  parameter Real TOutWetDes(
    final unit="K",
    final quantity="ThermodynamicTemperature",
    displayUnit="degC")=288.15
    "Design outdoor air wet bulb temperature"
    annotation(Dialog(group="Design parameters"));

  parameter Real VHeaExcDes_flow(
    final unit="m3/s",
    final quantity="VolumeFlowRate",
    displayUnit="m3/s")=0.015
      "Design heat exchanger chilled water volume flow rate"
    annotation(Dialog(group="Design parameters"));

  parameter Real dpDes(
    final unit="Pa",
    final quantity="PresureDifference")=6000
    "Design pressure difference across the chilled water side economizer"
    annotation (Dialog(group="Valve or pump control", enable=have_byPasValCon));
  parameter CDL.Types.SimpleController valCon=Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of controller"
    annotation (Dialog(group="Valve or pump control", enable=have_byPasValCon));
  parameter Real k=0.1
    "Gain of controller"
    annotation (Dialog(group="Valve or pump control", enable=have_byPasValCon));
  parameter Real Ti(unit="s")=0.5
    "Time constant of integrator block"
    annotation (Dialog(group="Valve or pump control",
                       enable=(valCon == Buildings.Controls.OBC.CDL.Types.SimpleController.PI
                               or valCon == Buildings.Controls.OBC.CDL.Types.SimpleController.PID)
                               and have_byPasValCon));
  parameter Real Td(unit="s")=0.1
    "Time constant of derivative block"
    annotation (Dialog(group="Valve or pump control",
                       enable=(valCon == Buildings.Controls.OBC.CDL.Types.SimpleController.PD
                               or valCon == Buildings.Controls.OBC.CDL.Types.SimpleController.PID)
                               and have_byPasValCon));
  parameter Real minSpe(
    final min=0,
    final max=1)=0.1
    "Minimum pump speed"
    annotation (Dialog(group="Valve or pump control", enable=not have_byPasValCon));
  parameter Real desSpe(
    final min=0,
    final max=1)=1
    "Design pump speed"
    annotation (Dialog(group="Valve or pump control", enable=not have_byPasValCon));

  parameter Real step(
    final unit="1")=0.02
    "Incremental step used to reduce or increase the water-side economizer tuning parameter"
    annotation (Evaluate=true, Dialog(tab="Advanced", group="Tuning"));

  parameter Real wseOnTimDec(
    final unit="s",
    final quantity="Time",
    displayUnit="h") = 3600
    "Economizer enable time needed to allow decrease of the tuning parameter"
    annotation (Evaluate=true,Dialog(tab="Advanced", group="Tuning"));

  parameter Real wseOnTimInc(
    final unit="s",
    final quantity="Time",
    displayUnit="h") = 1800
    "Economizer enable time needed to allow increase of the tuning parameter"
    annotation (Evaluate=true,Dialog(tab="Advanced", group="Tuning"));

  parameter Real hysDt(
    final unit="K",
    final quantity="TemperatureDifference")=1
     "Deadband temperature used in hysteresis block"
    annotation (Evaluate=true, Dialog(tab="Advanced", group="Hysteresis"));

  parameter Real hysVal(
    final unit="1")=0.05
    "Hysteresis for checking valve position"
    annotation (Evaluate=true, Dialog(tab="Advanced", group="Hysteresis"));

  parameter Real dtHol(
    final min=0,
    final unit="s")=900
    "Minimum hold time during stage change"
    annotation (Dialog(tab="Advanced", enable=not have_byPasValCon));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TOutWet(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Outdoor air wet bulb temperature"
    annotation (Placement(transformation(extent={{-220,210},{-180,250}}),
        iconTransformation(extent={{-140,110},{-100,150}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TChiWatRet(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Chilled water return temperature upstream of the WSE"
    annotation (Placement(transformation(extent={{-220,180},{-180,220}}),
        iconTransformation(extent={{-140,90},{-100,130}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TChiWatRetDow(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Chilled water return temperature downstream of the WSE"
    annotation (Placement(transformation(extent={{-220,150},{-180,190}}),
        iconTransformation(extent={{-140,70},{-100,110}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uTowFanSpeMax(
    final min=0,
    final max=1,
    final unit="1")
    "Maximum cooling tower fan speed"
    annotation (Placement(transformation(extent={{-220,60},{-180,100}}),
    iconTransformation(extent={{-140,30},{-100,70}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput VChiWat_flow(
    final quantity="VolumeFlowRate",
    final unit="m3/s") "Measured chilled water volume flow rate"
    annotation (Placement(transformation(extent={{-220,120},{-180,160}}),
    iconTransformation(extent={{-140,50},{-100,90}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uPla "Plant enable signal"
    annotation (Placement(transformation(extent={{-220,20},{-180,60}}),
        iconTransformation(extent={{-140,10},{-100,50}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uIni(
    final min=0,
    final max=nSta) "Initial chiller stage (at plant enable)"
    annotation (Placement(transformation(extent={{-220,-10},{-180,30}}),
        iconTransformation(extent={{-140,-10},{-100,30}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uChiSta(
    final min=0,
    final max=nSta)
    "Current chiller stage"
    annotation (Placement(transformation(extent={{-220,-68},{-180,-28}}),
        iconTransformation(extent={{-140,-30},{-100,10}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput dpChiWat(
    final unit="Pa",
    final quantity="PressureDifference") if have_byPasValCon
    "Differential static pressure across economizer in the chilled water side"
    annotation (Placement(transformation(extent={{-220,-100},{-180,-60}}),
        iconTransformation(extent={{-140,-50},{-100,-10}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uPum
    if not have_byPasValCon "True: heat exchanger pump is proven on"
    annotation (Placement(transformation(extent={{-220,-130},{-180,-90}}),
        iconTransformation(extent={{-140,-70},{-100,-30}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uStaPro
    if not have_byPasValCon
    "True: in staging process"
    annotation (Placement(transformation(extent={{-220,-150},{-180,-110}}),
        iconTransformation(extent={{-140,-90},{-100,-50}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TEntHex(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature") if not have_byPasValCon
    "Chilled water temperature entering heat exchanger"
    annotation (Placement(transformation(extent={{-220,-170},{-180,-130}}),
        iconTransformation(extent={{-140,-110},{-100,-70}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1ChiIsoVal[nChi] if have_priOnl and have_parChi
    "Chiller isolation valve commanded setpoint: true- commanded on"
    annotation (Placement(transformation(extent={{-220,-200},{-180,-160}}),
        iconTransformation(extent={{-140,-130},{-100,-90}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uChiIsoVal[nChi](
    final unit=fill("1", nChi),
    final min=fill(0, nChi),
    final max=fill(1, nChi))
                 if have_priOnl and have_parChi
    "Measured chiller isolation valve position"
    annotation (Placement(transformation(extent={{-220,-240},{-180,-200}}),
        iconTransformation(extent={{-140,-150},{-100,-110}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TWsePre(
    final quantity="ThermodynamicTemperature",
    displayUnit="degC",
    final unit="K")
    "Predicted waterside economizer outlet temperature"
    annotation (Placement(transformation(extent={{180,210},{220,250}}),
      iconTransformation(extent={{100,70},{140,110}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yTunPar
    "Tuning parameter"
    annotation (Placement(transformation(extent={{180,80},{220,120}}),
      iconTransformation(extent={{100,40},{140,80}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y
    "WSE enable/disable status"
    annotation (Placement(transformation(extent={{180,20},{220,60}}),
    iconTransformation(extent={{100,10},{140,50}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yConWatIsoVal
    "Economizer condenser water isolation valve position"
    annotation (Placement(transformation(extent={{180,-50},{220,-10}}),
        iconTransformation(extent={{100,-20},{140,20}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yRetVal(
    final min=0,
    final max=1,
    final unit="1") if have_byPasValCon
    "WSE in-line CHW return line valve position"
    annotation (Placement(transformation(extent={{180,-96},{220,-56}}),
      iconTransformation(extent={{100,-52},{140,-12}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yPumOn
    if not have_byPasValCon "Heat exchanger pump command on"
    annotation (Placement(transformation(extent={{180,-130},{220,-90}}),
        iconTransformation(extent={{100,-80},{140,-40}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yPumSpe(
    final min=0,
    final max=1,
    final unit="1") if not have_byPasValCon
    "Heat exchanger pump speed setpoint"
    annotation (Placement(transformation(extent={{180,-160},{220,-120}}),
        iconTransformation(extent={{100,-110},{140,-70}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1ChiWatBypVal
    if have_priOnl and have_parChi
    "Ecnomizer-only chiller water bypass valve commanded status"
    annotation (Placement(transformation(extent={{180,-200},{220,-160}}),
        iconTransformation(extent={{100,-130},{140,-90}})));

  Buildings.Controls.OBC.CDL.Reals.LessThreshold enaTChiWatRet(
    final t=delDis)
    "Enable condition based on chilled water return temperature upstream and downstream WSE"
    annotation (Placement(transformation(extent={{60,160},{80,180}})));

  Buildings.Controls.OBC.CDL.Reals.Hysteresis enaTWet(
    final uLow = TOffsetEna - hysDt/2,
    final uHigh = TOffsetEna + hysDt/2)
    "Enable condition based on the outdoor wet bulb temperature"
    annotation (Placement(transformation(extent={{20,200},{40,220}})));

protected
  Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Economizers.Subsequences.Tuning wseTun(
    final step=step,
    final wseOnTimDec=wseOnTimDec,
    final wseOnTimInc=wseOnTimInc)
    "Tuning parameter for the WSE outlet temperature calculation"
    annotation (Placement(transformation(extent={{-140,80},{-120,100}})));

  Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Economizers.Subsequences.PredictedOutletTemperature wseTOut(
    final heaExcAppDes=heaExcAppDes,
    final cooTowAppDes=cooTowAppDes,
    final TOutWetDes=TOutWetDes,
    final VHeaExcDes_flow=VHeaExcDes_flow)
    "Calculates the predicted WSE outlet temperature"
    annotation (Placement(transformation(extent={{-100,194},{-80,214}})));

  Buildings.Controls.OBC.CDL.Reals.Subtract sub2 "Subtract"
    annotation (Placement(transformation(extent={{-20,200},{0,220}})));

  Buildings.Controls.OBC.CDL.Reals.Subtract sub1 "Subtract"
    annotation (Placement(transformation(extent={{-100,160},{-80,180}})));

  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold truFalHol(
    final trueHoldDuration=holdPeriod,
    final falseHoldDuration=holdPeriod)
    "Keeps a signal constant for a given time period"
    annotation (Placement(transformation(extent={{140,200},{160,220}})));

  Buildings.Controls.OBC.CDL.Logical.And and2 "And"
    annotation (Placement(transformation(extent={{100,200},{120,220}})));

  Buildings.Controls.OBC.CDL.Reals.Hysteresis hys(
    final uLow = TOffsetDis - hysDt/2,
    final uHigh = TOffsetDis + hysDt/2)
    "Hysteresis comparing CHW temperatures upstream and downstream WSE"
    annotation (Placement(transformation(extent={{-60,160},{-40,180}})));

  Buildings.Controls.OBC.CDL.Logical.Timer timer
    "Measures the disable condition satisfied time "
    annotation (Placement(transformation(extent={{20,160},{40,180}})));

  Buildings.Controls.OBC.CDL.Logical.FallingEdge falEdg
    "Falling edge to indicate the moment of disable"
    annotation (Placement(transformation(extent={{-100,120},{-80,140}})));

  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold truHol(
    final trueHoldDuration=holdPeriod,
    final falseHoldDuration=0)
    "Holds a true signal for a period of time right after disable"
    annotation (Placement(transformation(extent={{-60,120},{-40,140}})));

  Buildings.Controls.OBC.CDL.Logical.Nor nor
    "Not either of the inputs"
    annotation (Placement(transformation(extent={{-20,160},{0,180}})));

  Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Economizers.Subsequences.BypassValve wseVal(
    final dpDes=dpDes,
    final controllerType=valCon,
    final k=k,
    final Ti=Ti,
    final Td=Td) if have_byPasValCon
    "Chilled water flow through economizer is controlled using bypass valve"
    annotation (Placement(transformation(extent={{120,-80},{140,-60}})));

  Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Economizers.Subsequences.HeatExchangerPump wsePum(
    final minSpe=minSpe,
    final desSpe=desSpe,
    final dtHol=dtHol)
    if not have_byPasValCon
    "Pump control for economizer when the chilled water flow is controlled by a variable speed heat exchanger pump"
    annotation (Placement(transformation(extent={{120,-120},{140,-100}})));

  Buildings.Controls.OBC.CDL.Logical.And and1
    "Plant enabled with 0 initial stage, it means enabled with economizer-only operation"
    annotation (Placement(transformation(extent={{-60,30},{-40,50}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt(
    final k=0) "Stage 0"
    annotation (Placement(transformation(extent={{-140,-30},{-120,-10}})));

  Buildings.Controls.OBC.CDL.Integers.Equal intEqu
    "Check if initial stage is 0"
    annotation (Placement(transformation(extent={{-100,0},{-80,20}})));

  Buildings.Controls.OBC.CDL.Logical.Latch lat
    "Plant enabled with economizer-only operation"
    annotation (Placement(transformation(extent={{20,30},{40,50}})));

  Buildings.Controls.OBC.CDL.Integers.Equal intEqu1
    "Check if current stage is initial stage"
    annotation (Placement(transformation(extent={{-100,-50},{-80,-30}})));

  Buildings.Controls.OBC.CDL.Logical.Not not1
    "Not in initial stage"
    annotation (Placement(transformation(extent={{-60,-50},{-40,-30}})));

  Buildings.Controls.OBC.CDL.Logical.Or enaEco "Economizer enabled"
    annotation (Placement(transformation(extent={{120,30},{140,50}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre2
    "Break algebric loop"
    annotation (Placement(transformation(extent={{60,30},{80,50}})));

  Buildings.Controls.OBC.CDL.Logical.And enaWSE
    "Enable economizer if the plant is enabled"
    annotation (Placement(transformation(extent={{20,70},{40,90}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre1
    "Break algebric loop"
    annotation (Placement(transformation(extent={{60,70},{80,90}})));

  Buildings.Controls.OBC.CDL.Logical.MultiOr anyComOpe(
    final nin=nChi) if have_priOnl and have_parChi
    "Check if there is any commanded open valve"
    annotation (Placement(transformation(extent={{-140,-190},{-120,-170}})));

  Buildings.Controls.OBC.CDL.Logical.Not notOpe if have_priOnl and have_parChi
    "All valves are commanded close"
    annotation (Placement(transformation(extent={{-100,-190},{-80,-170}})));

  Buildings.Controls.OBC.CDL.Logical.Latch valCom if have_priOnl and have_parChi
    "Economizer-only chiller water bypass valve commanded setpoint"
    annotation (Placement(transformation(extent={{120,-190},{140,-170}})));

  Buildings.Controls.OBC.CDL.Logical.And opeVal if have_priOnl and have_parChi
    "Check if the economizer-only bypass valve should open"
    annotation (Placement(transformation(extent={{-40,-190},{-20,-170}})));

  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold valOpe[nChi](
    final t=fill(0.25, nChi),
    final h=fill(hysVal,nChi))
    if have_priOnl and have_parChi
    "Check if any valve has been open greater than threshold"
    annotation (Placement(transformation(extent={{-140,-230},{-120,-210}})));

  Buildings.Controls.OBC.CDL.Logical.MultiOr anyOpeVal(
    final nin=nChi) if have_priOnl and have_parChi
    "Check if any commanded valve has been open greater than the threshold"
    annotation (Placement(transformation(extent={{-100,-230},{-80,-210}})));

  Buildings.Controls.OBC.CDL.Logical.And cloVal if have_priOnl and have_parChi
    "Check if the economizer-only bypass valve should close"
    annotation (Placement(transformation(extent={{40,-210},{60,-190}})));

equation
  connect(uTowFanSpeMax, wseTun.uTowFanSpeMax) annotation (Line(points={{-200,80},
          {-150,80},{-150,85},{-142,85}}, color={0,0,127}));
  connect(TOutWet, wseTOut.TOutWet)
    annotation (Line(points={{-200,230},{-120,230},{-120,212},{-102,212}},
    color={0,0,127}));
  connect(VChiWat_flow, wseTOut.VChiWat_flow)
    annotation (Line(points={{-200,140},{-120,140},{-120,204},{-102,204}},
    color={0,0,127}));
  connect(TChiWatRet, sub1.u1)
    annotation (Line(points={{-200,200},{-170,200},{-170,176},{-102,176}},
          color={0,0,127}));
  connect(enaTWet.y, and2.u1)
    annotation (Line(points={{42,210},{98,210}}, color={255,0,255}));
  connect(truFalHol.u, and2.y)
    annotation (Line(points={{138,210},{122,210}},
    color={255,0,255}));
  connect(timer.y, enaTChiWatRet.u)
    annotation (Line(points={{42,170},{58,170}}, color={0,0,127}));
  connect(TChiWatRetDow, sub1.u2)
    annotation (Line(points={{-200,170},{-160,170},{-160,164},{-102,164}},
    color={0,0,127}));
  connect(sub1.y, hys.u)
    annotation (Line(points={{-78,170},{-62,170}},color={0,0,127}));
  connect(enaTChiWatRet.y, and2.u2) annotation (Line(points={{82,170},{90,170},{
          90,202},{98,202}}, color={255,0,255}));
  connect(wseTun.y, wseTOut.uTunPar) annotation (Line(points={{-118,90},{-110,90},
          {-110,196},{-102,196}}, color={0,0,127}));
  connect(wseTOut.y, sub2.u2) annotation (Line(points={{-78,204},{-22,204}},
          color={0,0,127}));
  connect(TChiWatRet, sub2.u1) annotation (Line(points={{-200,200},{-170,200},{-170,
          224},{-60,224},{-60,216},{-22,216}}, color={0,0,127}));
  connect(sub2.y, enaTWet.u)
    annotation (Line(points={{2,210},{18,210}}, color={0,0,127}));
  connect(wseTun.y, yTunPar)
    annotation (Line(points={{-118,90},{-110,90},{-110,100},{200,100}}, color={0,0,127}));
  connect(nor.y, timer.u)
    annotation (Line(points={{2,170},{18,170}}, color={255,0,255}));
  connect(hys.y, nor.u1)
    annotation (Line(points={{-38,170},{-22,170}}, color={255,0,255}));
  connect(truHol.y, nor.u2) annotation (Line(points={{-38,130},{-30,130},{-30,162},
          {-22,162}},color={255,0,255}));
  connect(falEdg.y, truHol.u)
    annotation (Line(points={{-78,130},{-62,130}}, color={255,0,255}));
  connect(wseTOut.y, TWsePre) annotation (Line(points={{-78,204},{-40,204},{-40,
          230},{200,230}}, color={0,0,127}));
  connect(uIni, intEqu.u1)
    annotation (Line(points={{-200,10},{-102,10}},   color={255,127,0}));
  connect(conInt.y, intEqu.u2) annotation (Line(points={{-118,-20},{-110,-20},{-110,
          2},{-102,2}},     color={255,127,0}));
  connect(intEqu.y, and1.u2) annotation (Line(points={{-78,10},{-70,10},{-70,32},
          {-62,32}},  color={255,0,255}));
  connect(uIni, intEqu1.u1) annotation (Line(points={{-200,10},{-150,10},{-150,-40},
          {-102,-40}}, color={255,127,0}));
  connect(uChiSta, intEqu1.u2)
    annotation (Line(points={{-200,-48},{-102,-48}}, color={255,127,0}));
  connect(intEqu1.y, not1.u)
    annotation (Line(points={{-78,-40},{-62,-40}}, color={255,0,255}));
  connect(enaEco.y, y)
    annotation (Line(points={{142,40},{200,40}},   color={255,0,255}));
  connect(dpChiWat, wseVal.dpChiWat) annotation (Line(points={{-200,-80},{-42,-80},
          {-42,-76},{118,-76}},   color={0,0,127}));
  connect(uPum, wsePum.uPum) annotation (Line(points={{-200,-110},{-42,-110},{-42,
          -108},{118,-108}}, color={255,0,255}));
  connect(TEntHex, wsePum.TEntHex) annotation (Line(points={{-200,-150},{100,-150},
          {100,-118},{118,-118}}, color={0,0,127}));
  connect(wseVal.yRetVal, yRetVal)
    annotation (Line(points={{142,-76},{200,-76}}, color={0,0,127}));
  connect(wsePum.yPumOn, yPumOn)
    annotation (Line(points={{142,-110},{200,-110}}, color={255,0,255}));
  connect(wsePum.yPumSpe, yPumSpe) annotation (Line(points={{142,-116},{160,-116},
          {160,-140},{200,-140}}, color={0,0,127}));
  connect(TChiWatRet, wsePum.TEntWSE) annotation (Line(points={{-200,200},{-170,
          200},{-170,-114},{118,-114}}, color={0,0,127}));
  connect(uPla, wseVal.uPla) annotation (Line(points={{-200,40},{-154,40},{-154,
          -64},{118,-64}}, color={255,0,255}));
  connect(uPla, wsePum.uPla) annotation (Line(points={{-200,40},{-154,40},{-154,
          -102},{118,-102}}, color={255,0,255}));
  connect(uPla, and1.u1)
    annotation (Line(points={{-200,40},{-62,40}}, color={255,0,255}));
  connect(lat.y, pre2.u)
    annotation (Line(points={{42,40},{58,40}},   color={255,0,255}));
  connect(enaEco.y, wseVal.uWSE) annotation (Line(points={{142,40},{150,40},{150,
          20},{110,20},{110,-70},{118,-70}},     color={255,0,255}));
  connect(enaEco.y, wsePum.uWSE) annotation (Line(points={{142,40},{150,40},{150,
          20},{110,20},{110,-105},{118,-105}},   color={255,0,255}));
  connect(enaEco.y, falEdg.u) annotation (Line(points={{142,40},{160,40},{160,110},
          {-120,110},{-120,130},{-102,130}},color={255,0,255}));
  connect(enaEco.y, wseTun.uWseSta) annotation (Line(points={{142,40},{150,40},{
          150,60},{-160,60},{-160,95},{-142,95}},color={255,0,255}));
  connect(pre2.y, enaEco.u2) annotation (Line(points={{82,40},{100,40},{100,32},
          {118,32}},       color={255,0,255}));
  connect(not1.y, lat.clr) annotation (Line(points={{-38,-40},{0,-40},{0,34},{18,
          34}}, color={255,0,255}));
  connect(and1.y, lat.u)
    annotation (Line(points={{-38,40},{18,40}},   color={255,0,255}));
  connect(uPla, enaWSE.u2) annotation (Line(points={{-200,40},{-154,40},{-154,72},
          {18,72}},     color={255,0,255}));
  connect(enaWSE.y, pre1.u)
    annotation (Line(points={{42,80},{58,80}}, color={255,0,255}));
  connect(pre1.y, enaEco.u1) annotation (Line(points={{82,80},{110,80},{110,40},
          {118,40}},  color={255,0,255}));
  connect(truFalHol.y, enaWSE.u1) annotation (Line(points={{162,210},{168,210},{
          168,150},{0,150},{0,80},{18,80}}, color={255,0,255}));
  connect(u1ChiIsoVal, anyComOpe.u)
    annotation (Line(points={{-200,-180},{-142,-180}}, color={255,0,255}));
  connect(anyComOpe.y, notOpe.u)
    annotation (Line(points={{-118,-180},{-102,-180}}, color={255,0,255}));
  connect(notOpe.y, opeVal.u1)
    annotation (Line(points={{-78,-180},{-42,-180}}, color={255,0,255}));
  connect(opeVal.y, valCom.u)
    annotation (Line(points={{-18,-180},{118,-180}}, color={255,0,255}));
  connect(valCom.y, y1ChiWatBypVal)
    annotation (Line(points={{142,-180},{200,-180}}, color={255,0,255}));
  connect(enaEco.y, opeVal.u2) annotation (Line(points={{142,40},{150,40},{150,20},
          {110,20},{110,-160},{-60,-160},{-60,-188},{-42,-188}}, color={255,0,255}));
  connect(uChiIsoVal, valOpe.u)
    annotation (Line(points={{-200,-220},{-142,-220}}, color={0,0,127}));
  connect(anyComOpe.y, cloVal.u1) annotation (Line(points={{-118,-180},{-110,-180},
          {-110,-200},{38,-200}}, color={255,0,255}));
  connect(anyOpeVal.y, cloVal.u2) annotation (Line(points={{-78,-220},{20,-220},
          {20,-208},{38,-208}}, color={255,0,255}));
  connect(valOpe.y, anyOpeVal.u)
    annotation (Line(points={{-118,-220},{-102,-220}}, color={255,0,255}));
  connect(cloVal.y, valCom.clr) annotation (Line(points={{62,-200},{100,-200},{100,
          -186},{118,-186}}, color={255,0,255}));
  connect(uStaPro, wsePum.uStaPro) annotation (Line(points={{-200,-130},{90,-130},
          {90,-111},{118,-111}}, color={255,0,255}));
  connect(wseVal.yConWatIsoVal, yConWatIsoVal) annotation (Line(points={{142,-64},
          {160,-64},{160,-30},{200,-30}}, color={255,0,255}));
  connect(wsePum.yConWatIsoVal, yConWatIsoVal) annotation (Line(points={{142,-104},
          {160,-104},{160,-30},{200,-30}}, color={255,0,255}));
  annotation (defaultComponentName = "wseSta",
        Icon(coordinateSystem(extent={{-100,-140},{100,140}}),
             graphics={
        Rectangle(
        extent={{-100,-140},{100,140}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-100,180},{100,140}},
          textColor={0,0,255},
          textString="%name"),
        Rectangle(
          extent={{-82,64},{80,-56}},
          lineColor={28,108,200},
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          borderPattern=BorderPattern.Raised),
        Polygon(
          points={{-82,64},{-16,8},{-82,-56},{-82,64}},
          lineColor={175,175,175},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{6,60},{72,-52}},
          lineColor={28,108,200},
          lineThickness=0.5),
        Line(
          points={{6,-52},{72,60}},
          color={28,108,200},
          thickness=0.5)}),
        Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-180,-240},{180,240}}), graphics={
          Rectangle(
          extent={{-178,58},{58,-58}},
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None), Text(
          extent={{-92,-4},{52,-18}},
          textColor={0,0,127},
          textString="Plant enabled in water side economizer mode")}),
Documentation(info="<html>
<p>
Waterside economizer (WSE) control sequence per ASHRAE Guideline 36-2021, section 5.20.3.
</p>
<h4>Enable and disable WSE</h4>
<p>
The sequence controls the WSE status as follows:
</p>
<ul>
<li>
Enable WSE if it has been disabled for at least <code>holdPeriod</code> of time and the chilled water return
temperature (CHWRT) upstream of WSE, <code>TChiWatRet</code>, is greater than the WSE predicted heat
exchanger leaving water temperature (PHXLWT) increased in <code>TOffsetEna</code>.
</li>
<li>
Disable WSE if it has been enabled for at least <code>holdPeriod</code> of time and CHWRT downstream of
WSE, <code>TChiWatRetDow</code>, is greater than <code>TChiWatRet</code> decreased in <code>TOffsetDis</code>
for <code>delDis</code> period.
</li>
</ul>
<p>
The following state machine chart illustrates the transitions between WSE enabled and disabled states:
</p>
<p align=\"center\">
<img alt=\"Image of WSE enable-disable state machine chart\"
src=\"modelica://Buildings/Resources/Images/Controls/OBC/ASHRAE/G36/Plants/Chillers/Economizer/WaterSideEconomizerEnableDisableStateGraph.png\"/>
</p>
<p>
The WSE enabling sequence uses the following subsequences:
</p>
<ul>
<li>
Calculation of the PHXLWT at given conditions:
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Economizers.Subsequences.PredictedOutletTemperature\">
Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Economizers.Subsequences.PredictedOutletTemperature</a>.
</li>
<li>
Calculation of the tuning parameter used as an input to PHXLWT calculation:
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Economizers.Subsequences.Tuning\">
Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Economizers.Subsequences.Tuning</a>.
</li>
</ul>

<h4>Chilled water flow through the WSE</h4>
<ul>
<li>
If the flow through the WSE is controlled using a modulating heat exchanger bypass
valve (<code>have_byPasValCon=true</code>), the WSE in-line CHW return line valve
(<code>yRetVal</code>) is controlled by
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Economizers.Subsequences.BypassValve\">
Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Economizers.Subsequences.BypassValve</a>
</li>
<li>
If the flow through the WSE is controlled by a variable speed pump
(<code>have_byPasValCon=false</code>), the pump is controlled by
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Economizers.Subsequences.HeatExchangerPump\">
Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Economizers.Subsequences.HeatExchangerPump</a>
</li>
</ul>

<h4>Economizer-only chilled water bypass valve</h4>
<p>
Per section 5.20.3.11, when the economizer is enabled and all chiller isolation valves are
commanded closed, open the economizer-only chilled water bypass valve (<code>y1ChiWatBypVal=true</code>).
Close the bypass valve when any chiller isolation valve is commanded open and exceeds
25% open.
</p>
<p>
The economizer-only chilled water bypass valve is typically needed for primary-only
parallel plant.
</p>

</html>",
revisions="<html>
<ul>
<li>
January 19, 2021, by Milica Grahovac:<br/>
Added state chart illustration.
</li>
<li>
October 13, 2018, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>
</html>"));
end Controller;
