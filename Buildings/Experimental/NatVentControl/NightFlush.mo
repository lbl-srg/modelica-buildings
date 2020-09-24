within Buildings.Experimental.NatVentControl;
package NightFlush "Night flush blocks"
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
    connect(hysTem.u, sam.y) annotation (Line(points={{-2,28},{-2,30},{-24,30},{-24,
            28},{-40,28}},        color={0,0,127}));
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
</html>"),  Icon(coordinateSystem(preserveAspectRatio=false), graphics={
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
            preserveAspectRatio=false, extent={{-100,-260},{340,200}}),
          graphics={Rectangle(
            extent={{-100,200},{338,52}},
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
triggers night flush sequence)")}));
  end NightFlushDynamicDuration;

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
    connect(booPul1.y, tim.u) annotation (Line(points={{-76,-130},{-66,-130},{-66,
            70},{38,70}}, color={255,0,255}));
    connect(addPar.y, add2.u1) annotation (Line(points={{62,110},{80,110},{80,96},
            {98,96}}, color={0,0,127}));
    connect(tim.y, add2.u2) annotation (Line(points={{62,70},{80,70},{80,84},{98,84}},
          color={0,0,127}));
    connect(add2.y, hysNitFlu.u)
      annotation (Line(points={{122,90},{138,90}}, color={0,0,127}));
    connect(sam.y, tabRoo.u) annotation (Line(points={{-38,-10},{-32,-10},{-32,42},
            {148,42},{148,-3},{126.2,-3}}, color={0,0,127}));
    connect(tabRoo.y, swi.u1) annotation (Line(points={{77.9,-3},{62,-3},{62,-28},
            {280,-28},{280,-46},{298,-46},{298,-44}}, color={0,0,127}));
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
</html>"),  Icon(coordinateSystem(preserveAspectRatio=false), graphics={
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
            preserveAspectRatio=false, extent={{-100,-160},{340,200}})));
  end NightFlushFixedDuration;

  package Validation "Validation model for night flush strategies"
    model NightFlushDynamic "Night flush validation model"
      Modelica.Blocks.Sources.Ramp ramp1(
        height=30,
        duration=864000,
        offset=290)
        annotation (Placement(transformation(extent={{-60,-20},{-40,0}})));
      Modelica.Blocks.Sources.Constant const1(k=280)
        annotation (Placement(transformation(extent={{-60,60},{-40,80}})));
      NightFlushDynamicDuration nitFluDyn
        annotation (Placement(transformation(extent={{0,0},{20,20}})));
    equation
      connect(const1.y, nitFluDyn.uRooSet) annotation (Line(points={{-39,70},{-20,
              70},{-20,12.2},{-2,12.2}}, color={0,0,127}));
      connect(ramp1.y, nitFluDyn.uForHi) annotation (Line(points={{-39,-10},{-20,
              -10},{-20,7.2},{-2.2,7.2}}, color={0,0,127}));
      annotation (experiment(Tolerance=1e-6, StartTime=0, StopTime=864000),__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/NatVentControl/NightFlush/Validation/NightFlushDynamic.mos"
            "Simulate and plot"),Icon(coordinateSystem(preserveAspectRatio=false), graphics={
            Ellipse(
              lineColor={75,138,73},
              fillColor={255,255,255},
              fillPattern=FillPattern.Solid,
              extent={{-100,-100},{100,100}}),
            Polygon(lineColor = {0,0,255},
                    fillColor = {75,138,73},
                    pattern = LinePattern.None,
                    fillPattern = FillPattern.Solid,
                    points={{-34,64},{66,4},{-34,-56},{-34,64}})}), Diagram(
            coordinateSystem(preserveAspectRatio=false)));
    end NightFlushDynamic;

    model NightFlushFixed "Night flush validation model"
      Modelica.Blocks.Sources.Ramp ramp(
        height=30,
        duration=864000,
        offset=290)
        annotation (Placement(transformation(extent={{-60,-20},{-40,0}})));
      Modelica.Blocks.Sources.Constant const(k=280)
        annotation (Placement(transformation(extent={{-60,60},{-40,80}})));
      NightFlushFixedDuration nitFluFix
        annotation (Placement(transformation(extent={{0,0},{20,20}})));
    equation
      connect(const.y, nitFluFix.uRooSet) annotation (Line(points={{-39,70},{-20,
              70},{-20,12.2},{-2,12.2}}, color={0,0,127}));
      connect(ramp.y, nitFluFix.uForHi) annotation (Line(points={{-39,-10},{-22,
              -10},{-22,7.2},{-2.2,7.2}}, color={0,0,127}));
      annotation (experiment(Tolerance=1e-6, StartTime=0, StopTime=864000),__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/NatVentControl/NightFlush/Validation/NightFlushFixed.mos"
            "Simulate and plot"),Icon(coordinateSystem(preserveAspectRatio=false), graphics={
            Ellipse(
              lineColor={75,138,73},
              fillColor={255,255,255},
              fillPattern=FillPattern.Solid,
              extent={{-100,-100},{100,100}}),
            Polygon(lineColor = {0,0,255},
                    fillColor = {75,138,73},
                    pattern = LinePattern.None,
                    fillPattern = FillPattern.Solid,
                    points={{-34,64},{66,4},{-34,-56},{-34,64}})}), Diagram(
            coordinateSystem(preserveAspectRatio=false)));
    end NightFlushFixed;

  end Validation;
end NightFlush;
