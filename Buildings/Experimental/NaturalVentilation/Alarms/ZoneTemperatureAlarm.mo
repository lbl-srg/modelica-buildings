within Buildings.Experimental.NaturalVentilation.Alarms;
block ZoneTemperatureAlarm
  "Alarm if zone temp is out of range for more than a given time duration"
parameter Real TiErr(min=0,
    final unit="s",
    final displayUnit="s",
    final quantity="Time")=3600  "Time threshhold air temp must be out of range to trigger alarm";
parameter Real TErr(min=0,
    final unit="K",
    final displayUnit="K",
    final quantity="TemperatureDifference")=1.1 "Difference from zone air temp setpoint required to trigger alarm";

  Controls.OBC.CDL.Continuous.Abs           abs
    "Absolute value of difference between slab setpoint and slab temp"
    annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));
  Controls.OBC.CDL.Logical.Not           not7
    "Zero out integral if error is below threshhold"
    annotation (Placement(transformation(extent={{20,-140},{40,-120}})));
  Controls.OBC.CDL.Continuous.Sources.Constant           ConZero(k=0)
    "Error integral- constant zero"
    annotation (Placement(transformation(extent={{18,-102},{38,-82}})));
  Controls.OBC.CDL.Continuous.Sources.Constant           ConOne(k=1)
    "Error integral- constant one"
    annotation (Placement(transformation(extent={{20,20},{40,40}})));
  Controls.OBC.CDL.Logical.Switch           swi
    "Switch integrated function from constant zero to constant one if error is above threshhold"
    annotation (Placement(transformation(extent={{20,-40},{40,-20}})));
  Controls.OBC.CDL.Continuous.IntegratorWithReset           intWitRes
    "Find integral of how long error has been above threshold, reset to zero if error goes below 2 F threshhold"
    annotation (Placement(transformation(extent={{60,-40},{80,-20}})));
  Controls.OBC.CDL.Continuous.Hysteresis hys(uLow=TErr - 0.1, uHigh=TErr)
    "Trigger alarm if slab temp is out of range by a given amount, if error is sustained for specified time duration"
    annotation (Placement(transformation(extent={{-20,-40},{0,-20}})));
  Controls.OBC.CDL.Continuous.Hysteresis hys1(uLow=TiErr - 0.1, uHigh=TiErr)
    "Trigger alarm if slab temp is out of range by a given amount, if error is sustained for specified time duration"
    annotation (Placement(transformation(extent={{100,-40},{120,-20}})));
  Controls.OBC.CDL.Interfaces.RealInput TRooMea
    "Measured room air temperature " annotation (Placement(transformation(
          extent={{-180,-20},{-140,20}}), iconTransformation(extent={{-140,10},{
            -100,50}})));
  Controls.OBC.CDL.Interfaces.BooleanOutput TZonAla
    "True if alarm is triggered; false if not"
    annotation (Placement(transformation(extent={{140,-56},{180,-16}}),
        iconTransformation(extent={{100,-20},{140,20}})));
  Controls.OBC.CDL.Interfaces.RealInput TRooSet "Room temperature setpoint"
    annotation (Placement(transformation(extent={{-180,-80},{-140,-40}}),
        iconTransformation(extent={{-140,-54},{-100,-14}})));
  Controls.OBC.CDL.Continuous.Add addErr(k1=+1, k2=-1)
    "Air temperature minus air setpoint"
    annotation (Placement(transformation(extent={{-100,-40},{-80,-20}})));
