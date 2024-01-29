within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Generic.PlantEnable;
block Enable "Sequence to enable and disable plant"

  parameter Real schTab[4,2] = [0,1; 6*3600,1; 19*3600,1; 24*3600,1]
    "Plant enabling schedule allowing operators to lock out the plant during off-hour";

  parameter Real TChiLocOut=277.5
      "Outdoor air lockout temperature below which the chiller plant should be disabled";

  parameter Real plaThrTim(
    final unit="s",
    final quantity="Time")=900
      "Threshold time to check status of chiller plant";

  parameter Real reqThrTim(
    final unit="s",
    final quantity="Time")=180
      "Threshold time to check current chiller plant request";

  parameter Integer ignReq = 0
    "Ignorable chiller plant requests";

  parameter Real locDt(
    final unit="K",
    final quantity="TemperatureDifference") = 5/9
    "Offset temperature for lockout chiller"
    annotation (Dialog(tab="Advanced"));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput chiPlaReq
    "Number of chiller plant cooling requests"
    annotation (Placement(transformation(extent={{-240,70},{-200,110}}),
      iconTransformation(extent={{-140,20},{-100,60}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TOut(
    final unit="K",
    final quantity="ThermodynamicTemperature",
    displayUnit="degC")
    "Outdoor air temperature"
    annotation (Placement(transformation(extent={{-240,-170},{-200,-130}}),
      iconTransformation(extent={{-140,-62},{-100,-22}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yPla
    "Chiller plant enabling status"
    annotation (Placement(transformation(extent={{200,70},{220,90}}),
      iconTransformation(extent={{100,-10},{120,10}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.TimeTable enaSch(
    final table=schTab,
    final smoothness=Buildings.Controls.OBC.CDL.Types.Smoothness.ConstantSegments,
    final extrapolation=Buildings.Controls.OBC.CDL.Types.Extrapolation.Periodic)
    "Plant enabling schedule allowing operators to lock out the plant during off-hour"
    annotation (Placement(transformation(extent={{-140,40},{-120,60}})));

//   final parameter Buildings.Controls.OBC.CDL.Types.Smoothness tabSmo=
//     Buildings.Controls.OBC.CDL.Types.Smoothness.ConstantSegments
//     "Smoothness of table interpolation";
//
//   final parameter Buildings.Controls.OBC.CDL.Types.Extrapolation extrapolation=
//     Buildings.Controls.OBC.CDL.Types.Extrapolation.Periodic
//     "Extrapolation of data outside the definition range";

protected
  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold schOn(
    final t=0.5)
    "Check if enabling schedule is active"
    annotation (Placement(transformation(extent={{-100,40},{-80,60}})));

  Buildings.Controls.OBC.CDL.Logical.Not not1 "Logical not"
    annotation (Placement(transformation(extent={{-140,110},{-120,130}})));

  Buildings.Controls.OBC.CDL.Logical.Timer disTim(
    final t=plaThrTim)
    "Check if chiller plant has been disabled more than threshold time"
    annotation (Placement(transformation(extent={{-100,110},{-80,130}})));

  Buildings.Controls.OBC.CDL.Integers.GreaterThreshold hasReq(
    final t=ignReq)
    "Check if the number of chiller plant request is greater than the number of ignorable request"
    annotation (Placement(transformation(extent={{-140,80},{-120,100}})));

  Buildings.Controls.OBC.CDL.Logical.MultiAnd enaPla(
    final nin=4) "Enable chiller plant"
    annotation (Placement(transformation(extent={{40,70},{60,90}})));

  Buildings.Controls.OBC.CDL.Logical.Timer enaTim(
    final t=plaThrTim)
    "Check if chiller plant has been enabled more than threshold time"
    annotation (Placement(transformation(extent={{-140,-20},{-120,0}})));

  CDL.Logical.TrueDelay                    enaTim1(final delayTime=reqThrTim)
    "Check if number of chiller plant request has been less than ignorable request by more than threshold time"
    annotation (Placement(transformation(extent={{-100,-80},{-80,-60}})));

  Buildings.Controls.OBC.CDL.Logical.Not not2 "Logical not"
    annotation (Placement(transformation(extent={{-40,-60},{-20,-40}})));

  Buildings.Controls.OBC.CDL.Logical.And disPla
    "Disable chiller plant"
    annotation (Placement(transformation(extent={{100,-28},{120,-8}})));

  Buildings.Controls.OBC.CDL.Logical.Latch plaSta
    "Chiller plant enabling status"
    annotation (Placement(transformation(extent={{140,70},{160,90}})));

  Buildings.Controls.OBC.CDL.Reals.Hysteresis hys(
    final uLow=0,
    final uHigh=locDt)
    "Check if outdoor temperature is lower than chiller lockout temperature"
    annotation (Placement(transformation(extent={{-100,-140},{-80,-120}})));

  Buildings.Controls.OBC.CDL.Logical.Or disPlaCon
    "Disable chiller plant conditions"
    annotation (Placement(transformation(extent={{60,-88},{80,-68}})));

  Buildings.Controls.OBC.CDL.Logical.Not lesReq
    "Check if it is less than the ignorable request"
    annotation (Placement(transformation(extent={{-140,-80},{-120,-60}})));

  Buildings.Controls.OBC.CDL.Logical.Not notLoc
    "Check if outdoor temperature is higher than the chiller lockout temperature"
    annotation (Placement(transformation(extent={{-20,0},{0,20}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre1 "Pre"
    annotation (Placement(transformation(extent={{-180,110},{-160,130}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant chiLocOutTem(
    final k=TChiLocOut)
    "Outdoor air lockout temperature"
    annotation (Placement(transformation(extent={{-180,-120},{-160,-100}})));

  Buildings.Controls.OBC.CDL.Reals.Subtract sub1
    "Difference between chiller lockout temperature and outdoor temperature"
    annotation (Placement(transformation(extent={{-140,-140},{-120,-120}})));

  Buildings.Controls.OBC.CDL.Logical.Or or1
    "Disable chiller plant conditions"
    annotation (Placement(transformation(extent={{-20,-110},{0,-90}})));

equation
  connect(enaSch.y[1], schOn.u)
    annotation (Line(points={{-118,50},{-102,50}},   color={0,0,127}));
  connect(not1.y, disTim.u)
    annotation (Line(points={{-118,120},{-102,120}}, color={255,0,255}));
  connect(chiPlaReq, hasReq.u)
    annotation (Line(points={{-220,90},{-142,90}}, color={255,127,0}));
  connect(disTim.passed,enaPla. u[1])
    annotation (Line(points={{-78,112},{20,112},{20,77.375},{38,77.375}},
      color={255,0,255}));
  connect(hasReq.y,enaPla. u[2])
    annotation (Line(points={{-118,90},{-20,90},{-20,79.125},{38,79.125}},
      color={255,0,255}));
  connect(schOn.y,enaPla. u[3])
    annotation (Line(points={{-78,50},{0,50},{0,80.875},{38,80.875}},
      color={255,0,255}));
  connect(schOn.y, not2.u)
    annotation (Line(points={{-78,50},{-50,50},{-50,-50},{-42,-50}},
      color={255,0,255}));
  connect(enaPla.y, plaSta.u)
    annotation (Line(points={{62,80},{138,80}},color={255,0,255}));
  connect(plaSta.y, yPla)
    annotation (Line(points={{162,80},{210,80}}, color={255,0,255}));
  connect(disPlaCon.y, disPla.u2) annotation (Line(points={{82,-78},{90,-78},{90,
          -26},{98,-26}}, color={255,0,255}));
  connect(not2.y, disPlaCon.u1) annotation (Line(points={{-18,-50},{20,-50},{20,
          -78},{58,-78}}, color={255,0,255}));
  connect(hasReq.y, lesReq.u) annotation (Line(points={{-118,90},{-20,90},{-20,70},
          {-180,70},{-180,-70},{-142,-70}}, color={255,0,255}));
  connect(lesReq.y, enaTim1.u)
    annotation (Line(points={{-118,-70},{-102,-70}}, color={255,0,255}));
  connect(plaSta.y, pre1.u) annotation (Line(points={{162,80},{180,80},{180,140},
          {-190,140},{-190,120},{-182,120}}, color={255,0,255}));
  connect(pre1.y, not1.u)
    annotation (Line(points={{-158,120},{-142,120}}, color={255,0,255}));
  connect(pre1.y, enaTim.u)
    annotation (Line(points={{-158,120},{-150,120},{-150,-10},{-142,-10}},
      color={255,0,255}));
  connect(TOut, sub1.u2)
    annotation (Line(points={{-220,-150},{-150,-150},{-150,-136},{-142,-136}},
      color={0,0,127}));
  connect(chiLocOutTem.y, sub1.u1)
    annotation (Line(points={{-158,-110},{-150,-110},{-150,-124},{-142,-124}},
      color={0,0,127}));
  connect(sub1.y, hys.u)
    annotation (Line(points={{-118,-130},{-102,-130}}, color={0,0,127}));
  connect(hys.y, notLoc.u) annotation (Line(points={{-78,-130},{-60,-130},{-60,10},
          {-22,10}}, color={255,0,255}));
  connect(notLoc.y, enaPla.u[4]) annotation (Line(points={{2,10},{20,10},{20,82.625},
          {38,82.625}},color={255,0,255}));
  connect(disPla.y, plaSta.clr) annotation (Line(points={{122,-18},{130,-18},{
          130,74},{138,74}}, color={255,0,255}));
  connect(enaTim.passed, disPla.u1) annotation (Line(points={{-118,-18},{98,-18}},
          color={255,0,255}));
  connect(hys.y, or1.u2) annotation (Line(points={{-78,-130},{-60,-130},{-60,-108},
          {-22,-108}}, color={255,0,255}));
  connect(or1.y, disPlaCon.u2) annotation (Line(points={{2,-100},{20,-100},{20,-86},
          {58,-86}}, color={255,0,255}));
  connect(enaTim1.y, or1.u1) annotation (Line(points={{-78,-70},{-40,-70},{-40,-100},
          {-22,-100}}, color={255,0,255}));
annotation (
  defaultComponentName = "plaEna",
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-200,-180},{200,180}})),
  Icon(graphics={
        Text(
          extent={{-120,146},{100,108}},
          textColor={0,0,255},
          textString="%name"),
        Ellipse(extent={{-80,80},{80,-80}}, lineColor={28,108,200},fillColor={170,255,213},
          fillPattern=FillPattern.Solid),
        Ellipse(extent={{-90,90},{90,-90}}, lineColor={28,108,200}),
        Rectangle(extent={{-75,2},{75,-2}}, lineColor={28,108,200},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-66,46},{76,10}},
          textColor={28,108,200},
          textString="START"),
        Text(
          extent={{-66,-8},{76,-44}},
          textColor={28,108,200},
          textString="STOP")}),
 Documentation(info="<html>
<p>
Block that generate chiller plant enable signals and output the initial plant stage,
according to ASHRAE RP-1711 Advanced Sequences of Operation for HVAC Systems Phase II –
Central Plants and Hydronic Systems (Draft on March 23, 2020), section 5.2.2.1,
5.2.2.2 and 5.2.2.3.
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
The following state machine chart illustrates the transitions between plant enable and plant disable:
</p>
<p align=\"center\">
<img alt=\"Image of chiller plant enable-disable state machine chart\"
src=\"modelica://Buildings/Resources/Images/Controls/OBC/ASHRAE/PrimarySystem/ChillerPlant/Generic/PlantEnableStateGraph.png\"/>
</p>
</html>",
revisions="<html>
<ul>
<li>
January 19, 2021, by Milica Grahovac:<br/>
Added state chart illustration.
</li>
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
end Enable;
