within Buildings.Controls.OBC.CDL.Utilities;
block OptimalStart
  extends Modelica.Blocks.Icons.Block;
  parameter Real occupancy[:]=3600*{8, 18}
    "Occupancy table, each entry switching occupancy on or off";
  parameter Modelica.SIunits.Time maxOptTim = 3*3600 "Maximum optimal start time";
  //Modelica.SIunits.TemperatureSlope temSloHea "Temperature slope for heating";
  //Modelica.SIunits.TemperatureSlope temSloCoo "Temperature slope for cooling";
  Interfaces.RealInput TZon(
    final quantity = "ThermodynamicTemperature",
    final unit = "K",
    displayUnit = "degC",
    min=200) "Zone temperature"
    annotation (Placement(transformation(extent={{-340,60},{-300,100}}),
        iconTransformation(extent={{-140,60},{-100,100}})));
  Interfaces.RealInput TSetZonHea(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    displayUnit="degC",
    min=200) "Zone setpoint temperature for heating during occupied time"
    annotation (Placement(transformation(extent={{-340,-20},{-300,20}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));
  Interfaces.RealInput TSetZonCoo(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    displayUnit="degC",
    min=200) "Zone setpoint temperature for cooling during occupied time"
    annotation (Placement(transformation(extent={{-340,-100},{-300,-60}}),
        iconTransformation(extent={{-140,-100},{-100,-60}})));
  Continuous.Sources.ModelTime modTim
    annotation (Placement(transformation(extent={{-240,110},{-220,130}})));
  Continuous.Modulo mod
    annotation (Placement(transformation(extent={{-200,90},{-180,110}})));
  Continuous.Sources.Constant Period(k=86400)
    annotation (Placement(transformation(extent={{-240,70},{-220,90}})));
  Continuous.Sources.Constant startCal(k=occupancy[1] - maxOptTim)
    annotation (Placement(transformation(extent={{-200,60},{-180,80}})));
  Continuous.GreaterEqual greEqu
    annotation (Placement(transformation(extent={{-160,90},{-140,110}})));
  Continuous.Hysteresis hys(uLow=-0.25, uHigh=0.25)
    "Comparing zone temperature with heating setpoint"
    annotation (Placement(transformation(extent={{-220,10},{-200,30}})));
  Continuous.Add add(k1=-1)
    annotation (Placement(transformation(extent={{-280,10},{-260,30}})));
  Logical.Latch lat
    "Stop calculation when the zone temperature reaches setpoint"
    annotation (Placement(transformation(extent={{-120,40},{-100,60}})));
  Logical.Timer tim(reset=true)
    annotation (Placement(transformation(extent={{0,120},{20,140}})));
  Interfaces.RealOutput tOpt(
    final quantity="Time",
    final unit="s",
    displayUnit="h") "Optimal start time of HVAC system"
    annotation (Placement(transformation(extent={{300,-10},{320,10}}),
                    iconTransformation(extent={{100,-10},{120,10}})));
  Discrete.TriggeredSampler triSam
    annotation (Placement(transformation(extent={{40,120},{60,140}})));
  Logical.FallingEdge falEdg
    "Get the timing when the zone temperature reaches setpoint"
    annotation (Placement(transformation(extent={{-20,70},{0,90}})));
  Logical.TrueHoldWithReset truHol(duration(displayUnit="h") = occupancy[2] -
      occupancy[1])
    annotation (Placement(transformation(extent={{-40,120},{-20,140}})));
  Continuous.Add add1(k1=+1, k2=-1)
    annotation (Placement(transformation(extent={{-280,-40},{-260,-20}})));
  Continuous.LessEqual lesEqu
    annotation (Placement(transformation(extent={{-120,120},{-100,140}})));
  Continuous.Sources.Constant stopCal(k=occupancy[1])
    annotation (Placement(transformation(extent={{-180,140},{-160,160}})));
  Logical.Latch lat1 "Stop calculation when it reaches the max start time"
    annotation (Placement(transformation(extent={{-80,120},{-60,140}})));
  Continuous.Hysteresis hys1(
    uLow=-0.25,
    uHigh=+0.25,
    pre_y_start=false) "Comparing zone temperature with cooling setpoint"
    annotation (Placement(transformation(extent={{-240,-40},{-220,-20}})));
  Logical.Or or1
    annotation (Placement(transformation(extent={{-160,0},{-140,20}})));
  Logical.Not not1
    annotation (Placement(transformation(extent={{-200,-40},{-180,-20}})));
  Continuous.Division div
    annotation (Placement(transformation(extent={{-200,-80},{-180,-60}})));
  Continuous.Division div1
    annotation (Placement(transformation(extent={{-200,-120},{-180,-100}})));
  Continuous.Sources.Constant temSloHea(k=2/3600)
    "Temperature slope for heating"
    annotation (Placement(transformation(extent={{-280,-80},{-260,-60}})));
  Discrete.TriggeredSampler triSam1
    annotation (Placement(transformation(extent={{-160,-80},{-140,-60}})));
  Discrete.TriggeredSampler triSam2
    annotation (Placement(transformation(extent={{-160,-120},{-140,-100}})));
  Continuous.Sources.Constant maxStaTim(k=maxOptTim)
    annotation (Placement(transformation(extent={{-100,-60},{-80,-40}})));
  Continuous.Max max
    annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));
  Continuous.Min min
    annotation (Placement(transformation(extent={{-60,-80},{-40,-60}})));
  Discrete.TriggeredSampler triSam3(y_start=maxOptTim)
    annotation (Placement(transformation(extent={{80,120},{100,140}})));
  Discrete.TriggeredSampler triSam4(y_start=maxOptTim)
    annotation (Placement(transformation(extent={{120,120},{140,140}})));
  Discrete.TriggeredSampler triSam5(y_start=maxOptTim)
    annotation (Placement(transformation(extent={{160,120},{180,140}})));
  Continuous.MultiSum mulSum(k=fill(1, 3), nin=3)
    annotation (Placement(transformation(extent={{192,90},{212,110}})));
  Logical.Sources.SampleTrigger samTri(period(displayUnit="h") = 259200,
      startTime(displayUnit="h") = occupancy[1])
    annotation (Placement(transformation(extent={{60,50},{80,70}})));
  Logical.Sources.SampleTrigger samTri1(period(displayUnit="h") = 259200,
      startTime(displayUnit="h") = occupancy[1] + 24*3600)
    annotation (Placement(transformation(extent={{100,50},{120,70}})));
  Logical.Sources.SampleTrigger samTri2(period(displayUnit="h") = 259200,
      startTime(displayUnit="h") = occupancy[1] + 48*3600)
    annotation (Placement(transformation(extent={{140,50},{160,70}})));
  Continuous.Gain gai(k=1/3)
    annotation (Placement(transformation(extent={{220,90},{240,110}})));
