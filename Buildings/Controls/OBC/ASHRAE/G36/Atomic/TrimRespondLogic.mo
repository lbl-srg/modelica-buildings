within Buildings.Controls.OBC.ASHRAE.G36.Atomic;
block TrimRespondLogic "Block to inplement trim-respond logic"
  parameter Real iniSet  "Initial setpoint";
  parameter Real minSet  "Minimum setpoint";
  parameter Real maxSet  "Maximum setpoint";
  parameter Modelica.SIunits.Time delTim  "Delay time";
  parameter Modelica.SIunits.Time timSte  "Time step";
  parameter Integer numIgnReq  "Number of ignored requests";
  parameter Real triAmo  "Trim amount";
  parameter Real resAmo  "Respond amount (must be opposite in to triAmo)";
  parameter Real maxRes  "Maximum response per time interval (same sign as resAmo)";

  CDL.Interfaces.IntegerInput numOfReq "Number of requests from zones/systems"
    annotation (Placement(transformation(extent={{-140,-120},{-100,-80}}),
      iconTransformation(extent={{-140,-100},{-100,-60}})));
  CDL.Interfaces.RealOutput y "Setpoint that have been reset"
    annotation (Placement(transformation(extent={{200,10},{220,30}}),
      iconTransformation(extent={{100,-10},{120,10}})));
  CDL.Interfaces.BooleanInput uDevSta "On/Off status of the associated device"
    annotation (Placement(transformation(extent={{-140,70},{-100,110}}),
      iconTransformation(extent={{-140,60},{-100,100}})));

  CDL.Logical.Timer tim
    "Count elapsed time from instant when device switches ON"
    annotation (Placement(transformation(extent={{-80,80},{-60,100}})));
  CDL.Logical.GreaterEqualThreshold delTimCon(threshold=delTim + timSte)
    "Reset logic shall be actived in delay time (delTim) after device start"
    annotation (Placement(transformation(extent={{-40,80},{-20,100}})));
  CDL.Logical.GreaterThreshold greThr
    "Check if the real requests is more than ignored requests setting"
    annotation (Placement(transformation(extent={{20,-100},{40,-80}})));
  CDL.Logical.Switch netRes "Net setpoint reset value"
    annotation (Placement(transformation(extent={{140,-70},{160,-90}})));
  CDL.Continuous.Sources.Constant resAmoCon(k=resAmo) "Respond amount constant"
    annotation (Placement(transformation(extent={{-40,-160},{-20,-140}})));
  CDL.Continuous.Product pro
    "Products of net requests and respond amount value"
    annotation (Placement(transformation(extent={{0,-150},{20,-130}})));
  CDL.Discrete.UnitDelay uniDel(
    samplePeriod=timSte,
    y_start=iniSet,
    startTime=delTim + timSte) "Output the input signal with a unit delay"
    annotation (Placement(transformation(extent={{-80,0},{-60,20}})));
  CDL.Logical.Switch swi "Switch between initial setpoint and reseted setpoint"
    annotation (Placement(transformation(extent={{140,100},{160,80}})));
  CDL.Logical.Switch swi1
    "Before instant (device ON + delTim + timSte), the setpoint should not be trimmed"
    annotation (Placement(transformation(extent={{20,-30},{40,-50}})));
  CDL.Logical.Switch swi2
    "Reinitialize setpoint to initial setting when device become OFF"
    annotation (Placement(transformation(extent={{100,20},{120,40}})));
  CDL.Discrete.Sampler sampler(
    samplePeriod=timSte,
    startTime=delTim + timSte) "Sample number of requests"
    annotation (Placement(transformation(extent={{-80,-150},{-60,-130}})));

