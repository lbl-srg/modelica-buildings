within Buildings.Experimental.RadiantControl.Alarms;
block SlabTempAlarm "Trigger alarm if slab temperature is a user-specified amount away from setpoint for a user-specified amount of time"

  parameter Real TiErr(min=0,
    final unit="s",
    final displayUnit="s",
    final quantity="Time")=14400  "Time threshhold slab temp must be out of range to trigger alarm";
  parameter Real TErr(min=0,
    final unit="K",
    final displayUnit="degC",
    final quantity="TemperatureDifference")=1.1 "Difference from slab temp setpoint required to trigger alarm";

  Controls.OBC.CDL.Continuous.Abs           abs
    "Absolute value of difference between slab setpoint and slab temp"
    annotation (Placement(transformation(extent={{-100,20},{-80,40}})));
  Controls.OBC.CDL.Logical.Not           not7
    "Zero out integral if error is below threshhold"
    annotation (Placement(transformation(extent={{-20,-80},{0,-60}})));
  Controls.OBC.CDL.Continuous.Sources.Constant conZer(k=0)
    "Error integral- constant zero"
    annotation (Placement(transformation(extent={{-20,-40},{0,-20}})));
  Controls.OBC.CDL.Continuous.Sources.Constant           conOne(k=1)
    "Error integral- constant one"
    annotation (Placement(transformation(extent={{-20,80},{0,100}})));
  Controls.OBC.CDL.Logical.Switch           swi
    "Switch integrated function from constant zero to constant one if error is above threshhold"
    annotation (Placement(transformation(extent={{-20,20},{0,40}})));
  Controls.OBC.CDL.Continuous.IntegratorWithReset           intWitRes
    "Find integral of how long error has been above threshold, reset to zero if error goes below 2 F threshhold"
    annotation (Placement(transformation(extent={{20,20},{40,40}})));
  Controls.OBC.CDL.Interfaces.RealInput slaTemErr "Slab temperature error"
                                                  annotation (Placement(
        transformation(extent={{-160,10},{-120,50}}), iconTransformation(extent=
           {{-140,10},{-100,50}})));
  Controls.OBC.CDL.Interfaces.BooleanOutput slaTemAla
    "True if alarm is triggered; false if not"
    annotation (Placement(transformation(extent={{100,10},{140,50}})));
  Controls.OBC.CDL.Continuous.Hysteresis hys(uLow=TErr - 0.1, uHigh=TErr)
    "Trigger alarm if slab temp is out of range by a given amount, if error is sustained for specified time duration"
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
  Controls.OBC.CDL.Continuous.Hysteresis hys1(uLow=TiErr - 0.1, uHigh=TiErr)
    "Trigger alarm if slab temp is out of range by a given amount, if error is sustained for specified time duration"
    annotation (Placement(transformation(extent={{60,20},{80,40}})));
equation
  connect(swi.y,intWitRes. u) annotation (Line(points={{2,30},{18,30}},
                                   color={0,0,127}));
  connect(not7.y,intWitRes. trigger) annotation (Line(points={{2,-70},{30,-70},
          {30,18}},                       color={255,0,255}));
  connect(conZer.y, swi.u3) annotation (Line(points={{2,-30},{8,-30},{8,0},{-26,
          0},{-26,22},{-22,22}},
                         color={0,0,127}));
  connect(slaTemErr, abs.u)
    annotation (Line(points={{-140,30},{-102,30}}, color={0,0,127}));
  connect(abs.y, hys.u)
    annotation (Line(points={{-78,30},{-62,30}}, color={0,0,127}));
  connect(hys.y, swi.u2)
    annotation (Line(points={{-38,30},{-22,30}}, color={255,0,255}));
  connect(intWitRes.y, hys1.u) annotation (Line(points={{42,30},{58,30}},
                    color={0,0,127}));
  connect(hys1.y, slaTemAla) annotation (Line(points={{82,30},{92,30},{92,30},{
          120,30}}, color={255,0,255}));
  connect(conOne.y, swi.u1) annotation (Line(points={{2,90},{6,90},{6,56},{-28,
          56},{-28,38},{-22,38}}, color={0,0,127}));
  connect(hys.y, not7.u) annotation (Line(points={{-38,30},{-32,30},{-32,-70},{
          -22,-70}},                     color={255,0,255}));
  connect(conZer.y, intWitRes.y_reset_in) annotation (Line(points={{2,-30},{8,
          -30},{8,22},{18,22}}, color={0,0,127}));
  annotation (defaultComponentName = "slaTemAla",Documentation(info="<html>
<p>
This block is a slab temperature alarm, which will show true if the slab temperature
has been a user-specified amount above or below setpoint (TErr) for a user-specified amount of time (TiErr).  
</p>
</html>"),Icon(coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-100},{100,100}}), graphics={
        Text(
          lineColor={0,0,255},
          extent={{-150,110},{150,150}},
          textString="%name"),  Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Line(points={{-80,68},{-80,-80}}, color={192,192,192}),
        Polygon(
          points={{-80,90},{-88,68},{-72,68},{-80,90}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(points={{-90,-70},{82,-70}}, color={192,192,192}),
        Polygon(
          points={{90,-70},{68,-62},{68,-78},{90,-70}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-150,-150},{150,-110}},
          lineColor={0,0,0},
          textString="duration=%duration"),
        Polygon(lineColor = {191,0,0},
                fillColor = {191,0,0},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points={{20,58},{100,-2},{20,-62},{20,58}}),
        Text(
        extent={{-86,90},{28,-88}},
        lineColor={0,0,0},
        fillColor={0,0,0},
        fillPattern=FillPattern.Solid,
        textString="A"),
        Text(
          extent={{226,60},{106,10}},
          lineColor={0,0,0},
          textString=DynamicSelect("", String(y, leftjustified=false, significantDigits=3)))}), Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-120,-100},{100,100}}), graphics={
        Text(
          extent={{-118,80},{258,64}},
          lineColor={0,0,0},
          lineThickness=1,
          fontSize=9,
          horizontalAlignment=TextAlignment.Left,
          textStyle={TextStyle.Bold},
          textString="Slab Temperature Alarm:
Alarm shows true 
if slab temperature 
has been a 
user-specified 
amount out of range
for a user-specified
duration"),
        Rectangle(
          extent={{-70,100},{50,-100}},
          lineColor={217,67,180},
          lineThickness=1),
        Rectangle(
          extent={{50,100},{100,-100}},
          lineColor={217,67,180},
          lineThickness=1),
        Text(
          extent={{-66,-12},{-38,-64}},
          lineColor={217,67,180},
          lineThickness=1,
          fontName="Arial Narrow",
          horizontalAlignment=TextAlignment.Left,
          fontSize=12,
          textString="Integrates for each 
second 
slab temperature
is out of range;
resets to zero if
slab temperature
is no longer
out of range"),
        Text(
          extent={{58,100},{86,48}},
          lineColor={217,67,180},
          lineThickness=1,
          fontName="Arial Narrow",
          horizontalAlignment=TextAlignment.Left,
          fontSize=12,
          textString="Tests if 
time integral is
greater than
time threshhold")}));
end SlabTempAlarm;
