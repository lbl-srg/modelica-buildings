within Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.CoolingOnly.Subsequences;
block SystemRequests
  "Output system requests for VAV cooling only terminal unit"

  parameter Real thrTemDif(
    final unit="K",
    final quantity="TemperatureDifference")=3
    "Threshold difference between zone temperature and cooling setpoint for generating 3 cooling SAT reset requests";
  parameter Real twoTemDif(
    final unit="K",
    final quantity="TemperatureDifference")=2
    "Threshold difference between zone temperature and cooling setpoint for generating 2 cooling SAT reset requests";
  parameter Real durTimTem(
    final unit="s",
    final quantity="Time")=120
    "Duration time of zone temperature exceeds setpoint"
    annotation(Dialog(group="Duration times"));
  parameter Real durTimFlo(
    final unit="s",
    final quantity="Time")=60
    "Duration time of airflow rate less than setpoint"
    annotation(Dialog(group="Duration times"));
  parameter Real dTHys(
    final unit="K",
    final quantity="TemperatureDifference")=0.25
    "Near zero temperature difference, below which the difference will be seen as zero"
    annotation (Dialog(tab="Advanced"));
  parameter Real floHys(
    final quantity="VolumeFlowRate",
    final unit="m3/s")
    "Near zero flow rate, below which the flow rate or difference will be seen as zero"
    annotation (Dialog(tab="Advanced"));
  parameter Real damPosHys(
    final unit="1")
    "Near zero damper position, below which the damper will be seen as closed"
    annotation (Dialog(tab="Advanced"));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uAftSup
    "After suppression period due to the setpoint change"
    annotation (Placement(transformation(extent={{-220,138},{-180,178}}),
        iconTransformation(extent={{-140,70},{-100,110}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TZonCooSet(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Zone cooling setpoint temperature"
    annotation (Placement(transformation(extent={{-220,98},{-180,138}}),
        iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TZon(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Zone temperature"
    annotation (Placement(transformation(extent={{-220,38},{-180,78}}),
        iconTransformation(extent={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uCoo(
    final min=0,
    final max=1,
    final unit="1")
    "Cooling loop signal"
    annotation (Placement(transformation(extent={{-220,8},{-180,48}}),
        iconTransformation(extent={{-140,0},{-100,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VSet_flow(
    final min=0,
    final unit="m3/s",
    quantity="VolumeFlowRate")
    "Discharge airflow rate setpoint"
    annotation (Placement(transformation(extent={{-220,-60},{-180,-20}}),
        iconTransformation(extent={{-140,-50},{-100,-10}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VDis_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate")
    "Measured discharge airflow rate"
    annotation (Placement(transformation(extent={{-220,-150},{-180,-110}}),
        iconTransformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uDam(
    final min=0,
    final max=1,
    final unit="1")
    "Actual damper position"
    annotation (Placement(transformation(extent={{-220,-190},{-180,-150}}),
        iconTransformation(extent={{-140,-110},{-100,-70}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yZonTemResReq
    "Zone cooling supply air temperature reset request"
    annotation (Placement(transformation(extent={{180,118},{220,158}}),
        iconTransformation(extent={{100,40},{140,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yZonPreResReq
    "Zone static pressure reset requests"
    annotation (Placement(transformation(extent={{180,-80},{220,-40}}),
        iconTransformation(extent={{100,-80},{140,-40}})));

protected
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greThr1(
    final t=thrTemDif,
    final h=dTHys)
    "Check if zone temperature is greater than cooling setpoint by threshold"
    annotation (Placement(transformation(extent={{-60,108},{-40,128}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greThr2(
    final t=twoTemDif,
    final h=dTHys)
    "Check if zone temperature is greater than cooling setpoint by threshold"
    annotation (Placement(transformation(extent={{-60,68},{-40,88}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greThr3(
    final t=0.95,
    final h=damPosHys)
    "Check if damper position is greater than 0.95"
    annotation (Placement(transformation(extent={{-160,-180},{-140,-160}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greThr(
    final t=0.95,
    final h=0.1)
    "Check if cooling loop signal is greater than 0.95"
    annotation (Placement(transformation(extent={{-60,18},{-40,38}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greThr4(
    final t=floHys,
    final h=0.5*floHys)
    "Check if discharge airflow setpoint is greater than 0"
    annotation (Placement(transformation(extent={{-140,-50},{-120,-30}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt
    "Convert boolean to integer"
    annotation (Placement(transformation(extent={{40,18},{60,38}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt1
    "Convert boolean to integer"
    annotation (Placement(transformation(extent={{40,-180},{60,-160}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiplyByParameter gai1(
    final k=0.5)
    "50% of setpoint"
    annotation (Placement(transformation(extent={{-140,-80},{-120,-60}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiplyByParameter gai2(
    final k=0.7)
    "70% of setpoint"
    annotation (Placement(transformation(extent={{-140,-120},{-120,-100}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add2(
    final k1=-1)
    "Calculate difference between zone temperature and cooling setpoint"
    annotation (Placement(transformation(extent={{-100,108},{-80,128}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add3(
    final k1=-1)
    "Calculate difference between zone temperature and cooling setpoint"
    annotation (Placement(transformation(extent={{-100,68},{-80,88}})));
  Buildings.Controls.OBC.CDL.Logical.And and1
    "Logical and"
    annotation (Placement(transformation(extent={{40,68},{60,88}})));
  Buildings.Controls.OBC.CDL.Logical.And and2
    "Logical and"
    annotation (Placement(transformation(extent={{40,128},{60,148}})));
  Buildings.Controls.OBC.CDL.Logical.And and3
    "Logical and"
    annotation (Placement(transformation(extent={{40,-70},{60,-50}})));
  Buildings.Controls.OBC.CDL.Logical.And and4
    "Logical and"
    annotation (Placement(transformation(extent={{40,-140},{60,-120}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant thrCooResReq(
    final k=3)
    "Constant 3"
    annotation (Placement(transformation(extent={{100,168},{120,188}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant twoCooResReq(
    final k=2)
    "Constant 2"
    annotation (Placement(transformation(extent={{40,168},{60,188}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant thrPreResReq(
    final k=3)
    "Constant 3"
    annotation (Placement(transformation(extent={{100,-50},{120,-30}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant twoPreResReq(
    final k=2)
    "Constant 2"
    annotation (Placement(transformation(extent={{40,-110},{60,-90}})));
  Buildings.Controls.OBC.CDL.Integers.Switch intSwi
    "Output 3 or other request "
    annotation (Placement(transformation(extent={{140,128},{160,148}})));
  Buildings.Controls.OBC.CDL.Integers.Switch intSwi1
    "Output 2 or other request "
    annotation (Placement(transformation(extent={{100,68},{120,88}})));
  Buildings.Controls.OBC.CDL.Integers.Switch swi4
    "Output 3 or other request "
    annotation (Placement(transformation(extent={{140,-70},{160,-50}})));
  Buildings.Controls.OBC.CDL.Integers.Switch swi5
    "Output 2 or other request "
    annotation (Placement(transformation(extent={{100,-140},{120,-120}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay tim1(
    final delayTime=durTimTem) "Check if it is more than threshold time"
    annotation (Placement(transformation(extent={{-20,108},{0,128}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay tim2(
    final delayTime=durTimTem) "Check if it is more than threshold time"
    annotation (Placement(transformation(extent={{-20,68},{0,88}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay tim3(
    final delayTime=durTimFlo) "Check if it is more than threshold time"
    annotation (Placement(transformation(extent={{-60,-160},{-40,-140}})));
  Buildings.Controls.OBC.CDL.Continuous.Greater greEqu
    "Check if discharge airflow is less than 50% of setpoint"
    annotation (Placement(transformation(extent={{-60,-80},{-40,-60}})));
  Buildings.Controls.OBC.CDL.Continuous.Greater greEqu1
    "Check if discharge airflow is less than 70% of setpoint"
    annotation (Placement(transformation(extent={{-60,-120},{-40,-100}})));
  Buildings.Controls.OBC.CDL.Logical.And and5
    "Logical and"
    annotation (Placement(transformation(extent={{-20,-50},{0,-30}})));

equation
  connect(add2.y, greThr1.u)
    annotation (Line(points={{-78,118},{-62,118}}, color={0,0,127}));
  connect(and2.y, intSwi.u2)
    annotation (Line(points={{62,138},{138,138}},color={255,0,255}));
  connect(add3.y, greThr2.u)
    annotation (Line(points={{-78,78},{-62,78}},   color={0,0,127}));
  connect(and1.y, intSwi1.u2)
    annotation (Line(points={{62,78},{98,78}},   color={255,0,255}));
  connect(and3.y, swi4.u2)
    annotation (Line(points={{62,-60},{138,-60}},color={255,0,255}));
  connect(and4.y, swi5.u2)
    annotation (Line(points={{62,-130},{98,-130}}, color={255,0,255}));
  connect(greThr2.y, tim2.u)
    annotation (Line(points={{-38,78},{-22,78}},   color={255,0,255}));
  connect(tim2.y, and1.u2)
    annotation (Line(points={{2,78},{10,78},{10,70},{38,70}},
      color={255,0,255}));
  connect(greThr1.y, tim1.u)
    annotation (Line(points={{-38,118},{-22,118}}, color={255,0,255}));
  connect(tim1.y, and2.u2)
    annotation (Line(points={{2,118},{10,118},{10,130},{38,130}},
      color={255,0,255}));
  connect(greThr4.u, VSet_flow)
    annotation (Line(points={{-142,-40},{-200,-40}}, color={0,0,127}));
  connect(add2.u2, TZon)
    annotation (Line(points={{-102,112},{-150,112},{-150,58},{-200,58}},
      color={0,0,127}));
  connect(add3.u2, TZon)
    annotation (Line(points={{-102,72},{-150,72},{-150,58},{-200,58}},
      color={0,0,127}));
  connect(greEqu.u1, gai1.y)
    annotation (Line(points={{-62,-70},{-118,-70}},color={0,0,127}));
  connect(greEqu.y, and3.u2)
    annotation (Line(points={{-38,-70},{0,-70},{0,-68},{38,-68}},
      color={255,0,255}));
  connect(gai2.y, greEqu1.u1)
    annotation (Line(points={{-118,-110},{-62,-110}},
      color={0,0,127}));
  connect(greEqu1.y, and4.u2)
    annotation (Line(points={{-38,-110},{0,-110},{0,-138},{38,-138}},
      color={255,0,255}));
  connect(TZonCooSet, add2.u1) annotation (Line(points={{-200,118},{-160,118},{-160,
          124},{-102,124}}, color={0,0,127}));
  connect(TZonCooSet, add3.u1) annotation (Line(points={{-200,118},{-160,118},{-160,
          84},{-102,84}},   color={0,0,127}));
  connect(uCoo, greThr.u)
    annotation (Line(points={{-200,28},{-62,28}}, color={0,0,127}));
  connect(uAftSup, and2.u1) annotation (Line(points={{-200,158},{20,158},{20,138},
          {38,138}}, color={255,0,255}));
  connect(uAftSup, and1.u1) annotation (Line(points={{-200,158},{20,158},{20,78},
          {38,78}},  color={255,0,255}));
  connect(thrCooResReq.y, intSwi.u1) annotation (Line(points={{122,178},{130,178},
          {130,146},{138,146}}, color={255,127,0}));
  connect(twoCooResReq.y, intSwi1.u1) annotation (Line(points={{62,178},{80,178},
          {80,86},{98,86}},   color={255,127,0}));
  connect(intSwi1.y, intSwi.u3) annotation (Line(points={{122,78},{130,78},{130,
          130},{138,130}}, color={255,127,0}));
  connect(intSwi.y, yZonTemResReq)
    annotation (Line(points={{162,138},{200,138}}, color={255,127,0}));
  connect(greThr.y, booToInt.u)
    annotation (Line(points={{-38,28},{38,28}}, color={255,0,255}));
  connect(booToInt.y, intSwi1.u3) annotation (Line(points={{62,28},{80,28},{80,70},
          {98,70}},  color={255,127,0}));
  connect(uDam, greThr3.u)
    annotation (Line(points={{-200,-170},{-162,-170}}, color={0,0,127}));
  connect(VSet_flow, gai1.u) annotation (Line(points={{-200,-40},{-160,-40},{-160,
          -70},{-142,-70}}, color={0,0,127}));
  connect(VSet_flow, gai2.u) annotation (Line(points={{-200,-40},{-160,-40},{-160,
          -110},{-142,-110}}, color={0,0,127}));
  connect(VDis_flow, greEqu.u2) annotation (Line(points={{-200,-130},{-100,-130},
          {-100,-78},{-62,-78}}, color={0,0,127}));
  connect(VDis_flow, greEqu1.u2) annotation (Line(points={{-200,-130},{-100,-130},
          {-100,-118},{-62,-118}}, color={0,0,127}));
  connect(greThr3.y, tim3.u) annotation (Line(points={{-138,-170},{-80,-170},{-80,
          -150},{-62,-150}}, color={255,0,255}));
  connect(greThr4.y, and5.u1)
    annotation (Line(points={{-118,-40},{-22,-40}}, color={255,0,255}));
  connect(tim3.y, and5.u2) annotation (Line(points={{-38,-150},{-30,-150},{-30,-48},
          {-22,-48}}, color={255,0,255}));
  connect(and5.y, and3.u1) annotation (Line(points={{2,-40},{20,-40},{20,-60},{38,
          -60}}, color={255,0,255}));
  connect(and5.y, and4.u1) annotation (Line(points={{2,-40},{20,-40},{20,-130},{
          38,-130}}, color={255,0,255}));
  connect(greThr3.y, booToInt1.u) annotation (Line(points={{-138,-170},{38,-170}},
          color={255,0,255}));
  connect(booToInt1.y, swi5.u3) annotation (Line(points={{62,-170},{80,-170},{80,
          -138},{98,-138}}, color={255,127,0}));
  connect(twoPreResReq.y, swi5.u1) annotation (Line(points={{62,-100},{80,-100},
          {80,-122},{98,-122}}, color={255,127,0}));
  connect(thrPreResReq.y, swi4.u1) annotation (Line(points={{122,-40},{130,-40},
          {130,-52},{138,-52}}, color={255,127,0}));
  connect(swi5.y, swi4.u3) annotation (Line(points={{122,-130},{130,-130},{130,-68},
          {138,-68}}, color={255,127,0}));
  connect(swi4.y, yZonPreResReq) annotation (Line(points={{162,-60},{200,-60}},
          color={255,127,0}));

annotation (
  defaultComponentName="sysReq",
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-180,-200},{180,200}}),
      graphics={
        Rectangle(
          extent={{-178,198},{178,22}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-178,-22},{178,-198}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Text(
          extent={{-146,192},{-24,168}},
          lineColor={0,0,255},
          horizontalAlignment=TextAlignment.Left,
          textString="Cooling SAT reset requests"),
        Text(
          extent={{-134,-176},{10,-204}},
          lineColor={0,0,255},
          horizontalAlignment=TextAlignment.Left,
          textString="Static pressure reset requests")}),
     Icon(coordinateSystem(extent={{-100,-100},{100,100}}),
          graphics={
        Text(
          extent={{-100,140},{100,100}},
          lineColor={0,0,255},
          textString="%name"),
        Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-98,70},{-44,52}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TZonCooSet"),
        Text(
          extent={{-100,46},{-72,34}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TZon"),
        Text(
          extent={{-100,26},{-72,14}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="uCoo"),
        Text(
          extent={{-98,-22},{-54,-38}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VSet_flow"),
        Text(
          extent={{-98,-54},{-56,-66}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VDis_flow"),
        Text(
          extent={{-98,-84},{-72,-96}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="uDam"),
        Text(
          extent={{36,68},{98,52}},
          lineColor={255,127,0},
          pattern=LinePattern.Dash,
          horizontalAlignment=TextAlignment.Right,
          textString="yZonTemResReq"),
        Text(
          extent={{40,-50},{98,-66}},
          lineColor={255,127,0},
          pattern=LinePattern.Dash,
          horizontalAlignment=TextAlignment.Right,
          textString="yZonPreResReq"),
        Text(
          extent={{-98,98},{-58,84}},
          lineColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="uAftSup")}),
  Documentation(info="<html>
<p>
This sequence outputs the system reset requests for cooling only terminal unit. The
implementation is according to the Section 5.5.8 of ASHRAE Guideline 36, May 2020. 
</p>
<h4>Cooling SAT reset requests <code>yZonTemResReq</code></h4>
<ol>
<li>
If the zone temperature <code>TZon</code> exceeds the zone cooling setpoint
<code>TZonCooSet</code> by 3 &deg;C (5 &deg;F)) for 2 minutes and after suppression
period (<code>uAftSup=true</code>) due to setpoint change per G36 Part 5.1.20,
send 3 requests (<code>yZonTemResReq=3</code>).
</li>
<li>
Else if the zone temperature <code>TZon</code> exceeds the zone cooling setpoint
<code>TZonCooSet</code> by 2 &deg;C (3 &deg;F) for 2 minutes and after suppression
period (<code>uAftSup=true</code>) due to setpoint change per G36 Part 5.1.20,
send 2 requests (<code>yZonTemResReq=3</code>).
</li>
<li>
Else if the cooling loop <code>uCoo</code> is greater than 95%, send 1 request
(<code>yZonTemResReq=1</code>) until <code>uCoo</code> is less than 85%.
</li>
<li>
Else if <code>uCoo</code> is less than 95%, send 0 request (<code>yZonTemResReq=0</code>).
</li>
</ol>
<h4>Static pressure reset requests <code>yZonPreResReq</code></h4>
<ol>
<li>
If the measured airflow <code>VDis_flow</code> is less than 50% of setpoint
<code>VSet_flow</code> while the setpoint is greater than zero and the damper position
<code>uDam</code> is greater than 95% for 1 minute, send 3 requests (<code>yZonPreResReq=3</code>).
</li>
<li>
Else if the measured airflow <code>VDis_flow</code> is less than 70% of setpoint
<code>VSet_flow</code> while the setpoint is greater than zero and the damper position
<code>uDam</code> is greater than 95% for 1 minute, send 2 requests (<code>yZonPreResReq=2</code>).
</li>
<li>
Else if the damper position <code>uDam</code> is greater than 95%, send 1 request
(<code>yZonPreResReq=1</code>) until <code>uDam</code> is less than 85%.
</li>
<li>
Else if the damper position <code>uDam</code> is less than 95%, send 0 request
(<code>yZonPreResReq=0</code>).
</li>
</ol>
</html>", revisions="<html>
<ul>
<li>
August 1, 2020, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end SystemRequests;
