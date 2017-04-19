within Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.AtomicSequences;
model FreezeProtection
  "Freeze protection sequence according to G36 PART5.N.12 and O.9"

  CDL.Interfaces.RealInput TOut(unit="K", displayUnit="degC")
    "Outdoor temperature" annotation (Placement(transformation(extent={{-220,40},
            {-180,80}}),       iconTransformation(extent={{-220,40},{-180,80}})));
  CDL.Interfaces.BooleanInput uFre(start=false) "Freezestat status" annotation (
     Placement(transformation(extent={{-220,-80},{-180,-40}}),
                                                             iconTransformation(
          extent={{-220,-80},{-180,-40}})));
  CDL.Interfaces.RealInput TSup(unit="K", displayUnit="degC")
    "Supply air temperature" annotation (Placement(transformation(extent={{-220,
            -20},{-180,20}}), iconTransformation(extent={{-220,-20},{-180,20}})));
  CDL.Logical.Switch assignDamperPosition
    "If control loop signal = 1 opens the damper to it's max position; if signal = 0 closes the damper to it's min position."
    annotation (Placement(transformation(extent={{-120,-60},{-100,-40}})));
  CDL.Logical.Hysteresis hysTOut(uHigh=297, final uLow=297 - 1)
    "Close damper when TOut is above the uHigh, open it again only when TOut falls down to uLow"
    annotation (Placement(transformation(extent={{-100,90},{-80,110}})));
  //fixme: units for instantiated limits, example TOut limit is 75K, delta = 1K
  CDL.Logical.LessThreshold TSupThreshold(threshold=276.483)
    "fixme: timer still not implemented, threshold value provided in K, units not indicated. Fixme: add hysteresis"
    annotation (Placement(transformation(extent={{-120,50},{-100,70}})));
  CDL.Logical.Timer timer1
    annotation (Placement(transformation(extent={{-80,50},{-60,70}})));
  CDL.Logical.Greater greater
    annotation (Placement(transformation(extent={{-40,40},{-20,60}})));
  CDL.Continuous.Constant TSupTimeLimit(k=300)
    "Max time during which TSup may be lower than temperature defined in the appropriate evaluation block. fixme: should this be a parameter, how do we deal with units"
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  CDL.Interfaces.StatusTypeOutput y
    annotation (Placement(transformation(extent={{180,-10},{200,10}})));
equation
  connect(TOut, hysTOut.u) annotation (Line(points={{-200,60},{-200,58},{-192,58},
          {-192,60},{-160,60},{-160,100},{-132,100},{-132,100},{-102,100}},
                                                color={0,0,127}));
  connect(TSupThreshold.y, timer1.u) annotation (Line(points={{-99,60},{-90,60},
          {-82,60}},                 color={255,0,255}));
  connect(TSupTimeLimit.y, greater.u2) annotation (Line(points={{-59,30},{-52,30},
          {-52,42},{-42,42}},     color={0,0,127}));
  connect(timer1.y, greater.u1) annotation (Line(points={{-59,60},{-52,60},{-52,
          50},{-42,50}},   color={0,0,127}));
  connect(TSup, TSupThreshold.u) annotation (Line(points={{-200,0},{-200,0},{-140,
          0},{-140,26},{-140,60},{-122,60}},
                              color={0,0,127}));
  annotation (
    Icon(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-180,-200},{180,200}},
        initialScale=0.1), graphics={
        Rectangle(
          extent={{-100,-40},{100,160}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-38,-8},{-38,126},{40,126}},
          color={28,108,200},
          thickness=0.5),
        Line(
          points={{-38,72},{30,72}},
          color={28,108,200},
          thickness=0.5)}),
    Diagram(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-180,-200},{180,200}},
        initialScale=0.1), graphics={
        Rectangle(extent={{-172,192},{172,62}}, lineColor={0,0,255}),
        Rectangle(extent={{-172,56},{172,-64}}, lineColor={0,0,255}),
        Rectangle(extent={{-172,-70},{172,-190}}, lineColor={0,0,255}),
        Text(
          extent={{130,72},{166,68}},
          lineColor={0,0,255},
          textString="Stage 1"),
        Text(
          extent={{136,-52},{172,-56}},
          lineColor={0,0,255},
          textString="Stage 2"),
        Text(
          extent={{136,-178},{172,-182}},
          lineColor={0,0,255},
          textString="Stage 3")}),
    Documentation(info="<html>      
    <p>
This sequence implements the Freeze Protection according to G36 PART5.N.12 and O.9.
Inputs to the sequence are outdoor air temperature, supply air temperature, and 
freezestat status (if installed).
</p>   
<p>
Usage
</p>
<p>
The sequence is designed to output the Freeze Protection Stage. This signal should
get passed to any sequence influenced by the freeze protection stage, as perscribed
in ASHRAE G36. The initial output value is Freeze Protection Stage 0, which enumerates
a status where all relevant conditions are satisfying and freeze protection is not activated. 
The conditions for stages 1 through 3 are as follows:
</p>
<p>
Freeze Protection Stage 1:
</p>
<p>
Enable: TOut below 4.5℃ [40°F] for 5 minutes<br/>
Disable: TSup above 7℃ [45°F] for 5 minutes
</p>
<p>
Freeze Protection Stage 2:
</p>
<p>
Enable: TOut below 3.5℃ [38°F] for 5 minutes<br/>
Disable: After 1 hour set to Stage 1
</p>
<p>
Freeze Protection Stage 3:
</p>
<p>
Enable: TOut below 4.5℃ [40°F] for 15 minutes or 
TOut below 1.1℃ [34°F] for 5 minutes or Freezestat Status is ON (if installed) <br/>
Disable: Manual reset
</p>
<p>
Values in other sequences that react to the Freeze Protection Stage output:
</p>
<p>
Freeze Protection Stage 1 activated:
</p>
<p>
Make sure to affect: <br/>
EconomizerControl: set outDamPos to outDamPosMin <br/>
***TSupSet sequences: maintain TSup above 5.5℃ [42°F] <br/>
Send 2 or more BoilerPlantRequests [fixme: what are these supposed to do exactly,
which sequence do they influence?]
</p>
<p>
Freeze Protection Stage 2 activated:
</p>
<p>
Make sure to affect: <br/>
EconomizerControl: set outDamPos to outDamPhyPosMin <br/>
set Level 3 alarm [fixme: how are alarms implemented]
</p>
<p>
Freeze Protection Stage 3:
</p>
<p>
Make sure to affect: [fixme: most of these conditions are still not implemented in other sequences, go throught them and 
make sure that all variables are affected as desired]
EconomizerControl: set outDamPos to outDamPhyPosMin <br/>
Supply fan OFF<br/>
Relief fan OFF<br/>
Open cooling coil valve to 100%<br/>
Send Boiler Plant Requests (2 or more) to maintain max(TSup, TMix)>=80°F<br/>
Set Level 2 alarm [fixme - make Alarm sequence that takes freeze status as output, 
among other inputs req by G36, and output alarm level type output]
</p>
<p align=\"center\">
<img alt=\"Image of fixme\"
src=\"modelica://Buildings/Resources/Images/Experimental/OpenBuildingControl/ASHRAE/G36/fixme.png\"/>
</p>

</html>", revisions="<html>
<ul>
<li>
April 17, 2017, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>
</html>"));
end FreezeProtection;
