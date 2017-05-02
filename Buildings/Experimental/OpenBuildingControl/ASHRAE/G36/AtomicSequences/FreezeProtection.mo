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
  //fixme: units for instantiated limits, example TOut limit is 75K, delta = 1K
  CDL.Logical.LessThreshold TSupThreshold(threshold=276.483)
    "fixme: timer still not implemented, threshold value provided in K, units not indicated. Fixme: add hysteresis"
    annotation (Placement(transformation(extent={{-140,60},{-120,80}})));
  CDL.Logical.Timer timer1
    annotation (Placement(transformation(extent={{-100,60},{-80,80}})));
  CDL.Logical.Greater greater
    annotation (Placement(transformation(extent={{-60,50},{-40,70}})));
  CDL.Continuous.Constant TSupTimeLimit(k=300)
    "Max time during which TSup may be lower than temperature defined in the appropriate evaluation block. fixme: should this be a parameter, how do we deal with units"
    annotation (Placement(transformation(extent={{-100,30},{-80,50}})));
  CDL.Interfaces.StatusTypeOutput y
    annotation (Placement(transformation(extent={{180,-10},{200,10}})));
  CDL.Discrete.FreezeProtectionStage dayType1
    annotation (Placement(transformation(extent={{140,0},{160,20}})));
  CDL.Logical.LessThreshold TSupThreshold1(
                                          threshold=276.483)
    "fixme: timer still not implemented, threshold value provided in K, units not indicated. Fixme: add hysteresis"
    annotation (Placement(transformation(extent={{-140,160},{-120,180}})));
  CDL.Logical.Greater greater1
    annotation (Placement(transformation(extent={{-60,150},{-40,170}})));
  CDL.Logical.Timer timer2
    annotation (Placement(transformation(extent={{-100,160},{-80,180}})));
  CDL.Continuous.Constant TSupTimeLimit1(
                                        k=300)
    "Max time during which TSup may be lower than temperature defined in the appropriate evaluation block. fixme: should this be a parameter, how do we deal with units"
    annotation (Placement(transformation(extent={{-100,130},{-80,150}})));
  CDL.Logical.LessThreshold TSupThreshold2(
                                          threshold=276.483)
    "fixme: timer still not implemented, threshold value provided in K, units not indicated. Fixme: add hysteresis"
    annotation (Placement(transformation(extent={{-60,-140},{-40,-120}})));
  CDL.Logical.Timer timer3
    annotation (Placement(transformation(extent={{-20,-140},{0,-120}})));
  CDL.Continuous.Constant TSupTimeLimit2(
                                        k=300)
    "Max time during which TSup may be lower than temperature defined in the appropriate evaluation block. fixme: should this be a parameter, how do we deal with units"
    annotation (Placement(transformation(extent={{-20,-170},{0,-150}})));
  CDL.Logical.Greater greater2
    annotation (Placement(transformation(extent={{20,-150},{40,-130}})));
  CDL.Logical.LessThreshold TSupThreshold3(
                                          threshold=276.483)
    "fixme: timer still not implemented, threshold value provided in K, units not indicated. Fixme: add hysteresis"
    annotation (Placement(transformation(extent={{-140,-90},{-120,-70}})));
  CDL.Logical.Timer timer4
    annotation (Placement(transformation(extent={{-100,-90},{-80,-70}})));
  CDL.Continuous.Constant TSupTimeLimit3(
                                        k=300)
    "Max time during which TSup may be lower than temperature defined in the appropriate evaluation block. fixme: should this be a parameter, how do we deal with units"
    annotation (Placement(transformation(extent={{-100,-120},{-80,-100}})));
  CDL.Logical.Greater greater3
    annotation (Placement(transformation(extent={{-60,-100},{-40,-80}})));
  CDL.Logical.Or3 or1
    annotation (Placement(transformation(extent={{80,-40},{100,-20}})));
