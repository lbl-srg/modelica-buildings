within Buildings.Controls.OBC.ASHRAE.G36.Atomic;
<<<<<<< HEAD
block TrimRespondLogic "Block to inplement trim-respond logic"
=======
block TrimRespondLogic "Block to inplement TrimRespond logic"
>>>>>>> origin/issue838_TSupAir_multiZone
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
    annotation (Placement(transformation(extent={{-240,-110},{-200,-70}}),
      iconTransformation(extent={{-140,-100},{-100,-60}})));
  CDL.Interfaces.RealOutput y "Setpoint that have been reset"
<<<<<<< HEAD
    annotation (Placement(transformation(extent={{200,40},{220,60}}),
=======
    annotation (Placement(transformation(extent={{200,-10},{220,10}}),
>>>>>>> origin/issue838_TSupAir_multiZone
      iconTransformation(extent={{100,-10},{120,10}})));
  CDL.Interfaces.BooleanInput uDevSta "On/Off status of the associated device"
    annotation (Placement(transformation(extent={{-240,110},{-200,150}}),
      iconTransformation(extent={{-140,60},{-100,100}})));

  CDL.Logical.Timer tim
    "Count elapsed time from instant when device switches ON"
    annotation (Placement(transformation(extent={{-180,120},{-160,140}})));
  CDL.Continuous.GreaterEqualThreshold delTimCon(threshold=delTim + timSte)
    "Reset logic shall be actived in delay time (delTim) after device start"
    annotation (Placement(transformation(extent={{-140,120},{-120,140}})));
  CDL.Continuous.GreaterThreshold greThr
    "Check if the real requests is more than ignored requests setting"
    annotation (Placement(transformation(extent={{20,-100},{40,-80}})));
  CDL.Logical.Switch netRes "Net setpoint reset value"
    annotation (Placement(transformation(extent={{140,-60},{160,-80}})));
  CDL.Continuous.Sources.Constant resAmoCon(k=resAmo) "Respond amount constant"
    annotation (Placement(transformation(extent={{-80,-160},{-60,-140}})));
  CDL.Continuous.Product pro
    "Products of net requests and respond amount value"
    annotation (Placement(transformation(extent={{-20,-140},{0,-120}})));
  CDL.Discrete.UnitDelay uniDel(
    samplePeriod=timSte,
    y_start=iniSet,
    startTime=delTim + timSte) "Output the input signal with a unit delay"
    annotation (Placement(transformation(extent={{-80,50},{-60,70}})));
  CDL.Logical.Switch swi "Switch between initial setpoint and reseted setpoint"
    annotation (Placement(transformation(extent={{160,140},{180,120}})));
  CDL.Logical.Switch swi1
    "Before instant (device ON + delTim + timSte), the setpoint should not be trimmed"
    annotation (Placement(transformation(extent={{80,-40},{100,-20}})));
  CDL.Logical.Switch swi2
    "Reinitialize setpoint to initial setting when device become OFF"
    annotation (Placement(transformation(extent={{120,50},{140,70}})));
  CDL.Discrete.Sampler sampler(
    samplePeriod=timSte,
    startTime=delTim + timSte) "Sample number of requests"
    annotation (Placement(transformation(extent={{-140,-100},{-120,-80}})));

protected
  CDL.Continuous.Sources.Constant iniSetCon(k=iniSet) "Initial setpoint"
    annotation (Placement(transformation(extent={{-80,140},{-60,160}})));
  CDL.Continuous.Sources.Constant numIgnReqCon(k=numIgnReq)
    "Number of ignored requests"
    annotation (Placement(transformation(extent={{-140,-60},{-120,-40}})));
  CDL.Continuous.Sources.Constant triAmoCon(k=triAmo) "Trim amount constant"
    annotation (Placement(transformation(extent={{-80,-120},{-60,-100}})));
  CDL.Continuous.Sources.Constant maxResCon(k=maxRes)
    "Maximum response per time interval"
    annotation (Placement(transformation(extent={{-20,-180},{0,-160}})));
  CDL.Continuous.Sources.Constant maxSetCon(k=maxSet)
    "Maximum setpoint constant"
    annotation (Placement(transformation(extent={{-20,20},{0,40}})));
  CDL.Continuous.Sources.Constant zerTri(k=0)
    "Zero reset amount during time range from (device ON) to (device ON + delTim + timSet)"
    annotation (Placement(transformation(extent={{20,-60},{40,-40}})));
  CDL.Conversions.IntegerToReal intToRea "Convert integer input to real output"
    annotation (Placement(transformation(extent={{-180,-100},{-160,-80}})));
  CDL.Continuous.Add difReqIgnReq(k1=-1)
    "Difference between ignored request number and the real request number"
    annotation (Placement(transformation(extent={{-80,-80},{-60,-60}})));
  CDL.Continuous.Add add1
    "Increase setpoint by amount of value defined from reset logic"
    annotation (Placement(transformation(extent={{-20,50},{0,70}})));
  CDL.Continuous.Add add2 "Net reset value"
    annotation (Placement(transformation(extent={{80,-140},{100,-120}})));
<<<<<<< HEAD
  CDL.Continuous.Min min
=======
  CDL.Continuous.Min minInp
>>>>>>> origin/issue838_TSupAir_multiZone
    "Total response should not be more than maximum response"
    annotation (Placement(transformation(extent={{40,-140},{60,-120}})));
  CDL.Continuous.Min min1
    "Reset setpoint should not be higher than the maximum setpoint"
    annotation (Placement(transformation(extent={{20,50},{40,70}})));
  CDL.Logical.And and2
    "After (device ON + delTim + timSta), when request number becomes more than ignored requests number"
    annotation (Placement(transformation(extent={{80,-80},{100,-60}})));
  CDL.Logical.Not not1 "Logical Not"
    annotation (Placement(transformation(extent={{-80,80},{-60,100}})));
  CDL.Continuous.Sources.Constant minSetCon(k=minSet)
    "Minimum setpoint constant"
    annotation (Placement(transformation(extent={{20,20},{40,40}})));
<<<<<<< HEAD
  CDL.Continuous.Max max
=======
  CDL.Continuous.Max maxInp
>>>>>>> origin/issue838_TSupAir_multiZone
    "Reset setpoint should not be lower than the minimum setpoint"
    annotation (Placement(transformation(extent={{60,50},{80,70}})));

equation
  connect(tim.y, delTimCon.u)
    annotation (Line(points={{-159,130},{-142,130}}, color={0,0,127}));
  connect(numIgnReqCon.y, difReqIgnReq.u1)
    annotation (Line(points={{-119,-50},{-100,-50},{-100,-64},{-82,-64}},
      color={0,0,127}));
  connect(difReqIgnReq.y, greThr.u)
    annotation (Line(points={{-59,-70},{-40,-70},{-40,-90},{18,-90}},
      color={0,0,127}));
<<<<<<< HEAD
  connect(pro.y, min.u1)
    annotation (Line(points={{1,-130},{20,-130},{20,-124},{38,-124}},
      color={0,0,127}));
  connect(maxResCon.y, min.u2)
    annotation (Line(points={{1,-170},{20,-170},{20,-136},{38,-136}},
      color={0,0,127}));
  connect(min.y, add2.u2)
=======
  connect(pro.y, minInp.u1)
    annotation (Line(points={{1,-130},{20,-130},{20,-124},{38,-124}},
      color={0,0,127}));
  connect(maxResCon.y, minInp.u2)
    annotation (Line(points={{1,-170},{20,-170},{20,-136},{38,-136}},
      color={0,0,127}));
  connect(minInp.y, add2.u2)
>>>>>>> origin/issue838_TSupAir_multiZone
    annotation (Line(points={{61,-130},{70,-130},{70,-136},{78,-136}},
      color={0,0,127}));
  connect(triAmoCon.y, add2.u1)
    annotation (Line(points={{-59,-110},{70,-110},{70,-124},{78,-124}},
      color={0,0,127}));
  connect(add2.y, netRes.u1)
    annotation (Line(points={{101,-130},{120,-130},{120,-78},{138,-78}},
      color={0,0,127}));
  connect(delTimCon.y, swi.u2)
    annotation (Line(points={{-119,130},{158,130}}, color={255,0,255}));
  connect(iniSetCon.y, swi.u3)
    annotation (Line(points={{-59,150},{108,150},{108,138},{158,138}},
      color={0,0,127}));
  connect(swi.y, y)
<<<<<<< HEAD
    annotation (Line(points={{181,130},{190,130},{190,50},{210,50}},
=======
    annotation (Line(points={{181,130},{190,130},{190,0},{210,0}},
>>>>>>> origin/issue838_TSupAir_multiZone
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
  connect(delTimCon.y, swi1.u2)
    annotation (Line(points={{-119,130},{-110,130},{-110,-10},{0,-10},{0,-30},{78,-30}},
      color={255,0,255}));
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
  connect(delTimCon.y, and2.u1)
    annotation (Line(points={{-119,130},{-110,130},{-110,-10},{0,-10},{0,-70},{78,-70}},
      color={255,0,255}));
  connect(and2.y, netRes.u2)
    annotation (Line(points={{101,-70},{138,-70}},
      color={255,0,255}));
  connect(iniSetCon.y, swi2.u1)
    annotation (Line(points={{-59,150},{108,150},{108,68},{118,68}},
      color={0,0,127}));
  connect(swi2.y, swi.u1)
    annotation (Line(points={{141,60},{150,60},{150,122},{158,122}},
      color={0,0,127}));
  connect(swi2.y, uniDel.u)
    annotation (Line(points={{141,60},{150,60},{150,110},{-100,110},{-100,60},{-82,60}},
      color={0,0,127}));
  connect(uDevSta, not1.u)
    annotation (Line(points={{-220,130},{-190,130},{-190,90},{-82,90}},
      color={255,0,255}));
  connect(not1.y, swi2.u2)
    annotation (Line(points={{-59,90},{100,90},{100,60},{118,60}},
      color={255,0,255}));
<<<<<<< HEAD
  connect(min1.y, max.u1)
    annotation (Line(points={{41,60},{50,60},{50,66},{58,66}},
      color={0,0,127}));
  connect(minSetCon.y, max.u2)
    annotation (Line(points={{41,30},{50,30},{50,54},{58,54}},
      color={0,0,127}));
  connect(max.y, swi2.u3)
=======
  connect(min1.y, maxInp.u1)
    annotation (Line(points={{41,60},{50,60},{50,66},{58,66}},
      color={0,0,127}));
  connect(minSetCon.y, maxInp.u2)
    annotation (Line(points={{41,30},{50,30},{50,54},{58,54}},
      color={0,0,127}));
  connect(maxInp.y, swi2.u3)
>>>>>>> origin/issue838_TSupAir_multiZone
    annotation (Line(points={{81,60},{92,60},{92,52},{118,52}},
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

annotation (
<<<<<<< HEAD
  defaultComponentName = "tri&Res",
=======
  defaultComponentName = "triRes",
>>>>>>> origin/issue838_TSupAir_multiZone
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
          extent={{-192,176},{194,-4}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Text(
<<<<<<< HEAD
          extent={{-198,200},{-84,172}},
          lineColor={238,46,47},
          fontSize=11,
          textStyle={TextStyle.Italic},
          textString="fixme: the start time for both sampler and uniDel should ideally be the time (when uDevSta become true + delTim + timSte).  
Not the time instant (delTim + timSte)",
          horizontalAlignment=TextAlignment.Left),
        Text(
          extent={{-28,198},{34,150}},
          lineColor={238,46,47},
          fontSize=11,
          textStyle={TextStyle.Italic},
          textString="fixme: current initial time setting will couse the
unaccurate time range for first reset.",
          horizontalAlignment=TextAlignment.Left),
        Text(
=======
>>>>>>> origin/issue838_TSupAir_multiZone
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
<<<<<<< HEAD
          textString="Reset setpoint based 
on request number")}),
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
=======
          textString="Reset setpoint based
on request number")}),
   Documentation(info="<html>
<p>
This block implements TrimRespond logic according to ASHRAE guideline G36,
PART5.A.15 (TrimRespond setpoint reset logic).
</p>
<p>
TrimRespond logic shall reset setpoint within the range <code>minSet</code> to
<code>maxSet</code>.
When the associated device is off (<code>uDevSta=false</code>), the setpoint
shall be <code>iniSet</code>.
The reset logic shall be active while the associated device is proven
on (<code>uDevSta=true</code>), starting <code>delTim</code> after initial
device start command.
When active, every time step <code>timSte</code>, trim the setpoint by
<code>triAmo</code>.
If there are more than <code>numIgnReq</code> requests, respond by changing
the setpoint by <code>resAmo*(numOfReq-numIgnReq)</code>, i.e. the number of
requests minus the number of ignored requests, but no more than <code>maxRes</code>.
>>>>>>> origin/issue838_TSupAir_multiZone
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
<<<<<<< HEAD
<a href=\"http://gpc36.savemyenergy.com/public-files/\">BSR (ANSI Board of 
Standards Review)/ASHRAE Guideline 36P, 
<i>High Performance Sequences of Operation for HVAC systems</i>. 
=======
<a href=\"http://gpc36.savemyenergy.com/public-files/\">BSR (ANSI Board of
Standards Review)/ASHRAE Guideline 36P,
<i>High Performance Sequences of Operation for HVAC systems</i>.
>>>>>>> origin/issue838_TSupAir_multiZone
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
