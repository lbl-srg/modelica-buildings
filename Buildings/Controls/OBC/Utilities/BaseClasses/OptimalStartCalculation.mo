within Buildings.Controls.OBC.Utilities.BaseClasses;
block OptimalStartCalculation
  "Base class for the block OptimalStart"
<<<<<<< HEAD
  parameter Modelica.SIunits.Time tOptMax "Maximum optimal start time";
  parameter Modelica.SIunits.Time thrOptOn
    "Threshold time for the output optOn to become true";
  parameter Modelica.SIunits.Time tOptDef
    "Default optimal start time";
  parameter Integer nDay "Number of previous days for averaging the temperature slope";
  parameter Modelica.SIunits.TemperatureDifference uLow
=======
  parameter Real tOptMax(
    final quantity="Time",
    final unit="s")
    "Maximum optimal start time";
  parameter Real thrOptOn(
    final quantity="Time",
    final unit="s")
    "Threshold time for the output optOn to become true";
  parameter Integer nDay
    "Number of previous days for averaging the temperature slope";
  parameter Real uLow(
    final quantity="TemperatureDifference",
    final unit="K")
>>>>>>> master
    "Threshold to determine if the zone temperature reaches the occupied setpoint,
     should be a non-negative number";
  parameter Modelica.SIunits.TemperatureDifference uHigh
    "Threshold to determine the need to start the HVAC system before occupancy,
     should be greater than uLow";
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TDif(
    final quantity="TemperatureDifference",
    final unit="K")
    "Difference between zone setpoint and measured temperature, must be bigger than zero for heating and cooling if setpoint is not yet reached"
    annotation (Placement(transformation(extent={{-320,100},{-280,140}}),iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput staCal
    "Start calculation"
    annotation (Placement(transformation(extent={{-320,20},{-280,60}}),iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput tNexOcc(
    final quantity="Time",
    final unit="s",
    displayUnit="h")
    "Time until next occupancy"
    annotation (Placement(transformation(extent={{-320,-160},{-280,-120}}),iconTransformation(extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput tOpt(
    final quantity="Time",
    final unit="s",
    displayUnit="h")
    "Optimal start time of HVAC system"
    annotation (Placement(transformation(extent={{440,40},{480,80}}),iconTransformation(extent={{100,20},{140,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput optOn
<<<<<<< HEAD
    "Optimal start boolean output" annotation (
      Placement(transformation(extent={{440,-80},{480,-40}}),
        iconTransformation(extent={{100,-60},{140,-20}})));

protected
  parameter Modelica.SIunits.TemperatureSlope temSloDef = 1/3600
    "Default temperature slope in case of zero division";

  Buildings.Controls.OBC.CDL.Discrete.TriggeredMovingMean triMovMea(
=======
    "Optimal start boolean output"
    annotation (Placement(transformation(extent={{440,-80},{480,-40}}),iconTransformation(extent={{100,-60},{140,-20}})));

protected
  constant Real tReaMin(
    final quantity="Time",
    final unit="s",
    displayUnit="h")=120
    "Minimum value for optimal start time if the system reached the set point almost immediately (used to avoid division by zero)";
  constant Real temSloDef(
    final quantity="TemperatureSlope",
    final unit="K/s")=1/3600
    "Minimum value for temperature slope (used to avoid division by zero)";
  CDL.Logical.Sources.SampleTrigger samTri(
    final period=86400,
    final shift=0)
    "Trigger that triggers each midnight"
    annotation (Placement(transformation(extent={{0,-50},{20,-30}})));
  Buildings.Controls.OBC.CDL.Discrete.TriggeredMovingMean samTemSloAve(
>>>>>>> master
    final n=nDay)
    "Calculate the averaged temperature slope over the past n days"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
  Buildings.Controls.OBC.CDL.Discrete.TriggeredSampler dTCalOn
    "Get the sampled temperature difference at the same time each day"
    annotation (Placement(transformation(extent={{-40,70},{-20,90}})));
  Buildings.Controls.OBC.CDL.Discrete.TriggeredSampler dTHVACOn
    "Get the temperature difference when the HVAC system starts"
    annotation (Placement(transformation(extent={{-40,110},{-20,130}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con(
    final k=0)
    "Deadband case"
    annotation (Placement(transformation(extent={{40,50},{60,70}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant timReaMin(
    final k=tReaMin)
    "Minimum time to reach set point (used to avoid division by zero)"
    annotation (Placement(transformation(extent={{-80,-42},{-60,-22}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant defTemSlo(
    final k=temSloDef)
    "Default temperature slope in case of zero division"
    annotation (Placement(transformation(extent={{88,-40},{108,-20}})));
  Buildings.Controls.OBC.CDL.Logical.Edge edg
    "HVAC start time"
    annotation (Placement(transformation(extent={{-148,-90},{-128,-70}})));
  Buildings.Controls.OBC.CDL.Logical.FallingEdge falEdg
    "The instant when the zone temperature reaches setpoint"
    annotation (Placement(transformation(extent={{-148,-30},{-128,-10}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys(
    final uLow=uLow,
    final uHigh=uHigh)
    "Comparing zone temperature with zone setpoint"
    annotation (Placement(transformation(extent={{-260,64},{-240,84}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hysOpt(
    final pre_y_start=false,
    final uHigh=0,
<<<<<<< HEAD
    final uLow=-60) "Hysteresis to activate the optimal start"
    annotation (Placement(transformation(extent={{330,-90},{350,-70}})));
  Buildings.Controls.OBC.CDL.Continuous.LessEqualThreshold lesEquThr(
    final threshold=1E-15)
    "Avoid zero division"
    annotation (Placement(transformation(extent={{-20,-10},{0,10}})));
  Buildings.Controls.OBC.CDL.Continuous.LessEqualThreshold lesEquThr1(
    final threshold=1E-15)
    "Avoid zero division"
    annotation (Placement(transformation(extent={{140,-10},{160,10}})));
=======
    final uLow=-60)
    "Hysteresis to activate the optimal start"
    annotation (Placement(transformation(extent={{320,-90},{340,-70}})));
>>>>>>> master
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant maxStaTim(
    final k=tOptMax)
    "Maximum optimal start time"
    annotation (Placement(transformation(extent={{210,-40},{230,-20}})));
  Buildings.Controls.OBC.CDL.Logical.TrueHoldWithReset truHol(
    final duration=tOptMax+11*3600)
    "Hold the start time for timer"
    annotation (Placement(transformation(extent={{-240,0},{-220,20}})));
  Buildings.Controls.OBC.CDL.Continuous.Division temSlo
    "Calculate temperature slope"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  Buildings.Controls.OBC.CDL.Logical.Pre pre
    "Break algebraic loops"
    annotation (Placement(transformation(extent={{390,-16},{410,4}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add1(
    final k1=+1,
    final k2=-1)
    "Calculate the time duration to reach the setpoint"
    annotation (Placement(transformation(extent={{-88,-10},{-68,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add2(
    final k1=+1,
    final k2=-1)
    "Calculate differential between time-to-next-occupancy and the cool-down time"
    annotation (Placement(transformation(extent={{280,-90},{300,-70}})));
  Buildings.Controls.OBC.CDL.Continuous.Min min
    "Get the final optimal start time"
    annotation (Placement(transformation(extent={{240,-16},{260,4}})));
  Buildings.Controls.OBC.CDL.Discrete.TriggeredSampler triSam
    "The instant when the zone temperature reaches setpoint with maximum time cutoff"
    annotation (Placement(transformation(extent={{-128,0},{-108,20}})));
  Buildings.Controls.OBC.CDL.Discrete.TriggeredSampler triSam1
    "Record the start time when the HVAC system is turned on"
    annotation (Placement(transformation(extent={{-128,-60},{-108,-40}})));
  Buildings.Controls.OBC.CDL.Logical.Latch lat
<<<<<<< HEAD
     "Stop calculation when the zone temperature reaches setpoint"
    annotation (Placement(transformation(extent={{-190,70},{-170,90}})));
  Buildings.Controls.OBC.CDL.Logical.Timer tim(final reset=true)
=======
    "Stop calculation when the zone temperature reaches setpoint"
    annotation (Placement(transformation(extent={{-188,70},{-168,90}})));
  Buildings.Controls.OBC.CDL.Logical.Timer tim
>>>>>>> master
    "Record time duration for the zone temperature to reach setpoint"
    annotation (Placement(transformation(extent={{-210,0},{-190,20}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1
    "Becomes true when the setpoint is reached"
    annotation (Placement(transformation(extent={{-220,64},{-200,84}})));
  Buildings.Controls.OBC.CDL.Continuous.Division tOptCal
    "Calculate optimal start time using the averaged previous temperature slope"
<<<<<<< HEAD
    annotation (Placement(transformation(extent={{220,-10},{240,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.ModelTime modTim "Model time"
    annotation (Placement(transformation(extent={{0,-50},{20,-30}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con1(final k=86400)
  "Daily period"
    annotation (Placement(transformation(extent={{0,-90},{20,-70}})));
  Buildings.Controls.OBC.CDL.Continuous.Modulo mod "Get the modulo"
    annotation (Placement(transformation(extent={{40,-70},{60,-50}})));
  Buildings.Controls.OBC.CDL.Continuous.LessEqualThreshold lesEquThr2(
    final threshold=1E-06)
  "Get the instant when the simulation time arrives at midnight"
    annotation (Placement(transformation(extent={{80,-70},{100,-50}})));
  Buildings.Controls.OBC.CDL.Discrete.TriggeredSampler triSam4
  "Get the sampled optimal start time at the same time each day"
    annotation (Placement(transformation(extent={{250,-10},{270,10}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greThr(
    final threshold=thrOptOn)
  "The threshold for optOn signal becomes true"
    annotation (Placement(transformation(extent={{320,-10},{340,10}})));
  Buildings.Controls.OBC.CDL.Logical.And and2 "Logical and"
    annotation (Placement(transformation(extent={{360,-40},{380,-20}})));

equation
  connect(tim.y, triSam.u)  annotation (Line(points={{-158,10},{-102,10}},
                                              color={0,0,127}));
  connect(falEdg.y, triSam.trigger) annotation (Line(points={{-98,-20},{-90,-20},
          {-90,-1.8}},                                                                     color={255,0,255}));
  connect(not1.y, lat.clr) annotation (Line(points={{-208,80},{-200,80},{-200,74},
          {-192,74}}, color={255,0,255}));
  connect(swi1.y, tOptCal.u2) annotation (Line(points={{202,0},{210,0},{210,-6},
          {218,-6}}, color={0,0,127}));
  connect(temSlo.y, triMovMea.u)  annotation (Line(points={{82,0},{98,0}},     color={0,0,127}));
  connect(lesEquThr.y, swi.u2)   annotation (Line(points={{2,0},{18,0}},      color={255,0,255}));
  connect(lesEquThr1.y, swi1.u2)    annotation (Line(points={{162,0},{178,0}},     color={255,0,255}));
  connect(TDif, hys.u) annotation (Line(points={{-300,120},{-272,120},{-272,80},
          {-262,80}},
                color={0,0,127}));
  connect(triMovMea.y, lesEquThr1.u)   annotation (Line(points={{122,0},{138,0}},     color={0,0,127}));
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
  connect(add1.y, lesEquThr.u)   annotation (Line(points={{-38,0},{-22,0}},
                                                                         color={0,0,127}));
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
  connect(modTim.y, mod.u1) annotation (Line(points={{22,-40},{28,-40},{28,-54},
          {38,-54}}, color={0,0,127}));
  connect(con1.y, mod.u2) annotation (Line(points={{22,-80},{28,-80},{28,-66},{
          38,-66}}, color={0,0,127}));
  connect(mod.y, lesEquThr2.u)   annotation (Line(points={{62,-60},{78,-60}}, color={0,0,127}));
  connect(lesEquThr2.y, triMovMea.trigger) annotation (Line(points={{102,-60},{
          110,-60},{110,-12}}, color={255,0,255}));
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
   annotation (
defaultComponentName="optStaCal",
  Documentation(info="<html>
=======
    annotation (Placement(transformation(extent={{160,-10},{180,10}})));
  Buildings.Controls.OBC.CDL.Discrete.TriggeredSampler samTimOpt
    "Get the sampled optimal start time at the same time each day"
    annotation (Placement(transformation(extent={{190,-10},{210,10}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greThr(
    final t=thrOptOn)
    "The threshold for optOn signal becomes true"
    annotation (Placement(transformation(extent={{320,-16},{340,4}})));
  Buildings.Controls.OBC.CDL.Logical.And and2
    "Logical and"
    annotation (Placement(transformation(extent={{360,-16},{380,4}})));
  CDL.Continuous.Max timRea
    "Time required to reach the set point"
    annotation (Placement(transformation(extent={{-40,-16},{-20,4}})));
  CDL.Continuous.Max temSloAve
    "Temperature slope during heat up or cool down over the past sampled days"
    annotation (Placement(transformation(extent={{120,-16},{140,4}})));
  CDL.Logical.Switch dTUse
    "dT used in the calculations (to avoid negative dT)"
    annotation (Placement(transformation(extent={{80,70},{100,90}})));
  CDL.Continuous.GreaterThreshold reqStaUp(
    final t=0,
    final h=0)
    "Output true if optimal startup is needed"
    annotation (Placement(transformation(extent={{10,70},{30,90}})));
  CDL.Logical.And triAve
    "Trigger sampling but only if optimal start up is needed"
    annotation (Placement(transformation(extent={{40,-42},{60,-22}})));

equation
  connect(tim.y,triSam.u)
    annotation (Line(points={{-188,10},{-130,10}},color={0,0,127}));
  connect(falEdg.y,triSam.trigger)
    annotation (Line(points={{-126,-20},{-118,-20},{-118,-1.8}},color={255,0,255}));
  connect(not1.y,lat.clr)
    annotation (Line(points={{-198,74},{-190,74}},color={255,0,255}));
  connect(temSlo.y,samTemSloAve.u)
    annotation (Line(points={{22,0},{58,0}},color={0,0,127}));
  connect(TDif,hys.u)
    annotation (Line(points={{-300,120},{-272,120},{-272,74},{-262,74}},color={0,0,127}));
  connect(staCal,dTCalOn.trigger)
    annotation (Line(points={{-300,40},{-30,40},{-30,68.2}},color={255,0,255}));
  connect(TDif,dTHVACOn.u)
    annotation (Line(points={{-300,120},{-42,120}},color={0,0,127}));
  connect(pre.y,dTHVACOn.trigger)
    annotation (Line(points={{412,-6},{420,-6},{420,104},{-30,104},{-30,108.2}},color={255,0,255}));
  connect(pre.y,lat.u)
    annotation (Line(points={{412,-6},{420,-6},{420,150},{-190,150},{-190,80}},color={255,0,255}));
  connect(edg.y,triSam1.trigger)
    annotation (Line(points={{-126,-80},{-118,-80},{-118,-61.8}},color={255,0,255}));
  connect(triSam1.y,add1.u2)
    annotation (Line(points={{-106,-50},{-100,-50},{-100,-6},{-90,-6}},color={0,0,127}));
  connect(triSam.y,add1.u1)
    annotation (Line(points={{-106,10},{-100,10},{-100,6},{-90,6}},color={0,0,127}));
  connect(TDif,dTCalOn.u)
    annotation (Line(points={{-300,120},{-140,120},{-140,80},{-42,80}},color={0,0,127}));
  connect(tNexOcc,add2.u2)
    annotation (Line(points={{-300,-140},{272,-140},{272,-86},{278,-86}},color={0,0,127}));
  connect(add2.y,hysOpt.u)
    annotation (Line(points={{302,-80},{318,-80}},color={0,0,127}));
  connect(min.y,add2.u1)
    annotation (Line(points={{262,-6},{270,-6},{270,-74},{278,-74}},color={0,0,127}));
  connect(staCal,truHol.u)
    annotation (Line(points={{-300,40},{-260,40},{-260,10},{-242,10}},color={255,0,255}));
  connect(truHol.y,tim.u)
    annotation (Line(points={{-218,10},{-212,10}},color={255,0,255}));
  connect(tim.y,triSam1.u)
    annotation (Line(points={{-188,10},{-168,10},{-168,-50},{-130,-50}},color={0,0,127}));
  connect(min.y,tOpt)
    annotation (Line(points={{262,-6},{270,-6},{270,60},{460,60}},color={0,0,127}));
  connect(not1.u,hys.y)
    annotation (Line(points={{-222,74},{-238,74}},color={255,0,255}));
  connect(lat.y,edg.u)
    annotation (Line(points={{-166,80},{-162,80},{-162,-80},{-150,-80}},color={255,0,255}));
  connect(lat.y,falEdg.u)
    annotation (Line(points={{-166,80},{-162,80},{-162,-20},{-150,-20}},color={255,0,255}));
  connect(tOptCal.y,samTimOpt.u)
    annotation (Line(points={{182,0},{188,0}},color={0,0,127}));
  connect(staCal,samTimOpt.trigger)
    annotation (Line(points={{-300,40},{146,40},{146,-20},{200,-20},{200,-11.8}},color={255,0,255}));
  connect(dTHVACOn.y,temSlo.u1)
    annotation (Line(points={{-18,120},{-10,120},{-10,6},{-2,6}},color={0,0,127}));
  connect(min.y,greThr.u)
    annotation (Line(points={{262,-6},{318,-6}},color={0,0,127}));
  connect(hysOpt.y,and2.u2)
    annotation (Line(points={{342,-80},{350,-80},{350,-14},{358,-14}},color={255,0,255}));
  connect(greThr.y,and2.u1)
    annotation (Line(points={{342,-6},{358,-6}},color={255,0,255}));
  connect(and2.y,pre.u)
    annotation (Line(points={{382,-6},{388,-6}},color={255,0,255}));
  connect(pre.y,optOn)
    annotation (Line(points={{412,-6},{420,-6},{420,-60},{460,-60}},color={255,0,255}));
  connect(timRea.y,temSlo.u2)
    annotation (Line(points={{-18,-6},{-2,-6}},color={0,0,127}));
  connect(timRea.u1,add1.y)
    annotation (Line(points={{-42,0},{-66,0}},color={0,0,127}));
  connect(timRea.u2,timReaMin.y)
    annotation (Line(points={{-42,-12},{-42,-32},{-58,-32}},color={0,0,127}));
  connect(temSloAve.y,tOptCal.u2)
    annotation (Line(points={{142,-6},{158,-6}},color={0,0,127}));
  connect(temSloAve.u1,samTemSloAve.y)
    annotation (Line(points={{118,0},{82,0}},color={0,0,127}));
  connect(defTemSlo.y,temSloAve.u2)
    annotation (Line(points={{110,-30},{112,-30},{112,-12},{118,-12}},color={0,0,127}));
  connect(min.u1,samTimOpt.y)
    annotation (Line(points={{238,0},{212,0}},color={0,0,127}));
  connect(maxStaTim.y,min.u2)
    annotation (Line(points={{232,-30},{234,-30},{234,-12},{238,-12}},color={0,0,127}));
  connect(reqStaUp.u,dTCalOn.y)
    annotation (Line(points={{8,80},{-18,80}},color={0,0,127}));
  connect(dTUse.u2,reqStaUp.y)
    annotation (Line(points={{78,80},{32,80}},color={255,0,255}));
  connect(dTCalOn.y,dTUse.u1)
    annotation (Line(points={{-18,80},{2,80},{2,100},{52,100},{52,88},{78,88}},color={0,0,127}));
  connect(con.y,dTUse.u3)
    annotation (Line(points={{62,60},{72,60},{72,72},{78,72}},color={0,0,127}));
  connect(dTUse.y,tOptCal.u1)
    annotation (Line(points={{102,80},{150,80},{150,6},{158,6}},color={0,0,127}));
  connect(triAve.u2,samTri.y)
    annotation (Line(points={{38,-40},{22,-40}},color={255,0,255}));
  connect(reqStaUp.y,triAve.u1)
    annotation (Line(points={{32,80},{36,80},{36,-32},{38,-32}},color={255,0,255}));
  connect(triAve.y,samTemSloAve.trigger)
    annotation (Line(points={{62,-32},{70,-32},{70,-12}},color={255,0,255}));
  annotation (
    defaultComponentName="optStaCal",
    Documentation(
      info="<html>
>>>>>>> master
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
<<<<<<< HEAD
=======
January 30, 2021, by Michael Wetter:<br/>
Refactored sampling of history of temperature slope to only sample when control error requires optimal start up.
Refactored guarding against division by zero.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2345\">#2345</a>.
</li>
<li>
October 20, 2020, by Michael Wetter:<br/>
Reimplemented trigger of the moving average computation.
</li>
<li>
>>>>>>> master
December 15, 2019, by Kun Zhang:<br/>
First implementation.
</li>
</ul>
</html>"),
    Diagram(
      coordinateSystem(
        extent={{-280,-160},{440,160}})),
    Icon(
      graphics={
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