protected
  CDL.Continuous.Sources.Constant iniSetCon(k=iniSet) "Initial setpoint"
    annotation (Placement(transformation(extent={{-80,110},{-60,130}})));
  CDL.Continuous.Sources.Constant numIgnReqCon(k=numIgnReq)
    "Number of ignored requests"
    annotation (Placement(transformation(extent={{-80,-70},{-60,-50}})));
  CDL.Continuous.Sources.Constant triAmoCon(k=triAmo) "Trim amount constant"
    annotation (Placement(transformation(extent={{-40,-130},{-20,-110}})));
  CDL.Continuous.Sources.Constant maxResCon(k=maxRes)
    "Maximum response per time interval"
    annotation (Placement(transformation(extent={{-80,-180},{-60,-160}})));
  CDL.Continuous.Sources.Constant maxSetCon(k=maxSet)
    "Maximum setpoint constant"
    annotation (Placement(transformation(extent={{-20,-10},{0,10}})));
  CDL.Continuous.Sources.Constant zerTri(k=0)
    "Zero reset amount during time range from (device ON) to (device ON + delTim + timSet)"
    annotation (Placement(transformation(extent={{-80,-30},{-60,-10}})));
  CDL.Conversions.IntegerToReal intToRea "Convert integer input to real output"
    annotation (Placement(transformation(extent={{-80,-110},{-60,-90}})));
  CDL.Continuous.Add difReqIgnReq(k1=-1)
    "Difference between ignored request number and the real request number"
    annotation (Placement(transformation(extent={{-40,-100},{-20,-80}})));
  CDL.Continuous.Add add1
    "Increase setpoint by amount of value defined from reset logic"
    annotation (Placement(transformation(extent={{-20,20},{0,40}})));
  CDL.Continuous.Add add2 "Net reset value"
    annotation (Placement(transformation(extent={{80,-150},{100,-130}})));
  CDL.Continuous.Min min
    "Total response should not be more than maximum response"
    annotation (Placement(transformation(extent={{40,-150},{60,-130}})));
  CDL.Continuous.Min min1
    "Reset setpoint should not be higher than the maximum setpoint"
    annotation (Placement(transformation(extent={{20,20},{40,40}})));
  CDL.Logical.And and2
    "After (device ON + delTim + timSta), when request number becomes more than ignored requests number"
    annotation (Placement(transformation(extent={{80,-70},{100,-50}})));
  CDL.Logical.Not not1 "Logical Not"
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
  CDL.Continuous.Sources.Constant minSetCon(k=minSet)
    "Minimum setpoint constant"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  CDL.Continuous.Max max
    "Reset setpoint should not be lower than the minimum setpoint"
    annotation (Placement(transformation(extent={{60,20},{80,40}})));

