within Buildings.Experimental.NaturalVentilation.NightFlush;
block NightFlushFixedDuration
  "Implements night flush sequence with fixed duration"

  parameter Real h(min=0,max=24)=6 "hour at which night flush ends";

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
    "Samples forecast high"
    annotation (Placement(transformation(extent={{-60,-20},{-40,0}})));
  Controls.SetPoints.Table tabRoo(table=[294.2611111,294.2611111; 297.0388889,
        294.2611111; 297.04,293.7055556; 299.8166667,293.7055556; 299.82,
        292.5944444; 302.5944444,292.5944444; 302.6,291.4833333; 305.3722222,
        291.4833333; 305.38,290.3722222])
    "Room air temperature setpoint lookup table"
    annotation (Placement(transformation(extent={{122,-24},{80,18}})));
  Controls.SetPoints.Table tabDur(table=[293,0; 294.2611111,0; 294.27,3600;
        297.0388889,3600; 297.04,7200; 299.8166667,7200; 299.82,10800;
        302.5944444,10800; 302.6,14400; 305.3722222,14400; 305.38,18000])
                                                    "Night flish duration"
    annotation (Placement(transformation(extent={{100,140},{58,182}})));
  Controls.OBC.CDL.Continuous.Hysteresis hysTem(uLow=294.2 - 0.1, uHigh=294.2)
    "Tests if forecast high is below user-specified night flush low threshhold- if so, bypass night flush logic"
    annotation (Placement(transformation(extent={{-22,-20},{-2,0}})));
  Controls.OBC.CDL.Logical.Sources.Pulse booPul1(width=wi,
                                                 period=86400)
    "Pulse indicating that night flush could be active"
    annotation (Placement(transformation(extent={{-98,-140},{-78,-120}})));
  Controls.OBC.CDL.Logical.Switch swi
    annotation (Placement(transformation(extent={{300,-62},{320,-42}})));
  Controls.OBC.CDL.Logical.And3 and3
    "True if after night flush start time, before night flush stop time, and temperature is above low threshhold"
    annotation (Placement(transformation(extent={{240,-62},{260,-42}})));
  Controls.OBC.CDL.Continuous.Hysteresis hysNitFlu(uLow=0, uHigh=0.1)
    "If time is greater than night flush start time (time minus start time > 0), night flush mode is on"
    annotation (Placement(transformation(extent={{140,80},{160,100}})));
  Controls.OBC.CDL.Continuous.AddParameter addPar(p=h*3600, k=-1)
    "Subtracts night flush duration from hour at which night flush stops to get hour at which night flush starts"
    annotation (Placement(transformation(extent={{40,100},{60,120}})));
  Controls.OBC.CDL.Logical.Timer tim                   "Time since midnight"
    annotation (Placement(transformation(extent={{40,60},{60,80}})));
  Controls.OBC.CDL.Continuous.Add add2(k1=-1, k2=1)
    "Time since midnight minus hour at which night flush starts"
    annotation (Placement(transformation(extent={{100,80},{120,100}})));
  Controls.OBC.CDL.Interfaces.BooleanOutput yNitFlu
    "True if night flush mode is on, false if not" annotation (Placement(
        transformation(extent={{340,-110},{380,-70}}), iconTransformation(
          extent={{100,-48},{140,-8}})));
protected
          parameter Real wi=(h/24) "Width of pulse that indicates it is before night flush stop time";
