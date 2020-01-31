within Buildings.Controls.OBC.Utilities.BaseClasses;
block OptimalStartCalculation
  "Base class for the block OptimalStart"
  extends Modelica.Blocks.Icons.Block;
  parameter Modelica.SIunits.Time tOptMax "Maximum optimal start time";
  parameter Modelica.SIunits.Time tOptIni
    "Initial optimal start time";
  parameter Integer nDay "Number of previous days for averaging the temperature slope";
  parameter Modelica.SIunits.TemperatureDifference uLow
    "Threshold to determine if the zone temperature reaches the occupied setpoint, 
     should be a non-negative number";
  parameter Modelica.SIunits.TemperatureDifference uHigh
    "Threshold to determine the need to start the HVAC system before occupancy,
     should be greater than uLow";

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TDif(
    final quantity="TemperatureDifference",
    final unit="K")
    "Zone heating setpoint temperature during occupancy" annotation (Placement(
        transformation(extent={{-320,100},{-280,140}}),iconTransformation(
          extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput staCal
    "Start calculation" annotation (Placement(transformation(
          extent={{-320,20},{-280,60}}),  iconTransformation(extent={{-140,10},{
            -100,50}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput stoCal
    "Stop calculation" annotation (Placement(transformation(
          extent={{-320,-80},{-280,-40}}),  iconTransformation(extent={{-140,-50},
            {-100,-10}})));
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
    "Optimal start time of HVAC system"    annotation (Placement(transformation(extent={{400,40},{440,80}}),
        iconTransformation(extent={{100,20},{140,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput start
    "Optimal start boolean output" annotation (
      Placement(transformation(extent={{400,-80},{440,-40}}),
        iconTransformation(extent={{100,-60},{140,-20}})));

  Buildings.Controls.OBC.CDL.Logical.Latch lat
    "Stop calculation when the zone temperature reaches setpoint"
    annotation (Placement(transformation(extent={{-190,60},{-170,80}})));
  Buildings.Controls.OBC.CDL.Logical.Timer tim(final reset=true)
    "Record time duration for the zone temperature to reach setpoint"
    annotation (Placement(transformation(extent={{-140,0},{-120,20}})));
  Buildings.Controls.OBC.CDL.Logical.Latch latMax
    "Stop calculation when it reaches the max optimal time"
    annotation (Placement(transformation(extent={{-150,60},{-130,80}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1
    "Becomes true when the setpoint is reached"
    annotation (Placement(transformation(extent={{-230,60},{-210,80}})));
  Buildings.Controls.OBC.CDL.Continuous.Division tOptCal
    "Calculate optimal start time using the averaged previous temperature slope"
    annotation (Placement(transformation(extent={{260,-10},{280,10}})));
  Buildings.Controls.OBC.CDL.Logical.And and1
    "Duration that it takes to reach the setpoint"
    annotation (Placement(transformation(extent={{-114,60},{-94,80}})));
  Buildings.Controls.OBC.CDL.Discrete.TriggeredMovingMean triMovMea(final n=nDay)
    "Calculate the averaged temperature slope of past n days"
    annotation (Placement(transformation(extent={{140,-10},{160,10}})));
  Buildings.Controls.OBC.CDL.Discrete.TriggeredSampler triSam
    "The instant when the zone temperature reaches setpoint with maximum time cutoff"
    annotation (Placement(transformation(extent={{-60,0},{-40,20}})));
  Buildings.Controls.OBC.CDL.Discrete.TriggeredSampler triSam1
    "Record the start time when the HVAC system is turned on"
    annotation (Placement(transformation(extent={{-60,-54},{-40,-34}})));
  Buildings.Controls.OBC.CDL.Discrete.TriggeredSampler triSam2
    "Get the sampled temperature difference at the same time each day"
    annotation (Placement(transformation(extent={{120,110},{140,130}})));
  Buildings.Controls.OBC.CDL.Discrete.TriggeredSampler triSam3
    "Get the temperature difference when the HVAC system starts"
    annotation (Placement(transformation(extent={{60,70},{80,90}})));
  Buildings.Controls.OBC.CDL.Logical.Pre pre
    "Break algebraic loops"
    annotation (Placement(transformation(extent={{362,80},{382,100}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add1(final k1=+1, final k2=-1)
    "Calculate the time duration to reach the setpoint"
    annotation (Placement(transformation(extent={{-20,-10},{0,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add2(final k1=+1, final k2=-1)
    "Calculate differential between time-to-next-occupancy and the cool-down time"
    annotation (Placement(transformation(extent={{300,-90},{320,-70}})));
  Buildings.Controls.OBC.CDL.Continuous.Min min
    "Get the final optimal start time"
    annotation (Placement(transformation(extent={{294,-10},{314,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Max max
    "Consider the deadband case"
    annotation (Placement(transformation(extent={{200,104},{220,124}})));

protected
    parameter Modelica.SIunits.TemperatureSlope temSloDef = 1/3600
      "Default temperature slope in case of zero division";
    Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con(final k=0)
      "Deadband case"
      annotation (Placement(transformation(extent={{160,80},{180,100}})));
    Buildings.Controls.OBC.CDL.Continuous.Sources.Constant defOptTim(
      final k=tOptIni)
      "Default optimal start time in case of zero division"
      annotation (Placement(transformation(extent={{20,-50},{40,-30}})));
    Buildings.Controls.OBC.CDL.Continuous.Sources.Constant defTemSlo(
      final k=temSloDef)
      "Default temperature slope in case of zero division"
      annotation (Placement(transformation(extent={{180,-60},{200,-40}})));
    Buildings.Controls.OBC.CDL.Logical.Edge edg "HVAC start time"
      annotation (Placement(transformation(extent={{-80,-90},{-60,-70}})));
    Buildings.Controls.OBC.CDL.Logical.FallingEdge falEdg
      "The instant when the zone temperature reaches setpoint"
      annotation (Placement(transformation(extent={{-80,-28},{-60,-8}})));
    Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys(
      final uLow=uLow,
      final uHigh=uHigh)
      "Comparing zone temperature with zone setpoint"
      annotation (Placement(transformation(extent={{-260,60},{-240,80}})));
    Buildings.Controls.OBC.CDL.Continuous.Hysteresis hysOpt(
      final pre_y_start=false,
      final uHigh=0,
      final uLow=-60) "Hysteresis to activate the optimal start"
      annotation (Placement(transformation(extent={{328,80},{348,100}})));
    Buildings.Controls.OBC.CDL.Continuous.LessEqualThreshold lesEquThr
      "Avoid zero division"
      annotation (Placement(transformation(extent={{20,-10},{40,10}})));
    Buildings.Controls.OBC.CDL.Continuous.LessEqualThreshold lesEquThr1
      "Avoid zero division"
      annotation (Placement(transformation(extent={{180,-10},{200,10}})));
    Buildings.Controls.OBC.CDL.Continuous.Sources.Constant maxStaTim(
      final k=tOptMax-60)
      "Maximum optimal start time"
      annotation (Placement(transformation(extent={{240,-60},{260,-40}})));
    Buildings.Controls.OBC.CDL.Logical.TrueHoldWithReset truHol(
      final duration=tOptMax+2*3600)
      "Hold the start time for timer"
      annotation (Placement(transformation(extent={{-240,0},{-220,20}})));
    Buildings.Controls.OBC.CDL.Continuous.Division temSlo
      "Calculate temperature slope"
      annotation (Placement(transformation(extent={{100,-10},{120,10}})));
    Buildings.Controls.OBC.CDL.Logical.Switch swi
      "Switch to default optimal start time when time duration is 0"
      annotation (Placement(transformation(extent={{60,-10},{80,10}})));
    Buildings.Controls.OBC.CDL.Logical.Switch swi1
      "Switch to default value value when the calculated temperature slope is 0"
      annotation (Placement(transformation(extent={{220,-10},{240,10}})));
equation
  connect(tim.y, triSam.u)  annotation (Line(points={{-118,10},{-62,10}},
                                              color={0,0,127}));
  connect(falEdg.y, triSam.trigger) annotation (Line(points={{-58,-18},{-50,-18},
          {-50,-1.8}},                                                                     color={255,0,255}));
  connect(hys.y, not1.u)  annotation (Line(points={{-238,70},{-232,70}},
                                                     color={255,0,255}));
  connect(not1.y, lat.clr) annotation (Line(points={{-208,70},{-200,70},{-200,
          64},{-192,64}},
                      color={255,0,255}));
  connect(swi1.y, tOptCal.u2) annotation (Line(points={{242,0},{250,0},{250,-6},
          {258,-6}}, color={0,0,127}));
  connect(and1.y, falEdg.u)  annotation (Line(points={{-92,70},{-88,70},{-88,
          -18},{-82,-18}},                                                color={255,0,255}));
  connect(lat.y, latMax.u) annotation (Line(points={{-168,70},{-152,70}},
                          color={255,0,255}));
  connect(temSlo.y, triMovMea.u)  annotation (Line(points={{122,0},{138,0}},   color={0,0,127}));
  connect(lesEquThr.y, swi.u2)   annotation (Line(points={{42,0},{58,0}},     color={255,0,255}));
  connect(lesEquThr1.y, swi1.u2)    annotation (Line(points={{202,0},{218,0}},     color={255,0,255}));
  connect(stoCal, latMax.clr) annotation (Line(points={{-300,-60},{-160,-60},{
          -160,64},{-152,64}},
                          color={255,0,255}));
  connect(TDif, hys.u) annotation (Line(points={{-300,120},{-270,120},{-270,70},
          {-262,70}},
                color={0,0,127}));
  connect(triMovMea.y, lesEquThr1.u)   annotation (Line(points={{162,0},{178,0}},     color={0,0,127}));
  connect(defOptTim.y, swi.u1) annotation (Line(points={{42,-40},{54,-40},{54,8},
          {58,8}},  color={0,0,127}));
  connect(defTemSlo.y, swi1.u1) annotation (Line(points={{202,-50},{212,-50},{212,
          8},{218,8}},   color={0,0,127}));
  connect(staCal, triSam2.trigger) annotation (Line(points={{-300,40},{130,40},
          {130,108.2}},             color={255,0,255}));
  connect(TDif,triSam3. u)   annotation (Line(points={{-300,120},{40,120},{40,80},{58,80}},
                                                   color={0,0,127}));
  connect(pre.y,triSam3. trigger) annotation (Line(points={{384,90},{392,90},{
          392,50},{70,50},{70,68.2}},
                                    color={255,0,255}));
  connect(pre.y, lat.u) annotation (Line(points={{384,90},{392,90},{392,-106},{
          -196,-106},{-196,70},{-192,70}},
                                       color={255,0,255}));
  connect(latMax.y,and1. u1)    annotation (Line(points={{-128,70},{-116,70}}, color={255,0,255}));
  connect(edg.y, triSam1.trigger) annotation (Line(points={{-58,-80},{-50,-80},
          {-50,-55.8}},color={255,0,255}));
  connect(triSam1.y, add1.u2) annotation (Line(points={{-38,-44},{-32,-44},{-32,
          -6},{-22,-6}}, color={0,0,127}));
  connect(triSam.y, add1.u1) annotation (Line(points={{-38,10},{-32,10},{-32,6},
          {-22,6}}, color={0,0,127}));
  connect(swi.y, temSlo.u2)    annotation (Line(points={{82,0},{86,0},{86,-6},{98,-6}}, color={0,0,127}));
  connect(add1.y, lesEquThr.u)   annotation (Line(points={{2,0},{18,0}}, color={0,0,127}));
  connect(lat.y,and1. u2) annotation (Line(points={{-168,70},{-164,70},{-164,56},
          {-120,56},{-120,62},{-116,62}}, color={255,0,255}));
  connect(and1.y, edg.u) annotation (Line(points={{-92,70},{-88,70},{-88,-80},{
          -82,-80}},
                 color={255,0,255}));
  connect(add1.y, swi.u3) annotation (Line(points={{2,0},{10,0},{10,-18},{48,-18},
          {48,-8},{58,-8}}, color={0,0,127}));
  connect(triMovMea.y, swi1.u3) annotation (Line(points={{162,0},{168,0},{168,-18},
          {204,-18},{204,-8},{218,-8}}, color={0,0,127}));
  connect(TDif, triSam2.u)   annotation (Line(points={{-300,120},{118,120}}, color={0,0,127}));
  connect(tNexOcc, add2.u2) annotation (Line(points={{-300,-140},{290,-140},{290,
          -86},{298,-86}}, color={0,0,127}));
  connect(pre.u, hysOpt.y)   annotation (Line(points={{360,90},{350,90}}, color={255,0,255}));
  connect(add2.y, hysOpt.u) annotation (Line(points={{322,-80},{324,-80},{324,90},
          {326,90}}, color={0,0,127}));
  connect(maxStaTim.y,min. u2) annotation (Line(points={{262,-50},{286,-50},{286,
          -6},{292,-6}}, color={0,0,127}));
  connect(tOptCal.y,min. u1) annotation (Line(points={{282,0},{288,0},{288,6},{292,
          6}}, color={0,0,127}));
  connect(min.y, tOpt)    annotation (Line(points={{316,0},{368,0},{368,60},{420,60}},
                                               color={0,0,127}));
  connect(min.y, add2.u1) annotation (Line(points={{316,0},{320,0},{320,-58},{290,
          -58},{290,-74},{298,-74}}, color={0,0,127}));
  connect(triSam3.y, temSlo.u1)    annotation (Line(points={{82,80},{90,80},{90,6},{98,6}}, color={0,0,127}));
  connect(con.y, max.u2) annotation (Line(points={{182,90},{190,90},{190,108},{
          198,108}}, color={0,0,127}));
  connect(triSam2.y, max.u1)    annotation (Line(points={{142,120},{198,120}}, color={0,0,127}));
  connect(max.y, tOptCal.u1) annotation (Line(points={{222,114},{250,114},{250,
          6},{258,6}}, color={0,0,127}));
  connect(hysOpt.y, start) annotation (Line(points={{350,90},{354,90},{354,-60},
          {420,-60}}, color={255,0,255}));
  connect(staCal, truHol.u) annotation (Line(points={{-300,40},{-264,40},{-264,
          10},{-242,10}}, color={255,0,255}));
  connect(truHol.y, tim.u)    annotation (Line(points={{-218,10},{-142,10}}, color={255,0,255}));
  connect(staCal, triMovMea.trigger) annotation (Line(points={{-300,40},{-264,
          40},{-264,-94},{150,-94},{150,-12}}, color={255,0,255}));
  connect(tim.y, triSam1.u) annotation (Line(points={{-118,10},{-100,10},{-100,
          -44},{-62,-44}},
                      color={0,0,127}));
   annotation (
defaultComponentName="optStaCal",
  Documentation(info="<html>
<p>
This base class contains the algorithm of optimal start calculation. For the
description of algorithm, please refer to the documentation for the block
<a href=\"modelica://Buildings.Controls.OBC.Utilities.OptimalStart\">
Buildings.Controls.OBC.Utilities.OptimalStart</a>.
</p>
</html>",
revisions="<html>
<ul>
<li>
December 15, 2019, by Kun Zhang:<br/>
First implementation.
</li>
</ul>
</html>"),
Diagram(coordinateSystem(extent={{-280,-160},{400,160}})));
end OptimalStartCalculation;
