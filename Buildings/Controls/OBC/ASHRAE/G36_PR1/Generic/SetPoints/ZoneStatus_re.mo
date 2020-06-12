within Buildings.Controls.OBC.ASHRAE.G36_PR1.Generic.SetPoints;
block ZoneStatus_re "Block that outputs zone temperature status"

  parameter Real THeaSetOcc(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")=293.15
    "Occupied heating setpoint";
  parameter Real THeaSetUno(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")=285.15
    "Unoccupied heating setpoint";
  parameter Real TCooSetOcc(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")=297.15
    "Occupied cooling setpoint";
  parameter Real TCooSetUno(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")=303.15
    "Unoccupied cooling setpoint";
  parameter Real bouLim(
    final unit="K",
    final displayUnit="K",
    final quantity="TemperatureDifference",
    final min=0.5) = 1
    "Threshold of temperature difference for indicating the end of setback or setup mode";
  parameter Boolean have_winSen=false
    "Check if the zone has window status sensor";

  Buildings.Controls.OBC.CDL.Interfaces.RealInput cooDowTim(
    final unit="s",
    final quantity="Time")
    "Cool-down time retrieved from optimal cool-down block"
    annotation (Placement(transformation(extent={{-200,200},{-160,240}}),
        iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput warUpTim(
    final unit="s",
    final quantity="Time")
    "Warm-up time retrieved from optimal warm-up block"
    annotation (Placement(transformation(extent={{-200,160},{-160,200}}),
        iconTransformation(extent={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uWinSta if have_winSen
    "Window status: true=open, false=close"
    annotation (Placement(transformation(extent={{-200,130},{-160,170}}),
        iconTransformation(extent={{-140,-60},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TZon(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature") "Single zone temperature"
    annotation (Placement(transformation(extent={{-200,-70},{-160,-30}}),
        iconTransformation(extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yCooTim(
    final unit="s",
    final quantity="Time") "Cool-down time"
    annotation (Placement(transformation(extent={{160,200},{200,240}}),
        iconTransformation(extent={{100,90},{140,130}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yWarTim(
    final unit="s",
    final quantity="Time") "Warm-up time"
    annotation (Placement(transformation(extent={{160,160},{200,200}}),
        iconTransformation(extent={{100,70},{140,110}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput THeaSetOn(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature") "Occupied heating setpoint"
    annotation (Placement(transformation(extent={{160,110},{200,150}}),
        iconTransformation(extent={{100,50},{140,90}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yOccHeaHig
    "True when the zone temperature is lower than the occupied heating setpoint"
    annotation (Placement(transformation(extent={{160,70},{200,110}}),
        iconTransformation(extent={{100,30},{140,70}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TCooSetOn(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Occupied cooling setpoint temperature"
    annotation (Placement(transformation(extent={{160,30},{200,70}}),
        iconTransformation(extent={{100,10},{140,50}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yHigOccCoo
    "True when the zone temperature is higher than the occupied cooling setpoint"
    annotation (Placement(transformation(extent={{160,-10},{200,30}}),
        iconTransformation(extent={{100,-10},{140,30}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput THeaSetOff(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature") "Unoccupied heating setpoint"
    annotation (Placement(transformation(extent={{160,-60},{200,-20}}),
        iconTransformation(extent={{100,-30},{140,10}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yUnoHeaHig
    "True when the zone temperature is lower than the unoccupied heating setpoint"
    annotation (Placement(transformation(extent={{160,-100},{200,-60}}),
        iconTransformation(extent={{100,-50},{140,-10}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yEndSetBac
    "True when the zone could end setback mode"
    annotation (Placement(transformation(extent={{160,-140},{200,-100}}),
        iconTransformation(extent={{100,-70},{140,-30}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TCooSetOff(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature") "Unoccupied cooling setpoint"
    annotation (Placement(transformation(extent={{160,-180},{200,-140}}),
        iconTransformation(extent={{100,-90},{140,-50}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yHigUnoCoo
    "True when the zone temperature is higher than the unoccupied cooling setpoint"
    annotation (Placement(transformation(extent={{160,-220},{200,-180}}),
        iconTransformation(extent={{100,-110},{140,-70}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yEndSetUp
    "True when the zone could end setup mode"
    annotation (Placement(transformation(extent={{160,-260},{200,-220}}),
        iconTransformation(extent={{100,-130},{140,-90}})));

protected
  Buildings.Controls.OBC.CDL.Continuous.Product pro
    "Decide if the cool down time of one zone should be ignored: if window is open, 
    then output zero, otherwise, output cool-down time from optimal cool-down block"
    annotation (Placement(transformation(extent={{100,210},{120,230}})));
  Buildings.Controls.OBC.CDL.Continuous.Product pro1
    "Decide if the warm-up time of one zone should be ignored: if window is open, 
    then output zero, otherwise, output warm-up time from optimal warm-up block"
    annotation (Placement(transformation(extent={{100,170},{120,190}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add(
    final k2=-1)
    "Calculate differential between minimum zone temperature and the heating setpoint"
    annotation (Placement(transformation(extent={{60,80},{80,100}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys(
    final uLow=-0.1,
    final uHigh=0.1)
    "Hysteresis that outputs if the system should run in warm-up mode"
    annotation (Placement(transformation(extent={{100,80},{120,100}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add1(
    final k1=-1)
    "Calculate differential between maximum zone temperature and the cooling setpoint"
    annotation (Placement(transformation(extent={{60,0},{80,20}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys1(
    final uLow=-0.1,
    final uHigh=0.1)
    "Hysteresis that outputs if the system should run in cool-down mode"
    annotation (Placement(transformation(extent={{100,0},{120,20}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add2(
    final k2=-1)
    "Calculate zone temperature difference to setpoint"
    annotation (Placement(transformation(extent={{60,-90},{80,-70}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys2(
    final uLow=-0.1,
    final uHigh=0.1)
    "Hysteresis that outputs if the zone temperature is lower than unoccupied heating setpoint"
    annotation (Placement(transformation(extent={{100,-90},{120,-70}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add5(
    final k1=-1)
    "Calculate zone temperature difference to setpoint"
    annotation (Placement(transformation(extent={{60,-210},{80,-190}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys5(
    final uLow=-0.1,
    final uHigh=0.1)
    "Hysteresis that outputs if the zone temperature is higher than unoccupied cooling setpoint"
    annotation (Placement(transformation(extent={{100,-210},{120,-190}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1 "Logical not"
    annotation (Placement(transformation(extent={{0,140},{20,160}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea "Convert Boolean to Real number"
    annotation (Placement(transformation(extent={{40,140},{60,160}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi
    "Decide if the temperature difference to setpoint should be ignored: if the zone window 
    is open, then output setpoint temperature, otherwise, output zone temperature"
    annotation (Placement(transformation(extent={{0,-110},{20,-90}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi1
    "Decide if the temperature difference to setpoint should be ignored: if the zone window 
    is open, then output setpoint temperature, otherwise, output zone temperature"
    annotation (Placement(transformation(extent={{0,-230},{20,-210}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con(
    final k=false) if not have_winSen
    "Constant false"
    annotation (Placement(transformation(extent={{-140,120},{-120,140}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant occHeaSet(
    final k=THeaSetOcc)
    "Occupied heating setpoint"
    annotation (Placement(transformation(extent={{-80,120},{-60,140}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant unoHeaSet(
    final k=THeaSetUno)
    "Unoccupied heating setpoint"
    annotation (Placement(transformation(extent={{-80,-50},{-60,-30}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant occCooSet(
    final k=TCooSetOcc)
    "Occupied cooling setpoint"
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant unoCooSet(
    final k=TCooSetUno)
    "Unoccupied cooling setpoint"
    annotation (Placement(transformation(extent={{-80,-170},{-60,-150}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add3(
    final k2=-1)
    "Calculate zone temperature difference to setpoint"
    annotation (Placement(transformation(extent={{60,-130},{80,-110}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys3(
    final uLow=-0.5*bouLim,
    final uHigh=0.5*bouLim)
    "Hysteresis that outputs if the zone temperature is higher than its unoccupied heating setpoint by a given limit"
    annotation (Placement(transformation(extent={{100,-130},{120,-110}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add4(
    final k1=-1)
    "Calculate zone temperature difference to setpoint"
    annotation (Placement(transformation(extent={{60,-250},{80,-230}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys4(
    final uLow=-0.5*bouLim,
    final uHigh=0.5*bouLim)
    "Hysteresis that outputs if the zone temperature is lower than its unoccupied cooling setpoint by a given limit"
    annotation (Placement(transformation(extent={{100,-250},{120,-230}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi2
    "Decide if the temperature difference to setpoint should be ignored: if the zone window 
    is open, then output setpoint temperature, otherwise, output zone temperature"
    annotation (Placement(transformation(extent={{0,90},{20,110}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi3
    "Decide if the temperature difference to setpoint should be ignored: if the zone window 
    is open, then output setpoint temperature, otherwise, output zone temperature"
    annotation (Placement(transformation(extent={{0,10},{20,30}})));

equation
  connect(cooDowTim, pro.u1) annotation (Line(points={{-180,220},{-80,220},{-80,
          226},{98,226}}, color={0,0,127}));
  connect(warUpTim, pro1.u1) annotation (Line(points={{-180,180},{-80,180},{-80,
          186},{98,186}}, color={0,0,127}));
  connect(booToRea.y, pro.u2) annotation (Line(points={{62,150},{80,150},{80,214},
          {98,214}}, color={0,0,127}));
  connect(booToRea.y, pro1.u2) annotation (Line(points={{62,150},{80,150},{80,174},
          {98,174}}, color={0,0,127}));
  connect(add.y, hys.u)
    annotation (Line(points={{82,90},{98,90}}, color={0,0,127}));
  connect(add1.y, hys1.u)
    annotation (Line(points={{82,10},{98,10}},color={0,0,127}));
  connect(uWinSta, not1.u)
    annotation (Line(points={{-180,150},{-2,150}},  color={255,0,255}));
  connect(uWinSta, swi.u2) annotation (Line(points={{-180,150},{-100,150},{-100,
          -100},{-2,-100}}, color={255,0,255}));
  connect(TZon, swi.u3) annotation (Line(points={{-180,-50},{-140,-50},{-140,-108},
          {-2,-108}}, color={0,0,127}));
  connect(add2.y, hys2.u)
    annotation (Line(points={{82,-80},{98,-80}},   color={0,0,127}));
  connect(uWinSta, swi1.u2) annotation (Line(points={{-180,150},{-100,150},{-100,
          -220},{-2,-220}}, color={255,0,255}));
  connect(TZon, swi1.u3) annotation (Line(points={{-180,-50},{-140,-50},{-140,-228},
          {-2,-228}},  color={0,0,127}));
  connect(add5.y, hys5.u)
    annotation (Line(points={{82,-200},{98,-200}},   color={0,0,127}));
  connect(not1.y, booToRea.u)
    annotation (Line(points={{22,150},{38,150}},color={255,0,255}));
  connect(hys.y, yOccHeaHig)
    annotation (Line(points={{122,90},{180,90}},color={255,0,255}));
  connect(hys1.y, yHigOccCoo)
    annotation (Line(points={{122,10},{180,10}},color={255,0,255}));
  connect(pro.y, yCooTim)
    annotation (Line(points={{122,220},{180,220}}, color={0,0,127}));
  connect(pro1.y, yWarTim)
    annotation (Line(points={{122,180},{180,180}}, color={0,0,127}));
  connect(con.y, not1.u) annotation (Line(points={{-118,130},{-100,130},{-100,150},
          {-2,150}}, color={255,0,255}));
  connect(con.y, swi.u2) annotation (Line(points={{-118,130},{-100,130},{-100,-100},
          {-2,-100}},color={255,0,255}));
  connect(con.y, swi1.u2) annotation (Line(points={{-118,130},{-100,130},{-100,-220},
          {-2,-220}}, color={255,0,255}));
  connect(TZon, add1.u2) annotation (Line(points={{-180,-50},{-140,-50},{-140,4},
          {58,4}},  color={0,0,127}));
  connect(TZon, add.u2) annotation (Line(points={{-180,-50},{-140,-50},{-140,84},
          {58,84}}, color={0,0,127}));
  connect(unoHeaSet.y, swi.u1) annotation (Line(points={{-58,-40},{-40,-40},{-40,
          -92},{-2,-92}}, color={0,0,127}));
  connect(unoCooSet.y, swi1.u1) annotation (Line(points={{-58,-160},{-40,-160},{
          -40,-212},{-2,-212}}, color={0,0,127}));
  connect(unoCooSet.y, TCooSetOff)
    annotation (Line(points={{-58,-160},{180,-160}}, color={0,0,127}));
  connect(unoHeaSet.y, THeaSetOff)
    annotation (Line(points={{-58,-40},{180,-40}}, color={0,0,127}));
  connect(occHeaSet.y, THeaSetOn)
    annotation (Line(points={{-58,130},{180,130}}, color={0,0,127}));
  connect(occCooSet.y, TCooSetOn)
    annotation (Line(points={{-58,50},{180,50}}, color={0,0,127}));
  connect(hys2.y, yUnoHeaHig)
    annotation (Line(points={{122,-80},{180,-80}},   color={255,0,255}));
  connect(hys5.y, yHigUnoCoo)
    annotation (Line(points={{122,-200},{180,-200}}, color={255,0,255}));
  connect(swi.y, add2.u2) annotation (Line(points={{22,-100},{40,-100},{40,-86},
          {58,-86}}, color={0,0,127}));
  connect(unoHeaSet.y, add2.u1) annotation (Line(points={{-58,-40},{-40,-40},{-40,
          -74},{58,-74}}, color={0,0,127}));
  connect(swi1.y, add5.u2) annotation (Line(points={{22,-220},{40,-220},{40,-206},
          {58,-206}}, color={0,0,127}));
  connect(unoCooSet.y, add5.u1) annotation (Line(points={{-58,-160},{-40,-160},{
          -40,-194},{58,-194}}, color={0,0,127}));
  connect(swi.y, add3.u1) annotation (Line(points={{22,-100},{40,-100},{40,-114},
          {58,-114}},color={0,0,127}));
  connect(unoHeaSet.y, add3.u2) annotation (Line(points={{-58,-40},{-40,-40},{-40,
          -126},{58,-126}}, color={0,0,127}));
  connect(add3.y, hys3.u)
    annotation (Line(points={{82,-120},{98,-120}},   color={0,0,127}));
  connect(hys3.y, yEndSetBac)
    annotation (Line(points={{122,-120},{180,-120}}, color={255,0,255}));
  connect(swi1.y, add4.u1) annotation (Line(points={{22,-220},{40,-220},{40,-234},
          {58,-234}}, color={0,0,127}));
  connect(unoCooSet.y, add4.u2) annotation (Line(points={{-58,-160},{-40,-160},{
          -40,-246},{58,-246}}, color={0,0,127}));
  connect(add4.y, hys4.u)
    annotation (Line(points={{82,-240},{98,-240}},   color={0,0,127}));
  connect(hys4.y, yEndSetUp) annotation (Line(points={{122,-240},{180,-240}},
          color={255,0,255}));
  connect(uWinSta, swi2.u2) annotation (Line(points={{-180,150},{-100,150},{-100,
          100},{-2,100}}, color={255,0,255}));
  connect(TZon, swi2.u1) annotation (Line(points={{-180,-50},{-140,-50},{-140,108},
          {-2,108}}, color={0,0,127}));
  connect(occHeaSet.y, swi2.u3) annotation (Line(points={{-58,130},{-40,130},{-40,
          92},{-2,92}}, color={0,0,127}));
  connect(swi2.y, add.u1) annotation (Line(points={{22,100},{40,100},{40,96},{58,
          96}}, color={0,0,127}));
  connect(con.y, swi2.u2) annotation (Line(points={{-118,130},{-100,130},{-100,100},
          {-2,100}}, color={255,0,255}));
  connect(uWinSta, swi3.u2) annotation (Line(points={{-180,150},{-100,150},{-100,
          20},{-2,20}}, color={255,0,255}));
  connect(con.y, swi3.u2) annotation (Line(points={{-118,130},{-100,130},{-100,20},
          {-2,20}}, color={255,0,255}));
  connect(TZon, swi3.u1) annotation (Line(points={{-180,-50},{-140,-50},{-140,28},
          {-2,28}}, color={0,0,127}));
  connect(occCooSet.y, swi3.u3) annotation (Line(points={{-58,50},{-40,50},{-40,
          12},{-2,12}}, color={0,0,127}));
  connect(swi3.y, add1.u1) annotation (Line(points={{22,20},{40,20},{40,16},{58,
          16}}, color={0,0,127}));

annotation (
  defaultComponentName = "zonSta",
   Icon(coordinateSystem(extent={{-100,-100},{100,100}}),
        graphics={
        Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-96,88},{-46,72}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="cooDowTim"),
        Text(
          extent={{-98,46},{-50,34}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="warUpTim"),
        Text(
          extent={{-120,144},{100,106}},
          lineColor={0,0,255},
          textString="%name"),
        Text(
          extent={{-100,-74},{-74,-84}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TZon"),
        Text(
          extent={{-100,-32},{-62,-42}},
          lineColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="uWinSta"),
        Text(
          extent={{60,106},{98,90}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="yCooTim"),
        Text(
          extent={{60,94},{98,78}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="yWarTim"),
        Text(
          extent={{38,60},{96,44}},
          lineColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="yOccHeaHig"),
        Text(
          extent={{42,20},{98,2}},
          lineColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="yHigOccCoo"),
        Text(
          extent={{40,-20},{96,-36}},
          lineColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="yUnoHeaHig"),
        Text(
          extent={{40,-82},{96,-98}},
          lineColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="yHigUnoCoo"),
        Text(
          extent={{46,80},{96,64}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="THeaSetOn"),
        Text(
          extent={{46,40},{96,24}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TCooSetOn"),
        Text(
          extent={{46,0},{96,-16}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="THeaSetOff"),
        Text(
          extent={{46,-60},{96,-76}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TCooSetOff"),
        Text(
          extent={{42,-40},{98,-56}},
          lineColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="yEndSetBac"),
        Text(
          extent={{42,-100},{98,-116}},
          lineColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="yEndSetUp")}),
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
setpoint with the given limit <code></code>, then the zone should be out of the
setback mode,
</li>
<code>TCooSetOff</code>: the zone unoccupied cooling setpoint,
</li>
<li>
<code>yHigUnoCoo</code>: if the zone temperature is higher than the unoccupied cooling
setpoint,
</li>
<li>
<code>yEndSetUp</code>: if the zone temperature is lower than the unoccupied cooling
setpoint with the given limit <code></code>, then the zone should be out of the
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
end ZoneStatus_re;
