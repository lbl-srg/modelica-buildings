within Buildings.Experimental.NaturalVentilation.NightFlush;
block NightFlushDynamicDuration "Implements night flush sequence with dynamic duration"

  parameter Real e(min=0,max=24)=18 "hour at which occupancy ends";

  Controls.OBC.CDL.Interfaces.RealInput uForHi "Forecast high temperature"
    annotation (Placement(transformation(extent={{-140,-30},{-100,10}}),
        iconTransformation(extent={{-142,-48},{-102,-8}})));
  Controls.OBC.CDL.Interfaces.RealInput uRooSet "Room temperature setpoint"
    annotation (Placement(transformation(extent={{-140,-90},{-100,-50}}),
        iconTransformation(extent={{-140,2},{-100,42}})));
  Controls.OBC.CDL.Interfaces.RealOutput yRooSetAdj
    "Adjusted room setpoint for night flush duration" annotation (Placement(
        transformation(extent={{340,-20},{380,20}}), iconTransformation(extent={{100,30},
            {140,70}})));
  Controls.OBC.CDL.Discrete.Sampler sam(samplePeriod=86400)
    annotation (Placement(transformation(extent={{-62,18},{-42,38}})));
  Controls.SetPoints.Table tabRoo(table=[297.0388889,293.15; 298.15,293.15;
        298.16,292.5944444; 299.8166667,292.5944444; 299.82,292.0388889;
        301.4833333,292.0388889; 301.49,291.4833333; 302.5944444,291.4833333;
        302.6,290.9277778; 303.7055556,290.9277778; 303.71,290.3722222;
        305.3722222,290.3722222; 305.38,289.8166667])
    "Room air temperature setpoint lookup table"
    annotation (Placement(transformation(extent={{102,-42},{60,0}})));
  Controls.SetPoints.Table tabStop(table=[296,0; 297.0389,0; 297.04,14400;
        298.15,14400; 298.16,14400; 299.8166667,14400; 299.82,21600;
        301.4833333,21600; 301.49,21600; 302.5944444,21600; 302.6,21600;
        303.7055556,21600; 303.71,21600; 305.3722222,21600; 305.38,21600])
                "Night flush stop time (seconds after midnight)"
    annotation (Placement(transformation(extent={{100,140},{58,182}})));
  Controls.OBC.CDL.Continuous.Hysteresis hysTem(uLow=297 - 0.1, uHigh=297)
    "Tests if forecast high is below user-specified night flush low threshhold- if so, bypass night flush logic"
    annotation (Placement(transformation(extent={{0,18},{20,38}})));
  Controls.OBC.CDL.Logical.Sources.Pulse booPul1(width=0.99,
                                                 period=86400)
    "Pulse indicating that night flush could be active"
    annotation (Placement(transformation(extent={{-80,80},{-60,100}})));
  Controls.OBC.CDL.Logical.Switch swi
    "Switches between night flush and standard setpoiunt based on night flush activity"
    annotation (Placement(transformation(extent={{300,-62},{320,-42}})));
  Controls.OBC.CDL.Continuous.Hysteresis hysNitFlu(uLow=0, uHigh=5)
    "If time is greater than night flush start time (time minus start time > 0), night flush mode is on"
    annotation (Placement(transformation(extent={{122,100},{142,120}})));
  Controls.OBC.CDL.Logical.Timer tim                   "Time since midnight"
    annotation (Placement(transformation(extent={{0,80},{20,100}})));
  Controls.OBC.CDL.Continuous.Add add2(k1=-1, k2=1)
    "Timer minus night flush stop time- if timer > night flush stop time, night flush stops"
    annotation (Placement(transformation(extent={{80,100},{100,120}})));
  Controls.OBC.CDL.Interfaces.BooleanOutput yNitFlu
    "True if night flush mode is on, false if not" annotation (Placement(
        transformation(extent={{340,-110},{380,-70}}), iconTransformation(
          extent={{100,-48},{140,-8}})));
  Controls.OBC.CDL.Logical.And and1
    "Tests if dry bulb temperature is above room setpoint or above threshhold"
    annotation (Placement(transformation(extent={{258,20},{278,40}})));
  Controls.OBC.CDL.Logical.Or or2
    "True if pre- or post-occupancy night flush is active"
    annotation (Placement(transformation(extent={{200,100},{220,120}})));
  Controls.OBC.CDL.Logical.Sources.Pulse booPul2(width=en, period=86400)
    "Pulse indicating occupied hours"
    annotation (Placement(transformation(extent={{80,60},{100,80}})));
  Controls.OBC.CDL.Logical.Not not1
    "Outputs post-occupancy night flush signal- true if post-occupancy night flush is active, false if not"
    annotation (Placement(transformation(extent={{120,60},{140,80}})));
  Controls.OBC.CDL.Logical.Not not2
    "Outputs pre-occupancy night flush signal- true if pre-occupancy night flush is active, false if not"
    annotation (Placement(transformation(extent={{162,100},{182,120}})));