equation
  connect(TSupThreshold.y, timer1.u) annotation (Line(points={{-119,70},{-119,
          70},{-102,70}},            color={255,0,255}));
  connect(TSupTimeLimit.y, greater.u2) annotation (Line(points={{-79,40},{-70,
          40},{-70,52},{-62,52}}, color={0,0,127}));
  connect(timer1.y, greater.u1) annotation (Line(points={{-79,70},{-70,70},{-70,
          60},{-62,60}},   color={0,0,127}));
  connect(TSup, TSupThreshold.u) annotation (Line(points={{-200,0},{-200,0},{
          -160,0},{-160,70},{-142,70}},
                              color={0,0,127}));
  connect(TSupTimeLimit1.y, greater1.u2) annotation (Line(points={{-79,140},{
          -70,140},{-70,152},{-62,152}}, color={0,0,127}));
  connect(timer2.y, greater1.u1) annotation (Line(points={{-79,170},{-70,170},{
          -70,160},{-62,160}}, color={0,0,127}));
  connect(TSupThreshold1.y, timer2.u) annotation (Line(points={{-119,170},{-119,
          170},{-102,170}}, color={255,0,255}));
  connect(TOut, TSupThreshold1.u) annotation (Line(points={{-200,60},{-180,60},
          {-180,80},{-160,80},{-160,170},{-142,170}}, color={0,0,127}));
  connect(greater1.y, dayType1.uStage1OnOff) annotation (Line(points={{-39,160},
          {48.5,160},{48.5,14},{138,14}}, color={255,0,255}));
  connect(greater.y, dayType1.uStage2OnOff) annotation (Line(points={{-39,60},{
          20,60},{20,10},{138,10}}, color={255,0,255}));
  connect(dayType1.yFreezeProtectionStage, y) annotation (Line(points={{161,10},
          {172,10},{172,0},{190,0}}, color={255,85,85}));
  connect(timer3.y, greater2.u1) annotation (Line(points={{1,-130},{10,-130},{
          10,-140},{18,-140}}, color={0,0,127}));
  connect(TSupThreshold2.y, timer3.u) annotation (Line(points={{-39,-130},{-39,
          -130},{-22,-130}},color={255,0,255}));
  connect(TSupTimeLimit2.y, greater2.u2) annotation (Line(points={{1,-160},{10,
          -160},{10,-148},{18,-148}},    color={0,0,127}));
  connect(timer4.y, greater3.u1) annotation (Line(points={{-79,-80},{-70,-80},{
          -70,-90},{-62,-90}},    color={0,0,127}));
  connect(TSupThreshold3.y, timer4.u) annotation (Line(points={{-119,-80},{-119,
          -80},{-102,-80}},        color={255,0,255}));
  connect(TSupTimeLimit3.y, greater3.u2) annotation (Line(points={{-79,-110},{
          -70,-110},{-70,-98},{-62,-98}},   color={0,0,127}));
  connect(or1.y, dayType1.uStage3OnOff) annotation (Line(points={{101,-30},{110,
          -30},{110,6},{138,6}}, color={255,0,255}));
  connect(uFre, or1.u1) annotation (Line(points={{-200,-60},{-72,-60},{-72,-22},
          {78,-22}}, color={255,0,255}));
  connect(greater3.y, or1.u2) annotation (Line(points={{-39,-90},{20,-90},{20,
          -30},{78,-30}}, color={255,0,255}));
  connect(greater2.y, or1.u3) annotation (Line(points={{41,-140},{60,-140},{60,
          -38},{78,-38}}, color={255,0,255}));
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
        Rectangle(extent={{-172,192},{166,106}},lineColor={0,0,255}),
        Rectangle(extent={{-172,100},{110,0}},  lineColor={0,0,255}),
        Rectangle(extent={{-172,-6},{172,-190}},  lineColor={0,0,255}),
        Text(
          extent={{128,114},{164,110}},
          lineColor={0,0,255},
          textString="Stage 1"),
        Text(
          extent={{70,8},{106,4}},
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
get passed to any sequence influenced by the freeze protection stage as perscribed in ASHRAE G36, 
through a request block or directly. The initial output value is Freeze Protection Stage 0, which enumerates
a status where all relevant conditions are satisfying and freeze protection is not activated. 
The conditions for stages 1 through 3 are as follows:
</p>
<p>
Freeze Protection Stage 1:
</p>
<p>
Enable: TSup below 4.5℃ [40°F] for 5 minutes<br/>
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
