within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Generic;
block PlantEnable "Sequence to enable and disable plant"

  parameter Boolean have_WSE = true
    "Flag to indicate if the plant has waterside economizer";
  parameter Real schTab[4,2] = [0,1; 6*3600,1; 19*3600,1; 24*3600,1]
    "Plant enabling schedule allowing operators to lock out the plant during off-hour";
  parameter Modelica.SIunits.Temperature TChiLocOut=277.5
    "Outdoor air lockout temperature below which the chiller plant should be disabled";
  parameter Modelica.SIunits.Time plaThrTim = 15*60
    "Threshold time to check status of chiller plant";
  parameter Modelica.SIunits.Time reqThrTim = 3*60
    "Threshold time to check current chiller plant request";
  parameter Integer ignReq = 0
    "Ignorable chiller plant requests";
  parameter Modelica.SIunits.TemperatureDifference heaExcAppDes=2
    "Design heat exchanger approach"
    annotation (Dialog(group="Waterside economizer", enable=have_WSE));
  parameter Modelica.SIunits.TemperatureDifference cooTowAppDes=2
    "Design cooling tower approach"
    annotation (Dialog(group="Waterside economizer", enable=have_WSE));
  parameter Modelica.SIunits.Temperature TOutWetDes=288.15
    "Design outdoor air wet bulb temperature"
    annotation (Dialog(group="Waterside economizer", enable=have_WSE));
  parameter Modelica.SIunits.VolumeFlowRate VHeaExcDes_flow=0.01
    "Desing heat exchanger chilled water flow rate"
    annotation (Dialog(group="Waterside economizer", enable=have_WSE));
  parameter Real locDt = 1
    "Offset temperature for lockout chiller"
    annotation (Dialog(tab="Advanced"));
  parameter Real wseDt = 1
    "Offset for checking waterside economizer leaving water temperature"
    annotation (Dialog(tab="Advanced"));
  parameter Real hysDt = 1
    "Deadband temperature used in hysteresis block"
    annotation (Dialog(tab="Advanced"));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput chiWatSupResReq
    "Number of chiller plant cooling requests"
    annotation (Placement(transformation(extent={{-240,160},{-200,200}}),
      iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TOut(
    final unit="K",
    final quantity="ThermodynamicTemperature")
    "Outdoor air temperature"
    annotation (Placement(transformation(extent={{-240,-80},{-200,-40}}),
      iconTransformation(extent={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TOutWet(
    final unit="K",
    final quantity="ThermodynamicTemperature") if have_WSE
    "Outdoor air wet bulb temperature"
    annotation (Placement(transformation(extent={{-240,-160},{-200,-120}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uTunPar if have_WSE
    "Tuning parameter as at last plant disable"
    annotation (Placement(transformation(extent={{-240,-240},{-200,-200}}),
      iconTransformation(extent={{-140,-60},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TChiWatSupSet(
    final unit="K",
    final quantity="ThermodynamicTemperature") if have_WSE
    "Chilled water supply setpoint"
    annotation (Placement(transformation(extent={{-240,-120},{-200,-80}}),
      iconTransformation(extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yIniChiSta
    "Initial chiller plant stage"
    annotation (Placement(transformation(extent={{200,-210},{220,-190}}),
      iconTransformation(extent={{100,-70},{120,-50}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yPla
    "Chiller plant enabling status"
    annotation (Placement(transformation(extent={{200,160},{220,180}}),
      iconTransformation(extent={{100,-10},{120,10}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Economizer.Subsequences.PredictedOutletTemperature
    wseTOut(
    final heaExcAppDes=heaExcAppDes,
    final cooTowAppDes=cooTowAppDes,
    final TOutWetDes=TOutWetDes,
    final VHeaExcDes_flow=VHeaExcDes_flow) if have_WSE
    "Waterside economizer outlet temperature predictor"
    annotation (Placement(transformation(extent={{-140,-190},{-120,-170}})));

protected
  final parameter Buildings.Controls.OBC.CDL.Types.Smoothness tabSmo=
    Buildings.Controls.OBC.CDL.Types.Smoothness.ConstantSegments
    "Smoothness of table interpolation";
  final parameter Buildings.Controls.OBC.CDL.Types.Extrapolation extrapolation=
    Buildings.Controls.OBC.CDL.Types.Extrapolation.Periodic
    "Extrapolation of data outside the definition range";
  Buildings.Controls.OBC.CDL.Continuous.Sources.TimeTable enaSch(
    final table=schTab,
    final smoothness=tabSmo,
    final extrapolation=extrapolation)
    "Plant enabling schedule allowing operators to lock out the plant during off-hour"
    annotation (Placement(transformation(extent={{-140,130},{-120,150}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterEqualThreshold schOn(
    final threshold=0.5)
    "Check if enabling schedule is active"
    annotation (Placement(transformation(extent={{-100,130},{-80,150}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1 "Logical not"
    annotation (Placement(transformation(extent={{-140,200},{-120,220}})));
  Buildings.Controls.OBC.CDL.Logical.Timer disTim
    "Chiller plant disabled time"
    annotation (Placement(transformation(extent={{-100,200},{-80,220}})));
  Buildings.Controls.OBC.CDL.Integers.GreaterThreshold hasReq(
    final threshold=ignReq)
    "Check if the number of chiller plant request is greater than the number of ignorable request"
    annotation (Placement(transformation(extent={{-140,170},{-120,190}})));
  Buildings.Controls.OBC.CDL.Logical.MultiAnd mulAnd(
    final nu=4) "Logical and receiving multiple input"
    annotation (Placement(transformation(extent={{40,160},{60,180}})));
  Buildings.Controls.OBC.CDL.Logical.Timer enaTim "Chiller plant enabled time"
    annotation (Placement(transformation(extent={{-140,70},{-120,90}})));
  Buildings.Controls.OBC.CDL.Logical.Timer enaTim1
    "Total time when chiller plant request is less than ignorable request"
    annotation (Placement(transformation(extent={{-100,10},{-80,30}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt
    "Convert real input to integer output"
    annotation (Placement(transformation(extent={{140,-210},{160,-190}})));
  Buildings.Controls.OBC.CDL.Logical.Not not2 "Logical not"
    annotation (Placement(transformation(extent={{-20,30},{0,50}})));
  Buildings.Controls.OBC.CDL.Logical.And and2 "Logical and"
    annotation (Placement(transformation(extent={{40,70},{60,90}})));
  Buildings.Controls.OBC.CDL.Logical.Latch lat
    "Maintains an on signal until conditions changes"
    annotation (Placement(transformation(extent={{100,160},{120,180}})));
  Buildings.Controls.OBC.CDL.Discrete.TriggeredSampler triSam
    "Triggered sampling of continuous signals"
    annotation (Placement(transformation(extent={{140,-130},{160,-110}})));
  Buildings.Controls.OBC.CDL.Logical.Edge edg
    annotation (Placement(transformation(extent={{120,-170},{140,-150}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant staOne(final k=1)
    "Stage one"
    annotation (Placement(transformation(extent={{0,-150},{20,-130}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys(
    final uLow=0,
    final uHigh=locDt + hysDt)
    "Check if outdoor temperature is higher than chiller lockout temperature"
    annotation (Placement(transformation(extent={{-100,-50},{-80,-30}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterEqualThreshold greEquThr(
    final threshold=plaThrTim)
    "Check if chiller plant has been disabled more than threshold time"
    annotation (Placement(transformation(extent={{-60,200},{-40,220}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterEqualThreshold greEquThr1(
    final threshold=plaThrTim)
    "Check if chiller plant has been enabled more than threshold time"
    annotation (Placement(transformation(extent={{-100,70},{-80,90}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterEqualThreshold greEquThr2(
    final threshold=reqThrTim)
    "Check if number of chiller plant request has been less than ignorable request by more than threshold time"
    annotation (Placement(transformation(extent={{-60,10},{-40,30}})));
  Buildings.Controls.OBC.CDL.Logical.Or3 mulOr "Logical or"
    annotation (Placement(transformation(extent={{40,10},{60,30}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant staZer(final k=0)
    "Zero stage"
    annotation (Placement(transformation(extent={{0,-110},{20,-90}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys1(final uLow=wseDt,
      final uHigh=wseDt + hysDt) if have_WSE
    "Check if predict heat exchange leaving water temperature is greater than chilled water supply temperature setpoint minus 1degF"
    annotation (Placement(transformation(extent={{-60,-130},{-40,-110}})));
  Buildings.Controls.OBC.CDL.Continuous.Feedback feedback if have_WSE
    "Difference between predicted heat exchanger leaving water temperature and chilled water supply temperature setpoint"
    annotation (Placement(transformation(extent={{-110,-130},{-90,-110}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi "Logical switch"
    annotation (Placement(transformation(extent={{60,-130},{80,-110}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con2(
    final k=true) if not have_WSE "Constant true"
    annotation (Placement(transformation(extent={{-60,-190},{-40,-170}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con3(k=VHeaExcDes_flow) if have_WSE
    "Design heat exchanger chiller water flow rate"
    annotation (Placement(transformation(extent={{-180,-190},{-160,-170}})));
  Buildings.Controls.OBC.CDL.Logical.Not not3 "Logical not"
    annotation (Placement(transformation(extent={{-140,10},{-120,30}})));
  Buildings.Controls.OBC.CDL.Logical.Not not4 "Logical not"
    annotation (Placement(transformation(extent={{-20,90},{0,110}})));
  Buildings.Controls.OBC.CDL.Logical.Pre pre1 "Pre"
    annotation (Placement(transformation(extent={{-180,200},{-160,220}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant chiLocOutTem(
    final k=TChiLocOut)
    "Outdoor air lockout temperature 1 degF below which the chiller plant should be disabled"
    annotation (Placement(transformation(extent={{-180,-30},{-160,-10}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add2(final k2=-1)
    "Difference between chiller lockout temperature and outdoor temperature"
    annotation (Placement(transformation(extent={{-140,-50},{-120,-30}})));

equation
  connect(enaSch.y[1], schOn.u)
    annotation (Line(points={{-119,140},{-102,140}}, color={0,0,127}));
  connect(not1.y, disTim.u)
    annotation (Line(points={{-119,210},{-102,210}}, color={255,0,255}));
  connect(disTim.y, greEquThr.u)
    annotation (Line(points={{-79,210},{-62,210}}, color={0,0,127}));
  connect(chiWatSupResReq, hasReq.u)
    annotation (Line(points={{-220,180},{-142,180}}, color={255,127,0}));
  connect(enaTim.y, greEquThr1.u)
    annotation (Line(points={{-119,80},{-102,80}}, color={0,0,127}));
  connect(enaTim1.y, greEquThr2.u)
    annotation (Line(points={{-79,20},{-62,20}},   color={0,0,127}));
  connect(greEquThr1.y, and2.u1)
    annotation (Line(points={{-79,80},{38,80}},
      color={255,0,255}));
  connect(greEquThr.y, mulAnd.u[1])
    annotation (Line(points={{-39,210},{20,210},{20,175.25},{38,175.25}},
      color={255,0,255}));
  connect(hasReq.y, mulAnd.u[2])
    annotation (Line(points={{-119,180},{-20,180},{-20,171.75},{38,171.75}},
      color={255,0,255}));
  connect(schOn.y, mulAnd.u[3])
    annotation (Line(points={{-79,140},{0,140},{0,168.25},{38,168.25}},
      color={255,0,255}));
  connect(schOn.y, not2.u)
    annotation (Line(points={{-79,140},{-40,140},{-40,40},{-22,40}},
      color={255,0,255}));
  connect(mulAnd.y, lat.u)
    annotation (Line(points={{61.7,170},{99,170}}, color={255,0,255}));
  connect(lat.y, yPla)
    annotation (Line(points={{121,170},{210,170}}, color={255,0,255}));
  connect(mulOr.y, and2.u2)
    annotation (Line(points={{61,20},{80,20},{80,60},{20,60},{20,72},{38,72}},
      color={255,0,255}));
  connect(lat.y, edg.u)
    annotation (Line(points={{121,170},{140,170},{140,140},{100,140},{100,-160},
      {118,-160}}, color={255,0,255}));
  connect(edg.y, triSam.trigger)
    annotation (Line(points={{141,-160},{150,-160},{150,-131.8}}, color={255,0,255}));
  connect(triSam.y, reaToInt.u)
    annotation (Line(points={{161,-120},{180,-120},{180,-180},{120,-180},{120,-200},
      {138,-200}}, color={0,0,127}));
  connect(reaToInt.y, yIniChiSta)
    annotation (Line(points={{161,-200},{210,-200}}, color={255,127,0}));
  connect(feedback.y, hys1.u)
    annotation (Line(points={{-89,-120},{-62,-120}}, color={0,0,127}));
  connect(swi.y, triSam.u)
    annotation (Line(points={{81,-120},{138,-120}}, color={0,0,127}));
  connect(con2.y, swi.u2)
    annotation (Line(points={{-39,-180},{-20,-180},{-20,-120},{58,-120}},
      color={255,0,255}));
  connect(not2.y, mulOr.u1)
    annotation (Line(points={{1,40},{20,40},{20,28},{38,28}},  color={255,0,255}));
  connect(greEquThr2.y, mulOr.u2)
    annotation (Line(points={{-39,20},{38,20}}, color={255,0,255}));
  connect(hys1.y, swi.u2)
    annotation (Line(points={{-39,-120},{58,-120}}, color={255,0,255}));
  connect(wseTOut.TOutWet, TOutWet)
    annotation (Line(points={{-142,-172},{-150,-172},{-150,-140},{-220,-140}},
      color={0,0,127}));
  connect(con3.y, wseTOut.VChiWat_flow)
    annotation (Line(points={{-159,-180},{-142,-180}},
      color={0,0,127}));
  connect(wseTOut.uTunPar, uTunPar)
    annotation (Line(points={{-142,-188},{-150,-188},{-150,-220},{-220,-220}},
      color={0,0,127}));
  connect(hasReq.y, not3.u)
    annotation (Line(points={{-119,180},{-20,180},{-20,160},{-180,160},{-180,20},
       {-142,20}}, color={255,0,255}));
  connect(not3.y, enaTim1.u)
    annotation (Line(points={{-119,20},{-102,20}}, color={255,0,255}));
  connect(wseTOut.y, feedback.u2)
    annotation (Line(points={{-118,-180},{-100,-180},{-100,-132}}, color={0,0,127}));
  connect(TChiWatSupSet, feedback.u1)
    annotation (Line(points={{-220,-100},{-140,-100},{-140,-120},{-112,-120}},
      color={0,0,127}));
  connect(lat.y, pre1.u)
    annotation (Line(points={{121,170},{140,170},{140,230},{-190,230},{-190,210},
      {-182,210}}, color={255,0,255}));
  connect(pre1.y, not1.u)
    annotation (Line(points={{-159,210},{-142,210}}, color={255,0,255}));
  connect(pre1.y, enaTim.u)
    annotation (Line(points={{-159,210},{-150,210},{-150,80},{-142,80}},
      color={255,0,255}));
  connect(staZer.y, swi.u1)
    annotation (Line(points={{21,-100},{40,-100},{40,-112},{58,-112}}, color={0,0,127}));
  connect(staOne.y, swi.u3)
    annotation (Line(points={{21,-140},{40,-140},{40,-128},{58,-128}}, color={0,0,127}));
  connect(TOut, add2.u2)
    annotation (Line(points={{-220,-60},{-150,-60},{-150,-46},{-142,-46}},
      color={0,0,127}));
  connect(chiLocOutTem.y, add2.u1)
    annotation (Line(points={{-159,-20},{-150,-20},{-150,-34},{-142,-34}},
      color={0,0,127}));
  connect(add2.y, hys.u)
    annotation (Line(points={{-119,-40},{-102,-40}}, color={0,0,127}));
  connect(hys.y, mulOr.u3)
    annotation (Line(points={{-79,-40},{20,-40},{20,12},{38,12}},
      color={255,0,255}));
  connect(hys.y, not4.u)
    annotation (Line(points={{-79,-40},{-70,-40},{-70,100},{-22,100}},
      color={255,0,255}));
  connect(not4.y, mulAnd.u[4])
    annotation (Line(points={{1,100},{20,100},{20,164.75},{38,164.75}},
      color={255,0,255}));
  connect(and2.y, lat.clr) annotation (Line(points={{61,80},{80,80},{80,164},{
          99,164}}, color={255,0,255}));
annotation (
  defaultComponentName = "plaEna",
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-200,-240},{200,240}})),
  Icon(coordinateSystem(extent={{-100,-100},{100,100}}),
       graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={28,108,200},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          lineThickness=5,
          borderPattern=BorderPattern.Raised),
        Text(
          extent={{-120,146},{100,108}},
          lineColor={0,0,255},
          textString="%name"),
        Ellipse(extent={{-80,80},{80,-80}}, lineColor={28,108,200},fillColor={170,255,213},
          fillPattern=FillPattern.Solid),
        Ellipse(extent={{-90,90},{90,-90}}, lineColor={28,108,200}),
        Rectangle(extent={{-75,2},{75,-2}}, lineColor={28,108,200},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-66,46},{76,10}},
          lineColor={28,108,200},
          textString="START"),
        Text(
          extent={{-66,-8},{76,-44}},
          lineColor={28,108,200},
          textString="STOP")}),
 Documentation(info="<html>
<p>
Block that generate chiller plant enable signals and output the initial plant stage,
according to ASHRAE RP-1711 Advanced Sequences of Operation for HVAC Systems Phase II –
Central Plants and Hydronic Systems (Draft 4 on January 7, 2019), section 5.2.2 and 
5.2.4.13 Table 2.
</p>
<p>
The chiller plant should be enabled and disabled according to following sequences:
</p>
<ol>
<li>
An enabling schedule should be included to allow operators to lock out the 
chiller plant during off-hour, e.g. to allow off-hour operation of HVAC systems
except the chiller plant. The default schedule shall be 24/7 and be adjustable.
</li>
<li>
The plant should be enabled in the lowest stage when the plant has been
disabled for at least <code>plaThrTim</code>, e.g. 15 minutes and: 
<ul>
<li>
Number of chiller plant requests &gt; <code>ignReq</code> (<code>ignReq</code>
should default to 0 and adjustable), and,
</li>
<li>
Outdoor air temperature is greater than chiller lockout temperature, 
<code>TOut</code> &gt; <code>TChiLocOut</code>, and,
</li>
<li>
The chiller enable schedule is active.
</li>
</ul>
</li>
<li>
The plant should be disabled when it has been enabled for at least 
<code>plaThrTim</code>, e.g. 15 minutes and:
<ul>
<li>
Number of chiller plant requests &le; <code>ignReq</code> for <code>reqThrTim</code>, or,
</li>
<li>
Outdoor air temperature is 1 &deg;F less than chiller lockout temperature,
<code>TOut</code> &lt; <code>TChiLocOut</code> - 1 &deg;F, or,
</li>
<li>
The chiller enable schedule is inactive.
</li>
</ul>
</li>
</ol>

<p>
The initial stage <code>yIniChiSta</code> should be defined as:
</p>
<ol>
<li>
When the plant is enabled and the plant has no waterside economizer (<code>have_WSE</code>=false), 
the initial stage will be 1.
</li>
<li>
When the plant is enabled and the plant has waterside economizer (<code>have_WSE</code>=true),
the initial stage should be:
<ul>
<li>
If predicted heat exchanger leaving water temperature <code>TPreHeaChaLea</code> (
calculated with predicted heat exchanger part load ratio <code>PLRHeaExc</code> 
equals to 1) is 1 &deg;F &lt; <code>TChiWatSupSet</code> (the chilled water supply
temperature setpoint), then the initial stage will be 0. Waterside economizer will be
enabled.
</li>
<li>
Otherwise, the initial stage will be 1.
</li>

</ul>
</li>
</ol>

</html>",
revisions="<html>
<ul>
<li>
January 24, 2019, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end PlantEnable;
