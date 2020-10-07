within Buildings.Experimental.Lighting;
block DaylightControlContinuous "Controls light fixture continually to a foot-candle setpoint"
 parameter Real maxFC( min=0)= 50 "Maximum foot-candle output for light fixture";
  Controls.OBC.CDL.Interfaces.RealInput uLigSet
    "Room light setpoint in foot candles"
                                        annotation (Placement(transformation(
          extent={{-138,-90},{-98,-50}}), iconTransformation(extent={{-142,
            -30},{-102,10}})));
  Controls.OBC.CDL.Interfaces.BooleanInput uFixAva
    "Lighting fixture availability schedule: true if fixture is allowed to be on, false if not"
    annotation (Placement(transformation(extent={{-140,50},{-100,90}}),
        iconTransformation(extent={{-140,50},{-100,90}})));
  Controls.OBC.CDL.Interfaces.RealOutput yLigSig
    "Lighting signal: percent of maximum output" annotation (Placement(
        transformation(extent={{180,-10},{220,30}}), iconTransformation(extent={{104,-12},
            {144,28}})));
  Controls.OBC.CDL.Logical.Switch swi
    "If light fixture is available, pass % of output required. Otherwise, pass zero"
    annotation (Placement(transformation(extent={{20,0},{40,20}})));
  Controls.OBC.CDL.Continuous.Sources.Constant conZer(k=0)
    "Constant zero if light is scheduled to be off"
    annotation (Placement(transformation(extent={{-20,-40},{0,-20}})));
  Controls.OBC.CDL.Continuous.Hysteresis hys(uLow=0.01, uHigh=0.02)
    "If light level required is greater than 2%, light fixture is on and status is true. Otherwise, fixture status is false"
    annotation (Placement(transformation(extent={{140,40},{160,60}})));
  Controls.OBC.CDL.Interfaces.BooleanOutput yLigSta
    "Lighting fixture status: true if fixture is on, false if not" annotation (
      Placement(transformation(extent={{180,32},{220,72}}), iconTransformation(
          extent={{104,30},{144,70}})));
  Controls.OBC.CDL.Continuous.Product pro
    "Product of % of light fixture required and max fixture level"
    annotation (Placement(transformation(extent={{140,-60},{160,-40}})));
  Controls.OBC.CDL.Continuous.Sources.Constant conmaxFC(k=maxFC)
    "Maximum foot candle level from light"
    annotation (Placement(transformation(extent={{20,-80},{40,-60}})));
  Controls.OBC.CDL.Interfaces.RealOutput yLigLev
    "Lighting level in foot candles" annotation (Placement(transformation(
          extent={{180,-70},{220,-30}}), iconTransformation(extent={{104,-52},
            {144,-12}})));
  Controls.OBC.CDL.Interfaces.RealInput uDayLev
    "Daylight level in foot candles" annotation (Placement(transformation(
          extent={{-140,-30},{-100,10}}), iconTransformation(extent={{-142,10},
            {-102,50}})));
  Controls.OBC.CDL.Continuous.Add add2(k1=-1)
    "Light setpoint minus daylight level"
    annotation (Placement(transformation(extent={{-60,-18},{-40,2}})));
  Controls.OBC.CDL.Continuous.Division div
    "Calculates light level required by calculating remaining light required divided by max FC of light fixture"
    annotation (Placement(transformation(extent={{-20,60},{0,80}})));
  Controls.OBC.CDL.Continuous.Sources.Constant conmaxFC1(k=maxFC)
    "Maximum foot candle level from light"
    annotation (Placement(transformation(extent={{-60,-60},{-40,-40}})));
  Controls.OBC.CDL.Continuous.Hysteresis hys1(uLow=1, uHigh=1.01)
    "If light level fraction required is greater than 1, signal is true. Otherwise, signal is false"
    annotation (Placement(transformation(extent={{60,-40},{80,-20}})));
  Controls.OBC.CDL.Continuous.Sources.Constant conOne(k=1)
    "Constant one if required lighting level is greater than max output of light fixture"
    annotation (Placement(transformation(extent={{60,0},{80,20}})));
  Controls.OBC.CDL.Logical.Switch swi1
    "If fraction of light fixture capacity required is >1, pass 1. Otherwise, pass required fraction of capacity"
    annotation (Placement(transformation(extent={{100,-40},{120,-20}})));
