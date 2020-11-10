within Buildings.Controls.OBC.Utilities.BaseClasses;
block OptimalStartCalculation
  "Base class for the block OptimalStart"
  parameter Real tOptMax(
    final quantity="Time",
    final unit="s") "Maximum optimal start time";
  parameter Real thrOptOn(
    final quantity="Time",
    final unit="s")
    "Threshold time for the output optOn to become true";
  parameter Real tOptDef(
    final quantity="Time",
    final unit="s")
    "Default optimal start time";
  parameter Integer nDay "Number of previous days for averaging the temperature slope";
  parameter Real uLow(
    final quantity="TemperatureDifference",
    final unit="K")
    "Threshold to determine if the zone temperature reaches the occupied setpoint,
     should be a non-negative number";
  parameter Real uHigh(
    final quantity="TemperatureDifference",
    final unit="K")
    "Threshold to determine the need to start the HVAC system before occupancy,
     should be greater than uLow";

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TDif(
    final quantity="TemperatureDifference",
    final unit="K")
    "Zone setpoint temperature during occupancy" annotation (Placement(
        transformation(extent={{-320,100},{-280,140}}),iconTransformation(
          extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput staCal
    "Start calculation" annotation (Placement(transformation(
          extent={{-320,20},{-280,60}}),  iconTransformation(extent={{-140,-20},
            {-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput tNexOcc(
    final quantity="Time",
    final unit="s",
    displayUnit="h")
    "Time until next occupancy" annotation (
      Placement(transformation(extent={{-320,-160},{-280,-120}}),
        iconTransformation(extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput tOpt(
    final quantity="Time",
    final unit="s",
    displayUnit="h")
    "Optimal start time of HVAC system"    annotation (Placement(transformation(extent={{440,40},
            {480,80}}),
        iconTransformation(extent={{100,20},{140,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput optOn
    "Optimal start boolean output" annotation (
      Placement(transformation(extent={{440,-80},{480,-40}}),
        iconTransformation(extent={{100,-60},{140,-20}})));
protected
  parameter Real temSloDef(
    final quantity="TemperatureSlope",
    final unit="K/s") = 1/3600
    "Default temperature slope in case of zero division";

  CDL.Logical.Sources.SampleTrigger samTri(
    final period=86400,
    final delay=0)
    "Trigger that triggers each midnight"
    annotation (Placement(transformation(extent={{80,-50},{100,-30}})));

  Buildings.Controls.OBC.CDL.Discrete.TriggeredMovingMean triMovMea(
    final n=nDay)
    "Calculate the averaged temperature slope over the past n days"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  Buildings.Controls.OBC.CDL.Discrete.TriggeredSampler triSam2
    "Get the sampled temperature difference at the same time each day"
    annotation (Placement(transformation(extent={{100,110},{120,130}})));
  Buildings.Controls.OBC.CDL.Discrete.TriggeredSampler triSam3
    "Get the temperature difference when the HVAC system starts"
    annotation (Placement(transformation(extent={{20,70},{40,90}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con(final k=0)
    "Deadband case"
    annotation (Placement(transformation(extent={{140,90},{160,110}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant defOptTim(
    final k=tOptDef)
    "Default optimal start time in case of zero division"
    annotation (Placement(transformation(extent={{-20,30},{0,50}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant defTemSlo(
    final k=temSloDef)
    "Default temperature slope in case of zero division"
    annotation (Placement(transformation(extent={{120,40},{140,60}})));
  Buildings.Controls.OBC.CDL.Logical.Edge edg "HVAC start time"
    annotation (Placement(transformation(extent={{-120,-90},{-100,-70}})));
  Buildings.Controls.OBC.CDL.Logical.FallingEdge falEdg
    "The instant when the zone temperature reaches setpoint"
    annotation (Placement(transformation(extent={{-120,-30},{-100,-10}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys(
    final uLow=uLow,
    final uHigh=uHigh)
    "Comparing zone temperature with zone setpoint"
    annotation (Placement(transformation(extent={{-260,70},{-240,90}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hysOpt(
    final pre_y_start=false,
    final uHigh=0,
    final uLow=-60) "Hysteresis to activate the optimal start"
    annotation (Placement(transformation(extent={{330,-90},{350,-70}})));
  Buildings.Controls.OBC.CDL.Continuous.LessThreshold lesThr(final t=1E-15)
    "Avoid zero division"
    annotation (Placement(transformation(extent={{-20,-10},{0,10}})));
  Buildings.Controls.OBC.CDL.Continuous.LessThreshold lesThr1(final t=1E-15)
    "Avoid zero division"
    annotation (Placement(transformation(extent={{140,-10},{160,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant maxStaTim(
    final k=tOptMax)
    "Maximum optimal start time"
    annotation (Placement(transformation(extent={{250,40},{270,60}})));
  Buildings.Controls.OBC.CDL.Logical.TrueHoldWithReset truHol(
    final duration=tOptMax + 11*3600)
    "Hold the start time for timer"
    annotation (Placement(transformation(extent={{-240,0},{-220,20}})));
  Buildings.Controls.OBC.CDL.Continuous.Division temSlo
    "Calculate temperature slope"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi
    "Switch to default optimal start time when time duration is 0"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
   Buildings.Controls.OBC.CDL.Logical.Switch swi1
    "Switch to default value when the calculated temperature slope is 0"
     annotation (Placement(transformation(extent={{180,-10},{200,10}})));
  Buildings.Controls.OBC.CDL.Logical.Pre pre
    "Break algebraic loops"
    annotation (Placement(transformation(extent={{390,-40},{410,-20}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add1(final k1=+1, final k2=-1)
    "Calculate the time duration to reach the setpoint"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add2(final k1=+1, final k2=-1)
    "Calculate differential between time-to-next-occupancy and the cool-down time"
    annotation (Placement(transformation(extent={{300,-90},{320,-70}})));
  Buildings.Controls.OBC.CDL.Continuous.Min min
    "Get the final optimal start time"
    annotation (Placement(transformation(extent={{286,-10},{306,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Max max
    "Consider the deadband case"
    annotation (Placement(transformation(extent={{180,104},{200,124}})));
  Buildings.Controls.OBC.CDL.Discrete.TriggeredSampler triSam
    "The instant when the zone temperature reaches setpoint with maximum time cutoff"
    annotation (Placement(transformation(extent={{-100,0},{-80,20}})));
  Buildings.Controls.OBC.CDL.Discrete.TriggeredSampler triSam1
    "Record the start time when the HVAC system is turned on"
    annotation (Placement(transformation(extent={{-100,-60},{-80,-40}})));
  Buildings.Controls.OBC.CDL.Logical.Latch lat
     "Stop calculation when the zone temperature reaches setpoint"
    annotation (Placement(transformation(extent={{-190,70},{-170,90}})));
  Buildings.Controls.OBC.CDL.Logical.Timer tim
    "Record time duration for the zone temperature to reach setpoint"
    annotation (Placement(transformation(extent={{-180,0},{-160,20}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1
    "Becomes true when the setpoint is reached"
    annotation (Placement(transformation(extent={{-230,70},{-210,90}})));
  Buildings.Controls.OBC.CDL.Continuous.Division tOptCal
    "Calculate optimal start time using the averaged previous temperature slope"
    annotation (Placement(transformation(extent={{220,-10},{240,10}})));
  Buildings.Controls.OBC.CDL.Discrete.TriggeredSampler triSam4
  "Get the sampled optimal start time at the same time each day"
    annotation (Placement(transformation(extent={{250,-10},{270,10}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greThr(final t=
        thrOptOn) "The threshold for optOn signal becomes true"
    annotation (Placement(transformation(extent={{320,-10},{340,10}})));
  Buildings.Controls.OBC.CDL.Logical.And and2 "Logical and"
    annotation (Placement(transformation(extent={{360,-40},{380,-20}})));

equation
  connect(tim.y, triSam.u)  annotation (Line(points={{-158,10},{-102,10}},
                                              color={0,0,127}));
  connect(falEdg.y, triSam.trigger) annotation (Line(points={{-98,-20},{-90,-20},
          {-90,-1.8}}, color={255,0,255}));
  connect(not1.y, lat.clr) annotation (Line(points={{-208,80},{-200,80},{-200,74},
          {-192,74}}, color={255,0,255}));
  connect(swi1.y, tOptCal.u2) annotation (Line(points={{202,0},{210,0},{210,-6},
          {218,-6}}, color={0,0,127}));
  connect(temSlo.y, triMovMea.u)  annotation (Line(points={{82,0},{98,0}},     color={0,0,127}));
  connect(lesThr.y, swi.u2)
    annotation (Line(points={{2,0},{18,0}}, color={255,0,255}));
  connect(lesThr1.y, swi1.u2)
    annotation (Line(points={{162,0},{178,0}}, color={255,0,255}));
  connect(TDif, hys.u) annotation (Line(points={{-300,120},{-272,120},{-272,80},
          {-262,80}},
                color={0,0,127}));
  connect(triMovMea.y, lesThr1.u)
    annotation (Line(points={{122,0},{138,0}}, color={0,0,127}));
  connect(staCal, triSam2.trigger) annotation (Line(points={{-300,40},{-120,40},
          {-120,100},{110,100},{110,108.2}},
                                    color={255,0,255}));
  connect(TDif,triSam3. u)   annotation (Line(points={{-300,120},{0,120},{0,80},
          {18,80}},                                color={0,0,127}));
  connect(pre.y,triSam3. trigger) annotation (Line(points={{412,-30},{420,-30},
          {420,30},{30,30},{30,68.2}},
                                    color={255,0,255}));
  connect(pre.y, lat.u) annotation (Line(points={{412,-30},{420,-30},{420,-100},
          {-196,-100},{-196,80},{-192,80}},
                                       color={255,0,255}));
  connect(edg.y, triSam1.trigger) annotation (Line(points={{-98,-80},{-90,-80},
          {-90,-61.8}},color={255,0,255}));
  connect(triSam1.y, add1.u2) annotation (Line(points={{-78,-50},{-72,-50},{-72,
          -6},{-62,-6}}, color={0,0,127}));
  connect(triSam.y, add1.u1) annotation (Line(points={{-78,10},{-72,10},{-72,6},
          {-62,6}}, color={0,0,127}));
  connect(swi.y, temSlo.u2)    annotation (Line(points={{42,0},{46,0},{46,-6},{
          58,-6}},                                                                      color={0,0,127}));
  connect(add1.y, lesThr.u)
    annotation (Line(points={{-38,0},{-22,0}}, color={0,0,127}));
  connect(add1.y, swi.u3) annotation (Line(points={{-38,0},{-30,0},{-30,-18},{8,
          -18},{8,-8},{18,-8}},
                            color={0,0,127}));
  connect(triMovMea.y, swi1.u3) annotation (Line(points={{122,0},{128,0},{128,
          -18},{164,-18},{164,-8},{178,-8}},
                                        color={0,0,127}));
  connect(TDif, triSam2.u)   annotation (Line(points={{-300,120},{98,120}},  color={0,0,127}));
  connect(tNexOcc, add2.u2) annotation (Line(points={{-300,-140},{290,-140},{290,
          -86},{298,-86}}, color={0,0,127}));
  connect(add2.y, hysOpt.u) annotation (Line(points={{322,-80},{328,-80}},
                     color={0,0,127}));
  connect(min.y, add2.u1) annotation (Line(points={{308,0},{314,0},{314,-58},{
          290,-58},{290,-74},{298,-74}},
                                     color={0,0,127}));
  connect(con.y, max.u2) annotation (Line(points={{162,100},{170,100},{170,108},
          {178,108}},color={0,0,127}));
  connect(triSam2.y, max.u1)    annotation (Line(points={{122,120},{178,120}}, color={0,0,127}));
  connect(staCal, truHol.u) annotation (Line(points={{-300,40},{-260,40},{-260,
          10},{-242,10}}, color={255,0,255}));
  connect(truHol.y, tim.u)    annotation (Line(points={{-218,10},{-182,10}}, color={255,0,255}));
  connect(tim.y, triSam1.u) annotation (Line(points={{-158,10},{-140,10},{-140,
          -50},{-102,-50}},
                      color={0,0,127}));
  connect(min.y, tOpt) annotation (Line(points={{308,0},{314,0},{314,60},{460,
          60}},
        color={0,0,127}));
  connect(not1.u, hys.y)    annotation (Line(points={{-232,80},{-238,80}}, color={255,0,255}));
  connect(lat.y, edg.u) annotation (Line(points={{-168,80},{-134,80},{-134,-80},
          {-122,-80}},
                     color={255,0,255}));
  connect(lat.y, falEdg.u) annotation (Line(points={{-168,80},{-134,80},{-134,
          -20},{-122,-20}},
                      color={255,0,255}));
  connect(tOptCal.y, triSam4.u)   annotation (Line(points={{242,0},{248,0}}, color={0,0,127}));
  connect(staCal, triSam4.trigger) annotation (Line(points={{-300,40},{-260,40},
          {-260,-108},{260,-108},{260,-11.8}}, color={255,0,255}));
  connect(triSam4.y, min.u2) annotation (Line(points={{272,0},{276,0},{276,-6},
          {284,-6}}, color={0,0,127}));
  connect(maxStaTim.y, min.u1) annotation (Line(points={{272,50},{278,50},{278,
          6},{284,6}}, color={0,0,127}));
  connect(defOptTim.y, swi.u1)  annotation (Line(points={{2,40},{8,40},{8,8},{18,8}}, color={0,0,127}));
  connect(defTemSlo.y, swi1.u1) annotation (Line(points={{142,50},{170,50},{170,
          8},{178,8}}, color={0,0,127}));
  connect(max.y, tOptCal.u1) annotation (Line(points={{202,114},{212,114},{212,
          6},{218,6}}, color={0,0,127}));
  connect(triSam3.y, temSlo.u1)   annotation (Line(points={{42,80},{48,80},{48,6},{58,6}}, color={0,0,127}));
  connect(min.y, greThr.u)  annotation (Line(points={{308,0},{318,0}}, color={0,0,127}));
  connect(hysOpt.y, and2.u2) annotation (Line(points={{352,-80},{354,-80},{354,
          -38},{358,-38}}, color={255,0,255}));
  connect(greThr.y, and2.u1) annotation (Line(points={{342,0},{354,0},{354,-30},
          {358,-30}}, color={255,0,255}));
  connect(and2.y, pre.u) annotation (Line(points={{382,-30},{386,-30},{386,-30},
          {388,-30}}, color={255,0,255}));
  connect(pre.y, optOn) annotation (Line(points={{412,-30},{428,-30},{428,-60},
          {460,-60},{460,-60}}, color={255,0,255}));
  connect(samTri.y, triMovMea.trigger) annotation (Line(points={{102,-40},{110,-40},
          {110,-12}}, color={255,0,255}));
   annotation (
defaultComponentName="optStaCal",
  Documentation(info="<html>
<p>
This base class contains the algorithm for the optimal start calculation. For the
description of the algorithm, please refer to the documentation for the block
<a href=\"modelica://Buildings.Controls.OBC.Utilities.OptimalStart\">
Buildings.Controls.OBC.Utilities.OptimalStart</a>.
</p>
</html>",
revisions="<html>
<ul>
<li>
October 20, 2020, by Michael Wetter:<br/>
Reimplemented trigger the moving average computation.
</li>
<li>
December 15, 2019, by Kun Zhang:<br/>
First implementation.
</li>
</ul>
</html>"),
Diagram(coordinateSystem(extent={{-280,-160},{440,160}})),
    Icon(graphics={
          Rectangle(
            extent={{-100,-100},{100,100}},
            lineColor={0,0,127},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid),
        Text(
          lineColor={0,0,255},
          extent={{-150,110},{150,150}},
          textString="%name")}));
end OptimalStartCalculation;
