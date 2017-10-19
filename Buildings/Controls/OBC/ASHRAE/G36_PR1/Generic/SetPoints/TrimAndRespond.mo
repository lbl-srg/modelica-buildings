within Buildings.Controls.OBC.ASHRAE.G36_PR1.Generic.SetPoints;
block TrimAndRespond "Block to inplement trim and respond logic"
  parameter Real iniSet  "Initial setpoint";
  parameter Real minSet  "Minimum setpoint";
  parameter Real maxSet  "Maximum setpoint";
  parameter Modelica.SIunits.Time delTim(min=100*1E-15)  "Delay time";
  parameter Modelica.SIunits.Time samplePeriod(min=1E-3)
    "Sample period of component";
  parameter Integer numIgnReq  "Number of ignored requests";
  parameter Real triAmo  "Trim amount";
  parameter Real resAmo  "Respond amount (must have opposite sign of triAmo)";
  parameter Real maxRes  "Maximum response per time interval (must have same sign as resAmo)";

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput numOfReq
    "Number of requests from zones/systems"
    annotation (Placement(transformation(extent={{-240,-110},{-200,-70}}),
      iconTransformation(extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uDevSta
    "On/Off status of the associated device"
    annotation (Placement(transformation(extent={{-240,110},{-200,150}}),
      iconTransformation(extent={{-140,60},{-100,100}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput y
    "Setpoint that have been reset"
    annotation (Placement(transformation(extent={{200,-10},{220,10}}),
      iconTransformation(extent={{100,-10},{120,10}})));

  Buildings.Controls.OBC.CDL.Logical.TrueDelay tim(
    final delayTime=delTim + samplePeriod)
    "Send an on signal after some delay time"
    annotation (Placement(transformation(extent={{-180,120},{-160,140}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterEqualThreshold greThr
    "Check if the real requests is more than ignored requests setting"
    annotation (Placement(transformation(extent={{20,-100},{40,-80}})));
  Buildings.Controls.OBC.CDL.Logical.Switch netRes "Net setpoint reset value"
    annotation (Placement(transformation(extent={{140,-60},{160,-80}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant resAmoCon(k=resAmo)
    "Respond amount constant"
    annotation (Placement(transformation(extent={{-80,-160},{-60,-140}})));
  Buildings.Controls.OBC.CDL.Continuous.Product pro
    "Products of net requests and respond amount value"
    annotation (Placement(transformation(extent={{-20,-140},{0,-120}})));
  Buildings.Controls.OBC.CDL.Discrete.UnitDelay uniDel(
    final samplePeriod=samplePeriod,
    final y_start=iniSet)
    "Output the input signal with a unit delay"
    annotation (Placement(transformation(extent={{-80,50},{-60,70}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi
    "Switch between initial setpoint and reseted setpoint"
    annotation (Placement(transformation(extent={{160,140},{180,120}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi1
    "Before instant (device ON + delTim + samplePeriod), the setpoint should not be trimmed"
    annotation (Placement(transformation(extent={{80,-40},{100,-20}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi2
    "Reinitialize setpoint to initial setting when device become OFF"
    annotation (Placement(transformation(extent={{120,90},{140,110}})));
  Buildings.Controls.OBC.CDL.Discrete.Sampler sampler(samplePeriod=samplePeriod)
    "Sample number of requests"
    annotation (Placement(transformation(extent={{-140,-100},{-120,-80}})));

protected
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant iniSetCon(k=iniSet)
    "Initial setpoint"
    annotation (Placement(transformation(extent={{-80,140},{-60,160}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant numIgnReqCon(k=numIgnReq)
    "Number of ignored requests"
    annotation (Placement(transformation(extent={{-140,-60},{-120,-40}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant triAmoCon(k=triAmo)
    "Trim amount constant"
    annotation (Placement(transformation(extent={{-80,-120},{-60,-100}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant maxResCon(k=maxRes)
    "Maximum response per time interval"
    annotation (Placement(transformation(extent={{-20,-180},{0,-160}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant maxSetCon(k=maxSet)
    "Maximum setpoint constant"
    annotation (Placement(transformation(extent={{-20,20},{0,40}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zerTri(k=0)
    "Zero reset amount during time range from (device ON) to (device ON + delTim + timSet)"
    annotation (Placement(transformation(extent={{20,-60},{40,-40}})));
  Buildings.Controls.OBC.CDL.Conversions.IntegerToReal intToRea
    "Convert integer input to real output"
    annotation (Placement(transformation(extent={{-180,-100},{-160,-80}})));
  Buildings.Controls.OBC.CDL.Continuous.Add difReqIgnReq(k1=-1)
    "Difference between ignored request number and the real request number"
    annotation (Placement(transformation(extent={{-80,-80},{-60,-60}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add1
    "Increase setpoint by amount of value defined from reset logic"
    annotation (Placement(transformation(extent={{-20,50},{0,70}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add2 "Net reset value"
    annotation (Placement(transformation(extent={{80,-126},{100,-106}})));
  Buildings.Controls.OBC.CDL.Continuous.Min minInp
    "Total response should not be more than maximum response"
    annotation (Placement(transformation(extent={{40,-140},{60,-120}})));
  Buildings.Controls.OBC.CDL.Continuous.Min min1
    "Reset setpoint should not be higher than the maximum setpoint"
    annotation (Placement(transformation(extent={{20,50},{40,70}})));
  Buildings.Controls.OBC.CDL.Logical.And and2
    "After (device ON + delTim + timSta), when request number becomes more than ignored requests number"
    annotation (Placement(transformation(extent={{80,-80},{100,-60}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1 "Logical Not"
    annotation (Placement(transformation(extent={{-80,80},{-60,100}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant minSetCon(k=minSet)
    "Minimum setpoint constant"
    annotation (Placement(transformation(extent={{20,20},{40,40}})));
  Buildings.Controls.OBC.CDL.Continuous.Max maxInp
    "Reset setpoint should not be lower than the minimum setpoint"
    annotation (Placement(transformation(extent={{60,50},{80,70}})));

equation
  connect(numIgnReqCon.y, difReqIgnReq.u1)
    annotation (Line(points={{-119,-50},{-100,-50},{-100,-64},{-82,-64}},
      color={0,0,127}));
  connect(difReqIgnReq.y, greThr.u)
    annotation (Line(points={{-59,-70},{-40,-70},{-40,-90},{18,-90}},
      color={0,0,127}));
  connect(pro.y, minInp.u1)
    annotation (Line(points={{1,-130},{20,-130},{20,-124},{38,-124}},
      color={0,0,127}));
  connect(maxResCon.y, minInp.u2)
    annotation (Line(points={{1,-170},{20,-170},{20,-136},{38,-136}},
      color={0,0,127}));
  connect(minInp.y, add2.u2)
    annotation (Line(points={{61,-130},{70,-130},{70,-122},{78,-122}},
      color={0,0,127}));
  connect(triAmoCon.y, add2.u1)
    annotation (Line(points={{-59,-110},{78,-110}},
      color={0,0,127}));
  connect(add2.y, netRes.u1)
    annotation (Line(points={{101,-116},{120,-116},{120,-78},{138,-78}},
      color={0,0,127}));
  connect(iniSetCon.y, swi.u3)
    annotation (Line(points={{-59,150},{108,150},{108,138},{158,138}},
      color={0,0,127}));
  connect(swi.y, y)
    annotation (Line(points={{181,130},{190,130},{190,0},{210,0}},
      color={0,0,127}));
  connect(maxSetCon.y, min1.u2)
    annotation (Line(points={{1,30},{10,30},{10,54},{18,54}},
      color={0,0,127}));
  connect(add1.y, min1.u1)
    annotation (Line(points={{1,60},{10,60},{10,66},{18,66}},
      color={0,0,127}));
  connect(uniDel.y, add1.u1)
    annotation (Line(points={{-59,60},{-40,60},{-40,66},{-22,66}},
      color={0,0,127}));
  connect(netRes.y, add1.u2)
    annotation (Line(points={{161,-70},{180,-70},{180,-6},{-40,-6},{-40,54},{-22,54}},
      color={0,0,127}));
  connect(sampler.y, difReqIgnReq.u2)
    annotation (Line(points={{-119,-90},{-100,-90},{-100,-76},{-82,-76}},
      color={0,0,127}));
  connect(triAmoCon.y, swi1.u1)
    annotation (Line(points={{-59,-110},{-20,-110},{-20,-22},{78,-22}},
      color={0,0,127}));
  connect(zerTri.y, swi1.u3)
    annotation (Line(points={{41,-50},{60,-50},{60,-38},{78,-38}},
      color={0,0,127}));
  connect(swi1.y, netRes.u3)
    annotation (Line(points={{101,-30},{120,-30},{120,-62},{138,-62}},
      color={0,0,127}));
  connect(greThr.y, and2.u2)
    annotation (Line(points={{41,-90},{60,-90},{60,-78},{78,-78}},
      color={255,0,255}));
  connect(and2.y, netRes.u2)
    annotation (Line(points={{101,-70},{138,-70}},
      color={255,0,255}));
  connect(iniSetCon.y, swi2.u1)
    annotation (Line(points={{-59,150},{108,150},{108,108},{118,108}},
      color={0,0,127}));
  connect(swi2.y, swi.u1)
    annotation (Line(points={{141,100},{150,100},{150,122},{158,122}},
      color={0,0,127}));
  connect(swi2.y, uniDel.u)
    annotation (Line(points={{141,100},{150,100},{150,120},{-100,120},{-100,60},
          {-82,60}},
                 color={0,0,127}));
  connect(uDevSta, not1.u)
    annotation (Line(points={{-220,130},{-190,130},{-190,90},{-82,90}},
      color={255,0,255}));
  connect(not1.y, swi2.u2)
    annotation (Line(points={{-59,90},{30,90},{30,100},{118,100}},
      color={255,0,255}));
  connect(min1.y, maxInp.u1)
    annotation (Line(points={{41,60},{50,60},{50,66},{58,66}},
      color={0,0,127}));
  connect(minSetCon.y, maxInp.u2)
    annotation (Line(points={{41,30},{50,30},{50,54},{58,54}},
      color={0,0,127}));
  connect(numOfReq, intToRea.u)
    annotation (Line(points={{-220,-90},{-182,-90}}, color={255,127,0}));
  connect(intToRea.y, sampler.u)
    annotation (Line(points={{-159,-90},{-142,-90}}, color={0,0,127}));
  connect(resAmoCon.y, pro.u2)
    annotation (Line(points={{-59,-150},{-50,-150},{-50,-136},{-22,-136}},
      color={0,0,127}));
  connect(difReqIgnReq.y, pro.u1)
    annotation (Line(points={{-59,-70},{-40,-70},{-40,-124},{-22,-124}},
      color={0,0,127}));
  connect(uDevSta, tim.u)
    annotation (Line(points={{-220,130},{-182,130}}, color={255,0,255}));
  connect(tim.y, swi.u2)
    annotation (Line(points={{-159,130},{158,130}}, color={255,0,255}));
  connect(tim.y, swi1.u2)
    annotation (Line(points={{-159,130},{-120,130},{-120,-30},{78,-30}},
      color={255,0,255}));
  connect(and2.u1, tim.y)
    annotation (Line(points={{78,-70},{6,-70},{6,-30},{-120,-30},{-120,130},
      {-159,130}}, color={255,0,255}));

  connect(maxInp.y, swi2.u3) annotation (Line(points={{81,60},{108,60},{108,92},
          {118,92}}, color={0,0,127}));
annotation (
  defaultComponentName = "triRes",
  Icon(graphics={Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={223,211,169},
        lineThickness=5.0,
        borderPattern=BorderPattern.Raised,
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-114,146},{106,108}},
          lineColor={0,0,255},
          textString="%name"),
        Text(
          extent={{-88,58},{90,-42}},
          lineColor={192,192,192},
          textString="Trim & Respond")}),
   Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-200,-200},{200,
            180}}),
           graphics={
        Rectangle(
          extent={{-192,-12},{194,-192}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-192,172},{194,-8}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Text(
          extent={{-186,82},{-142,42}},
          lineColor={0,0,255},
          fontSize=11,
          horizontalAlignment=TextAlignment.Left,
          textString="Check device status,
Count time"), Text(
          extent={{-186,-114},{-142,-154}},
          lineColor={0,0,255},
          fontSize=11,
          horizontalAlignment=TextAlignment.Left,
          textString="Reset setpoint based
on request number")}),
   Documentation(info="<html>
<p>
This block implements the trim and respond logic according to ASHRAE guideline G36,
PART5.A.15 (trim and respond setpoint reset logic).
</p>
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
In other words, every time step <code>samplePeriod</code>:
<ul>
<li>Change setpoint by <code>triAmo</code>; </li>
<li>If <code>numOfReq > numIgnReq</code>, <i>also</i> change setpoint by <code>resAmo*(numOfReq
-numIgnReq)</code> but no more than <code>maxRes</code>.
</li>
</ul>

<p align=\"center\">
<img alt=\"Image of set point reset\"
src=\"modelica://Buildings/Resources/Images/Controls/OBC/ASHRAE/G36_PR1/Generic/TrimRespond.png\"/>
</p>
</html>", revisions="<html>
<ul>
<li>
July 10, 2017, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end TrimAndRespond;
