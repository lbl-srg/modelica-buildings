within Buildings.Controls.OBC.ASHRAE.G36.ZoneGroups;
block ZoneStatus "Block that outputs zone temperature status"

  parameter Real bouLim(
    final unit="K",
    displayUnit="K",
    final quantity="TemperatureDifference",
    final min=0.5) = 1
    "Threshold of temperature difference for indicating the end of setback or setup mode"
    annotation (__cdl(ValueInReference=True));
  parameter Boolean have_winSen=false
    "Check if the zone has window status sensor"
    annotation (__cdl(ValueInReference=False));
  parameter Real uLow(
    final unit="K",
    final quantity="TemperatureDifference")=-0.1
    "Low limit of the hysteresis for checking temperature difference"
    annotation (__cdl(ValueInReference=False), Dialog(tab="Advanced"));
  parameter Real uHigh(
    final unit="K",
    final quantity="TemperatureDifference")=0.1
    "High limit of the hysteresis for checking temperature difference"
    annotation (__cdl(ValueInReference=False), Dialog(tab="Advanced"));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput cooDowTim(
    final unit="s",
    final quantity="Time")
    "Cool-down time retrieved from optimal cool-down block"
    annotation (Placement(transformation(extent={{-200,200},{-160,240}}),
        iconTransformation(extent={{-140,90},{-100,130}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput warUpTim(
    final unit="s",
    final quantity="Time")
    "Warm-up time retrieved from optimal warm-up block"
    annotation (Placement(transformation(extent={{-200,160},{-160,200}}),
        iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1Win if have_winSen
    "Window status, normally closed (true), when windows open, it becomes false"
    annotation (Placement(transformation(extent={{-200,130},{-160,170}}),
        iconTransformation(extent={{-140,30},{-100,70}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TZon(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature") "Single zone temperature"
    annotation (Placement(transformation(extent={{-200,90},{-160,130}}),
        iconTransformation(extent={{-140,2},{-100,42}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TOccHeaSet(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature") "Occupied heating setpoint"
    annotation (Placement(transformation(extent={{-200,50},{-160,90}}),
        iconTransformation(extent={{-140,-40},{-100,0}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TOccCooSet(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature") "Occupied cooling setpoint"
    annotation (Placement(transformation(extent={{-200,10},{-160,50}}),
        iconTransformation(extent={{-140,-70},{-100,-30}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TUnoHeaSet(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature") "Unoccupied heating setpoint"
    annotation (Placement(transformation(extent={{-200,-60},{-160,-20}}),
        iconTransformation(extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TUnoCooSet(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature") "Unoccupied cooling setpoint"
    annotation (Placement(transformation(extent={{-200,-180},{-160,-140}}),
        iconTransformation(extent={{-140,-130},{-100,-90}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yCooTim(
    final unit="s",
    final quantity="Time") "Cool-down time"
    annotation (Placement(transformation(extent={{160,200},{200,240}}),
        iconTransformation(extent={{100,110},{140,150}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yWarTim(
    final unit="s",
    final quantity="Time") "Warm-up time"
    annotation (Placement(transformation(extent={{160,160},{200,200}}),
        iconTransformation(extent={{100,90},{140,130}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yOccHeaHig
    "True when the zone temperature is lower than the occupied heating setpoint"
    annotation (Placement(transformation(extent={{160,70},{200,110}}),
        iconTransformation(extent={{100,40},{140,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yHigOccCoo
    "True when the zone temperature is higher than the occupied cooling setpoint"
    annotation (Placement(transformation(extent={{160,-10},{200,30}}),
        iconTransformation(extent={{100,-10},{140,30}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yUnoHeaHig
    "True when the zone temperature is lower than the unoccupied heating setpoint"
    annotation (Placement(transformation(extent={{160,-100},{200,-60}}),
        iconTransformation(extent={{100,-60},{140,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yEndSetBac
    "True when the zone could end setback mode"
    annotation (Placement(transformation(extent={{160,-140},{200,-100}}),
        iconTransformation(extent={{100,-80},{140,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yHigUnoCoo
    "True when the zone temperature is higher than the unoccupied cooling setpoint"
    annotation (Placement(transformation(extent={{160,-220},{200,-180}}),
        iconTransformation(extent={{100,-130},{140,-90}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yEndSetUp
    "True when the zone could end setup mode"
    annotation (Placement(transformation(extent={{160,-260},{200,-220}}),
        iconTransformation(extent={{100,-150},{140,-110}})));

protected
  Buildings.Controls.OBC.CDL.Continuous.Multiply pro
    "Decide if the cool down time of one zone should be ignored: if window is open, 
    then output zero, otherwise, output cool-down time from optimal cool-down block"
    annotation (Placement(transformation(extent={{120,210},{140,230}})));
  Buildings.Controls.OBC.CDL.Continuous.Multiply pro1
    "Decide if the warm-up time of one zone should be ignored: if window is open, 
    then output zero, otherwise, output warm-up time from optimal warm-up block"
    annotation (Placement(transformation(extent={{120,170},{140,190}})));
  Buildings.Controls.OBC.CDL.Continuous.Subtract sub
    "Calculate difference between zone temperature and the occupied heating setpoint"
    annotation (Placement(transformation(extent={{-40,80},{-20,100}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys(
    final uLow=uLow,
    final uHigh=uHigh)
    "Hysteresis that outputs if the system should run in warm-up mode"
    annotation (Placement(transformation(extent={{0,80},{20,100}})));
  Buildings.Controls.OBC.CDL.Continuous.Subtract sub1
    "Calculate difference between zone temperature and the occupied cooling setpoint"
    annotation (Placement(transformation(extent={{-40,0},{-20,20}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys1(
    final uLow=uLow,
    final uHigh=uHigh)
    "Hysteresis that outputs if the system should run in cool-down mode"
    annotation (Placement(transformation(extent={{0,0},{20,20}})));
  Buildings.Controls.OBC.CDL.Continuous.Subtract sub2
    "Calculate zone temperature difference to unoccupied heating setpoint"
    annotation (Placement(transformation(extent={{-40,-80},{-20,-60}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys2(
    final uLow=uLow,
    final uHigh=uHigh)
    "Hysteresis that outputs if the zone temperature is lower than unoccupied heating setpoint"
    annotation (Placement(transformation(extent={{0,-80},{20,-60}})));
  Buildings.Controls.OBC.CDL.Continuous.Subtract sub5
    "Calculate zone temperature difference to unoccupied cooling setpoint"
    annotation (Placement(transformation(extent={{-40,-200},{-20,-180}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys5(
    final uLow=uLow,
    final uHigh=uHigh)
    "Hysteresis that outputs if the zone temperature is higher than unoccupied cooling setpoint"
    annotation (Placement(transformation(extent={{0,-200},{20,-180}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1 "Logical not"
    annotation (Placement(transformation(extent={{-40,140},{-20,160}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea "Convert Boolean to Real number"
    annotation (Placement(transformation(extent={{60,140},{80,160}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con(
    final k=false) if not have_winSen
    "Constant false"
    annotation (Placement(transformation(extent={{-140,190},{-120,210}})));
  Buildings.Controls.OBC.CDL.Continuous.Subtract sub3
    "Calculate zone temperature difference to unoccupied heating setpoint"
    annotation (Placement(transformation(extent={{-40,-120},{-20,-100}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys3(
    final uLow=0,
    final uHigh=bouLim)
    "Hysteresis that outputs if the zone temperature is higher than its unoccupied heating setpoint by a given limit"
    annotation (Placement(transformation(extent={{0,-120},{20,-100}})));
  Buildings.Controls.OBC.CDL.Continuous.Subtract sub4
    "Calculate zone temperature difference to unoccupied cooling setpoint"
    annotation (Placement(transformation(extent={{-40,-240},{-20,-220}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys4(
    final uLow=0,
    final uHigh=bouLim)
    "Hysteresis that outputs if the zone temperature is lower than its unoccupied cooling setpoint by a given limit"
    annotation (Placement(transformation(extent={{0,-240},{20,-220}})));
  Buildings.Controls.OBC.CDL.Logical.And and2
    "When window is open, it should output false"
    annotation (Placement(transformation(extent={{120,80},{140,100}})));
  Buildings.Controls.OBC.CDL.Logical.And and1
    "When window is open, it should output false"
    annotation (Placement(transformation(extent={{120,0},{140,20}})));
  Buildings.Controls.OBC.CDL.Logical.And and3
    "When window is open, it should output false"
    annotation (Placement(transformation(extent={{120,-90},{140,-70}})));
  Buildings.Controls.OBC.CDL.Logical.Or or2
    "When window is open, it should output true"
    annotation (Placement(transformation(extent={{120,-130},{140,-110}})));
  Buildings.Controls.OBC.CDL.Logical.And and5
    "When window is open, it should output false"
    annotation (Placement(transformation(extent={{120,-210},{140,-190}})));
  Buildings.Controls.OBC.CDL.Logical.Or or1
    "When window is open, it should output true"
    annotation (Placement(transformation(extent={{120,-250},{140,-230}})));
  Buildings.Controls.OBC.CDL.Logical.Not winOpe if have_winSen "Window is open"
    annotation (Placement(transformation(extent={{-140,140},{-120,160}})));
equation
  connect(cooDowTim, pro.u1) annotation (Line(points={{-180,220},{60,220},{60,226},
          {118,226}},     color={0,0,127}));
  connect(warUpTim, pro1.u1) annotation (Line(points={{-180,180},{60,180},{60,186},
          {118,186}},     color={0,0,127}));
  connect(booToRea.y, pro.u2) annotation (Line(points={{82,150},{100,150},{100,214},
          {118,214}},color={0,0,127}));
  connect(booToRea.y, pro1.u2) annotation (Line(points={{82,150},{100,150},{100,
          174},{118,174}}, color={0,0,127}));
  connect(sub.y, hys.u)
    annotation (Line(points={{-18,90},{-2,90}},color={0,0,127}));
  connect(sub1.y, hys1.u)
    annotation (Line(points={{-18,10},{-2,10}}, color={0,0,127}));
  connect(sub2.y, hys2.u)
    annotation (Line(points={{-18,-70},{-2,-70}},  color={0,0,127}));
  connect(sub5.y, hys5.u)
    annotation (Line(points={{-18,-190},{-2,-190}},  color={0,0,127}));
  connect(not1.y, booToRea.u)
    annotation (Line(points={{-18,150},{58,150}}, color={255,0,255}));
  connect(pro.y, yCooTim)
    annotation (Line(points={{142,220},{180,220}}, color={0,0,127}));
  connect(pro1.y, yWarTim)
    annotation (Line(points={{142,180},{180,180}}, color={0,0,127}));
  connect(con.y, not1.u) annotation (Line(points={{-118,200},{-80,200},{-80,150},
          {-42,150}},color={255,0,255}));
  connect(TZon, sub.u2) annotation (Line(points={{-180,110},{-140,110},{-140,84},
          {-42,84}},color={0,0,127}));
  connect(sub3.y, hys3.u)
    annotation (Line(points={{-18,-110},{-2,-110}},  color={0,0,127}));
  connect(sub4.y, hys4.u)
    annotation (Line(points={{-18,-230},{-2,-230}},  color={0,0,127}));
  connect(TZon, sub2.u2) annotation (Line(points={{-180,110},{-140,110},{-140,-76},
          {-42,-76}}, color={0,0,127}));
  connect(TZon, sub3.u1) annotation (Line(points={{-180,110},{-140,110},{-140,-104},
          {-42,-104}}, color={0,0,127}));
  connect(and2.y, yOccHeaHig)
    annotation (Line(points={{142,90},{180,90}}, color={255,0,255}));
  connect(hys.y, and2.u1)
    annotation (Line(points={{22,90},{118,90}}, color={255,0,255}));
  connect(hys1.y, and1.u1)
    annotation (Line(points={{22,10},{118,10}}, color={255,0,255}));
  connect(hys2.y, and3.u1) annotation (Line(points={{22,-70},{100,-70},{100,-80},
          {118,-80}}, color={255,0,255}));
  connect(hys3.y, or2.u1) annotation (Line(points={{22,-110},{100,-110},{100,-120},
          {118,-120}}, color={255,0,255}));
  connect(hys5.y, and5.u1) annotation (Line(points={{22,-190},{100,-190},{100,-200},
          {118,-200}}, color={255,0,255}));
  connect(hys4.y, or1.u1) annotation (Line(points={{22,-230},{100,-230},{100,-240},
          {118,-240}}, color={255,0,255}));
  connect(not1.y, and2.u2) annotation (Line(points={{-18,150},{40,150},{40,82},
          {118,82}},color={255,0,255}));
  connect(not1.y, and1.u2) annotation (Line(points={{-18,150},{40,150},{40,2},{118,
          2}}, color={255,0,255}));
  connect(and1.y, yHigOccCoo) annotation (Line(points={{142,10},{152,10},{152,10},
          {180,10}}, color={255,0,255}));
  connect(and3.y, yUnoHeaHig)
    annotation (Line(points={{142,-80},{180,-80}}, color={255,0,255}));
  connect(or2.y, yEndSetBac) annotation (Line(points={{142,-120},{154,-120},{
          154,-120},{180,-120}}, color={255,0,255}));
  connect(and5.y, yHigUnoCoo)
    annotation (Line(points={{142,-200},{180,-200}}, color={255,0,255}));
  connect(or1.y, yEndSetUp)
    annotation (Line(points={{142,-240},{180,-240}}, color={255,0,255}));
  connect(con.y, or2.u2) annotation (Line(points={{-118,200},{-80,200},{-80,-128},
          {118,-128}}, color={255,0,255}));
  connect(con.y, or1.u2) annotation (Line(points={{-118,200},{-80,200},{-80,-248},
          {118,-248}}, color={255,0,255}));
  connect(not1.y, and3.u2) annotation (Line(points={{-18,150},{40,150},{40,-88},
          {118,-88}}, color={255,0,255}));
  connect(not1.y, and5.u2) annotation (Line(points={{-18,150},{40,150},{40,-208},
          {118,-208}}, color={255,0,255}));
  connect(TZon, sub1.u1) annotation (Line(points={{-180,110},{-140,110},{-140,16},
          {-42,16}}, color={0,0,127}));
  connect(TZon, sub5.u1) annotation (Line(points={{-180,110},{-140,110},{-140,-184},
          {-42,-184}},            color={0,0,127}));
  connect(TZon, sub4.u2) annotation (Line(points={{-180,110},{-140,110},{-140,-236},
          {-42,-236}}, color={0,0,127}));
  connect(TOccHeaSet, sub.u1) annotation (Line(points={{-180,70},{-120,70},{-120,
          96},{-42,96}}, color={0,0,127}));
  connect(TOccCooSet, sub1.u2) annotation (Line(points={{-180,30},{-120,30},{-120,
          4},{-42,4}}, color={0,0,127}));
  connect(TUnoHeaSet, sub2.u1) annotation (Line(points={{-180,-40},{-120,-40},{-120,
          -64},{-42,-64}}, color={0,0,127}));
  connect(TUnoHeaSet, sub3.u2) annotation (Line(points={{-180,-40},{-120,-40},{-120,
          -116},{-42,-116}}, color={0,0,127}));
  connect(TUnoCooSet, sub5.u2) annotation (Line(points={{-180,-160},{-120,-160},
          {-120,-196},{-42,-196}}, color={0,0,127}));
  connect(TUnoCooSet, sub4.u1) annotation (Line(points={{-180,-160},{-120,-160},
          {-120,-224},{-42,-224}}, color={0,0,127}));
  connect(u1Win, winOpe.u)
    annotation (Line(points={{-180,150},{-142,150}}, color={255,0,255}));
  connect(winOpe.y, not1.u)
    annotation (Line(points={{-118,150},{-42,150}}, color={255,0,255}));
  connect(winOpe.y, or2.u2) annotation (Line(points={{-118,150},{-80,150},{-80,-128},
          {118,-128}}, color={255,0,255}));
  connect(winOpe.y, or1.u2) annotation (Line(points={{-118,150},{-80,150},{-80,-248},
          {118,-248}}, color={255,0,255}));
annotation (
  defaultComponentName = "zonSta",
   Icon(coordinateSystem(extent={{-100,-140},{100,140}}),
        graphics={
        Rectangle(
        extent={{-100,-140},{100,140}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-96,118},{-46,102}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="cooDowTim"),
        Text(
          extent={{-100,86},{-52,74}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="warUpTim"),
        Text(
          extent={{-120,180},{100,140}},
          textColor={0,0,255},
          textString="%name"),
        Text(
          extent={{-100,28},{-74,18}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TZon"),
        Text(
          extent={{-100,58},{-62,48}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="u1Win",
          visible=have_winSen),
        Text(
          extent={{60,140},{98,124}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="yCooTim"),
        Text(
          extent={{60,120},{98,104}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="yWarTim"),
        Text(
          extent={{38,70},{96,54}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="yOccHeaHig"),
        Text(
          extent={{42,20},{98,2}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="yHigOccCoo"),
        Text(
          extent={{40,-30},{96,-46}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="yUnoHeaHig"),
        Text(
          extent={{42,-102},{98,-118}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="yHigUnoCoo"),
        Text(
          extent={{42,-50},{98,-66}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="yEndSetBac"),
        Text(
          extent={{46,-124},{98,-138}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="yEndSetUp"),
        Text(
          extent={{-98,-12},{-48,-28}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TOccHeaSet"),
        Text(
          extent={{-98,-42},{-48,-58}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TOccCooSet"),
        Text(
          extent={{-98,-102},{-48,-118}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TUnoCooSet"),
        Text(
          extent={{-98,-72},{-48,-88}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TUnoHeaSet")}),
   Documentation(info="<html>
<p>
This block outputs single zone status. It includes outputs as following:
</p>
<ul>
<li>
the times for cooling-down (<code>yCooTim</code>) and warm-up (<code>yWarTim</code>) the zone,
</li>
<li>
<code>THeaSetOn</code>: the zone occupied heating setpoint,
</li>
<li>
<code>yOccHeaHig</code>: if the zone temperature is lower than the occupied heating
setpoint,
</li>
<li>
<code>TCooSetOn</code>: the zone occupied cooling setpoint,
</li>
<li>
<code>yHigOccCoo</code>: if the zone temperature is higher than the occupied cooling
setpoint,
</li>
<li>
<code>THeaSetOff</code>: the zone unoccupied heating setpoint,
</li>
<li>
<code>yUnoHeaHig</code>: if the zone temperature is lower than the unoccupied heating
setpoint,
</li>
<li>
<code>yEndSetBac</code>: if the zone temperature is higher than the unoccupied heating
setpoint with the given limit <code>bouLim</code>, then the zone should be out of the
setback mode,
</li>
<li>
<code>TCooSetOff</code>: the zone unoccupied cooling setpoint,
</li>
<li>
<code>yHigUnoCoo</code>: if the zone temperature is higher than the unoccupied cooling
setpoint,
</li>
<li>
<code>yEndSetUp</code>: if the zone temperature is lower than the unoccupied cooling
setpoint with the given limit <code>bouLim</code>, then the zone should be out of the
setup mode.
</li>
</ul>
</html>",revisions="<html>
<ul>
<li>
June 10 15, 2020, by Jianjun Hu:<br/>
Simplified implementation.
</li>
<li>
January 15, 2020, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(extent={{-160,-260},{160,240}},
          preserveAspectRatio=false)));
end ZoneStatus;