equation
  connect(swi.y,intWitRes. u) annotation (Line(points={{42,-30},{58,-30}},
                                   color={0,0,127}));
  connect(ConZero.y,swi. u3) annotation (Line(points={{40,-92},{40,-60},{14,-60},
          {14,-38},{18,-38}}, color={0,0,127}));
  connect(abs.y,hys. u)
    annotation (Line(points={{-38,-30},{-22,-30}},
                                                 color={0,0,127}));
  connect(hys.y,swi. u2)
    annotation (Line(points={{2,-30},{18,-30}},  color={255,0,255}));
  connect(intWitRes.y,hys1. u) annotation (Line(points={{82,-30},{98,-30}},
                    color={0,0,127}));
  connect(hys1.y, TZonAla) annotation (Line(points={{122,-30},{132,-30},{132,-36},
          {160,-36}}, color={255,0,255}));
  connect(ConOne.y, swi.u1) annotation (Line(points={{42,30},{46,30},{46,-4},{12,
          -4},{12,-22},{18,-22}}, color={0,0,127}));
  connect(hys.y, not7.u) annotation (Line(points={{2,-30},{6,-30},{6,-104},{-10,
          -104},{-10,-130},{18,-130}}, color={255,0,255}));
  connect(not7.y, intWitRes.trigger) annotation (Line(points={{42,-130},{70,
          -130},{70,-42}}, color={255,0,255}));
  connect(ConZero.y, intWitRes.y_reset_in) annotation (Line(points={{40,-92},{
          50,-92},{50,-38},{58,-38}}, color={0,0,127}));
  connect(TRooMea, addErr.u1) annotation (Line(points={{-160,0},{-130,0},{-130,
          -24},{-102,-24}}, color={0,0,127}));
  connect(TRooSet, addErr.u2) annotation (Line(points={{-160,-60},{-130,-60},{-130,
          -36},{-102,-36}}, color={0,0,127}));
  connect(addErr.y, abs.u)
    annotation (Line(points={{-78,-30},{-62,-30}}, color={0,0,127}));
  annotation (defaultComponentName = "zonTemAla",Documentation(info="<html>
  <p>
  This alarm is triggered when the zone air temperature is out of range by a user-specified amount for a user-specified amount of time.
 <p>The user specifies values for two parameters:
         <p>1. The amount of time the air temperature must be out of range to trigger the alarm, TiErr
         <p>2. The difference from the zone air temperature setpoint  required to trigger the alarm, TErr

<p> If the zone temperature is more than the user-specified difference out of range for more than the user-specified amount of time, the alarm is triggered. 
</p>
</html>", revisions="<html>
<ul>
<li>
October 6, 2020, by Fiona Woods:<br/>
Updated description. 
</li>
</html>"),Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={238,46,47},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
          Polygon(
          points={{-40,90},{40,90},{60,32},{60,-30},{40,-90},{-40,-90},{-60,-30},
              {-60,30},{-40,90}},
          lineColor={255,0,0},
          lineThickness=1), Text(
          extent={{-18,50},{18,-46}},
          lineColor={255,0,0},
          lineThickness=1,
          textString="Z"),
        Text(
          lineColor={0,0,255},
          extent={{-144,106},{156,146}},
          textString="%name")}),
                             Diagram(coordinateSystem(preserveAspectRatio=false, extent={
            {-140,-160},{140,100}}), graphics={
        Text(
          extent={{-110,-66},{-82,-118}},
          lineColor={217,67,180},
          lineThickness=1,
          fontName="Arial Narrow",
          horizontalAlignment=TextAlignment.Left,
          fontSize=12,
          textString="Integrates for each second 
zone temperature
is out of range;
resets to zero if
zone temperature
is no longer out of range"),
        Rectangle(
          extent={{-140,50},{80,-160}},
          lineColor={217,67,180},
          lineThickness=1),
        Rectangle(
          extent={{80,50},{140,-160}},
          lineColor={217,67,180},
          lineThickness=1),
        Text(
          extent={{90,50},{118,-2}},
          lineColor={217,67,180},
          lineThickness=1,
          fontName="Arial Narrow",
          horizontalAlignment=TextAlignment.Left,
          fontSize=12,
          textString="Tests if 
time integral is
greater than
time threshold"),
        Text(
          extent={{-136,74},{240,58}},
          lineColor={0,0,0},
          lineThickness=1,
          fontSize=9,
          horizontalAlignment=TextAlignment.Left,
          textStyle={TextStyle.Bold},
          textString="Zone Temperature Alarm:
Alarm shows true 
if zone temperature 
has been a 
user-specified 
amount out of range
for a user-specified
duration")}));
end ZoneTemperatureAlarm;
