within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Economizers;
block Controller "Waterside economizer (WSE) enable/disable status"

  parameter Boolean have_byPasValCon=true
    "True: chilled water flow through economizer is controlled using heat exchanger bypass valve";

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

  parameter Real hysDt(
    final unit="K",
    final quantity="TemperatureDifference")=1
     "Deadband temperature used in hysteresis block"
    annotation (Evaluate=true, Dialog(tab="Advanced", group="Hysteresis"));

  parameter Real VHeaExcDes_flow(
    final unit="m3/s",
    final quantity="VolumeFlowRate",
    displayUnit="m3/s")=0.015
      "Design heat exchanger chilled water volume flow rate"
    annotation(Dialog(group="Design parameters"));

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
                       enable=(valCon == CDL.Types.SimpleController.PI or valCon == CDL.Types.SimpleController.PID)
                               and have_byPasValCon));
  parameter Real Td(unit="s")=0.1
    "Time constant of derivative block"
    annotation (Dialog(group="Valve or pump control",
                       enable=(valCon == CDL.Types.SimpleController.PD or valCon == CDL.Types.SimpleController.PID)
                               and have_byPasValCon));
  parameter Real minSpe(
    final min=0,
    final max=1)=0.1
    "Minimum pump speed"
    annotation (Dialog(group="Valve or pump control", enable=not have_byPasValCon));
  parameter Real desSpe(
    final min=0,
    final max=1)=0.9
    "Design pump speed"
    annotation (Dialog(group="Valve or pump control", enable=not have_byPasValCon));


  Buildings.Controls.OBC.CDL.Interfaces.RealInput TOutWet(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Outdoor air wet bulb temperature"
    annotation (Placement(transformation(extent={{-220,190},{-180,230}}),
        iconTransformation(extent={{-140,80},{-100,120}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TChiWatRet(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Chilled water return temperature upstream of the WSE"
    annotation (Placement(transformation(extent={{-220,150},{-180,190}}),
        iconTransformation(extent={{-140,60},{-100,100}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TChiWatRetDow(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Chilled water return temperature downstream of the WSE"
    annotation (Placement(transformation(extent={{-220,110},{-180,150}}),
        iconTransformation(extent={{-140,40},{-100,80}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uTowFanSpeMax(
    final min=0,
    final max=1,
    final unit="1")
    "Maximum cooling tower fan speed"
    annotation (Placement(transformation(extent={{-220,-10},{-180,30}}),
    iconTransformation(extent={{-140,0},{-100,40}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput VChiWat_flow(
    final quantity="VolumeFlowRate",
    final unit="m3/s")
    "Measured chilled water volume flow rate"
    annotation (Placement(transformation(extent={{-220,50},{-180,90}}),
    iconTransformation(extent={{-140,20},{-100,60}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uPla
    "Plant enable signal"
    annotation (Placement(transformation(extent={{-220,-40},{-180,0}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uIni(
    final min=0,
    final max=nSta) "Initial chiller stage (at plant enable)"
    annotation (Placement(transformation(extent={{-220,-70},{-180,-30}}),
        iconTransformation(extent={{-140,-40},{-100,0}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uChiSta(
    final min=0,
    final max=nSta)
    "Current chiller stage"
    annotation (Placement(transformation(extent={{-220,-128},{-180,-88}}),
        iconTransformation(extent={{-140,-60},{-100,-20}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput dpChiWat(
    final unit="Pa",
    final quantity="PressureDifference") if have_byPasValCon
    "Differential static pressure across economizer in the chilled water side"
    annotation (Placement(transformation(extent={{-220,-160},{-180,-120}}),
        iconTransformation(extent={{-140,-80},{-100,-40}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uPum
    if not have_byPasValCon "True: heat exchanger pump is proven on"
    annotation (Placement(transformation(extent={{-220,-200},{-180,-160}}),
        iconTransformation(extent={{-140,-100},{-100,-60}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TEntHex(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature") if not have_byPasValCon
    "Chilled water temperature entering heat exchanger"
    annotation (Placement(transformation(extent={{-220,-230},{-180,-190}}),
        iconTransformation(extent={{-140,-120},{-100,-80}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TWsePre(
    final quantity="ThermodynamicTemperature",
    displayUnit="degC",
    final unit="K")
    "Predicted waterside economizer outlet temperature"
    annotation (Placement(transformation(extent={{180,110},{220,150}}),
      iconTransformation(extent={{100,70},{140,110}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yTunPar
    "Tuning parameter"
    annotation (Placement(transformation(extent={{180,10},{220,50}}),
      iconTransformation(extent={{100,40},{140,80}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y
    "WSE enable/disable status"
    annotation (Placement(transformation(extent={{180,-40},{220,0}}),
    iconTransformation(extent={{100,10},{140,50}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yConWatIsoVal(
    final min=0,
    final max=1,
    final unit="1") "Economizer condensing water isolation valve position"
    annotation (Placement(transformation(extent={{180,-120},{220,-80}}),
        iconTransformation(extent={{100,-20},{140,20}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yRetVal(
    final min=0,
    final max=1,
    final unit="1") if have_byPasValCon
    "WSE in-line CHW return line valve position"
    annotation (Placement(transformation(extent={{180,-166},{220,-126}}),
      iconTransformation(extent={{100,-52},{140,-12}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yPumOn
    if not have_byPasValCon "Heat exchanger pump command on"
    annotation (Placement(transformation(extent={{180,-200},{220,-160}}),
        iconTransformation(extent={{100,-80},{140,-40}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yPumSpe(
    final min=0,
    final max=1,
    final unit="1") if not have_byPasValCon
    "Heat exchanger pump speed setpoint"
    annotation (Placement(transformation(extent={{180,-230},{220,-190}}),
        iconTransformation(extent={{100,-110},{140,-70}})));

  Buildings.Controls.OBC.CDL.Reals.LessThreshold enaTChiWatRet(
    final t=delDis)
    "Enable condition based on chilled water return temperature upstream and downstream WSE"
    annotation (Placement(transformation(extent={{60,90},{80,110}})));

  Buildings.Controls.OBC.CDL.Reals.Hysteresis enaTWet(
    final uLow = TOffsetEna - hysDt/2,
    final uHigh = TOffsetEna + hysDt/2)
    "Enable condition based on the outdoor wet bulb temperature"
    annotation (Placement(transformation(extent={{20,156},{40,176}})));

protected
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Economizers.Subsequences.Tuning wseTun(
    final step=step,
    final wseOnTimDec=wseOnTimDec,
    final wseOnTimInc=wseOnTimInc)
    "Tuning parameter for the WSE outlet temperature calculation"
    annotation (Placement(transformation(extent={{-140,20},{-120,40}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Economizers.Subsequences.PredictedOutletTemperature wseTOut(
    final heaExcAppDes=heaExcAppDes,
    final cooTowAppDes=cooTowAppDes,
    final TOutWetDes=TOutWetDes,
    final VHeaExcDes_flow=VHeaExcDes_flow)
    "Calculates the predicted WSE outlet temperature"
    annotation (Placement(transformation(extent={{-100,150},{-80,170}})));

  Buildings.Controls.OBC.CDL.Reals.Subtract sub2 "Subtract"
    annotation (Placement(transformation(extent={{-20,156},{0,176}})));

  Buildings.Controls.OBC.CDL.Reals.Subtract sub1 "Subtract"
    annotation (Placement(transformation(extent={{-100,90},{-80,110}})));

  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold truFalHol(
    final trueHoldDuration=holdPeriod,
    final falseHoldDuration=holdPeriod)
    "Keeps a signal constant for a given time period"
    annotation (Placement(transformation(extent={{140,156},{160,176}})));

  Buildings.Controls.OBC.CDL.Logical.And and2 "And"
    annotation (Placement(transformation(extent={{100,156},{120,176}})));

  Buildings.Controls.OBC.CDL.Reals.Hysteresis hys(
    final uLow = TOffsetDis - hysDt/2,
    final uHigh = TOffsetDis + hysDt/2)
    "Hysteresis comparing CHW temperatures upstream and downstream WSE"
    annotation (Placement(transformation(extent={{-60,90},{-40,110}})));

  Buildings.Controls.OBC.CDL.Logical.Timer timer
    "Measures the disable condition satisfied time "
    annotation (Placement(transformation(extent={{20,90},{40,110}})));

  Buildings.Controls.OBC.CDL.Logical.FallingEdge falEdg
    "Falling edge to indicate the moment of disable"
    annotation (Placement(transformation(extent={{-100,50},{-80,70}})));

  Buildings.Controls.OBC.CDL.Logical.TrueHoldWithReset truHol(
    final duration=holdPeriod)
    "Holds a true signal for a period of time right after disable"
    annotation (Placement(transformation(extent={{-60,50},{-40,70}})));

  Buildings.Controls.OBC.CDL.Logical.Nor nor
    "Not either of the inputs"
    annotation (Placement(transformation(extent={{-20,90},{0,110}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Economizers.Subsequences.BypassValve wseVal(
    final dpDes=dpDes,
    final controllerType=valCon,
    final k=k,
    final Ti=Ti,
    final Td=Td) if have_byPasValCon
    "Chilled water flow through economizer is controlled using bypass valve"
    annotation (Placement(transformation(extent={{120,-150},{140,-130}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Economizers.Subsequences.HeatExchangerPump wsePum(
    final minSpe=minSpe,
    final desSpe=desSpe)
    if not have_byPasValCon
    "Pump control for economizer when the chilled water flow is controlled by a variable speed heat exchanger pump"
    annotation (Placement(transformation(extent={{120,-190},{140,-170}})));

  Buildings.Controls.OBC.CDL.Logical.And and1
    "Plant enabled with 0 initial stage, it means enabled with economizer-only operation"
    annotation (Placement(transformation(extent={{-60,-30},{-40,-10}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt(
    final k=0) "Stage 0"
    annotation (Placement(transformation(extent={{-140,-90},{-120,-70}})));

  Buildings.Controls.OBC.CDL.Integers.Equal intEqu
    "Check if initial stage is 0"
    annotation (Placement(transformation(extent={{-100,-60},{-80,-40}})));

  Buildings.Controls.OBC.CDL.Logical.Latch lat
    "Plant enabled with economizer-only operation"
    annotation (Placement(transformation(extent={{20,-30},{40,-10}})));

  Buildings.Controls.OBC.CDL.Integers.Equal intEqu1
    "Check if current stage is initial stage"
    annotation (Placement(transformation(extent={{-100,-110},{-80,-90}})));

  Buildings.Controls.OBC.CDL.Logical.Not not1
    "Not in initial stage"
    annotation (Placement(transformation(extent={{-60,-110},{-40,-90}})));

  Buildings.Controls.OBC.CDL.Logical.Or enaEco "Economizer enabled"
    annotation (Placement(transformation(extent={{120,-30},{140,-10}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre2
    "Break algebric loop"
    annotation (Placement(transformation(extent={{60,-30},{80,-10}})));

equation
  connect(uTowFanSpeMax, wseTun.uTowFanSpeMax) annotation (Line(points={{-200,10},
          {-150,10},{-150,25},{-142,25}},     color={0,0,127}));
  connect(TOutWet, wseTOut.TOutWet)
    annotation (Line(points={{-200,210},{-120,210},{-120,168},{-102,168}},
    color={0,0,127}));
  connect(VChiWat_flow, wseTOut.VChiWat_flow)
    annotation (Line(points={{-200,70},{-120,70},{-120,160},{-102,160}},
    color={0,0,127}));
  connect(TChiWatRet, sub1.u1)
    annotation (Line(points={{-200,170},{-170,170},{-170,106},{-102,106}},
          color={0,0,127}));
  connect(enaTWet.y, and2.u1)
    annotation (Line(points={{42,166},{98,166}}, color={255,0,255}));
  connect(truFalHol.u, and2.y)
    annotation (Line(points={{138,166},{122,166}},
    color={255,0,255}));
  connect(timer.y, enaTChiWatRet.u)
    annotation (Line(points={{42,100},{58,100}}, color={0,0,127}));
  connect(TChiWatRetDow, sub1.u2)
    annotation (Line(points={{-200,130},{-160,130},{-160,94},{-102,94}},
    color={0,0,127}));
  connect(sub1.y, hys.u)
    annotation (Line(points={{-78,100},{-62,100}},color={0,0,127}));
  connect(enaTChiWatRet.y, and2.u2) annotation (Line(points={{82,100},{90,100},{
          90,158},{98,158}}, color={255,0,255}));
  connect(wseTun.y, wseTOut.uTunPar) annotation (Line(points={{-118,30},{-110,
          30},{-110,152},{-102,152}},
                                  color={0,0,127}));
  connect(wseTOut.y, sub2.u2) annotation (Line(points={{-78,160},{-22,160}},
                     color={0,0,127}));
  connect(TChiWatRet, sub2.u1) annotation (Line(points={{-200,170},{-170,170},{-170,
          180},{-60,180},{-60,172},{-22,172}}, color={0,0,127}));
  connect(sub2.y, enaTWet.u)
    annotation (Line(points={{2,166},{18,166}}, color={0,0,127}));
  connect(wseTun.y, yTunPar)
    annotation (Line(points={{-118,30},{200,30}},   color={0,0,127}));
  connect(nor.y, timer.u)
    annotation (Line(points={{2,100},{18,100}}, color={255,0,255}));
  connect(hys.y, nor.u1)
    annotation (Line(points={{-38,100},{-22,100}}, color={255,0,255}));
  connect(truHol.y, nor.u2) annotation (Line(points={{-38,60},{-30,60},{-30,92},
          {-22,92}},       color={255,0,255}));
  connect(falEdg.y, truHol.u)
    annotation (Line(points={{-78,60},{-62,60}},   color={255,0,255}));
  connect(wseTOut.y, TWsePre) annotation (Line(points={{-78,160},{-60,160},{-60,
          130},{200,130}},           color={0,0,127}));
  connect(uIni, intEqu.u1)
    annotation (Line(points={{-200,-50},{-102,-50}}, color={255,127,0}));
  connect(conInt.y, intEqu.u2) annotation (Line(points={{-118,-80},{-110,-80},{-110,
          -58},{-102,-58}}, color={255,127,0}));
  connect(intEqu.y, and1.u2) annotation (Line(points={{-78,-50},{-70,-50},{-70,-28},
          {-62,-28}}, color={255,0,255}));
  connect(uIni, intEqu1.u1) annotation (Line(points={{-200,-50},{-150,-50},{-150,
          -100},{-102,-100}}, color={255,127,0}));
  connect(uChiSta, intEqu1.u2)
    annotation (Line(points={{-200,-108},{-102,-108}}, color={255,127,0}));
  connect(intEqu1.y, not1.u)
    annotation (Line(points={{-78,-100},{-62,-100}}, color={255,0,255}));
  connect(truFalHol.y, enaEco.u1) annotation (Line(points={{162,166},{170,166},{
          170,70},{110,70},{110,-20},{118,-20}},  color={255,0,255}));
  connect(enaEco.y, y)
    annotation (Line(points={{142,-20},{200,-20}}, color={255,0,255}));
  connect(dpChiWat, wseVal.dpChiWat) annotation (Line(points={{-200,-140},{-60,-140},
          {-60,-146},{118,-146}}, color={0,0,127}));
  connect(uPum, wsePum.uPum) annotation (Line(points={{-200,-180},{118,-180}},
                             color={255,0,255}));
  connect(TEntHex, wsePum.TEntHex) annotation (Line(points={{-200,-210},{100,
          -210},{100,-188},{118,-188}},  color={0,0,127}));
  connect(wseVal.yConWatIsoVal, yConWatIsoVal) annotation (Line(points={{142,-134},
          {160,-134},{160,-100},{200,-100}}, color={0,0,127}));
  connect(wseVal.yRetVal, yRetVal)
    annotation (Line(points={{142,-146},{200,-146}}, color={0,0,127}));
  connect(wsePum.yPumOn, yPumOn)
    annotation (Line(points={{142,-180},{200,-180}}, color={255,0,255}));
  connect(wsePum.yPumSpe, yPumSpe) annotation (Line(points={{142,-186},{160,-186},
          {160,-210},{200,-210}}, color={0,0,127}));
  connect(wsePum.yConWatIsoVal, yConWatIsoVal) annotation (Line(points={{142,-174},
          {160,-174},{160,-100},{200,-100}}, color={0,0,127}));
  connect(TChiWatRet, wsePum.TEntWSE) annotation (Line(points={{-200,170},{-170,
          170},{-170,-184},{118,-184}}, color={0,0,127}));
  connect(uPla, wseVal.uPla) annotation (Line(points={{-200,-20},{-154,-20},{
          -154,-134},{118,-134}}, color={255,0,255}));
  connect(uPla, wsePum.uPla) annotation (Line(points={{-200,-20},{-154,-20},{
          -154,-172},{118,-172}}, color={255,0,255}));
  connect(uPla, and1.u1)
    annotation (Line(points={{-200,-20},{-62,-20}}, color={255,0,255}));
  connect(lat.y, pre2.u)
    annotation (Line(points={{42,-20},{58,-20}}, color={255,0,255}));
  connect(enaEco.y, wseVal.uWSE) annotation (Line(points={{142,-20},{150,-20},{150,
          -40},{110,-40},{110,-140},{118,-140}}, color={255,0,255}));
  connect(enaEco.y, wsePum.uWSE) annotation (Line(points={{142,-20},{150,-20},{150,
          -40},{110,-40},{110,-176},{118,-176}}, color={255,0,255}));
  connect(enaEco.y, falEdg.u) annotation (Line(points={{142,-20},{150,-20},{150,
          0},{-160,0},{-160,60},{-102,60}}, color={255,0,255}));
  connect(enaEco.y, wseTun.uWseSta) annotation (Line(points={{142,-20},{150,-20},
          {150,0},{-160,0},{-160,35},{-142,35}}, color={255,0,255}));
  connect(pre2.y, enaEco.u2) annotation (Line(points={{82,-20},{100,-20},{100,
          -28},{118,-28}}, color={255,0,255}));
  connect(not1.y, lat.clr) annotation (Line(points={{-38,-100},{0,-100},{0,-26},
          {18,-26}}, color={255,0,255}));
  connect(and1.y, lat.u)
    annotation (Line(points={{-38,-20},{18,-20}}, color={255,0,255}));
  annotation (defaultComponentName = "wseSta",
        Icon(coordinateSystem(extent={{-100,-100},{100,100}}),
             graphics={
        Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-100,140},{100,100}},
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
          extent={{-180,-220},{180,220}}), graphics={
          Rectangle(
          extent={{-178,-2},{58,-118}},
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None), Text(
          extent={{-92,-64},{52,-78}},
          textColor={0,0,127},
          textString="Plant enabled in water side economizer mode")}),
Documentation(info="<html>
<p>
Waterside economizer (WSE) control sequence per ASHRAE RP-1711, March 2020, section 5.2.3.
It implements the enable/disable conditions as provided in sections 5.2.3.1. and 5.2.3.2.
</p>
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
for <code>delDis</code> time period.
</li>
</ul>
<p>
The following state machine chart illustrates the transitions between WSE enabled and disabled state:
</p>
<p align=\"center\">
<img alt=\"Image of WSE enable-disable state machine chart\"
src=\"modelica://Buildings/Resources/Images/Controls/OBC/ASHRAE/PrimarySystem/ChillerPlant/Economizer/WaterSideEconomizerEnableDisableStateGraph.png\"/>
</p>
<p>
The WSE control sequence uses the following subsequences:
</p>
<ul>
<li>
Calculation of the PHXLWT at given conditions:
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Economizers.Subsequences.PredictedOutletTemperature\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Economizers.Subsequences.PredictedOutletTemperature</a>.
</li>
<li>
Calculation of the tuning parameter used as an input to PHXLWT calculation:
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Economizers.Subsequences.Tuning\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Economizers.Subsequences.Tuning</a>.
</li>
</ul>
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
