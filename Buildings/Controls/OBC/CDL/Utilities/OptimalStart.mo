within Buildings.Controls.OBC.CDL.Utilities;
block OptimalStart
  extends Modelica.Blocks.Icons.Block;
  parameter Modelica.SIunits.TemperatureDifference deadband = 0.5
    "Deadband of thermostats";
  parameter Real occupancy[:] = 3600*{8, 18}
    "Occupancy table, each entry switching occupancy on or off";
  parameter Modelica.SIunits.Time maxOptTim = 3600*3
    "Maximum optimal start time";
  parameter Modelica.SIunits.Time minOptTim = 900
    "Minimum optimal start time";
  parameter Modelica.SIunits.Time tOptIni = minOptTim
    "Initial optimal start time";
  parameter Modelica.SIunits.TemperatureSlope temSloIni = 1/3600
    "Initial temperature slope for heating";
  parameter Real n = 3 "Number of days for averaging the temperature slopes";
  Interfaces.RealInput TZon(
    final quantity = "ThermodynamicTemperature",
    final unit = "K",
    displayUnit = "degC",
    min=200) "Zone temperature"
    annotation (Placement(transformation(extent={{-340,40},{-300,80}}),
        iconTransformation(extent={{-140,60},{-100,100}})));
  Interfaces.RealInput TSetZon(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    displayUnit="degC",
    min=200) "Zone setpoint temperature during occupied time" annotation (
      Placement(transformation(extent={{-340,-80},{-300,-40}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));
  Continuous.Sources.ModelTime modTim
    annotation (Placement(transformation(extent={{-280,-70},{-260,-50}})));
  Continuous.Modulo mod
    annotation (Placement(transformation(extent={{-240,-90},{-220,-70}})));
  Continuous.Sources.Constant period(k=86400)
    "Period of optimal start calculation algorithm"
    annotation (Placement(transformation(extent={{-280,-110},{-260,-90}})));
  Continuous.Sources.Constant staCal(k=occupancy[1] - maxOptTim)
    "Start calculation"
    annotation (Placement(transformation(extent={{-240,-130},{-220,-110}})));
  Continuous.GreaterEqual greEqu
    annotation (Placement(transformation(extent={{-200,-100},{-180,-80}})));
  Continuous.Hysteresis hys(uLow=-deadband*0.5, uHigh=deadband*0.5)
    "Comparing zone temperature with zone setpoint"
    annotation (Placement(transformation(extent={{-240,90},{-220,110}})));
  Continuous.Add add(k1=-1, k2=+1)
    annotation (Placement(transformation(extent={{-280,-10},{-260,10}})));
  Logical.Latch lat
    "Stop calculation when the zone temperature reaches setpoint"
    annotation (Placement(transformation(extent={{-160,96},{-140,116}})));
  Logical.Timer timHea(reset=true)
    annotation (Placement(transformation(extent={{-40,80},{-20,100}})));
  Interfaces.RealOutput tOpt(
    final quantity="Time",
    final unit="s",
    displayUnit="h") "Optimal start time of HVAC system"
    annotation (Placement(transformation(extent={{300,-10},{320,10}}),
                    iconTransformation(extent={{100,-10},{120,10}})));
  Discrete.TriggeredSampler triSam(y_start=minOptTim)
    annotation (Placement(transformation(extent={{0,80},{20,100}})));
  Logical.FallingEdge falEdg
    "Get the timing when the zone temperature reaches setpoint"
    annotation (Placement(transformation(extent={{-60,50},{-40,70}})));
  Logical.TrueHoldWithReset truHol(duration(displayUnit="h") = occupancy[2] -
      occupancy[1])
    annotation (Placement(transformation(extent={{-80,80},{-60,100}})));
  Continuous.LessEqual lesEqu
    annotation (Placement(transformation(extent={{-200,-20},{-180,0}})));
  Continuous.Sources.Constant stoCal(k=occupancy[1]) "Stop calculation"
    annotation (Placement(transformation(extent={{-240,0},{-220,20}})));
  Logical.Latch latHea "Stop calculation when it reaches the max start time"
    annotation (Placement(transformation(extent={{-120,80},{-100,100}})));
  Discrete.TriggeredSampler triSam1
    annotation (Placement(transformation(extent={{120,-60},{140,-40}})));
  Continuous.Sources.Constant maxStaTim(k=maxOptTim)
    annotation (Placement(transformation(extent={{180,10},{200,30}})));
  Continuous.Min min
    annotation (Placement(transformation(extent={{232,-10},{252,10}})));
  Discrete.MovingMean movMea(n=n, samplePeriod=86400)
    annotation (Placement(transformation(extent={{200,80},{220,100}})));
  Interfaces.BooleanOutput Warmup "Warm-up mode" annotation (Placement(
        transformation(extent={{300,-150},{320,-130}}),
                                                      iconTransformation(extent=
           {{100,-50},{120,-30}})));
  Logical.Not not1
    annotation (Placement(transformation(extent={{-200,90},{-180,110}})));
  Continuous.Division temSlo "Calculate temperature slope "
    annotation (Placement(transformation(extent={{40,80},{60,100}})));
  Continuous.Division tOptCal
    "Calculate optimal start time based on the averaged previous temperature slope"
    annotation (Placement(transformation(extent={{238,80},{258,100}})));
  Discrete.TriggeredSampler triSam4(y_start=temSloHeaIni)
    annotation (Placement(transformation(extent={{76,80},{96,100}})));
  Continuous.LessEqual lesEqu1
    annotation (Placement(transformation(extent={{120,80},{140,100}})));
  Continuous.Sources.Constant casCoo(k=0)
    annotation (Placement(transformation(extent={{60,110},{80,130}})));
  Logical.Switch swi2
    annotation (Placement(transformation(extent={{160,80},{180,100}})));
  Continuous.Sources.Constant temSloDef(k=temSloIni)
    annotation (Placement(transformation(extent={{120,114},{140,134}})));
equation
  connect(mod.y, greEqu.u1) annotation (Line(points={{-218,-80},{-210,-80},{-210,
          -90},{-202,-90}},
                         color={0,0,127}));
  connect(add.y, hys.u) annotation (Line(points={{-258,0},{-254,0},{-254,100},{-242,
          100}}, color={0,0,127}));
  connect(staCal.y, greEqu.u2) annotation (Line(points={{-218,-120},{-208,-120},
          {-208,-98},{-202,-98}}, color={0,0,127}));
  connect(period.y, mod.u2) annotation (Line(points={{-258,-100},{-254,-100},{-254,
          -86},{-242,-86}},
                      color={0,0,127}));
  connect(modTim.y, mod.u1) annotation (Line(points={{-258,-60},{-254,-60},{-254,
          -74},{-242,-74}}, color={0,0,127}));
  connect(TSetZon, add.u2) annotation (Line(points={{-320,-60},{-290,-60},{-290,
          -6},{-282,-6}}, color={0,0,127}));
  connect(TZon, add.u1) annotation (Line(points={{-320,60},{-290,60},{-290,6},{-282,
          6}},        color={0,0,127}));
  connect(timHea.y, triSam.u)
    annotation (Line(points={{-18,90},{-2,90}},  color={0,0,127}));
  connect(greEqu.y, lat.u) annotation (Line(points={{-178,-90},{-170,-90},{-170,
          106},{-162,106}},
                          color={255,0,255}));
  connect(falEdg.y, triSam.trigger)
    annotation (Line(points={{-38,60},{10,60},{10,78.2}},  color={255,0,255}));
  connect(timHea.u, truHol.y)
    annotation (Line(points={{-42,90},{-58,90}},  color={255,0,255}));
  connect(lesEqu.y, latHea.clr) annotation (Line(points={{-178,-10},{-136,-10},{
          -136,84},{-122,84}},
                           color={255,0,255}));
  connect(lat.y, latHea.u) annotation (Line(points={{-138,106},{-136,106},{-136,
          90},{-122,90}},
                      color={255,0,255}));
  connect(stoCal.y, lesEqu.u1) annotation (Line(points={{-218,10},{-210,10},{-210,
          -10},{-202,-10}}, color={0,0,127}));
  connect(latHea.y, truHol.u)
    annotation (Line(points={{-98,90},{-82,90}},   color={255,0,255}));
  connect(latHea.y, falEdg.u) annotation (Line(points={{-98,90},{-90,90},{-90,60},
          {-62,60}},       color={255,0,255}));
  connect(greEqu.y, triSam1.trigger) annotation (Line(points={{-178,-90},{130,-90},
          {130,-61.8}},                             color={255,0,255}));
  connect(maxStaTim.y, min.u1) annotation (Line(points={{202,20},{220,20},{220,6},
          {230,6}},            color={0,0,127}));
  connect(min.y, tOpt) annotation (Line(points={{254,0},{310,0}},
                   color={0,0,127}));
  connect(hys.y, not1.u)
    annotation (Line(points={{-218,100},{-202,100}}, color={255,0,255}));
  connect(not1.y, lat.clr) annotation (Line(points={{-178,100},{-162,100}},
                      color={255,0,255}));
  connect(latHea.y, Warmup) annotation (Line(points={{-98,90},{-90,90},{-90,-140},
          {310,-140}},     color={255,0,255}));
  connect(add.y,tOptCal. u1) annotation (Line(points={{-258,0},{-254,0},{-254,140},
          {230,140},{230,96},{236,96}},        color={0,0,127}));
  connect(movMea.y,tOptCal. u2) annotation (Line(points={{222,90},{228,90},{228,
          84},{236,84}},   color={0,0,127}));
  connect(tOptCal.y, triSam1.u) annotation (Line(points={{260,90},{266,90},{266,
          40},{100,40},{100,-50},{118,-50}},
                                         color={0,0,127}));
  connect(temSlo.y, triSam4.u)
    annotation (Line(points={{62,90},{74,90}}, color={0,0,127}));
  connect(triSam4.trigger, triSam1.trigger) annotation (Line(points={{86,78.2},{
          86,60},{40,60},{40,-90},{130,-90},{130,-61.8}},color={255,0,255}));
  connect(triSam4.y, lesEqu1.u1)
    annotation (Line(points={{98,90},{118,90}},    color={0,0,127}));
  connect(casCoo.y, lesEqu1.u2) annotation (Line(points={{82,120},{108,120},{108,
          82},{118,82}},   color={0,0,127}));
  connect(lesEqu1.y, swi2.u2)
    annotation (Line(points={{142,90},{158,90}},   color={255,0,255}));
  connect(swi2.y, movMea.u)
    annotation (Line(points={{182,90},{198,90}},   color={0,0,127}));
  connect(temSloDef.y, swi2.u1) annotation (Line(points={{142,124},{144,124},{144,
          98},{158,98}}, color={0,0,127}));
  connect(triSam4.y, swi2.u3) annotation (Line(points={{98,90},{104,90},{104,62},
          {148,62},{148,82},{158,82}},         color={0,0,127}));
  connect(triSam1.y, min.u2) annotation (Line(points={{142,-50},{170,-50},{170,-6},
          {230,-6}}, color={0,0,127}));
  connect(mod.y, lesEqu.u2) annotation (Line(points={{-218,-80},{-210,-80},{-210,
          -18},{-202,-18}}, color={0,0,127}));
  connect(temSlo.u1, tOptCal.u1) annotation (Line(points={{38,96},{28,96},{28,140},
          {230,140},{230,96},{236,96}}, color={0,0,127}));
  connect(triSam.y, temSlo.u2) annotation (Line(points={{22,90},{28,90},{28,84},
          {38,84}}, color={0,0,127}));
  annotation (            Diagram(coordinateSystem(extent={{-300,-160},{300,160}})));
end OptimalStart;
