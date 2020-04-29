within Buildings.Controls.OBC.ASHRAE.G36_PR1.Generic.SetPoints;
block ZoneStatus "Block that outputs zone temperature status"

  parameter Real bouLim(
    final unit="K",
    final displayUnit="K",
    final quantity="TemperatureDifference",
    final min=0.5) = 1.1
    "Value limit to indicate the end of setback or setup mode";
  parameter Boolean have_winSen=false
    "Check if the zone has window status sensor";

  Buildings.Controls.OBC.CDL.Interfaces.RealInput cooDowTim(
    final unit="s",
    final quantity="Time")
    "Cool-down time retrieved from optimal cool-down block"
    annotation (Placement(transformation(extent={{-180,200},{-140,240}}),
        iconTransformation(extent={{-140,70},{-100,110}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput warUpTim(
    final unit="s",
    final quantity="Time")
    "Warm-up time retrieved from optimal warm-up block"
    annotation (Placement(transformation(extent={{-180,140},{-140,180}}),
        iconTransformation(extent={{-140,50},{-100,90}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uWinSta if have_winSen
    "Window status: true=open, false=close"
    annotation (Placement(transformation(extent={{-180,100},{-140,140}}),
        iconTransformation(extent={{-140,30},{-100,70}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TZonHeaSetOcc(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Occupied heating setpoint temperature"
    annotation (Placement(transformation(extent={{-180,50},{-140,90}}),
        iconTransformation(extent={{-140,10},{-100,50}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TZonCooSetOcc(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Occupied cooling setpoint temperature"
    annotation (Placement(transformation(extent={{-180,0},{-140,40}}),
      iconTransformation(extent={{-140,-10},{-100,30}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TZonMax(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Maximum zone temperature in the zone group"
    annotation (Placement(transformation(extent={{-180,-40},{-140,0}}),
        iconTransformation(extent={{-140,-30},{-100,10}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TZon(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Single zone temperature"
    annotation (Placement(transformation(extent={{-180,-80},{-140,-40}}),
        iconTransformation(extent={{-140,-50},{-100,-10}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TZonMin(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Minimum zone temperature in the zone group"
    annotation (Placement(transformation(extent={{-180,-130},{-140,-90}}),
        iconTransformation(extent={{-140,-70},{-100,-30}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TZonHeaSetUno(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Unoccupied heating setpoint temperature"
    annotation (Placement(transformation(extent={{-180,-170},{-140,-130}}),
        iconTransformation(extent={{-140,-90},{-100,-50}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TZonCooSetUno(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Unoccupied cooling setpoint temperature"
    annotation (Placement(transformation(extent={{-180,-260},{-140,-220}}),
        iconTransformation(extent={{-140,-110},{-100,-70}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yCooTim(
    final unit="s",
    final quantity="Time") "Cool-down time"
    annotation (Placement(transformation(extent={{140,200},{180,240}}),
        iconTransformation(extent={{100,70},{140,110}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yWarTim(
    final unit="s",
    final quantity="Time") "Warm-up time"
    annotation (Placement(transformation(extent={{140,140},{180,180}}),
        iconTransformation(extent={{100,50},{140,90}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yOccHeaHigMin
    "True when the occupied heating setpoint temperature is higher than the minimum zone temperature"
    annotation (Placement(transformation(extent={{140,50},{180,90}}),
        iconTransformation(extent={{100,10},{140,50}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yMaxHigOccCoo
    "True when the maximum zone temperature is higher than the occupied cooling setpoint"
    annotation (Placement(transformation(extent={{140,0},{180,40}}),
        iconTransformation(extent={{100,-10},{140,30}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yLowUnoHea
    "True when zone temperature is lower than unoccupied heating setpoint"
    annotation (Placement(transformation(extent={{140,-80},{180,-40}}),
        iconTransformation(extent={{100,-30},{140,10}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yUnoHeaHigMin
    "True when the unoccupied heating setpoint is higher than minimum zone temperature"
    annotation (Placement(transformation(extent={{140,-130},{180,-90}}),
        iconTransformation(extent={{100,-70},{140,-30}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yMaxHigUnoCoo
    "True when the maximum zone temperature is higher than unoccupied cooling setpoint"
    annotation (Placement(transformation(extent={{140,-190},{180,-150}}),
        iconTransformation(extent={{100,-90},{140,-50}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yHigUnoCoo
    "True when the zone temperature is higher than the unoccupied cooling setpoint"
    annotation (Placement(transformation(extent={{140,-240},{180,-200}}),
        iconTransformation(extent={{100,-110},{140,-70}})));

protected
  Buildings.Controls.OBC.CDL.Continuous.Product pro
    "Decide if the cool down time of one zone should be ignored: if window is open, then output zero, otherwise, output cool-down time from optimal cool-down block"
    annotation (Placement(transformation(extent={{80,210},{100,230}})));
  Buildings.Controls.OBC.CDL.Continuous.Product pro1
    "Decide if the warm-up time of one zone should be ignored: if window is open, then output zero, otherwise, output warm-up time from optimal warm-up block"
    annotation (Placement(transformation(extent={{80,150},{100,170}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add(final k2=-1)
    "Calculate differential between minimum zone temperature and the heating setpoint"
    annotation (Placement(transformation(extent={{-20,60},{0,80}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys(
    final pre_y_start=false,
    final uLow=-0.1,
    final uHigh=0.1)
    "Hysteresis that outputs if the system should run in warm-up mode"
    annotation (Placement(transformation(extent={{20,60},{40,80}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add1(final k1=-1)
    "Calculate differential between maximum zone temperature and the cooling setpoint"
    annotation (Placement(transformation(extent={{-20,10},{0,30}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys1(
    final pre_y_start=false,
    final uLow=-0.1,
    final uHigh=0.1)
    "Hysteresis that outputs if the system should run in cool-down mode"
    annotation (Placement(transformation(extent={{20,10},{40,30}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add2(final k1=-1)
    "Calculate zone temperature difference to setpoint"
    annotation (Placement(transformation(extent={{40,-70},{60,-50}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys2(
    final pre_y_start=false,
    final uLow=-0.1,
    final uHigh=0.1)
    "Hysteresis that outputs if the zone temperature is lower then setpoint"
    annotation (Placement(transformation(extent={{80,-70},{100,-50}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add3(final k2=-1)
    "Calculate the difference between minimum zone temperature and unoccupied heating setpoint"
    annotation (Placement(transformation(extent={{40,-120},{60,-100}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys3(
    final uLow=-0.5*bouLim,
    final uHigh=0.5*bouLim,
    final pre_y_start=false)
    "Hysteresis that outputs if the unoccupied heating setpoint is higher than minimum zone temperature by a given limit"
    annotation (Placement(transformation(extent={{80,-120},{100,-100}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add5(final k2=-1)
    "Calculate zone temperature difference to setpoint"
    annotation (Placement(transformation(extent={{40,-230},{60,-210}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys5(
    final pre_y_start=false,
    final uLow=-0.1,
    final uHigh=0.1)
    "Hysteresis that outputs if the zone temperature is higher than setpoint"
    annotation (Placement(transformation(extent={{80,-230},{100,-210}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add4(final k2=-1)
    "Calculate the difference between maximum zone temperature and unoccupied cooling setpoint"
    annotation (Placement(transformation(extent={{40,-180},{60,-160}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys4(
    final pre_y_start=false,
    final uLow=-0.5*bouLim,
    final uHigh=0.5*bouLim)
    "Hysteresis that outputs if the maximum zone temperature is higher than unoccupied cooling setpoint by a given limit"
    annotation (Placement(transformation(extent={{80,-180},{100,-160}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1 "Logical not"
    annotation (Placement(transformation(extent={{-20,110},{0,130}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea "Convert Boolean to Real number"
    annotation (Placement(transformation(extent={{20,110},{40,130}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi
    "Decide if the temperature difference to setpoint should be ignored: if the zone window is open, then output setpoint temperature, otherwise, output zone temperature"
    annotation (Placement(transformation(extent={{-20,-70},{0,-50}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi1
    "Decide if the temperature difference to setpoint should be ignored: if the zone window is open, then output setpoint temperature, otherwise, output zone temperature"
    annotation (Placement(transformation(extent={{-20,-230},{0,-210}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con(final k=false) if not have_winSen
    "Constant false"
    annotation (Placement(transformation(extent={{-128,130},{-108,150}})));

equation
  connect(cooDowTim, pro.u1) annotation (Line(points={{-160,220},{-60,220},{-60,
          226},{78,226}}, color={0,0,127}));
  connect(warUpTim, pro1.u1) annotation (Line(points={{-160,160},{-60,160},{-60,
          166},{78,166}}, color={0,0,127}));
  connect(booToRea.y, pro.u2) annotation (Line(points={{42,120},{60,120},{60,214},
          {78,214}}, color={0,0,127}));
  connect(booToRea.y, pro1.u2) annotation (Line(points={{42,120},{60,120},{60,154},
          {78,154}}, color={0,0,127}));
  connect(TZonHeaSetOcc, add.u1) annotation (Line(points={{-160,70},{-60,70},{-60,
          76},{-22,76}}, color={0,0,127}));
  connect(TZonMin, add.u2) annotation (Line(points={{-160,-110},{-60,-110},{-60,
          64},{-22,64}}, color={0,0,127}));
  connect(add.y, hys.u)
    annotation (Line(points={{2,70},{18,70}}, color={0,0,127}));
  connect(TZonCooSetOcc, add1.u1) annotation (Line(points={{-160,20},{-80,20},{-80,
          26},{-22,26}}, color={0,0,127}));
  connect(TZonMax, add1.u2) annotation (Line(points={{-160,-20},{-80,-20},{-80,14},
          {-22,14}}, color={0,0,127}));
  connect(add1.y, hys1.u)
    annotation (Line(points={{2,20},{18,20}}, color={0,0,127}));
  connect(uWinSta, not1.u)
    annotation (Line(points={{-160,120},{-22,120}}, color={255,0,255}));
  connect(uWinSta, swi.u2) annotation (Line(points={{-160,120},{-100,120},{-100,
          -60},{-22,-60}}, color={255,0,255}));
  connect(TZonHeaSetUno, swi.u1) annotation (Line(points={{-160,-150},{-40,-150},
          {-40,-52},{-22,-52}}, color={0,0,127}));
  connect(TZon, swi.u3) annotation (Line(points={{-160,-60},{-120,-60},{-120,-68},
          {-22,-68}}, color={0,0,127}));
  connect(swi.y, add2.u1) annotation (Line(points={{2,-60},{20,-60},{20,-54},{38,
          -54}}, color={0,0,127}));
  connect(TZonHeaSetUno, add2.u2) annotation (Line(points={{-160,-150},{20,-150},
          {20,-66},{38,-66}}, color={0,0,127}));
  connect(add2.y, hys2.u)
    annotation (Line(points={{62,-60},{78,-60}}, color={0,0,127}));
  connect(TZonMin, add3.u2) annotation (Line(points={{-160,-110},{-60,-110},{-60,
          -116},{38,-116}}, color={0,0,127}));
  connect(TZonHeaSetUno, add3.u1) annotation (Line(points={{-160,-150},{20,-150},
          {20,-104},{38,-104}}, color={0,0,127}));
  connect(add3.y, hys3.u)
    annotation (Line(points={{62,-110},{78,-110}}, color={0,0,127}));
  connect(uWinSta, swi1.u2) annotation (Line(points={{-160,120},{-100,120},{-100,
          -220},{-22,-220}}, color={255,0,255}));
  connect(TZonCooSetUno, swi1.u1) annotation (Line(points={{-160,-240},{-60,-240},
          {-60,-212},{-22,-212}}, color={0,0,127}));
  connect(TZon, swi1.u3) annotation (Line(points={{-160,-60},{-120,-60},{-120,-228},
          {-22,-228}}, color={0,0,127}));
  connect(swi1.y, add5.u1) annotation (Line(points={{2,-220},{20,-220},{20,-214},
          {38,-214}}, color={0,0,127}));
  connect(TZonCooSetUno, add5.u2) annotation (Line(points={{-160,-240},{20,-240},
          {20,-226},{38,-226}}, color={0,0,127}));
  connect(add5.y, hys5.u)
    annotation (Line(points={{62,-220},{78,-220}}, color={0,0,127}));
  connect(TZonMax, add4.u1) annotation (Line(points={{-160,-20},{-80,-20},{-80,-164},
          {38,-164}}, color={0,0,127}));
  connect(TZonCooSetUno, add4.u2) annotation (Line(points={{-160,-240},{-60,-240},
          {-60,-176},{38,-176}}, color={0,0,127}));
  connect(add4.y, hys4.u)
    annotation (Line(points={{62,-170},{78,-170}}, color={0,0,127}));
  connect(not1.y, booToRea.u)
    annotation (Line(points={{2,120},{18,120}}, color={255,0,255}));
  connect(hys.y, yOccHeaHigMin)
    annotation (Line(points={{42,70},{160,70}}, color={255,0,255}));
  connect(hys1.y, yMaxHigOccCoo)
    annotation (Line(points={{42,20},{160,20}}, color={255,0,255}));
  connect(pro.y, yCooTim)
    annotation (Line(points={{102,220},{160,220}}, color={0,0,127}));
  connect(pro1.y, yWarTim)
    annotation (Line(points={{102,160},{160,160}}, color={0,0,127}));
  connect(hys2.y, yLowUnoHea)
    annotation (Line(points={{102,-60},{160,-60}}, color={255,0,255}));
  connect(hys3.y,yUnoHeaHigMin)
    annotation (Line(points={{102,-110},{160,-110}}, color={255,0,255}));
  connect(hys4.y, yMaxHigUnoCoo)
    annotation (Line(points={{102,-170},{160,-170}}, color={255,0,255}));
  connect(hys5.y, yHigUnoCoo)
    annotation (Line(points={{102,-220},{160,-220}}, color={255,0,255}));
  connect(con.y, not1.u) annotation (Line(points={{-106,140},{-100,140},{-100,120},
          {-22,120}}, color={255,0,255}));
  connect(con.y, swi.u2) annotation (Line(points={{-106,140},{-100,140},{-100,-60},
          {-22,-60}}, color={255,0,255}));
  connect(con.y, swi1.u2) annotation (Line(points={{-106,140},{-100,140},{-100,-220},
          {-22,-220}}, color={255,0,255}));

annotation (
  defaultComponentName = "zonSta",
  Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-140,-260},{140,260}})),
   Icon(coordinateSystem(extent={{-100,-100},{100,100}}),
        graphics={
        Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-96,98},{-46,82}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="cooDowTim"),
        Text(
          extent={{-98,76},{-50,64}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="warUpTim"),
        Text(
          extent={{-96,-84},{-32,-98}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TZonCooSetUno"),
        Text(
          extent={{-96,38},{-30,20}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TZonHeaSetOcc"),
        Text(
          extent={{-96,16},{-28,4}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TZonCooSetOcc"),
        Text(
          extent={{-120,144},{100,106}},
          lineColor={0,0,255},
          textString="%name"),
        Text(
          extent={{-100,-4},{-58,-14}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TZonMax"),
        Text(
          extent={{-100,-24},{-74,-34}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TZon"),
        Text(
          extent={{-100,-44},{-58,-54}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TZonMin"),
        Text(
          extent={{-96,-64},{-32,-78}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TZonHeaSetUno"),
        Text(
          visible=have_winSen,
          extent={{-98,56},{-60,46}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="uWinSta"),
        Text(
          extent={{60,100},{98,84}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="yCooTim"),
        Text(
          extent={{60,80},{98,64}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="yWarTim"),
        Text(
          extent={{30,40},{96,22}},
          lineColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="yOccHeaHigMin"),
        Text(
          extent={{30,20},{96,2}},
          lineColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="yMaxHigOccCoo"),
        Text(
          extent={{46,0},{96,-16}},
          lineColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="yLowUnoHea"),
        Text(
          extent={{30,-38},{96,-56}},
          lineColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="yUnoHeaHigMin"),
        Text(
          extent={{30,-58},{96,-76}},
          lineColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="yMaxHigUnoCoo"),
        Text(
          extent={{46,-80},{96,-96}},
          lineColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="yHigUnoCoo")}),
   Documentation(info="<html>
<p>
This block outputs single zone status. It includes outputs as following:
</p>
<ul>
<li>
the times for cooling-down (<code>yCooTim</code>) and warm-up (<code>yWarTim</code>) the zone,
</li>
<li>
<code>yOccHeaHigMin</code>: if the zone occupied heating setpoint <code>TZonHeaSetOcc</code> 
is higher than the minimum zone temperature <code>TZonMin</code> of the zone group (if the 
zone is in a multiple zone system), or the zone temperature 
(<code>TZonMin</code> = <code>TZon</code>) (if it is in a single zone system),
</li>
<li>
<code>yMaxHigOccCoo</code>: if the maximum zone temperature <code>TZonMax</code> of the zone 
group (if the zone is in a multiple zone system), or the zone temperature 
(<code>TZonMax</code> = <code>TZon</code>) (if it is in a single zone system), is higher 
than the zone occupied cooling setpoint <code>TZonCooSetOcc</code>,
</li>
<li>
<code>yLowUnoHea</code>: if the zone temperature <code>TZon</code> is lower than
the unoccupied heating setpoint <code>TZonHeaSetUno</code>,
</li>
<li>
<code>yUnoHeaHigMin</code>: if the zone unoccupied heating setpoint <code>TZonHeaSetUno</code> 
is higher than the minimum zone temperature <code>TZonMin</code> of the zone group (if the 
zone is in a multiple zone system), or the zone temperature 
(<code>TZonMin</code> = <code>TZon</code>) (if it is in a single zone system), 
</li>
<li>
<code>yMaxHigUnoCoo</code>: if the maximum zone temperature <code>TZonMax</code> of the zone 
group (if the zone is in a multiple zone system), or the zone temperature 
(<code>TZonMax</code> = <code>TZon</code>) (if it is in a single zone system), is higher 
than the zone unoccupied cooling setpoint <code>TZonCooSetUno</code>,
</li>
<li>
<code>yHigUnoCoo</code>: if the zone temperature <code>TZon</code> is higher than
the unoccupied cooling setpoint <code>TZonCooSetUno</code>,
</li>
</ul>
</html>",revisions="<html>
<ul>
<li>
January 15, 2020, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end ZoneStatus;