equation
  connect(uFixAva, swi.u2) annotation (Line(points={{-120,70},{-80,70},{-80,10},
          {18,10}}, color={255,0,255}));
  connect(conZer.y, swi.u3) annotation (Line(points={{2,-30},{12,-30},{12,2},{
          18,2}}, color={0,0,127}));
  connect(yLigSig, yLigSig)
    annotation (Line(points={{200,10},{200,10}}, color={0,0,127}));
  connect(hys.y, yLigSta) annotation (Line(points={{162,50},{176,50},{176,52},{200,
          52}}, color={255,0,255}));
  connect(conmaxFC.y, pro.u2) annotation (Line(points={{42,-70},{128,-70},{128,
          -56},{138,-56}}, color={0,0,127}));
  connect(uDayLev, add2.u1) annotation (Line(points={{-120,-10},{-82,-10},{
          -82,-2},{-62,-2}}, color={0,0,127}));
  connect(uLigSet, add2.u2) annotation (Line(points={{-118,-70},{-80,-70},{
          -80,-14},{-62,-14}}, color={0,0,127}));
  connect(add2.y, div.u1) annotation (Line(points={{-38,-8},{-36,-8},{-36,76},
          {-22,76}}, color={0,0,127}));
  connect(conmaxFC1.y, div.u2) annotation (Line(points={{-38,-50},{-30,-50},{
          -30,64},{-22,64}}, color={0,0,127}));
  connect(div.y, swi.u1) annotation (Line(points={{2,70},{10,70},{10,18},{18,18}},
                        color={0,0,127}));
  connect(hys1.y, swi1.u2)
    annotation (Line(points={{82,-30},{98,-30}}, color={255,0,255}));
  connect(conOne.y, swi1.u1) annotation (Line(points={{82,10},{92,10},{92,-22},
          {98,-22}}, color={0,0,127}));
  connect(pro.y, yLigLev)
    annotation (Line(points={{162,-50},{200,-50}}, color={0,0,127}));
  connect(swi1.y, yLigSig) annotation (Line(points={{122,-30},{172,-30},{172,10},
          {200,10}}, color={0,0,127}));
  connect(swi.y, hys1.u) annotation (Line(points={{42,10},{50,10},{50,-30},{58,
          -30}}, color={0,0,127}));
  connect(swi1.y, pro.u1) annotation (Line(points={{122,-30},{130,-30},{130,-44},
          {138,-44}}, color={0,0,127}));
  connect(swi1.y, hys.u) annotation (Line(points={{122,-30},{130,-30},{130,50},
          {138,50}}, color={0,0,127}));
  connect(swi.y, swi1.u3) annotation (Line(points={{42,10},{50,10},{50,-60},{92,
          -60},{92,-38},{98,-38}}, color={0,0,127}));
  annotation (defaultComponentName = "dayConCon", Documentation(info="<html>
  <p>
  This block determines the percent of a light fixture's maximum output that is required,
  given a daylight level, a foot-candle setpoint, and the fixture's maximum foot-candle output (maxFC). 
  <p>
  If daylight is sufficient to meet the foot-candle setpoint, the fixture is allowed to turn off. 
  Otherwise, the fixture modulates to meet the foot-candle setpoint. 
  
<p>
</p>
</p>
</html>", revisions="<html>
<ul>
<li>
October 6, 2020, by Fiona Woods:<br/>
Reconfigured block; updated description & unit test. 
</li>
</html>"),Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-100,98},{102,-102}},
          lineColor={244,125,35},
          lineThickness=1),
        Ellipse(
          extent={{-34,32},{32,-34}},
          lineColor={244,125,35},
          lineThickness=1,
          fillColor={217,67,180},
          fillPattern=FillPattern.None,
          startAngle=0,
          endAngle=360),
        Polygon(
          points={{-10,42},{0,58},{10,42},{-10,42}},
          lineColor={244,125,35},
          lineThickness=1,
          fillColor={217,67,180},
          fillPattern=FillPattern.None),
        Polygon(
          points={{-10,-8},{0,8},{10,-8},{-10,-8}},
          lineColor={244,125,35},
          lineThickness=1,
          fillColor={217,67,180},
          fillPattern=FillPattern.None,
          origin={0,-50},
          rotation=180),
        Polygon(
          points={{-10,-8},{0,8},{10,-8},{-10,-8}},
          lineColor={244,125,35},
          lineThickness=1,
          fillColor={217,67,180},
          fillPattern=FillPattern.None,
          origin={48,2},
          rotation=270),
        Polygon(
          points={{-10,-8},{0,8},{10,-8},{-10,-8}},
          lineColor={244,125,35},
          lineThickness=1,
          fillColor={217,67,180},
          fillPattern=FillPattern.None,
          origin={-50,0},
          rotation=90),
        Text(
          lineColor={0,0,255},
          extent={{-140,98},{160,138}},
          textString="%name")}),
                          Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-100,-100},{180,140}}), graphics={
        Text(
          extent={{-96,134},{280,118}},
          lineColor={0,0,0},
          lineThickness=1,
          fontSize=9,
          horizontalAlignment=TextAlignment.Left,
          textStyle={TextStyle.Bold},
          textString="Daylight Control: 
Ramps up light level to meet setpoint 
depending on daylight availability"),
        Rectangle(
          extent={{-100,102},{0,-100}},
          lineColor={217,67,180},
          lineThickness=1),
        Rectangle(
          extent={{0,30},{180,-100}},
          lineColor={217,67,180},
          lineThickness=1),
        Text(
          extent={{-74,116},{-24,30}},
          lineColor={217,67,180},
          lineThickness=1,
          fontName="Arial Narrow",
          horizontalAlignment=TextAlignment.Left,
          fontSize=11,
          textString="Determine percent of 
maximum fixture 
lighting level
required
based on 
daylight level
and setpoint"),
        Text(
          extent={{88,110},{138,24}},
          lineColor={217,67,180},
          lineThickness=1,
          fontName="Arial Narrow",
          horizontalAlignment=TextAlignment.Left,
          fontSize=11,
          textString="Show lighting status:
true if fixture on;
false if fixture off"),
        Text(
          extent={{116,48},{166,-38}},
          lineColor={217,67,180},
          lineThickness=1,
          fontName="Arial Narrow",
          horizontalAlignment=TextAlignment.Left,
          fontSize=11,
          textString="Calculate lighting level
in foot candles and 
percent of 
fixture capacity required
(adjust to one hundred
percent if capacity required
is greater
than fixture capacity)")}));
end DaylightControlContinuous;
