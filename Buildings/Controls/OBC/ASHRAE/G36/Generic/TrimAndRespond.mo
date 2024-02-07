within Buildings.Controls.OBC.ASHRAE.G36.Generic;
block TrimAndRespond "Block to inplement trim and respond logic"
  parameter Real iniSet  "Initial setpoint";
  parameter Real minSet  "Minimum setpoint";
  parameter Real maxSet  "Maximum setpoint";
  parameter Real delTim(
    final unit="s",
    final quantity="Time",
    final min=100*1E-15)  "Delay time";
  parameter Real samplePeriod(
    final unit="s",
    final quantity="Time",
    final min=1E-3)
    "Sample period of component";
  parameter Integer numIgnReq  "Number of ignored requests";
  parameter Real triAmo  "Trim amount";
  parameter Real resAmo  "Respond amount (must have opposite sign of triAmo)";
  parameter Real maxRes  "Maximum response per time interval (must have same sign as resAmo)";

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput numOfReq
    "Number of requests from zones/systems"
    annotation (Placement(transformation(extent={{-260,-30},{-220,10}}),
        iconTransformation(extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uDevSta
    "On/Off status of the associated device"
    annotation (Placement(transformation(extent={{-260,150},{-220,190}}),
        iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput y
    "Setpoint that have been reset"
    annotation (Placement(transformation(extent={{220,150},{260,190}}),
        iconTransformation(extent={{100,-20},{140,20}})));

  Buildings.Controls.OBC.CDL.Logical.TrueDelay tim(
    final delayTime=delTim + samplePeriod,
    final delayOnInit=true)
    "Send an on signal after some delay time"
    annotation (Placement(transformation(extent={{-200,160},{-180,180}})));
  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold greThr
    "Check if the real requests is more than ignored requests setting"
    annotation (Placement(transformation(extent={{20,-60},{40,-40}})));
  Buildings.Controls.OBC.CDL.Reals.Switch netRes "Net setpoint reset value"
    annotation (Placement(transformation(extent={{160,-20},{180,-40}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant resAmoCon(
    final k=resAmo)
    "Respond amount constant"
    annotation (Placement(transformation(extent={{-200,-140},{-180,-120}})));
  Buildings.Controls.OBC.CDL.Reals.Multiply pro
    "Products of net requests and respond amount value"
    annotation (Placement(transformation(extent={{-20,-110},{0,-90}})));
  Buildings.Controls.OBC.CDL.Reals.Multiply pro1 "Product of trim and respond amount"
    annotation (Placement(transformation(extent={{-160,-110},{-140,-90}})));
  Buildings.Controls.OBC.CDL.Reals.Multiply pro2 "Product of respond and maximum amount"
    annotation (Placement(transformation(extent={{-160,-180},{-140,-160}})));
  Buildings.Controls.OBC.CDL.Discrete.UnitDelay uniDel(
    final samplePeriod=samplePeriod,
    final y_start=iniSet)
    "Output the input signal with a unit delay"
    annotation (Placement(transformation(extent={{-100,96},{-80,116}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi
    "Switch between initial setpoint and reseted setpoint"
    annotation (Placement(transformation(extent={{160,180},{180,160}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi1
    "Before instant (device ON + delTim + samplePeriod), the setpoint should not be trimmed"
    annotation (Placement(transformation(extent={{120,0},{140,20}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi2
    "Reinitialize setpoint to initial setting when device become OFF"
    annotation (Placement(transformation(extent={{100,130},{120,150}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi3 "Logical switch"
    annotation (Placement(transformation(extent={{120,-160},{140,-140}})));
  Buildings.Controls.OBC.CDL.Discrete.Sampler sampler(
    final samplePeriod=samplePeriod)
    "Sample number of requests"
    annotation (Placement(transformation(extent={{-160,-20},{-140,0}})));
  Buildings.Controls.OBC.CDL.Reals.LessThreshold lesThr1
    "Check if trim and response amount have same sign"
    annotation (Placement(transformation(extent={{-120,-110},{-100,-90}})));
  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold greThr2
    "Check if trim and response amount have opposite sign"
    annotation (Placement(transformation(extent={{-120,-180},{-100,-160}})));
  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold greThr1
    "Check if response amount have positive sign"
    annotation (Placement(transformation(extent={{20,-160},{40,-140}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter gai(
    final k=-1) "Convert results back to negative"
    annotation (Placement(transformation(extent={{80,-190},{100,-170}})));

protected
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant iniSetCon(k=iniSet)
    "Initial setpoint"
    annotation (Placement(transformation(extent={{-100,180},{-80,200}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant numIgnReqCon(k=numIgnReq)
    "Number of ignored requests"
    annotation (Placement(transformation(extent={{-160,-60},{-140,-40}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant triAmoCon(k=triAmo)
    "Trim amount constant"
    annotation (Placement(transformation(extent={{-200,-90},{-180,-70}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant maxResCon(k=maxRes)
    "Maximum response per time interval"
    annotation (Placement(transformation(extent={{-200,-210},{-180,-190}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant maxSetCon(k=maxSet)
    "Maximum setpoint constant"
    annotation (Placement(transformation(extent={{-40,60},{-20,80}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant zerTri(k=0)
    "Zero reset amount during time range from (device ON) to (device ON + delTim + timSet)"
    annotation (Placement(transformation(extent={{60,-20},{80,0}})));
  Buildings.Controls.OBC.CDL.Conversions.IntegerToReal intToRea
    "Convert integer input to real output"
    annotation (Placement(transformation(extent={{-200,-20},{-180,0}})));
  Buildings.Controls.OBC.CDL.Reals.Subtract difReqIgnReq
    "Difference between ignored request number and the real request number"
    annotation (Placement(transformation(extent={{-100,-40},{-80,-20}})));
  Buildings.Controls.OBC.CDL.Reals.Add add1
    "Increase setpoint by amount of value defined from reset logic"
    annotation (Placement(transformation(extent={{-40,90},{-20,110}})));
  Buildings.Controls.OBC.CDL.Reals.Add add2 "Net reset value"
    annotation (Placement(transformation(extent={{120,-96},{140,-76}})));
  Buildings.Controls.OBC.CDL.Reals.Min minInp
    "Total response should not be more than maximum response"
    annotation (Placement(transformation(extent={{20,-130},{40,-110}})));
  Buildings.Controls.OBC.CDL.Reals.Min min1
    "Reset setpoint should not be higher than the maximum setpoint"
    annotation (Placement(transformation(extent={{0,90},{20,110}})));
  Buildings.Controls.OBC.CDL.Logical.And and2
    "After (device ON + delTim + timSta), when request number becomes more than ignored requests number"
    annotation (Placement(transformation(extent={{120,-40},{140,-20}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1 "Logical Not"
    annotation (Placement(transformation(extent={{-100,130},{-80,150}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant minSetCon(k=minSet)
    "Minimum setpoint constant"
    annotation (Placement(transformation(extent={{0,60},{20,80}})));
  Buildings.Controls.OBC.CDL.Reals.Max maxInp
    "Reset setpoint should not be lower than the minimum setpoint"
    annotation (Placement(transformation(extent={{40,90},{60,110}})));
  Buildings.Controls.OBC.CDL.Utilities.Assert assMes(
    final message="Trim amount 'triAmo' and respond amount 'resAmo' must have opposite signs.")
    "Generate alarm message"
    annotation (Placement(transformation(extent={{-80,-110},{-60,-90}})));
  Buildings.Controls.OBC.CDL.Utilities.Assert assMes2(
    final message="Respond amount 'resAmo' and maximum respond amount 'maxRes' must have same sign.")
    "Generate alarm message"
    annotation (Placement(transformation(extent={{-80,-180},{-60,-160}})));
  Buildings.Controls.OBC.CDL.Reals.Abs abs "Absolute value of real input"
    annotation (Placement(transformation(extent={{-120,-140},{-100,-120}})));
  Buildings.Controls.OBC.CDL.Reals.Abs abs1 "Absolute value of real input"
    annotation (Placement(transformation(extent={{-120,-210},{-100,-190}})));

equation
  connect(difReqIgnReq.y, greThr.u)
    annotation (Line(points={{-78,-30},{-40,-30},{-40,-50},{18,-50}},
      color={0,0,127}));
  connect(pro.y, minInp.u1)
    annotation (Line(points={{2,-100},{10,-100},{10,-114},{18,-114}},
      color={0,0,127}));
  connect(triAmoCon.y, add2.u1)
    annotation (Line(points={{-178,-80},{118,-80}},
      color={0,0,127}));
  connect(add2.y, netRes.u1)
    annotation (Line(points={{142,-86},{150,-86},{150,-38},{158,-38}},
      color={0,0,127}));
  connect(iniSetCon.y, swi.u3)
    annotation (Line(points={{-78,190},{80,190},{80,178},{158,178}},
      color={0,0,127}));
  connect(swi.y, y)
    annotation (Line(points={{182,170},{240,170}},
      color={0,0,127}));
  connect(maxSetCon.y, min1.u2)
    annotation (Line(points={{-18,70},{-10,70},{-10,94},{-2,94}},
      color={0,0,127}));
  connect(add1.y, min1.u1)
    annotation (Line(points={{-18,100},{-10,100},{-10,106},{-2,106}},
      color={0,0,127}));
  connect(uniDel.y, add1.u1)
    annotation (Line(points={{-78,106},{-42,106}},
      color={0,0,127}));
  connect(triAmoCon.y, swi1.u1)
    annotation (Line(points={{-178,-80},{0,-80},{0,18},{118,18}},
      color={0,0,127}));
  connect(zerTri.y, swi1.u3)
    annotation (Line(points={{82,-10},{100,-10},{100,2},{118,2}},
      color={0,0,127}));
  connect(greThr.y, and2.u2)
    annotation (Line(points={{42,-50},{60,-50},{60,-38},{118,-38}},
      color={255,0,255}));
  connect(and2.y, netRes.u2)
    annotation (Line(points={{142,-30},{158,-30}},
      color={255,0,255}));
  connect(iniSetCon.y, swi2.u1)
    annotation (Line(points={{-78,190},{80,190},{80,148},{98,148}},
      color={0,0,127}));
  connect(swi2.y, swi.u1)
    annotation (Line(points={{122,140},{140,140},{140,162},{158,162}},
      color={0,0,127}));
  connect(swi2.y, uniDel.u)
    annotation (Line(points={{122,140},{140,140},{140,160},{-120,160},
      {-120,106},{-102,106}}, color={0,0,127}));
  connect(uDevSta, not1.u)
    annotation (Line(points={{-240,170},{-210,170},{-210,140},{-102,140}},
      color={255,0,255}));
  connect(not1.y, swi2.u2)
    annotation (Line(points={{-78,140},{98,140}},
      color={255,0,255}));
  connect(min1.y, maxInp.u1)
    annotation (Line(points={{22,100},{30,100},{30,106},{38,106}},
      color={0,0,127}));
  connect(minSetCon.y, maxInp.u2)
    annotation (Line(points={{22,70},{30,70},{30,94},{38,94}},
      color={0,0,127}));
  connect(numOfReq, intToRea.u)
    annotation (Line(points={{-240,-10},{-202,-10}}, color={255,127,0}));
  connect(intToRea.y, sampler.u)
    annotation (Line(points={{-178,-10},{-162,-10}}, color={0,0,127}));
  connect(difReqIgnReq.y, pro.u1)
    annotation (Line(points={{-78,-30},{-40,-30},{-40,-94},{-22,-94}},
      color={0,0,127}));
  connect(uDevSta, tim.u)
    annotation (Line(points={{-240,170},{-202,170}}, color={255,0,255}));
  connect(tim.y, swi.u2)
    annotation (Line(points={{-178,170},{158,170}}, color={255,0,255}));
  connect(tim.y, swi1.u2)
    annotation (Line(points={{-178,170},{-140,170},{-140,10},{118,10}},
      color={255,0,255}));
  connect(and2.u1, tim.y)
    annotation (Line(points={{118,-30},{-20,-30},{-20,10},{-140,10},{-140,170},
      {-178,170}}, color={255,0,255}));
  connect(maxInp.y, swi2.u3)
    annotation (Line(points={{62,100},{80,100},{80,132},{98,132}}, color={0,0,127}));
  connect(triAmoCon.y, pro1.u1)
    annotation (Line(points={{-178,-80},{-170,-80},{-170,-94},{-162,-94}},
      color={0,0,127}));
  connect(resAmoCon.y, pro1.u2)
    annotation (Line(points={{-178,-130},{-170,-130},{-170,-106},{-162,-106}},
      color={0,0,127}));
  connect(pro1.y, lesThr1.u)
    annotation (Line(points={{-138,-100},{-122,-100}}, color={0,0,127}));
  connect(lesThr1.y, assMes.u)
    annotation (Line(points={{-98,-100},{-82,-100}}, color={255,0,255}));
  connect(resAmoCon.y, pro2.u1)
    annotation (Line(points={{-178,-130},{-170,-130},{-170,-164},{-162,-164}},
      color={0,0,127}));
  connect(maxResCon.y, pro2.u2)
    annotation (Line(points={{-178,-200},{-170,-200},{-170,-176},{-162,-176}},
      color={0,0,127}));
  connect(pro2.y, greThr2.u)
    annotation (Line(points={{-138,-170},{-122,-170}}, color={0,0,127}));
  connect(greThr2.y, assMes2.u)
    annotation (Line(points={{-98,-170},{-82,-170}}, color={255,0,255}));
  connect(resAmoCon.y, abs.u)
    annotation (Line(points={{-178,-130},{-122,-130}}, color={0,0,127}));
  connect(abs.y, pro.u2)
    annotation (Line(points={{-98,-130},{-40,-130},{-40,-106},{-22,-106}},
      color={0,0,127}));
  connect(maxResCon.y, abs1.u)
    annotation (Line(points={{-178,-200},{-122,-200}}, color={0,0,127}));
  connect(abs1.y, minInp.u2)
    annotation (Line(points={{-98,-200},{-20,-200},{-20,-126},{18,-126}},
      color={0,0,127}));
  connect(minInp.y, swi3.u1)
    annotation (Line(points={{42,-120},{60,-120},{60,-142},{118,-142}},
      color={0,0,127}));
  connect(resAmoCon.y, greThr1.u)
    annotation (Line(points={{-178,-130},{-170,-130},{-170,-150},{18,-150}},
      color={0,0,127}));
  connect(greThr1.y, swi3.u2)
    annotation (Line(points={{42,-150},{118,-150}}, color={255,0,255}));
  connect(netRes.y, add1.u2)
    annotation (Line(points={{182,-30},{200,-30},{200,36},{-60,36},{-60,94},
      {-42,94}},  color={0,0,127}));
  connect(swi1.y, netRes.u3)
    annotation (Line(points={{142,10},{150,10},{150,-22},{158,-22}}, color={0,0,127}));
  connect(minInp.y, gai.u)
    annotation (Line(points={{42,-120},{60,-120},{60,-180},{78,-180}}, color={0,0,127}));
  connect(gai.y, swi3.u3)
    annotation (Line(points={{102,-180},{110,-180},{110,-158},{118,-158}},
      color={0,0,127}));
  connect(swi3.y, add2.u2)
    annotation (Line(points={{142,-150},{160,-150},{160,-120},{100,-120},
      {100,-92},{118,-92}}, color={0,0,127}));
  connect(sampler.y, difReqIgnReq.u1)
    annotation (Line(points={{-138,-10},{-120,-10},{-120,-24},{-102,-24}},
      color={0,0,127}));
  connect(numIgnReqCon.y, difReqIgnReq.u2)
    annotation (Line(points={{-138,-50},{-120,-50},{-120,-36},{-102,-36}},
      color={0,0,127}));

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
   Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-220,-220},{220,
            220}}),
           graphics={
        Rectangle(
          extent={{-218,28},{218,-218}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-218,218},{218,42}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Text(
          extent={{-214,122},{-124,98}},
          textColor={0,0,255},
          horizontalAlignment=TextAlignment.Left,
          textString="Check device status,
Count time"), Text(
          extent={{-216,32},{-110,4}},
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
