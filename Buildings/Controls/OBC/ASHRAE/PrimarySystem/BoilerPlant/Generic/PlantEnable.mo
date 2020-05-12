within Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Generic;
model PlantEnable
  "Sequence to enable/disable boiler plant based on heating hot-water requirements"

  parameter Integer nIgnReq(final min=0) = 0
  "Number of hot-water requests to be ignored before enablng boiler plant loop";

  parameter Integer nSchRow(final min=1) = 4
  "Number of rows to be created for plant schedule table";

  parameter Real TLocOut(final unit="K",
                         final displayUnit="degC") = 299.67
  "Boiler lock-out temperature for outdoor air";

  parameter Real plaOffThrTim(final unit="s",
                              final displayUnit="s") = 15*60
  "Minimum time for which the plant has to stay off once it has been disabled";

  parameter Real plaOnThrTim(final unit="s",
                             final displayUnit="s") = plaOffThrTim
  "Minimum time for which the boiler plant has to stay on once it has been enabled";

  parameter Real schTab[nSchRow,2] = [0,1; 6,1; 18,1; 24,1]
  "Table defining schedule for enabling plant";

  parameter Real staOnReqTim(final unit="s",
                             final displayUnit="s") = 3*60
  "Time-limit for receiving hot-water requests to maintain enabled plant on";

  parameter Real locDt(final unit="K",
                       final displayUnit="K",
                       final quantity="ThermodynamicTemperature") = 1
  "Temperature deadband for boiler lockout"
  annotation (Dialog(tab="Advanced"));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TOut(final unit="K",
                                                       final displayUnit="degC",
                                                       final quantity="ThermodynamicTemperature")
  "Measured outdoor air temperature"
    annotation (Placement(transformation(extent={{-200,-70},{-160,-30}}),
        iconTransformation(extent={{-140,-70},{-100,-30}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput supResReq
    "Number of heating hot-water requests"
    annotation (Placement(transformation(
          extent={{-200,30},{-160,70}}), iconTransformation(extent={{-140,30},{-100,
            70}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yPla
    "Plant enable signal"
    annotation (Placement(transformation(extent={{160,-20},
            {200,20}}), iconTransformation(extent={{100,-20},{140,20}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.TimeTable enaSch(final table=schTab,
    final smoothness=Buildings.Controls.OBC.CDL.Types.Smoothness.ConstantSegments,
                                                                 final timeScale=3600)
    "Table defining when plant can be enabled"
    annotation (Placement(transformation(extent={{-150,-120},{-130,-100}})));

  Buildings.Controls.OBC.CDL.Logical.Timer tim
  "Time since plant has been enabled"
  annotation (Placement(transformation(extent={{10,0},{30,20}})));

  Buildings.Controls.OBC.CDL.Logical.Timer tim2
  "Time since plant has been disabled"
  annotation (Placement(transformation(extent={{10,60},{30,80}})));

protected
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greThr(final threshold=0.5)
    "Check if schedule lets the controller enable the plant or not"
    annotation (Placement(transformation(extent={{-120,-120},{-100,-100}})));

  Buildings.Controls.OBC.CDL.Integers.GreaterThreshold intGreThr(final threshold=nIgnReq)
    "Check if number of requests is greater than number of requests to be ignored"
    annotation (Placement(transformation(extent={{-120,40},{-100,60}})));

  Buildings.Controls.OBC.CDL.Logical.Latch lat
    "Maintain plant status till the conditions to change it are met"
    annotation (Placement(transformation(extent={{120,-10},{140,10}})));

  Buildings.Controls.OBC.CDL.Logical.MultiAnd mulAnd(final nu=4)
    "Check if all the conditions for enabling plant have been met"
    annotation (Placement(transformation(extent={{80,110},{100,130}})));

  Buildings.Controls.OBC.CDL.Logical.MultiOr mulOr(final nu=3)
    "Check if any conditions except plant-on time have been satisfied to disable plant"
    annotation (Placement(transformation(extent={{30,-80},{50,-60}})));

  Buildings.Controls.OBC.CDL.Logical.And and2
    "Check if all conditions have been met to disable the plant"
    annotation (Placement(transformation(extent={{80,-40},{100,-20}})));

  Buildings.Controls.OBC.CDL.Logical.Not not1
    "Logical Not"
    annotation (Placement(transformation(extent={{-10,-120},{10,-100}})));

  Buildings.Controls.OBC.CDL.Continuous.AddParameter addPar(final p=TLocOut,
                                                            final k=-1)
    "Compare measured outdoor air temperature to boiler lockout temperature"
    annotation (Placement(transformation(extent={{-150,-60},{-130,-40}})));

  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys(final uLow=-locDt,
                                                       final uHigh=0)
    "Hysteresis loop to prevent cycling caused by measured value"
    annotation (Placement(transformation(extent={{-120,-60},{-100,-40}})));

  Buildings.Controls.OBC.CDL.Logical.Not not3
    "Logical Not"
    annotation (Placement(transformation(extent={{-70,-40},{-50,-20}})));

  Buildings.Controls.OBC.CDL.Logical.Timer tim1
    "Time since number of requests was greater than number of ignores"
    annotation (Placement(transformation(extent={{-40,-40},{-20,-20}})));

  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greThr1(final threshold=staOnReqTim)
    "Time limit for receiving requests to maintain status on"
    annotation (Placement(transformation(extent={{-10,-40},{10,-20}})));

  Buildings.Controls.OBC.CDL.Logical.Not not4
    "Logical Not"
    annotation (Placement(transformation(extent={{-20,60},{0,80}})));

  Buildings.Controls.OBC.CDL.Continuous.GreaterEqualThreshold greEquThr1(final
      threshold=plaOnThrTim)
    "Check if minimum amount of time to maintain the plant on has elapsed"
    annotation (Placement(transformation(extent={{40,0},{60,20}})));

  Buildings.Controls.OBC.CDL.Continuous.GreaterEqualThreshold greEquThr(final
      threshold=plaOffThrTim)
    "Check if minimum amount of time to maintain the plant off has elapsed"
    annotation (Placement(transformation(extent={{40,60},{60,80}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre1
    "Feedback delay"
    annotation (Placement(transformation(extent={{-60,40},{-40,60}})));

  Buildings.Controls.OBC.CDL.Logical.Not not2
    "Logical Not"
    annotation (Placement(transformation(extent={{-10,-80},{10,-60}})));

equation
  connect(yPla, yPla)
    annotation (Line(points={{180,0},{180,0}}, color={255,0,255}));
  connect(greThr.y, not1.u)
    annotation (Line(points={{-98,-110},{-12,-110}}, color={255,0,255}));
  connect(hys.u, addPar.y) annotation (Line(points={{-122,-50},{-128,-50}}, color={0,0,127}));
  connect(not3.y, tim1.u)
    annotation (Line(points={{-48,-30},{-42,-30}}, color={255,0,255}));
  connect(tim1.y, greThr1.u)
    annotation (Line(points={{-18,-30},{-12,-30}}, color={0,0,127}));
  connect(not4.y, tim2.u)
    annotation (Line(points={{2,70},{8,70}}, color={255,0,255}));
  connect(not2.u, hys.y) annotation (Line(points={{-12,-70},{-20,-70},{-20,-50},
  {-98,-50}}, color={255,0,255}));
  connect(intGreThr.y, not3.u) annotation (Line(points={{-98,50},{-80,50},{-80,-30},
  {-72,-30}}, color={255,0,255}));
  connect(pre1.y, not4.u) annotation (Line(points={{-38,50},{-30,50},{-30,70},{-22,
  70}}, color={255,0,255}));
  connect(greThr.y, mulAnd.u[1]) annotation (Line(points={{-98,-110},{-92,-110},
  {-92,125.25},{78,125.25}}, color={255,0,255}));
  connect(hys.y, mulAnd.u[2]) annotation (Line(points={{-98,-50},{-86,-50},{-86,
          121.75},{78,121.75}}, color={255,0,255}));
  connect(intGreThr.y, mulAnd.u[3]) annotation (Line(points={{-98,50},{-80,50},{
          -80,118.25},{78,118.25}}, color={255,0,255}));
  connect(mulAnd.y, lat.u) annotation (Line(points={{102,120},{110,120},{110,0},
          {118,0}}, color={255,0,255}));
  connect(and2.y, lat.clr) annotation (Line(points={{102,-30},{110,-30},{110,-6},
          {118,-6}}, color={255,0,255}));
  connect(greThr1.y, mulOr.u[1]) annotation (Line(points={{12,-30},{20,-30},{20,
          -65.3333},{28,-65.3333}}, color={255,0,255}));
  connect(not2.y, mulOr.u[2]) annotation (Line(points={{12,-70},{20,-70},{20,-70},
          {28,-70}}, color={255,0,255}));
  connect(not1.y, mulOr.u[3]) annotation (Line(points={{12,-110},{20,-110},{20,
          -74.6667},{28,-74.6667}},
                          color={255,0,255}));
  connect(mulOr.y, and2.u2) annotation (Line(points={{52,-70},{70,-70},{70,-38},
          {78,-38}}, color={255,0,255}));
  connect(intGreThr.u, supResReq)
    annotation (Line(points={{-122,50},{-180,50}}, color={255,127,0}));
  connect(addPar.u, TOut)
    annotation (Line(points={{-152,-50},{-180,-50}}, color={0,0,127}));
  connect(greEquThr.y, mulAnd.u[4]) annotation (Line(points={{62,70},{72,70},{72,
          114.75},{78,114.75}}, color={255,0,255}));
  connect(greEquThr.u, tim2.y)
    annotation (Line(points={{38,70},{32,70}}, color={0,0,127}));
  connect(greEquThr1.u, tim.y)
    annotation (Line(points={{38,10},{32,10}}, color={0,0,127}));
  connect(greEquThr1.y, and2.u1) annotation (Line(points={{62,10},{70,10},{70,-30},
          {78,-30}}, color={255,0,255}));
  connect(lat.y, yPla)
    annotation (Line(points={{142,0},{180,0}}, color={255,0,255}));
  connect(lat.y, pre1.u) annotation (Line(points={{142,0},{150,0},{150,30},{-70,
          30},{-70,50},{-62,50}}, color={255,0,255}));
  connect(pre1.y, tim.u) annotation (Line(points={{-38,50},{-30,50},{-30,10},{8,
          10}}, color={255,0,255}));
  connect(enaSch.y[1], greThr.u)
    annotation (Line(points={{-128,-110},{-122,-110}}, color={0,0,127}));
  annotation (defaultComponentName = "plaEna",
  Icon(graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          lineThickness=0.1),
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={28,108,200},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          lineThickness=5,
          borderPattern=BorderPattern.Raised),
        Text(
          extent={{-120,146},{100,108}},
          lineColor={0,0,255},
          textString="%name"),
        Ellipse(extent={{-80,80},{80,-80}}, lineColor={28,108,200},fillColor={170,255,213},
          fillPattern=FillPattern.Solid),
        Ellipse(extent={{-90,90},{90,-90}}, lineColor={28,108,200}),
        Rectangle(extent={{-75,2},{75,-2}}, lineColor={28,108,200},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-66,46},{76,10}},
          lineColor={28,108,200},
          textString="START"),
        Text(
          extent={{-66,-8},{76,-44}},
          lineColor={28,108,200},
          textString="STOP")},
          coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-160,-140},{160,140}})),
  Documentation(info="<html>
<p>
Block that generates boiler plant enable signal according to ASHRAE RP-1711
Advanced Sequences of Operation for HVAC Systems Phase II – Central Plants and
Hydronic Systems (March 23, 2020), section 5.3.2.1, 5.3.2.2, and 5.3.2.3.
</p>
<p>
The boiler plant should be enabled and disabled according to following sequences:
</p>
<ol>
<li>
An enabling schedule should be included to allow operators to lock out the 
boiler plant during off-hour, e.g. to allow off-hour operation of HVAC systems
except the boiler plant. The default schedule shall be 24/7 and be adjustable.
</li>
<li>
The plant should be enabled in the lowest stage when the plant has been
disabled for at least <code>plaOffThrTim</code>, e.g. 15 minutes and: 
<ul>
<li>
Number of boiler plant requests is greater than number of requests to be ignored,
ie, <code>supResReq</code> &gt; <code>nIgnReq</code>
(<code>nIgnReq</code> should default to 0 and be adjustable), and,
</li>
<li>
Measured outdoor air temperature is lower than boiler lockout temperature, ie,
<code>TOut</code> &lt; <code>TLocOut</code>, and,
</li>
<li>
The boiler enable schedule <code>schTab</code> is active.
</li>
</ul>
</li>
<li>
The plant should be disabled when it has been enabled for at least 
<code>plaOnThrTim</code>, e.g. 15 minutes and:
<ul>
<li>
Number of boiler plant requests is less than number of requests to be ignored,ie,
<code>supResReq</code> &le; <code>nIgnReq</code> for a time <code>staOnReqTim</code>, or,
</li>
<li>
Outdoor air temperature is 1 &deg;C greater than boiler lockout temperature,ie,
<code>TOut</code> &gt; <code>TLocOut</code> + 1 &deg;C, or,
</li>
<li>
The boiler enable schedule <code>schTab</code> is inactive.
</li>
</ul>
</li>
</ol>
<p align=\"center\">
<img alt=\"Validation plot for PlantEnable\"
src=\"modelica://Buildings/Resources/Images/Controls/OBC/ASHRAE/PrimarySystem/BoilerPlant/Generic/PlantEnable.png\"/>
<br/>
Validation plot generated from model <a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Generic.Validation.PlantEnable\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Generic.Validation.PlantEnable</a>.
</p>
</html>",
revisions="<html>
<ul>
<li>
May 7, 2020, by Karthik Devaprasad:<br/>
First implementation.
</li>
</ul>
</html>"));
end PlantEnable;