protected
          parameter Real en=(e/24) "Width of pulse that indicates it's before night flush stop time";
equation
  connect(uRooSet, swi.u3) annotation (Line(points={{-120,-70},{292,-70},{292,-60},
          {298,-60}}, color={0,0,127}));
  connect(uForHi, sam.u)
    annotation (Line(points={{-120,-10},{-92,-10},{-92,28},{-64,28}},
                                                    color={0,0,127}));
  connect(sam.y, tabStop.u) annotation (Line(points={{-40,28},{-20,28},{-20,196},
          {268,196},{268,161},{104.2,161}}, color={0,0,127}));
  connect(hysTem.u, sam.y) annotation (Line(points={{-2,28},{-40,28}},
                                color={0,0,127}));
  connect(booPul1.y, tim.u) annotation (Line(points={{-58,90},{-2,90}},
                        color={255,0,255}));
  connect(tim.y, add2.u2) annotation (Line(points={{22,90},{26,90},{26,104},{
          78,104}},
        color={0,0,127}));
  connect(add2.y, hysNitFlu.u)
    annotation (Line(points={{102,110},{120,110}},
                                                 color={0,0,127}));
  connect(sam.y, tabRoo.u) annotation (Line(points={{-40,28},{-20,28},{-20,50},
          {140,50},{140,-21},{106.2,-21}},
                                         color={0,0,127}));
  connect(tabRoo.y, swi.u1) annotation (Line(points={{57.9,-21},{38,-21},{38,
          -44},{298,-44}},                          color={0,0,127}));
  connect(swi.y, yRooSetAdj) annotation (Line(points={{322,-52},{334,-52},{334,0},
          {360,0}}, color={0,0,127}));
  connect(tabStop.y, add2.u1) annotation (Line(points={{55.9,161},{0,161},{0,
          116},{78,116}},
                     color={0,0,127}));
  connect(or2.y, and1.u1) annotation (Line(points={{222,110},{228,110},{228,30},
          {256,30}}, color={255,0,255}));
  connect(hysTem.y, and1.u2) annotation (Line(points={{22,28},{204,28},{204,22},
          {256,22}}, color={255,0,255}));
  connect(and1.y, swi.u2) annotation (Line(points={{280,30},{280,-53},{298,-53},
          {298,-52}}, color={255,0,255}));
  connect(and1.y, yNitFlu) annotation (Line(points={{280,30},{280,-90},{360,-90}},
        color={255,0,255}));
  connect(booPul2.y, not1.u)
    annotation (Line(points={{102,70},{118,70}}, color={255,0,255}));
  connect(not1.y, or2.u2) annotation (Line(points={{142,70},{188,70},{188,102},
          {198,102}}, color={255,0,255}));
  connect(or2.u1, not2.y)
    annotation (Line(points={{198,110},{184,110}}, color={255,0,255}));
  connect(hysNitFlu.y, not2.u)
    annotation (Line(points={{144,110},{160,110}}, color={255,0,255}));
  annotation (defaultComponentName = "nitFluDyn",  Documentation(info="<html>
  <p>This block determines if night flush is required and outputs the appropriate night flush setpoint for the appropriate night flush duration, 
  given the current setpoint and the forecast high temperature. 
  <p> Based on the forecast high for each day, a night flush stop time and set point are selected from a lookup table, as shown below. 
  <p>Higher forecast high temperatures yield later night flush stop times and lower night flush setpoints. 
  <p>Below a forecast high of 75F, night flush is not active.
 
 
 <p>
 <table>
 <tr><th>Forecast High Temp Above [deg F]</th>       <th>Night Flush Setpoint [deg F] </th>  <th>Stop Time </th>      </tr>
<tr><td>75F</td>         <td>68F</td>  <td>4AM</td>      </tr>
<tr><td>77F</td>         <td>67F</td>  <td>4AM</td>       </tr>
<tr><td>80F</td>         <td>66F</td>  <td>6AM</td>      </tr>
<tr><td>83F</td>         <td>65F</td>  <td>6AM</td>      </tr>
<tr><td>85F</td>         <td>64F</td>  <td>6AM</td>     </tr>
<tr><td>87F</td>         <td>63F</td>  <td>6AM</td>     </tr>
<tr><td>90F</td>         <td>62F</td>  <td>6AM</td>     </tr>

</table>
</p>

<p>The user specifies a last occupied hour (e, typically 18 = 6PM). 
<p>Each day at midnight, the setpoint is set to the night flush setpoint based on the forecast high for the coming day.
<p>The setpoint remains at night flush value until the specified stop time, as per the lookup table. 
<p>The night flush signal is set to true until this stop time.
<p>From the stop time until the last occupied hour, the setpoint input is passed through the night flush block unchanged. 
<p>After the last occupied hour, the setpoint is again set to the night flush value until midnight, at which point the night flush setpoint is updated
to the appropriate value based on the new day's forecast high OR is turned off, if the new day's forecast high is below 75F. 


If night flush is not on, the setpoint passes through the block unchanged and the night flush signal is false. 

  
<p>
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
          lineColor={162,29,33},
          lineThickness=1,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{70,82},{-70,-62}},
          lineColor={28,108,200},
          fillColor={162,29,33},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-36,80},{82,-66}},
          pattern=LinePattern.None,
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-2,58},{84,-46}},
          lineColor={28,108,200},
          fillColor={162,29,33},
          fillPattern=FillPattern.Solid,
          textString="dyn"),
        Rectangle(
          extent={{-10,42},{94,-32}},
          lineColor={28,108,200},
          lineThickness=1),
        Text(
          lineColor={0,0,255},
          extent={{-144,100},{156,140}},
          textString="%name")}),            Diagram(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-140},{340,240}}),
        graphics={Rectangle(
          extent={{-100,200},{338,54}},
          lineColor={28,108,200},
          lineThickness=1), Text(
          extent={{242,160},{308,62}},
          lineColor={28,108,200},
          lineThickness=1,
          horizontalAlignment=TextAlignment.Left,
          textString="Before night flush 
stop time 
& after occupancy,
night flush is allowed
(if OAT forecast high
triggers night flush sequence)"),
                            Text(
          extent={{-68,44},{-2,-54}},
          lineColor={28,108,200},
          lineThickness=1,
          horizontalAlignment=TextAlignment.Left,
          textString="Night flush is locked out
if forecast high is too cold"),
                  Rectangle(
          extent={{-98,54},{32,-32}},
          lineColor={28,108,200},
          lineThickness=1),
                  Rectangle(
          extent={{32,54},{340,-134}},
          lineColor={28,108,200},
          lineThickness=1), Text(
          extent={{192,26},{258,-72}},
          lineColor={28,108,200},
          lineThickness=1,
          horizontalAlignment=TextAlignment.Left,
          textString="If night flush is active, 
pass night flush setpoint. 
Otherwise, 
pass room setpoint"),
        Text(
          extent={{-94,242},{306,210}},
          lineColor={0,0,0},
          lineThickness=1,
          fontSize=9,
          horizontalAlignment=TextAlignment.Left,
          textStyle={TextStyle.Bold},
          textString="Night Flush Dynamic Duration:
If forecast high calls for night flush,
night flush mode begins immediately after the last occupied hour and doesn't end until specified stop time from lookup table.")}));
end NightFlushDynamicDuration;
