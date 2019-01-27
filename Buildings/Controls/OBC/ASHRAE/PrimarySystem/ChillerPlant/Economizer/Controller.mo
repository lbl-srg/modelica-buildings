within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Economizer;
block Controller "Waterside economizer (WSE) enable/disable status"

  parameter Modelica.SIunits.Time holdPeriod=20*60
  "WSE minimum on or off time"
  annotation(Dialog(group="Enable parameters"));

  parameter Modelica.SIunits.Time dTperiod=2*60
  "Postpone disable time period"
  annotation(Dialog(group="Enable parameters"));

  parameter Modelica.SIunits.TemperatureDifference TOffsetEna=2
  "Temperature offset between the chilled water return upstream of WSE and the predicted WSE output"
  annotation(Dialog(group="Enable parameters"));

  parameter Modelica.SIunits.TemperatureDifference TOffsetDis=1
  "Temperature offset between the chilled water return upstream and downstream WSE"
  annotation(Dialog(group="Enable parameters"));

  parameter Modelica.SIunits.TemperatureDifference heaExcAppDes=2
  "Design heat exchanger approach"
    annotation(Dialog(group="Design parameters"));

  parameter Modelica.SIunits.TemperatureDifference cooTowAppDes=2
  "Design cooling tower approach"
    annotation(Dialog(group="Design parameters"));

  parameter Modelica.SIunits.Temperature TOutWetDes=288.15
  "Design outdoor air wet bulb temperature"
    annotation(Dialog(group="Design parameters"));

  parameter Real VHeaExcDes_flow(
    final quantity="VolumeFlowRate",
    final unit="m3/s")=0.015
    "Desing heat exchanger chilled water volume flow rate"
    annotation(Dialog(group="Design parameters"));

  parameter Real step=0.02 "Tuning step"
    annotation (Evaluate=true,Dialog(tab="Advanced", group="Tuning"));

  parameter Modelica.SIunits.Time wseOnTimDec = 60*60
  "Economizer enable time needed to allow decrease of the tuning parameter"
    annotation (Evaluate=true,Dialog(tab="Advanced", group="Tuning"));

  parameter Modelica.SIunits.Time wseOnTimInc = 30*60
  "Economizer enable time needed to allow increase of the tuning parameter"
    annotation (Evaluate=true,Dialog(tab="Advanced", group="Tuning"));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TOutWet(
    final unit="K",
    final quantity="ThermodynamicTemperature")
    "Outdoor air wet bulb temperature"
    annotation (Placement(transformation(extent={{-220,80},{-180,120}}),
        iconTransformation(extent={{-140,60},{-100,100}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TChiWatRet(
    final unit="K",
    final quantity="ThermodynamicTemperature")
    "Chiller water return temperature upstream of the WSE"
    annotation (Placement(transformation(extent={{-220,40},{-180,80}}),
        iconTransformation(extent={{-140,20},{-100,60}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TChiWatRetDow
    "Chiller water return temperature downstream of the WSE"
    annotation (Placement(transformation(extent={{-220,0},{-180,40}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uTowFanSpe
    "Cooling tower fan speed"
    annotation (Placement(transformation(extent={{-220,-120},{-180,-80}}),
        iconTransformation(extent={{-140,-100},{-100,-60}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput VChiWat_flow(
    final quantity="VolumeFlowRate",
    final unit="m3/s")
    "Measured chilled water volume flow rate"
    annotation (Placement(transformation(extent={{-220,-60},{-180,-20}}),
    iconTransformation(extent={{-140,-60},{-100,-20}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y
    "WSE enable disable status"
    annotation (Placement(transformation(extent={{180,-10},{200,10}}),
    iconTransformation(extent={{100,-10},{120,10}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yTPre(
    final quantity="ThermodynamicTemperature",
    final unit="K") "Predicted waterside economizer outlet temperature"
    annotation (Placement(transformation(extent={{180,70},{200,90}}),
        iconTransformation(extent={{100,-20},{140,20}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Economizer.Subsequences.Tuning wseTun(
    final step=step,
    final wseOnTimDec=wseOnTimDec,
    final wseOnTimInc=wseOnTimInc)
    "Tuning parameter for the WSE outlet temperature calculation"
    annotation (Placement(transformation(extent={{-140,-110},{-120,-90}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Economizer.Subsequences.PredictedOutletTemperature wseTOut(
    final heaExcAppDes=heaExcAppDes,
    final cooTowAppDes=cooTowAppDes,
    final TOutWetDes=TOutWetDes,
    final VHeaExcDes_flow=VHeaExcDes_flow)
    "Calculates the predicted WSE outlet temperature"
    annotation (Placement(transformation(extent={{-100,50},{-80,70}})));

  CDL.Continuous.LessThreshold enaTChiWatRet(
    final threshold=dTperiod)
    "Enable condition based on chilled water return temperature upstream and downstream WSE"
    annotation (Placement(transformation(extent={{60,-20},{80,0}})));

  Buildings.Controls.OBC.CDL.Continuous.Greater enaTWet
    "Enable condition based on the outdoor wet bulb temperature"
    annotation (Placement(transformation(extent={{0,40},{20,60}})));

//protected
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant addTOffsetEna(
    final k=TOffsetEna)
    "Temperature offset for enable conditions"
    annotation (Placement(transformation(extent={{-100,10},{-80,30}})));

  Buildings.Controls.OBC.CDL.Continuous.Add add2 "Adder"
    annotation (Placement(transformation(extent={{-40,30},{-20,50}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre "Logical pre"
    annotation (Placement(transformation(extent={{150,-60},{170,-40}})));

  Buildings.Controls.OBC.CDL.Continuous.Add add1(
    final k1=1,
    final k2=-1) "Adder"
    annotation (Placement(transformation(extent={{-60,-20},{-40,0}})));

  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold truFalHol(
    final trueHoldDuration=holdPeriod,
    final falseHoldDuration=holdPeriod)
    "Keeps a signal constant for a given time period"
    annotation (Placement(transformation(extent={{140,20},{160,40}})));

  Buildings.Controls.OBC.CDL.Logical.And and2 "And"
    annotation (Placement(transformation(extent={{100,40},{120,60}})));

  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys(
    final uLow=TOffsetDis,
    final uHigh=TOffsetDis + 1)
    "Hysteresis comparing CHW temperatures upstream and downstream WSE"
    annotation (Placement(transformation(extent={{-30,-20},{-10,0}})));

  Buildings.Controls.OBC.CDL.Logical.Timer timer
    "Measures the disable condition satisfied time "
    annotation (Placement(transformation(extent={{30,-20},{50,0}})));

  CDL.Logical.Not not1
    annotation (Placement(transformation(extent={{0,-20},{20,0}})));

equation
  connect(addTOffsetEna.y, add2.u2)
    annotation (Line(points={{-79,20},{-60,20},{-60,34},{-42,34}},color={0,0,127}));
  connect(add2.y, enaTWet.u2) annotation (Line(points={{-19,40},{-10,40},{-10,42},
          {-2,42}}, color={0,0,127}));
  connect(TChiWatRet, enaTWet.u1) annotation (Line(points={{-200,60},{-140,60},{
          -140,80},{-10,80},{-10,50},{-2,50}}, color={0,0,127}));
  connect(uTowFanSpe, wseTun.uTowFanSpe)
    annotation (Line(points={{-200,-100},{-150,-100},{-150,-105},{-142,-105}},
    color={0,0,127}));
  connect(wseTun.y, wseTOut.uTunPar) annotation (Line(points={{-119,-100},{-110,
          -100},{-110,52},{-102,52}},color={0,0,127}));
  connect(TOutWet, wseTOut.TOutWet)
    annotation (Line(points={{-200,100},{-120,100},{-120,68},{-102,68}},
    color={0,0,127}));
  connect(wseTOut.y, add2.u1) annotation (Line(points={{-78,60},{-60,60},{-60,46},
          {-42,46}}, color={0,0,127}));
  connect(VChiWat_flow, wseTOut.VChiWat_flow)
    annotation (Line(points={{-200,-40},{-120,-40},{-120,60},{-102,60}},
    color={0,0,127}));
  connect(pre.y,wseTun.uWseSta)
    annotation (Line(points={{171,-50},{174,-50},{174,-80},{-150,-80},{-150,-95},
          {-142,-95}},color={255,0,255}));
  connect(TChiWatRet, add1.u1)
    annotation (Line(points={{-200,60},{-140,60},{-140,-4},{-62,-4}},
          color={0,0,127}));
  connect(truFalHol.y, pre.u)
    annotation (Line(points={{161,30},{170,30},{170,-30},{140,-30},{140,-50},{
          148,-50}},
                color={255,0,255}));
  connect(truFalHol.y, y) annotation (Line(points={{161,30},{170,30},{170,0},{
          190,0}}, color={255,0,255}));
  connect(enaTWet.y, and2.u1)
    annotation (Line(points={{21,50},{98,50}}, color={255,0,255}));
  connect(truFalHol.u, and2.y)
    annotation (Line(points={{139,30},{130,30},{130,50},{121,50}},
    color={255,0,255}));
  connect(timer.y, enaTChiWatRet.u)
    annotation (Line(points={{51,-10},{58,-10}}, color={0,0,127}));
  connect(TChiWatRetDow, add1.u2) annotation (Line(points={{-200,20},{-160,20},{
          -160,-16},{-62,-16}}, color={0,0,127}));
  connect(add1.y, hys.u)
    annotation (Line(points={{-39,-10},{-32,-10}},color={0,0,127}));
  connect(hys.y, not1.u)
    annotation (Line(points={{-9,-10},{-2,-10}},   color={255,0,255}));
  connect(not1.y, timer.u)
    annotation (Line(points={{21,-10},{28,-10}},   color={255,0,255}));
  connect(enaTChiWatRet.y, and2.u2) annotation (Line(points={{81,-10},{90,-10},{
          90,42},{98,42}}, color={255,0,255}));
  connect(wseTOut.y, yTPre) annotation (Line(points={{-78,60},{-70,60},{-70,90},
          {160,90},{160,80},{190,80}}, color={0,0,127}));
  annotation (defaultComponentName = "wseSta",
        Icon(graphics={
        Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-120,146},{100,108}},
          lineColor={0,0,255},
          textString="%name")}),
        Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-180,-120},{180,120}})),
Documentation(info="<html>
<p>
Waterside economizer (WSE) sequence per OBC Chilled Water Plant Sequence of Operation
document, section 3.2.3. It consists of enable/disable conditions as provided in sections 3.2.3.1. and 3.2.3.2, and:
<li>
- A subsequence to predict the WSE outlet temperature at given conditions:
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Economizer.Subsequences.PredictedOutletTemperature\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Economizer.Subsequences.PredictedOutletTemperature</a>
</li>
<li>
- A subsequence to define the temperature prediction
tuning parameter:
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Economizer.Subsequences.Tuning\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Economizer.Subsequences.Tuning</a>
</li>
<li>
<p>
The sequence controls the WSE status as follows:
<li>
- Enable if WSE has been disabled for at least <code>holdPeriod<\code> of time and chilled water return 
temperature (CHWRT) upstream of WSE is greater than the predicted heat 
exchanger leaving water temperature (PHXLWT) plus <code>TOffsetEna<\code>
</li>
<li>
- Disable if WSE has been enabled for at least <code>holdPeriod<\code> of time and CHWRT downstream of 
WSE is greater than CHWRT upstream of WSE less <code>TOffsetDis<\code> for 2 minutes
</li>
<p>
</p>
</html>",
revisions="<html>
<ul>
<li>
October 13, 2018, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>
</html>"));
end Controller;