equation
  connect(uDevSta, tim.u)
    annotation (Line(points={{-120,90},{-82,90}}, color={255,0,255}));
  connect(tim.y, delTimCon.u)
    annotation (Line(points={{-59,90},{-50.5,90},{-42,90}}, color={0,0,127}));
  connect(numOfReq, intToRea.u)
    annotation (Line(points={{-120,-100},{-90,-100},{-82,-100}},
      color={255,127,0}));
  connect(numIgnReqCon.y, difReqIgnReq.u1)
    annotation (Line(points={{-59,-60},{-52,-60},{-52,-84},{-42,-84}},
      color={0,0,127}));
  connect(difReqIgnReq.y, greThr.u)
    annotation (Line(points={{-19,-90},{18,-90}}, color={0,0,127}));
  connect(difReqIgnReq.y, pro.u1)
    annotation (Line(points={{-19,-90},{-8,-90},{-8,-134},{-2,-134}},
      color={0,0,127}));
  connect(pro.y, min.u1)
    annotation (Line(points={{21,-140},{30,-140},{30,-134},{38,-134}},
      color={0,0,127}));
  connect(maxResCon.y, min.u2)
    annotation (Line(points={{-59,-170},{30,-170},{30,-146},{38,-146}},
      color={0,0,127}));
  connect(min.y, add2.u2)
    annotation (Line(points={{61,-140},{70,-140},{70,-146},{78,-146}},
      color={0,0,127}));
  connect(triAmoCon.y, add2.u1)
    annotation (Line(points={{-19,-120},{70,-120},{70,-134},{78,-134}},
      color={0,0,127}));
  connect(add2.y, netRes.u1)
    annotation (Line(points={{101,-140},{120,-140},{120,-88},{138,-88}},
      color={0,0,127}));
  connect(delTimCon.y, swi.u2)
    annotation (Line(points={{-19,90},{138,90}}, color={255,0,255}));
  connect(iniSetCon.y, swi.u3)
    annotation (Line(points={{-59,120},{92,120},{92,98},{138,98}},
      color={0,0,127}));
  connect(swi.y, y)
    annotation (Line(points={{161,90},{180,90},{180,20},{210,20}},
      color={0,0,127}));
  connect(maxSetCon.y, min1.u2)
    annotation (Line(points={{1,0},{10,0},{10,24},{18,24}}, color={0,0,127}));
  connect(add1.y, min1.u1)
    annotation (Line(points={{1,30},{10,30},{10,36},{18,36}},
      color={0,0,127}));
  connect(uniDel.y, add1.u1)
    annotation (Line(points={{-59,10},{-34,10},{-34,36},{-22,36}},
      color={0,0,127}));
  connect(netRes.y, add1.u2)
    annotation (Line(points={{161,-80},{161,-80},{180,-80},{180,-20},
      {-30,-20},{-30,24},{-22,24}}, color={0,0,127}));
  connect(intToRea.y, sampler.u)
    annotation (Line(points={{-59,-100},{-52,-100},{-52,-120},{-100,-120},
      {-100,-140},{-82,-140}}, color={0,0,127}));
  connect(sampler.y, difReqIgnReq.u2)
    annotation (Line(points={{-59,-140},{-50,-140},{-50,-96},{-42,-96}},
      color={0,0,127}));
  connect(delTimCon.y, swi1.u2)
    annotation (Line(points={{-19,90},{0,90},{0,72},{-100,72},{-100,-40},{18,-40}},
      color={255,0,255}));
  connect(triAmoCon.y, swi1.u1)
    annotation (Line(points={{-19,-120},{-12,-120},{-12,-48},{18,-48}},
      color={0,0,127}));
  connect(zerTri.y, swi1.u3)
    annotation (Line(points={{-59,-20},{-40,-20},{-40,-32},{18,-32}},
      color={0,0,127}));
  connect(swi1.y, netRes.u3)
    annotation (Line(points={{41,-40},{120,-40},{120,-72},{138,-72}},
      color={0,0,127}));
  connect(resAmoCon.y, pro.u2)
    annotation (Line(points={{-19,-150},{-10,-150},{-10,-146},{-2,-146}},
      color={0,0,127}));
  connect(greThr.y, and2.u2)
    annotation (Line(points={{41,-90},{60,-90},{60,-68},{78,-68}},
      color={255,0,255}));
  connect(delTimCon.y, and2.u1)
    annotation (Line(points={{-19,90},{-19,90},{0,90},{0,72},{-100,72},
      {-100,-40},{-40,-40},{-40,-60},{78,-60}}, color={255,0,255}));
  connect(and2.y, netRes.u2)
    annotation (Line(points={{101,-60},{101,-60},{116,-60},{116,-80},{138,-80}},
      color={255,0,255}));
  connect(iniSetCon.y, swi2.u1)
    annotation (Line(points={{-59,120},{92,120},{92,38},{98,38}},
      color={0,0,127}));
  connect(swi2.y, swi.u1)
    annotation (Line(points={{121,30},{130,30},{130,82},{138,82}},
      color={0,0,127}));
  connect(swi2.y, uniDel.u)
    annotation (Line(points={{121,30},{130,30},{130,68},{-96,68},{-96,10},
      {-82,10}}, color={0,0,127}));
  connect(uDevSta, not1.u)
    annotation (Line(points={{-120,90},{-92,90},{-92,50},{-82,50}},
      color={255,0,255}));
  connect(not1.y, swi2.u2)
    annotation (Line(points={{-59,50},{90,50},{90,30},{98,30}},
      color={255,0,255}));
  connect(min1.y, max.u1)
    annotation (Line(points={{41,30},{50,30},{50,36},{58,36}},
      color={0,0,127}));
  connect(minSetCon.y, max.u2)
    annotation (Line(points={{41,0},{50,0},{50,24},{58,24}}, color={0,0,127}));
  connect(max.y, swi2.u3)
    annotation (Line(points={{81,30},{88,30},{88,22},{98,22}},
      color={0,0,127}));

  annotation (
  defaultComponentName = "tri&Res",
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
   Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-180},{200,140}}),
           graphics={Text(
          extent={{118,18},{180,-30}},
          lineColor={238,46,47},
          fontSize=11,
          textStyle={TextStyle.Italic},
          textString="fixme: the start time for both sampler and
 uniDel should ideally be the time (when 
uDevSta become true + delTim + timSte). 
Not the time instant (delTim + timSte)"), Text(
          extent={{108,-8},{170,-56}},
          lineColor={238,46,47},
          fontSize=11,
          textStyle={TextStyle.Italic},
          textString="fixme: current initial time setting will couse the 
          unaccurate time range for first reset.")}),
   Documentation(info="<html>
<p>
This block implements trim-response logic according to ASHRAE guideline G36, 
PART5.A.15 (Trim-Reponse setpoint reset logic).
</p>
<p>
Trim-reponse logic shall reset setpoint within the range <code>minSet</code> to 
<code>maxSet</code>. 
When the associated device is off (<code>uDevSta=false</code>), the setpoint 
shall be <code>iniSet</code>. 
The reset logic shall be active while the associated device is proven 
on (<code>uDevSta=true</code>), starting <code>delTim</code> after initial 
device start command. 
When active, every time step <code>timSte</code>, trim the setpoint by 
<code>triAmo</code>. 
If there are more than <code>numIgnReq</code> Requests, respond by changing 
the setpoint by <code>resAmo*(numOfReq-numIgnReq)</code>, i.e. the number of 
Requests minus the number of Ignored Requests, but no more than <code>maxRes</code>. 
</p>
In other words, every time step <code>timSte</code>:
<ul>
<li>Change setpoint by <code>triAmo</code>; </li>
<li>If <code>numOfReq > numIgnReq</code>, <i>also</i> change setpoint by <code>resAmo*(numOfReq
-numIgnReq)</code> but no larger than <code>maxRes</code>; </li>
</ul>

<p align=\"center\">
<img alt=\"Image of set point reset\"
src=\"modelica://Buildings/Resources/Images/Controls/OBC/ASHRAE/G36/Atomic/TrimRespond.png\"/>
</p>
<h4>References</h4>
<p>
<a href=\"http://gpc36.savemyenergy.com/public-files/\">BSR (ANSI Board of 
Standards Review)/ASHRAE Guideline 36P, 
<i>High Performance Sequences of Operation for HVAC systems</i>. 
First Public Review Draft (June 2016)</a>
</p>
</html>", revisions="<html>
<ul>
<li>
July 10, 2017, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end TrimRespondLogic;