equation
  connect(uRooSet, swi.u3) annotation (Line(points={{-120,-70},{282,-70},{282,-60},
          {298,-60}}, color={0,0,127}));
  connect(hysTem.y, and3.u2) annotation (Line(points={{0,-10},{20,-10},{20,-52},
          {238,-52}}, color={255,0,255}));
  connect(and3.y, swi.u2)
    annotation (Line(points={{262,-52},{298,-52}}, color={255,0,255}));
  connect(uForHi, sam.u)
    annotation (Line(points={{-120,-10},{-62,-10}}, color={0,0,127}));
  connect(sam.y, tabDur.u) annotation (Line(points={{-38,-10},{-32,-10},{-32,106},
          {-34,106},{-34,196},{256,196},{256,161},{104.2,161}}, color={0,0,127}));
  connect(hysTem.u, sam.y) annotation (Line(points={{-24,-10},{-24,-8},{-28,-8},
          {-28,-10},{-38,-10}}, color={0,0,127}));
  connect(tabDur.y, addPar.u) annotation (Line(points={{55.9,161},{55.9,160},{0,
          160},{0,110},{38,110}}, color={0,0,127}));
  connect(booPul1.y, tim.u) annotation (Line(points={{-76,-130},{-70,-130},{
          -70,70},{38,70}},
                        color={255,0,255}));
  connect(addPar.y, add2.u1) annotation (Line(points={{62,110},{80,110},{80,96},
          {98,96}}, color={0,0,127}));
  connect(tim.y, add2.u2) annotation (Line(points={{62,70},{80,70},{80,84},{98,84}},
        color={0,0,127}));
  connect(add2.y, hysNitFlu.u)
    annotation (Line(points={{122,90},{138,90}}, color={0,0,127}));
  connect(sam.y, tabRoo.u) annotation (Line(points={{-38,-10},{-32,-10},{-32,42},
          {148,42},{148,-3},{126.2,-3}}, color={0,0,127}));
  connect(tabRoo.y, swi.u1) annotation (Line(points={{77.9,-3},{62,-3},{62,
          -26},{280,-26},{280,-44},{298,-44}},      color={0,0,127}));
  connect(hysNitFlu.y, and3.u1) annotation (Line(points={{162,90},{202,90},{202,
          -44},{238,-44}}, color={255,0,255}));
  connect(swi.y, yRooSetAdj) annotation (Line(points={{322,-52},{334,-52},{334,0},
          {360,0}}, color={0,0,127}));
  connect(and3.y, yNitFlu) annotation (Line(points={{262,-52},{270,-52},{270,-90},
          {360,-90}}, color={255,0,255}));
  connect(booPul1.y, and3.u3) annotation (Line(points={{-76,-130},{82,-130},{82,
          -60},{238,-60}}, color={255,0,255}));
  annotation (defaultComponentName = "nitFluFix",  Documentation(info="<html>
  <p>This block determines if night flush is required and outputs the appropriate night flush setpoint for the appropriate night flush duration, 
  given the current setpoint and the forecast high temperature. 
  <p> Based on the forecast high for each day, a night flush duration and set point are selected from a lookup table, as shown below. 
  <p>Higher forecast high temperatures yield longer night flush durations and lower night flush setpoints. 
  <p>Below a forecast high of 70F, night flush is not active.
  <p>The user specifies a fixed night flush stop time (h, typically 6 = 6AM) at which night flush stops every day it is active.
 
 <p>
 <table>
<tr><th>Forecast High Temp Above [deg F]</th>       <th>Night Flush Setpoint [deg F] </th>  <th>Duration [hours] </th>      </tr>
<tr><td>70</td>         <td>70</td>  <td>1</td>      </tr>
<tr><td>75</td>         <td>69</td>  <td>2</td>       </tr>
<tr><td>80</td>         <td>67</td>  <td>3</td>      </tr>
<tr><td>85</td>         <td>65</td>  <td>4</td>      </tr>
<tr><td>90</td>         <td>63</td>  <td>5</td>     </tr>

</table>
</p>

During the setpoint duration, the setpoint is changed to the appropriate night flush setpoint. During this specified duration, the night flush signal is set to true.
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
          lineColor={0,0,255},
          extent={{-148,102},{152,142}},
          textString="%name")}),            Diagram(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-160},{340,280}}),
        graphics={
        Text(
          extent={{-90,270},{310,238}},
          lineColor={0,0,0},
          lineThickness=1,
          fontSize=9,
          horizontalAlignment=TextAlignment.Left,
          textStyle={TextStyle.Bold},
          textString="Night Flush Fixed Duration:
If forecast high calls for night flush,
night flush mode begins at a specified start time based on lookup table
and continues until a fixed stop time specified by the user"),
                            Text(
          extent={{-66,12},{0,-86}},
          lineColor={28,108,200},
          lineThickness=1,
          horizontalAlignment=TextAlignment.Left,
          textString="Night flush is locked out
if forecast high is too cold"),
        Rectangle(
          extent={{-98,46},{36,-62}},
          lineColor={28,108,200},
          lineThickness=1),
        Rectangle(
          extent={{-98,214},{338,46}},
          lineColor={28,108,200},
          lineThickness=1), Text(
          extent={{160,174},{226,76}},
          lineColor={28,108,200},
          lineThickness=1,
          horizontalAlignment=TextAlignment.Left,
          textString="If forecast high requires night flush, 
and it is after the start time
 (as determined by the lookup table) 
and before the user-specified stop time,
 night flush setpoint is determined"),
                            Text(
          extent={{226,54},{292,-44}},
          lineColor={28,108,200},
          lineThickness=1,
          horizontalAlignment=TextAlignment.Left,
          textString="If night flush is active, 
pass night flush setpoint. 
Otherwise, 
pass room setpoint"),
        Rectangle(
          extent={{36,46},{340,-160}},
          lineColor={28,108,200},
          lineThickness=1)}));
end NightFlushFixedDuration;