equation
  connect(mod.y, greEqu.u1) annotation (Line(points={{-179,100.2},{-169.5,100.2},
          {-169.5,100},{-162,100}},
                         color={0,0,127}));
  connect(add.y, hys.u)
    annotation (Line(points={{-259,20},{-222,20}}, color={0,0,127}));
  connect(startCal.y, greEqu.u2) annotation (Line(points={{-179,70},{-168,70},{
          -168,92},{-162,92}},  color={0,0,127}));
  connect(Period.y, mod.u2) annotation (Line(points={{-219,80},{-210,80},{-210,
          94},{-202,94}},
                      color={0,0,127}));
  connect(modTim.y, mod.u1) annotation (Line(points={{-219,120},{-210,120},{
          -210,106},{-202,106}},
                            color={0,0,127}));
  connect(TSetZonHea, add.u2) annotation (Line(points={{-320,0},{-294,0},{-294,
          14},{-282,14}}, color={0,0,127}));
  connect(TZon, add.u1) annotation (Line(points={{-320,80},{-294,80},{-294,26},
          {-282,26}}, color={0,0,127}));
  connect(tim.y, triSam.u)
    annotation (Line(points={{21,130},{38,130}},color={0,0,127}));
  connect(greEqu.y, lat.u) annotation (Line(points={{-139,100},{-130,100},{-130,
          50},{-121,50}}, color={255,0,255}));
  connect(falEdg.y, triSam.trigger)
    annotation (Line(points={{1,80},{50,80},{50,118.2}},   color={255,0,255}));
  connect(tim.u, truHol.y)
    annotation (Line(points={{-2,130},{-19,130}},  color={255,0,255}));
  connect(lesEqu.y, lat1.u0) annotation (Line(points={{-99,130},{-94,130},{-94,
          124},{-81,124}}, color={255,0,255}));
  connect(lat.y, lat1.u) annotation (Line(points={{-99,50},{-88,50},{-88,130},{
          -81,130}}, color={255,0,255}));
  connect(mod.y, lesEqu.u2) annotation (Line(points={{-179,100.2},{-172,100.2},
          {-172,122},{-122,122}}, color={0,0,127}));
  connect(stopCal.y, lesEqu.u1) annotation (Line(points={{-159,150},{-140,150},
          {-140,130},{-122,130}}, color={0,0,127}));
  connect(lat1.y, truHol.u)
    annotation (Line(points={{-59,130},{-41,130}}, color={255,0,255}));
  connect(lat1.y, falEdg.u) annotation (Line(points={{-59,130},{-50,130},{-50,
          80},{-22,80}}, color={255,0,255}));
  connect(add1.y, hys1.u)
    annotation (Line(points={{-259,-30},{-242,-30}}, color={0,0,127}));
  connect(hys.y, or1.u1) annotation (Line(points={{-199,20},{-170,20},{-170,10},
          {-162,10}}, color={255,0,255}));
  connect(hys1.y, not1.u)
    annotation (Line(points={{-219,-30},{-202,-30}}, color={255,0,255}));
  connect(not1.y, or1.u2) annotation (Line(points={{-179,-30},{-170,-30},{-170,
          2},{-162,2}}, color={255,0,255}));
  connect(TSetZonCoo, add1.u2) annotation (Line(points={{-320,-80},{-290,-80},{
          -290,-36},{-282,-36}}, color={0,0,127}));
  connect(TZon, add1.u1) annotation (Line(points={{-320,80},{-294,80},{-294,26},
          {-288,26},{-288,-24},{-282,-24}}, color={0,0,127}));
  connect(or1.y, lat.u0) annotation (Line(points={{-139,10},{-130,10},{-130,44},
          {-121,44}}, color={255,0,255}));
  connect(add.y, div.u1) annotation (Line(points={{-259,20},{-250,20},{-250,-64},
          {-202,-64}}, color={0,0,127}));
  connect(add1.y, div1.u1) annotation (Line(points={{-259,-30},{-254,-30},{-254,
          -104},{-202,-104}}, color={0,0,127}));
  connect(temSloHea.y, div.u2) annotation (Line(points={{-259,-70},{-240,-70},{
          -240,-76},{-202,-76}}, color={0,0,127}));
  connect(div.y, triSam1.u)
    annotation (Line(points={{-179,-70},{-162,-70}}, color={0,0,127}));
  connect(div1.y, triSam2.u)
    annotation (Line(points={{-179,-110},{-162,-110}}, color={0,0,127}));
  connect(greEqu.y, triSam1.trigger) annotation (Line(points={{-139,100},{-134,
          100},{-134,-88},{-150,-88},{-150,-81.8}}, color={255,0,255}));
  connect(triSam2.trigger, triSam1.trigger) annotation (Line(points={{-150,
          -121.8},{-150,-130},{-134,-130},{-134,-88},{-150,-88},{-150,-81.8}},
        color={255,0,255}));
  connect(triSam2.y, max.u2) annotation (Line(points={{-139,-110},{-120,-110},{
          -120,-96},{-102,-96}}, color={0,0,127}));
  connect(triSam1.y, max.u1) annotation (Line(points={{-139,-70},{-120,-70},{
          -120,-84},{-102,-84}}, color={0,0,127}));
  connect(maxStaTim.y, min.u1) annotation (Line(points={{-79,-50},{-70,-50},{
          -70,-64},{-62,-64}}, color={0,0,127}));
  connect(max.y, min.u2) annotation (Line(points={{-79,-90},{-70,-90},{-70,-76},
          {-62,-76}}, color={0,0,127}));
  connect(min.y, tOpt) annotation (Line(points={{-39,-70},{-20,-70},{-20,0},{
          310,0}}, color={0,0,127}));
  connect(triSam3.y, mulSum.u[1]) annotation (Line(points={{101,130},{104,130},
          {104,101.333},{190,101.333}}, color={0,0,127}));
  connect(triSam4.y, mulSum.u[2]) annotation (Line(points={{141,130},{142,130},
          {142,100},{190,100}}, color={0,0,127}));
  connect(triSam5.y, mulSum.u[3]) annotation (Line(points={{181,130},{184,130},
          {184,98.6667},{190,98.6667}}, color={0,0,127}));
  connect(samTri.y, triSam3.trigger)
    annotation (Line(points={{81,60},{90,60},{90,118.2}}, color={255,0,255}));
  connect(samTri1.y, triSam4.trigger) annotation (Line(points={{121,60},{130,60},
          {130,118.2}}, color={255,0,255}));
  connect(samTri2.y, triSam5.trigger) annotation (Line(points={{161,60},{170,60},
          {170,118.2}}, color={255,0,255}));
  connect(mulSum.y, gai.u)
    annotation (Line(points={{213,100},{218,100}}, color={0,0,127}));
  connect(triSam.y, triSam3.u)
    annotation (Line(points={{61,130},{78,130}}, color={0,0,127}));
  connect(triSam.y, triSam4.u) annotation (Line(points={{61,130},{70,130},{70,
          148},{112,148},{112,130},{118,130}}, color={0,0,127}));
  connect(triSam.y, triSam5.u) annotation (Line(points={{61,130},{66,130},{66,
          150},{146,150},{146,130},{158,130}}, color={0,0,127}));
  connect(gai.y, div1.u2) annotation (Line(points={{241,100},{250,100},{250,
          -136},{-222,-136},{-222,-116},{-202,-116}}, color={0,0,127}));
  annotation (            Diagram(coordinateSystem(extent={{-300,-200},{300,200}})));
end OptimalStart;
