within Buildings.Controls.OBC.ASHRAE.G36.Generic;
block TrimAndRespond "Block to inplement trim and respond logic"
  parameter Boolean have_hol=false
    "Set to true to allow holding the reset, false to continuously reset when enabled"
    annotation(Evaluate=true);
  parameter Real iniSet  "Initial setpoint";
  parameter Real minSet  "Minimum setpoint";
  parameter Real maxSet  "Maximum setpoint";
  parameter Real delTim(min=100*1E-15, unit="s")
                          "Delay time";
  parameter Real samplePeriod(min=1E-3, unit="s")
    "Sample period of component";
  parameter Integer numIgnReq  "Number of ignored requests";
  parameter Real triAmo  "Trim amount";
  parameter Real resAmo  "Respond amount (must have opposite sign of triAmo)";
  parameter Real maxRes  "Maximum response per time interval (must have same sign as resAmo)";
  parameter Real dtHol(
    min=0,
    start=0,
    unit="s")=0
    "Minimum hold time"
    annotation(Dialog(enable=have_hol));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput numOfReq
    "Number of requests from zones/systems"
    annotation (Placement(transformation(extent={{-260,-70},{-220,-30}}),
        iconTransformation(extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uDevSta
    "On/Off status of the associated device"
    annotation (Placement(transformation(extent={{-260,190},{-220,230}}),
        iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uHol if have_hol
    "Hold signal"
    annotation (Placement(
        transformation(extent={{-260,40},{-220,80}}), iconTransformation(extent={{-140,
            -20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput y
    "Setpoint that have been reset"
    annotation (Placement(transformation(extent={{220,190},{260,230}}),
        iconTransformation(extent={{100,-20},{140,20}})));

  Buildings.Controls.OBC.CDL.Logical.TrueDelay tim(
    final delayTime=delTim + samplePeriod,
    final delayOnInit=true)
    "Send an on signal after some delay time"
    annotation (Placement(transformation(extent={{-200,200},{-180,220}})));
  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold greThr
    "Check if the real requests is more than ignored requests setting"
    annotation (Placement(transformation(extent={{20,-100},{40,-80}})));
  Buildings.Controls.OBC.CDL.Reals.Switch netRes "Net setpoint reset value"
    annotation (Placement(transformation(extent={{160,-60},{180,-80}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant resAmoCon(
    final k=resAmo)
    "Respond amount constant"
    annotation (Placement(transformation(extent={{-200,-180},{-180,-160}})));
  Buildings.Controls.OBC.CDL.Reals.Multiply pro
    "Products of net requests and respond amount value"
    annotation (Placement(transformation(extent={{-20,-150},{0,-130}})));
  Buildings.Controls.OBC.CDL.Reals.Multiply pro1 "Product of trim and respond amount"
    annotation (Placement(transformation(extent={{-160,-150},{-140,-130}})));
  Buildings.Controls.OBC.CDL.Reals.Multiply pro2 "Product of respond and maximum amount"
    annotation (Placement(transformation(extent={{-160,-220},{-140,-200}})));
  Buildings.Controls.OBC.CDL.Discrete.UnitDelay uniDel(
    final samplePeriod=samplePeriod,
    final y_start=iniSet)
    "Output the input signal with a unit delay"
    annotation (Placement(transformation(extent={{-100,136},{-80,156}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi
    "Switch between initial setpoint and reseted setpoint"
    annotation (Placement(transformation(extent={{160,220},{180,200}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi1
    "Before instant (device ON + delTim + samplePeriod), the setpoint should not be trimmed"
    annotation (Placement(transformation(extent={{120,-40},{140,-20}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi2
    "Reinitialize setpoint to initial setting when device become OFF"
    annotation (Placement(transformation(extent={{100,170},{120,190}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi3 "Logical switch"
    annotation (Placement(transformation(extent={{120,-200},{140,-180}})));
  Buildings.Controls.OBC.CDL.Discrete.Sampler sampler(
    final samplePeriod=samplePeriod)
    "Sample number of requests"
    annotation (Placement(transformation(extent={{-160,-60},{-140,-40}})));
  Buildings.Controls.OBC.CDL.Reals.LessThreshold lesThr1
    "Check if trim and response amount have same sign"
    annotation (Placement(transformation(extent={{-120,-150},{-100,-130}})));
  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold greThr2
    "Check if trim and response amount have opposite sign"
    annotation (Placement(transformation(extent={{-120,-220},{-100,-200}})));
  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold greThr1
    "Check if response amount have positive sign"
    annotation (Placement(transformation(extent={{20,-200},{40,-180}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter gai(
    final k=-1) "Convert results back to negative"
    annotation (Placement(transformation(extent={{80,-230},{100,-210}})));
  CDL.Logical.Sources.Constant                fal(final k=false) if not
    have_hol "Constant"
    annotation (Placement(transformation(extent={{-200,10},{-180,30}})));
  CDL.Reals.Switch                        swiHol1
                                                 "Switch to fixed value during hold period"
    annotation (Placement(transformation(extent={{-28,26},{-8,46}})));
  CDL.Conversions.RealToInteger reaToInt
    annotation (Placement(transformation(extent={{-128,98},{-108,118}})));
  CDL.Integers.Change cha
    annotation (Placement(transformation(extent={{-100,98},{-80,118}})));
  CDL.Logical.Not not2
    annotation (Placement(transformation(extent={{-160,30},{-140,50}})));
  CDL.Logical.Latch lat
    annotation (Placement(transformation(extent={{-70,56},{-50,76}})));
  CDL.Logical.TrueHold holCha(duration=10)
    annotation (Placement(transformation(extent={{-66,100},{-46,120}})));
protected
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant iniSetCon(k=iniSet)
    "Initial setpoint"
    annotation (Placement(transformation(extent={{-100,220},{-80,240}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant numIgnReqCon(k=numIgnReq)
    "Number of ignored requests"
    annotation (Placement(transformation(extent={{-160,-98},{-140,-78}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant triAmoCon(k=triAmo)
    "Trim amount constant"
    annotation (Placement(transformation(extent={{-200,-130},{-180,-110}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant maxResCon(k=maxRes)
    "Maximum response per time interval"
    annotation (Placement(transformation(extent={{-200,-250},{-180,-230}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant maxSetCon(k=maxSet)
    "Maximum setpoint constant"
    annotation (Placement(transformation(extent={{-28,100},{-8,120}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant zerTri(k=0)
    "Zero reset amount during time range from (device ON) to (device ON + delTim + timSet)"
    annotation (Placement(transformation(extent={{60,-60},{80,-40}})));
  Buildings.Controls.OBC.CDL.Conversions.IntegerToReal intToRea
    "Convert integer input to real output"
    annotation (Placement(transformation(extent={{-200,-60},{-180,-40}})));
  Buildings.Controls.OBC.CDL.Reals.Subtract difReqIgnReq
    "Difference between ignored request number and the real request number"
    annotation (Placement(transformation(extent={{-100,-80},{-80,-60}})));
  Buildings.Controls.OBC.CDL.Reals.Add add1
    "Increase setpoint by amount of value defined from reset logic"
    annotation (Placement(transformation(extent={{-28,130},{-8,150}})));
  Buildings.Controls.OBC.CDL.Reals.Add add2 "Net reset value"
    annotation (Placement(transformation(extent={{120,-136},{140,-116}})));
  Buildings.Controls.OBC.CDL.Reals.Min minInp
    "Total response should not be more than maximum response"
    annotation (Placement(transformation(extent={{20,-170},{40,-150}})));
  Buildings.Controls.OBC.CDL.Reals.Min min1
    "Reset setpoint should not be higher than the maximum setpoint"
    annotation (Placement(transformation(extent={{12,130},{32,150}})));
  Buildings.Controls.OBC.CDL.Logical.And and2
    "After (device ON + delTim + timSta), when request number becomes more than ignored requests number"
    annotation (Placement(transformation(extent={{120,-80},{140,-60}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1 "Logical Not"
    annotation (Placement(transformation(extent={{-100,170},{-80,190}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant minSetCon(k=minSet)
    "Minimum setpoint constant"
    annotation (Placement(transformation(extent={{12,100},{32,120}})));
  Buildings.Controls.OBC.CDL.Reals.Max maxInp
    "Reset setpoint should not be lower than the minimum setpoint"
    annotation (Placement(transformation(extent={{52,130},{72,150}})));
  Buildings.Controls.OBC.CDL.Utilities.Assert assMes(
    final message="Trim amount 'triAmo' and respond amount 'resAmo' must have opposite signs.")
    "Generate alarm message"
    annotation (Placement(transformation(extent={{-80,-150},{-60,-130}})));
  Buildings.Controls.OBC.CDL.Utilities.Assert assMes2(
    final message="Respond amount 'resAmo' and maximum respond amount 'maxRes' must have same sign.")
    "Generate alarm message"
    annotation (Placement(transformation(extent={{-80,-220},{-60,-200}})));
  Buildings.Controls.OBC.CDL.Reals.Abs abs "Absolute value of real input"
    annotation (Placement(transformation(extent={{-120,-180},{-100,-160}})));
  Buildings.Controls.OBC.CDL.Reals.Abs abs1 "Absolute value of real input"
    annotation (Placement(transformation(extent={{-120,-250},{-100,-230}})));
protected
  CDL.Reals.Sources.Constant zer(final k=0) "Constant"
    annotation (Placement(transformation(extent={{-200,94},{-180,114}})));
equation
  connect(difReqIgnReq.y, greThr.u)
    annotation (Line(points={{-78,-70},{-40,-70},{-40,-90},{18,-90}},
      color={0,0,127}));
  connect(pro.y, minInp.u1)
    annotation (Line(points={{2,-140},{10,-140},{10,-154},{18,-154}},
      color={0,0,127}));
  connect(triAmoCon.y, add2.u1)
    annotation (Line(points={{-178,-120},{118,-120}},
      color={0,0,127}));
  connect(add2.y, netRes.u1)
    annotation (Line(points={{142,-126},{150,-126},{150,-78},{158,-78}},
      color={0,0,127}));
  connect(iniSetCon.y, swi.u3)
    annotation (Line(points={{-78,230},{80,230},{80,218},{158,218}},
      color={0,0,127}));
  connect(swi.y, y)
    annotation (Line(points={{182,210},{240,210}},
      color={0,0,127}));
  connect(maxSetCon.y, min1.u2)
    annotation (Line(points={{-6,110},{6,110},{6,134},{10,134}},
      color={0,0,127}));
  connect(add1.y, min1.u1)
    annotation (Line(points={{-6,140},{6,140},{6,146},{10,146}},
      color={0,0,127}));
  connect(triAmoCon.y, swi1.u1)
    annotation (Line(points={{-178,-120},{100,-120},{100,-22},{118,-22}},
      color={0,0,127}));
  connect(zerTri.y, swi1.u3)
    annotation (Line(points={{82,-50},{110,-50},{110,-38},{118,-38}},
      color={0,0,127}));
  connect(greThr.y, and2.u2)
    annotation (Line(points={{42,-90},{60,-90},{60,-78},{118,-78}},
      color={255,0,255}));
  connect(and2.y, netRes.u2)
    annotation (Line(points={{142,-70},{158,-70}},
      color={255,0,255}));
  connect(iniSetCon.y, swi2.u1)
    annotation (Line(points={{-78,230},{80,230},{80,188},{98,188}},
      color={0,0,127}));
  connect(swi2.y, swi.u1)
    annotation (Line(points={{122,180},{140,180},{140,202},{158,202}},
      color={0,0,127}));
  connect(uDevSta, not1.u)
    annotation (Line(points={{-240,210},{-210,210},{-210,180},{-102,180}},
      color={255,0,255}));
  connect(not1.y, swi2.u2)
    annotation (Line(points={{-78,180},{98,180}},
      color={255,0,255}));
  connect(min1.y, maxInp.u1)
    annotation (Line(points={{34,140},{42,140},{42,146},{50,146}},
      color={0,0,127}));
  connect(minSetCon.y, maxInp.u2)
    annotation (Line(points={{34,110},{42,110},{42,134},{50,134}},
      color={0,0,127}));
  connect(numOfReq, intToRea.u)
    annotation (Line(points={{-240,-50},{-202,-50}}, color={255,127,0}));
  connect(intToRea.y, sampler.u)
    annotation (Line(points={{-178,-50},{-162,-50}}, color={0,0,127}));
  connect(difReqIgnReq.y, pro.u1)
    annotation (Line(points={{-78,-70},{-40,-70},{-40,-134},{-22,-134}},
      color={0,0,127}));
  connect(uDevSta, tim.u)
    annotation (Line(points={{-240,210},{-202,210}}, color={255,0,255}));
  connect(tim.y, swi.u2)
    annotation (Line(points={{-178,210},{158,210}}, color={255,0,255}));
  connect(tim.y, swi1.u2)
    annotation (Line(points={{-178,210},{0,210},{0,-30},{118,-30}},
      color={255,0,255}));
  connect(and2.u1, tim.y)
    annotation (Line(points={{118,-70},{0,-70},{0,210},{-178,210}},
                   color={255,0,255}));
  connect(maxInp.y, swi2.u3)
    annotation (Line(points={{74,140},{80,140},{80,172},{98,172}}, color={0,0,127}));
  connect(triAmoCon.y, pro1.u1)
    annotation (Line(points={{-178,-120},{-170,-120},{-170,-134},{-162,-134}},
      color={0,0,127}));
  connect(resAmoCon.y, pro1.u2)
    annotation (Line(points={{-178,-170},{-170,-170},{-170,-146},{-162,-146}},
      color={0,0,127}));
  connect(pro1.y, lesThr1.u)
    annotation (Line(points={{-138,-140},{-122,-140}}, color={0,0,127}));
  connect(lesThr1.y, assMes.u)
    annotation (Line(points={{-98,-140},{-82,-140}}, color={255,0,255}));
  connect(resAmoCon.y, pro2.u1)
    annotation (Line(points={{-178,-170},{-170,-170},{-170,-204},{-162,-204}},
      color={0,0,127}));
  connect(maxResCon.y, pro2.u2)
    annotation (Line(points={{-178,-240},{-170,-240},{-170,-216},{-162,-216}},
      color={0,0,127}));
  connect(pro2.y, greThr2.u)
    annotation (Line(points={{-138,-210},{-122,-210}}, color={0,0,127}));
  connect(greThr2.y, assMes2.u)
    annotation (Line(points={{-98,-210},{-82,-210}}, color={255,0,255}));
  connect(resAmoCon.y, abs.u)
    annotation (Line(points={{-178,-170},{-122,-170}}, color={0,0,127}));
  connect(abs.y, pro.u2)
    annotation (Line(points={{-98,-170},{-40,-170},{-40,-146},{-22,-146}},
      color={0,0,127}));
  connect(maxResCon.y, abs1.u)
    annotation (Line(points={{-178,-240},{-122,-240}}, color={0,0,127}));
  connect(abs1.y, minInp.u2)
    annotation (Line(points={{-98,-240},{-20,-240},{-20,-166},{18,-166}},
      color={0,0,127}));
  connect(minInp.y, swi3.u1)
    annotation (Line(points={{42,-160},{60,-160},{60,-182},{118,-182}},
      color={0,0,127}));
  connect(resAmoCon.y, greThr1.u)
    annotation (Line(points={{-178,-170},{-170,-170},{-170,-190},{18,-190}},
      color={0,0,127}));
  connect(greThr1.y, swi3.u2)
    annotation (Line(points={{42,-190},{118,-190}}, color={255,0,255}));
  connect(swi1.y, netRes.u3)
    annotation (Line(points={{142,-30},{150,-30},{150,-62},{158,-62}},
                                                                     color={0,0,127}));
  connect(minInp.y, gai.u)
    annotation (Line(points={{42,-160},{60,-160},{60,-220},{78,-220}}, color={0,0,127}));
  connect(gai.y, swi3.u3)
    annotation (Line(points={{102,-220},{110,-220},{110,-198},{118,-198}},
      color={0,0,127}));
  connect(swi3.y, add2.u2)
    annotation (Line(points={{142,-190},{160,-190},{160,-160},{100,-160},{100,-132},
          {118,-132}},      color={0,0,127}));
  connect(sampler.y, difReqIgnReq.u1)
    annotation (Line(points={{-138,-50},{-120,-50},{-120,-64},{-102,-64}},
      color={0,0,127}));

  connect(numIgnReqCon.y, difReqIgnReq.u2) annotation (Line(points={{-138,-88},
          {-120,-88},{-120,-76},{-102,-76}}, color={0,0,127}));
  connect(netRes.y, swiHol1.u3) annotation (Line(points={{182,-70},{190,-70},{
          190,20},{-100,20},{-100,28},{-30,28}}, color={0,0,127}));
  connect(swiHol1.y, add1.u2) annotation (Line(points={{-6,36},{4,36},{4,34},{
          12,34},{12,134},{-30,134}}, color={0,0,127}));
  connect(swi2.y, uniDel.u) annotation (Line(points={{122,180},{140,180},{140,
          202},{-120,202},{-120,146},{-102,146}}, color={0,0,127}));
  connect(uniDel.y, add1.u1)
    annotation (Line(points={{-78,146},{-30,146}}, color={0,0,127}));
  connect(uniDel.u, reaToInt.u) annotation (Line(points={{-102,146},{-140,146},
          {-140,108},{-130,108}}, color={0,0,127}));
  connect(reaToInt.y, cha.u)
    annotation (Line(points={{-106,108},{-102,108}}, color={255,127,0}));
  connect(zer.y, swiHol1.u1) annotation (Line(points={{-178,104},{-130,104},{
          -130,44},{-30,44}}, color={0,0,127}));
  connect(fal.y, not2.u) annotation (Line(points={{-178,20},{-170,20},{-170,40},
          {-162,40}}, color={255,0,255}));
  connect(cha.y, lat.u) annotation (Line(points={{-78,108},{-76,108},{-76,66},{
          -72,66}}, color={255,0,255}));
  connect(not2.y, lat.clr) annotation (Line(points={{-138,40},{-104,40},{-104,
          60},{-72,60}}, color={255,0,255}));
  connect(lat.y, swiHol1.u2) annotation (Line(points={{-48,66},{-40,66},{-40,36},
          {-30,36}}, color={255,0,255}));
  connect(cha.y, holCha.u) annotation (Line(points={{-78,108},{-74,108},{-74,
          110},{-68,110}}, color={255,0,255}));
  connect(uHol, not2.u) annotation (Line(points={{-240,60},{-180,60},{-180,40},
          {-162,40}}, color={255,0,255}));
annotation (
  defaultComponentName = "triRes",
  Icon(coordinateSystem(extent={{-100,-100},{100,100}}),
       graphics={Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={223,211,169},
        lineThickness=5.0,
        borderPattern=BorderPattern.Raised,
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-114,146},{106,108}},
          textColor={0,0,255},
          textString="%name"),
        Text(
          extent={{-88,58},{90,-42}},
          textColor={192,192,192},
          textString="Trim & Respond")}),
   Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-220,-260},{220,
            260}}),
           graphics={
        Rectangle(
          extent={{-218,0},{218,-258}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-218,258},{218,82}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Text(
          extent={{-214,162},{-124,138}},
          textColor={0,0,255},
          horizontalAlignment=TextAlignment.Left,
          textString="Check device status,
Count time"), Text(
          extent={{-214,0},{-108,-28}},
          textColor={0,0,255},
          horizontalAlignment=TextAlignment.Left,
          textString="Reset setpoint based
on request number")}),
   Documentation(info="<html>
<p>
This block implements the trim and respond logic according to ASHRAE guideline G36,
Section 5.1.14.3 and 5.1.14.4.
</p>
<p>
For each upstream system or plant set point being controlled by a trim and respond
loop, define the initial values in system or plant sequences. Values for trim,
respond, time step, etc. shall be tuned to provide stable control.
</p>
<table summary=\"summary\" border=\"1\">
<tr><th> Variable </th> <th> Value </th> <th> Definition </th> </tr>
<tr><td>Device</td><td>AHU Supply Fan</td> <td>Associated device</td></tr>
<tr><td>SP0</td><td><code>iniSet</code></td><td>Initial setpoint</td></tr>
<tr><td>SPmin</td><td><code>minSet</code></td><td>Minimum setpoint</td></tr>
<tr><td>SPmax</td><td><code>maxSet</code></td><td>Maximum setpoint</td></tr>
<tr><td>Td</td><td><code>delTim</code></td><td>Delay timer</td></tr>
<tr><td>T</td><td><code>samplePeriod</code></td><td>Time step</td></tr>
<tr><td>I</td><td><code>numIgnReq</code></td><td>Number of ignored requests</td></tr>
<tr><td>R</td><td><code>numOfReq</code></td><td>Number of requests</td></tr>
<tr><td>SPtrim</td><td><code>triAmo</code></td><td>Trim amount</td></tr>
<tr><td>SPres</td><td><code>resAmo</code></td><td>Respond amount</td></tr>
<tr><td>SPres_max</td><td><code>maxRes</code></td><td>Maximum response per time interval</td></tr>
</table>
<p>
The trim and respond logic shall reset setpoint within the range <code>minSet</code> to
<code>maxSet</code>.
When the associated device is off (<code>uDevSta=false</code>), the setpoint
shall be <code>iniSet</code>.
The reset logic shall be active while the associated device is proven
on (<code>uDevSta=true</code>), starting <code>delTim</code> after initial
device start command.
When active, every time step <code>samplePeriod</code>, trim the setpoint by
<code>triAmo</code>.
If there are more than <code>numIgnReq</code> requests, respond by changing
the setpoint by <code>resAmo*(numOfReq-numIgnReq)</code>, i.e., the number of
requests minus the number of ignored requests, but no more than <code>maxRes</code>.
</p>
<p>
In other words, every time step <code>samplePeriod</code>:
</p>
<ul>
<li>Change setpoint by <code>triAmo</code>; </li>
<li>If <code>numOfReq > numIgnReq</code>, <i>also</i> change setpoint by <code>resAmo*(numOfReq
-numIgnReq)</code> but no more than <code>maxRes</code>.
</li>
</ul>
<p align=\"center\">
<img alt=\"Image of set point reset\"
src=\"modelica://Buildings/Resources/Images/Controls/OBC/ASHRAE/G36/Generic/TrimRespond.png\"/>
</p>
</html>", revisions="<html>
<ul>
<li>
June 3, 2020, by Jianjun Hu:<br/>
Upgraded according to G36 official release.
</li>
<li>
April 13, 2020, by Jianjun Hu:<br/>
Corrected to delay the true initial device status.
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1876\">#1876</a>.
</li>
<li>
August 28, 2019, by Jianjun Hu:<br/>
Added assertions and corrected implementation when response amount is negative.
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1530\">#1503</a>.
</li>
<li>
July 10, 2017, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end TrimAndRespond;
