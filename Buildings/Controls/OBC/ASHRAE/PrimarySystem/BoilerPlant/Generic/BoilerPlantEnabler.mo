within Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Generic;
model BoilerPlantEnabler
  "Sequence to enable/disable boiler plant based on heating hot-water requirements"
  parameter Integer nHotWatReqIgn(min=0) = 0
  "Number of hot-water requests to be ignored before turning on boiler plant loop";
  parameter Integer nSchRow(min=1) = 4
  "Number of rows to be created for boiler plant schedule table";
  parameter Real TLocOut(final unit = "K", displayUnit = "degC") = (273+(80-32)/1.8)
  "Boiler lock-out temperature for outdoor air";
  parameter Real boiPlaOffStaHolTimVal(final unit = "s", displayUnit = "s") = 15*60
  "Minimum time for which the boiler plant has to stay off once it has been switched off";
  parameter Real boiPlaOnStaHolTimVal(final unit = "s", displayUnit = "s") = 15*60
  "Minimum time for which the boiler plant has to stay on once it has been switched on";
  parameter Real boiEnaSchTab[nSchRow,2] = [0,1; 6,1; 18,1; 24,1]
  "Table defining schedule for enabling boiler";
  parameter Real staOnHeaWatReqTim(final unit = "s", displayUnit = "s") = 3*60
  "Time-limit for receiving hot-water requests to keep boiler plant on";
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TOut(final unit = "K",
  displayUnit = "degC") "Measured outdoor air temperature"
    annotation (Placement(transformation(extent={{-200,-70},{-160,-30}}),
        iconTransformation(extent={{-140,-70},{-100,-30}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput hotWatSupResReq
  "Number of heating hot-water requests from heating coil"
   annotation (Placement(transformation(extent={{-200,30},{-160,70}}),
               iconTransformation(extent={{-140,30},{-100,70}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput boiEnaSig "Boiler enable signal"
    annotation (Placement(transformation(extent={{160,-20},{200,20}}),
        iconTransformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.TimeTable boiEnaSch(table=boiEnaSchTab,
    smoothness=Buildings.Controls.OBC.CDL.Types.Smoothness.ConstantSegments,
                                                                 timeScale=3600)
    "Schedule table defining when boiler can be enabled"
    annotation (Placement(transformation(extent={{-148,-120},{-128,-100}})));
  Buildings.Controls.OBC.CDL.Logical.Timer tim "Time since plant has been turned on"
    annotation (Placement(transformation(extent={{12,0},{32,20}})));
  Buildings.Controls.OBC.CDL.Logical.Timer tim2 "Time since plant has been turned off"
    annotation (Placement(transformation(extent={{12,60},{32,80}})));
protected
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greThr(threshold=0.5)
    "Block to check if schedule lets the controller enable the plant or not"
    annotation (Placement(transformation(extent={{-120,-120},{-100,-100}})));
  Buildings.Controls.OBC.CDL.Integers.GreaterThreshold intGreThr(threshold=nHotWatReqIgn)
    "Check to find if number of requests is greater than number of requests to be ignored"
    annotation (Placement(transformation(extent={{-120,40},{-100,60}})));
  Buildings.Controls.OBC.CDL.Logical.Latch lat
    "Block to maintain plant status till the conditions to change it are met"
    annotation (Placement(transformation(extent={{120,-10},{140,10}})));
  Buildings.Controls.OBC.CDL.Logical.MultiAnd mulAnd(nu=4)
    "Block to check if all the conditions for turning on plant have been met"
    annotation (Placement(transformation(extent={{80,110},{100,130}})));
  Buildings.Controls.OBC.CDL.Logical.MultiOr mulOr(nu=3)
    "Block to check if any conditions except plant-on time have been satisfied to turn off plant"
    annotation (Placement(transformation(extent={{30,-80},{50,-60}})));
  Buildings.Controls.OBC.CDL.Logical.And and2
    "Block to check if all conditions have been met to turn off the plant"
    annotation (Placement(transformation(extent={{80,-16},{100,4}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1
    annotation (Placement(transformation(extent={{-10,-120},{10,-100}})));
  Buildings.Controls.OBC.CDL.Continuous.AddParameter addPar(p=TLocOut, k=-1)
    "Block comparing measured outdoor air temperature to boiler lockout temperature"
    annotation (Placement(transformation(extent={{-150,-60},{-130,-40}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys(uLow=-1/1.8, uHigh=0)
    "Hysteresis loop to prevent cycling of boiler plant based on lockout temperature condition"
    annotation (Placement(transformation(extent={{-120,-60},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Logical.Not not3
    annotation (Placement(transformation(extent={{-62,-30},{-42,-10}})));
  Buildings.Controls.OBC.CDL.Logical.Timer tim1
    "Time since number of requests was greater than number of ignores"
    annotation (Placement(transformation(extent={{-36,-30},{-16,-10}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greThr1(threshold=staOnHeaWatReqTim)
    "Time limit for receiving requests to maintain status on"
    annotation (Placement(transformation(extent={{-10,-30},{10,-10}})));
  Buildings.Controls.OBC.CDL.Logical.Not not4
    annotation (Placement(transformation(extent={{-18,60},{2,80}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterEqualThreshold boiPlaOnStaHolTim(threshold=
        boiPlaOnStaHolTimVal)
    "Minimum amount of time to hold the boiler plant on"
    annotation (Placement(transformation(extent={{40,0},{60,20}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterEqualThreshold boiPlaOffStaHolTim(threshold=
        boiPlaOffStaHolTimVal)
    "Minimum amount of time to hold boiler plant off"
    annotation (Placement(transformation(extent={{40,60},{60,80}})));
  Buildings.Controls.OBC.CDL.Logical.Pre pre
    annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
  Buildings.Controls.OBC.CDL.Logical.Not not2
    annotation (Placement(transformation(extent={{-10,-80},{10,-60}})));
equation
  connect(boiEnaSig, boiEnaSig)
    annotation (Line(points={{180,0},{180,0}}, color={255,0,255}));
  connect(boiEnaSch.y[1], greThr.u)
    annotation (Line(points={{-126,-110},{-122,-110}},
                                                   color={0,0,127}));
  connect(intGreThr.u, hotWatSupResReq)
    annotation (Line(points={{-122,50},{-180,50}},  color={255,127,0}));
  connect(lat.y, boiEnaSig)
    annotation (Line(points={{142,0},{180,0}}, color={255,0,255}));
  connect(addPar.u, TOut)
    annotation (Line(points={{-152,-50},{-180,-50}},
                                                color={0,0,127}));
  connect(greThr.y, not1.u)
    annotation (Line(points={{-98,-110},{-12,-110}}, color={255,0,255}));
  connect(hys.u, addPar.y) annotation (Line(points={{-122,-50},{-128,-50}},
               color={0,0,127}));
  connect(not3.y, tim1.u)
    annotation (Line(points={{-40,-20},{-38,-20}}, color={255,0,255}));
  connect(tim1.y, greThr1.u)
    annotation (Line(points={{-14,-20},{-12,-20}},
                                                color={0,0,127}));
  connect(not4.y, tim2.u)
    annotation (Line(points={{4,70},{10,70}},color={255,0,255}));
  connect(tim.y, boiPlaOnStaHolTim.u)
    annotation (Line(points={{34,10},{38,10}},color={0,0,127}));
  connect(tim2.y, boiPlaOffStaHolTim.u)
    annotation (Line(points={{34,70},{38,70}}, color={0,0,127}));
  connect(not2.u, hys.y) annotation (Line(points={{-12,-70},{-20,-70},{-20,-50},
          {-98,-50}}, color={255,0,255}));
  connect(intGreThr.y, not3.u) annotation (Line(points={{-98,50},{-80,50},{-80,-20},
          {-64,-20}}, color={255,0,255}));
  connect(pre.u, boiEnaSig) annotation (Line(points={{-62,50},{-68,50},{-68,30},
          {150,30},{150,0},{180,0}}, color={255,0,255}));
  connect(pre.y, not4.u) annotation (Line(points={{-38,50},{-34,50},{-34,70},{-20,
          70}}, color={255,0,255}));
  connect(tim.u, not4.u) annotation (Line(points={{10,10},{-34,10},{-34,70},{-20,
          70}}, color={255,0,255}));
  connect(boiPlaOnStaHolTim.y, and2.u1) annotation (Line(points={{62,10},{70,10},
          {70,-6},{78,-6}},   color={255,0,255}));
  connect(greThr.y, mulAnd.u[1]) annotation (Line(points={{-98,-110},{-92,-110},
          {-92,125.25},{78,125.25}}, color={255,0,255}));
  connect(hys.y, mulAnd.u[2]) annotation (Line(points={{-98,-50},{-86,-50},{-86,
          121.75},{78,121.75}}, color={255,0,255}));
  connect(intGreThr.y, mulAnd.u[3]) annotation (Line(points={{-98,50},{-80,50},{
          -80,118.25},{78,118.25}}, color={255,0,255}));
  connect(boiPlaOffStaHolTim.y, mulAnd.u[4]) annotation (Line(points={{62,70},{70,
          70},{70,114.75},{78,114.75}}, color={255,0,255}));
  connect(mulAnd.y, lat.u) annotation (Line(points={{102,120},{110,120},{110,0},
          {118,0}}, color={255,0,255}));
  connect(and2.y, lat.clr) annotation (Line(points={{102,-6},{118,-6}},
                     color={255,0,255}));
  connect(greThr1.y, mulOr.u[1]) annotation (Line(points={{12,-20},{20,-20},{20,
          -65.3333},{28,-65.3333}}, color={255,0,255}));
  connect(not2.y, mulOr.u[2]) annotation (Line(points={{12,-70},{20,-70},{20,-70},
          {28,-70}}, color={255,0,255}));
  connect(not1.y, mulOr.u[3]) annotation (Line(points={{12,-110},{20,-110},{20,
          -74.6667},{28,-74.6667}},
                          color={255,0,255}));
  connect(mulOr.y, and2.u2) annotation (Line(points={{52,-70},{70,-70},{70,-14},
          {78,-14}}, color={255,0,255}));
  annotation (defaultComponentName = "boiPlaEna",
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
Hydronic Systems (December 31, 2019), section 5.3.2.1, 5.3.2.2, and 5.3.2.3.
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
disabled for at least <code>boiPlaOffStaHolTimVal</code>, e.g. 15 minutes and: 
<ul>
<li>
Number of boiler plant requests is greater than number of requests to be ignored,
ie, <code>hotWatSupResReq</code> &gt; <code>nHotWatReqIgn</code>
(<code>nHotWatReqIgn</code> should default to 0 and be adjustable), and,
</li>
<li>
Measured outdoor air temperature is lower than boiler lockout temperature, ie,
<code>TOut</code> &lt; <code>TLocOut</code>, and,
</li>
<li>
The boiler enable schedule <code>boiEnaSchTab</code> is active.
</li>
</ul>
</li>
<li>
The plant should be disabled when it has been enabled for at least 
<code>boiPlaOnStaHolTimVal</code>, e.g. 15 minutes and:
<ul>
<li>
Number of boiler plant requests is less than number of requests to be ignored,ie,
<code>hotWatSupResReq</code> &le; <code>ignReq</code> for a time <code>staOnHeaWatReqTim</code>, or,
</li>
<li>
Outdoor air temperature is 1 &deg;F greater than boiler lockout temperature,ie,
<code>TOut</code> &gt; <code>TLocOut</code> + 1 &deg;F, or,
</li>
<li>
The boiler enable schedule <code>boiEnaSchTab</code> is inactive.
</li>
</ul>
</li>
</ol>
<p align=\"center\">
<img alt=\"Validation plot for BoilerPlantEnabler\"
src=\"modelica://Buildings/Resources/Images/Controls/OBC/ASHRAE/PrimarySystem/BoilerPlant/Generic/BoilerPlantEnabler.png\"/>
<br/>
Validation plot generated from model <a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Generic.Validation.BoilerPlantEnabler\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Generic.Validation.BoilerPlantEnabler</a>.
</p>
</html>",
revisions="<html>
<ul>
<li>
April 17, 2020, by Karthik Devaprasad:<br/>
First implementation.
</li>
</ul>
</html>"));
end BoilerPlantEnabler;
