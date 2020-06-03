within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Generic;
block PlantEnable "Sequence to enable and disable plant"

  parameter Boolean have_WSE = true
    "Flag to indicate if the plant has waterside economizer";

  parameter Real schTab[4,2] = [0,1; 6*3600,1; 19*3600,1; 24*3600,1]
    "Plant enabling schedule allowing operators to lock out the plant during off-hour";

  parameter Modelica.SIunits.Temperature TChiLocOut=277.5
    "Outdoor air lockout temperature below which the chiller plant should be disabled";

  parameter Real plaThrTim(
    final unit="s",
    final quantity="Time")=15*60
      "Threshold time to check status of chiller plant";

  parameter Real reqThrTim(
    final unit="s",
    final quantity="Time")=3*60
      "Threshold time to check current chiller plant request";

  parameter Integer ignReq = 0
    "Ignorable chiller plant requests";

  parameter Real locDt = 1
    "Offset temperature for lockout chiller"
    annotation (Dialog(tab="Advanced"));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput chiWatSupResReq
    "Number of chiller plant cooling requests"
    annotation (Placement(transformation(extent={{-240,70},{-200,110}}),
      iconTransformation(extent={{-140,20},{-100,60}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TOut(
    final unit="K",
    final quantity="ThermodynamicTemperature")
    "Outdoor air temperature"
    annotation (Placement(transformation(extent={{-240,-170},{-200,-130}}),
      iconTransformation(extent={{-140,-62},{-100,-22}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yPla
    "Chiller plant enabling status"
    annotation (Placement(transformation(extent={{200,70},{220,90}}),
      iconTransformation(extent={{100,-10},{120,10}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.TimeTable enaSch(
    final table=schTab,
    final smoothness=tabSmo,
    final extrapolation=extrapolation)
    "Plant enabling schedule allowing operators to lock out the plant during off-hour"
    annotation (Placement(transformation(extent={{-140,40},{-120,60}})));

protected
  final parameter Buildings.Controls.OBC.CDL.Types.Smoothness tabSmo=
    Buildings.Controls.OBC.CDL.Types.Smoothness.ConstantSegments
    "Smoothness of table interpolation";

  final parameter Buildings.Controls.OBC.CDL.Types.Extrapolation extrapolation=
    Buildings.Controls.OBC.CDL.Types.Extrapolation.Periodic
    "Extrapolation of data outside the definition range";

  Buildings.Controls.OBC.CDL.Continuous.GreaterEqualThreshold schOn(
    final threshold=0.5)
    "Check if enabling schedule is active"
    annotation (Placement(transformation(extent={{-100,40},{-80,60}})));

  Buildings.Controls.OBC.CDL.Logical.Not not1 "Logical not"
    annotation (Placement(transformation(extent={{-140,110},{-120,130}})));

  Buildings.Controls.OBC.CDL.Logical.Timer disTim
    "Chiller plant disabled time"
    annotation (Placement(transformation(extent={{-100,110},{-80,130}})));

  Buildings.Controls.OBC.CDL.Integers.GreaterThreshold hasReq(
    final threshold=ignReq)
    "Check if the number of chiller plant request is greater than the number of ignorable request"
    annotation (Placement(transformation(extent={{-140,80},{-120,100}})));

  Buildings.Controls.OBC.CDL.Logical.MultiAnd mulAnd(
    final nu=4) "Logical and receiving multiple input"
    annotation (Placement(transformation(extent={{40,70},{60,90}})));

  Buildings.Controls.OBC.CDL.Logical.Timer enaTim "Chiller plant enabled time"
    annotation (Placement(transformation(extent={{-140,-20},{-120,0}})));

  Buildings.Controls.OBC.CDL.Logical.Timer enaTim1
    "Total time when chiller plant request is less than ignorable request"
    annotation (Placement(transformation(extent={{-100,-80},{-80,-60}})));

  Buildings.Controls.OBC.CDL.Logical.Not not2 "Logical not"
    annotation (Placement(transformation(extent={{-20,-60},{0,-40}})));

  Buildings.Controls.OBC.CDL.Logical.And and2 "Logical and"
    annotation (Placement(transformation(extent={{40,-20},{60,0}})));

  Buildings.Controls.OBC.CDL.Logical.Latch lat
    "Maintains an on signal until conditions changes"
    annotation (Placement(transformation(extent={{100,70},{120,90}})));

  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys(
    final uLow=0,
    final uHigh=locDt)
    "Check if outdoor temperature is higher than chiller lockout temperature"
    annotation (Placement(transformation(extent={{-100,-140},{-80,-120}})));

  Buildings.Controls.OBC.CDL.Continuous.GreaterEqualThreshold greEquThr(
    final threshold=plaThrTim)
    "Check if chiller plant has been disabled more than threshold time"
    annotation (Placement(transformation(extent={{-60,110},{-40,130}})));

  Buildings.Controls.OBC.CDL.Continuous.GreaterEqualThreshold greEquThr1(
    final threshold=plaThrTim)
    "Check if chiller plant has been enabled more than threshold time"
    annotation (Placement(transformation(extent={{-100,-20},{-80,0}})));

  Buildings.Controls.OBC.CDL.Continuous.GreaterEqualThreshold greEquThr2(
    final threshold=reqThrTim)
    "Check if number of chiller plant request has been less than ignorable request by more than threshold time"
    annotation (Placement(transformation(extent={{-60,-80},{-40,-60}})));

  Buildings.Controls.OBC.CDL.Logical.Or3 mulOr "Logical or"
    annotation (Placement(transformation(extent={{40,-80},{60,-60}})));

  Buildings.Controls.OBC.CDL.Logical.Not not3 "Logical not"
    annotation (Placement(transformation(extent={{-140,-80},{-120,-60}})));

  Buildings.Controls.OBC.CDL.Logical.Not not4 "Logical not"
    annotation (Placement(transformation(extent={{-20,0},{0,20}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre1 "Pre"
    annotation (Placement(transformation(extent={{-180,110},{-160,130}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant chiLocOutTem(
    final k=TChiLocOut)
    "Outdoor air lockout temperature"
    annotation (Placement(transformation(extent={{-180,-120},{-160,-100}})));

  Buildings.Controls.OBC.CDL.Continuous.Add add2(final k1=1, final k2=-1)
    "Difference between chiller lockout temperature and outdoor temperature"
    annotation (Placement(transformation(extent={{-140,-140},{-120,-120}})));

equation
  connect(enaSch.y[1], schOn.u)
    annotation (Line(points={{-118,50},{-102,50}},   color={0,0,127}));
  connect(not1.y, disTim.u)
    annotation (Line(points={{-118,120},{-102,120}}, color={255,0,255}));
  connect(disTim.y, greEquThr.u)
    annotation (Line(points={{-78,120},{-62,120}}, color={0,0,127}));
  connect(chiWatSupResReq, hasReq.u)
    annotation (Line(points={{-220,90},{-142,90}},   color={255,127,0}));
  connect(enaTim.y, greEquThr1.u)
    annotation (Line(points={{-118,-10},{-102,-10}},
                                                   color={0,0,127}));
  connect(enaTim1.y, greEquThr2.u)
    annotation (Line(points={{-78,-70},{-62,-70}}, color={0,0,127}));
  connect(greEquThr1.y, and2.u1)
    annotation (Line(points={{-78,-10},{38,-10}},
      color={255,0,255}));
  connect(greEquThr.y, mulAnd.u[1])
    annotation (Line(points={{-38,120},{20,120},{20,85.25},{38,85.25}},
      color={255,0,255}));
  connect(hasReq.y, mulAnd.u[2])
    annotation (Line(points={{-118,90},{-20,90},{-20,81.75},{38,81.75}},
      color={255,0,255}));
  connect(schOn.y, mulAnd.u[3])
    annotation (Line(points={{-78,50},{0,50},{0,78.25},{38,78.25}},
      color={255,0,255}));
  connect(schOn.y, not2.u)
    annotation (Line(points={{-78,50},{-40,50},{-40,-50},{-22,-50}},
      color={255,0,255}));
  connect(mulAnd.y, lat.u)
    annotation (Line(points={{62,80},{98,80}},     color={255,0,255}));
  connect(lat.y, yPla)
    annotation (Line(points={{122,80},{210,80}},   color={255,0,255}));
  connect(mulOr.y, and2.u2)
    annotation (Line(points={{62,-70},{80,-70},{80,-30},{20,-30},{20,-18},{38,-18}},
      color={255,0,255}));
  connect(not2.y, mulOr.u1)
    annotation (Line(points={{2,-50},{20,-50},{20,-62},{38,-62}}, color={255,0,255}));
  connect(greEquThr2.y, mulOr.u2)
    annotation (Line(points={{-38,-70},{38,-70}}, color={255,0,255}));
  connect(hasReq.y, not3.u)
    annotation (Line(points={{-118,90},{-20,90},{-20,70},{-180,70},{-180,-70},{-142,
          -70}},   color={255,0,255}));
  connect(not3.y, enaTim1.u)
    annotation (Line(points={{-118,-70},{-102,-70}}, color={255,0,255}));
  connect(lat.y, pre1.u)
    annotation (Line(points={{122,80},{140,80},{140,140},{-190,140},{-190,120},{
          -182,120}}, color={255,0,255}));
  connect(pre1.y, not1.u)
    annotation (Line(points={{-158,120},{-142,120}}, color={255,0,255}));
  connect(pre1.y, enaTim.u)
    annotation (Line(points={{-158,120},{-150,120},{-150,-10},{-142,-10}},
      color={255,0,255}));
  connect(TOut, add2.u2)
    annotation (Line(points={{-220,-150},{-150,-150},{-150,-136},{-142,-136}},
      color={0,0,127}));
  connect(chiLocOutTem.y, add2.u1)
    annotation (Line(points={{-158,-110},{-150,-110},{-150,-124},{-142,-124}},
      color={0,0,127}));
  connect(add2.y, hys.u)
    annotation (Line(points={{-118,-130},{-102,-130}}, color={0,0,127}));
  connect(hys.y, mulOr.u3)
    annotation (Line(points={{-78,-130},{20,-130},{20,-78},{38,-78}},
      color={255,0,255}));
  connect(hys.y, not4.u)
    annotation (Line(points={{-78,-130},{-70,-130},{-70,10},{-22,10}},
      color={255,0,255}));
  connect(not4.y, mulAnd.u[4])
    annotation (Line(points={{2,10},{20,10},{20,74.75},{38,74.75}},
      color={255,0,255}));
  connect(and2.y, lat.clr) annotation (Line(points={{62,-10},{80,-10},{80,74},{98,
          74}},     color={255,0,255}));

annotation (
  defaultComponentName = "plaEna",
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-200,-180},{200,180}})),
  Icon(graphics={
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
</html>",
revisions="<html>
<ul>
<li>
March 12, 2020, by Milica Grahovac:<br/>
Removed initial stage determination as it is imlemented as a separate sequence. This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1831\">issue 1831</a>.
</li>
<li>
January 24, 2019, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end PlantEnable;
