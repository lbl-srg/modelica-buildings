within Buildings.Controls.OBC.CDL.Utilities;
block OptimalStart
    "Block that outputs the optimal start time for an HVAC system"
  extends Modelica.Blocks.Icons.Block;
  parameter Modelica.SIunits.TemperatureDifference deadband = 0.5
    "Deadband of thermostat";
  parameter Real occupancy[:] = 3600*{8, 18}
    "Occupancy table, each entry switching occupancy on or off";
  parameter Modelica.SIunits.Time maxOptTim = 3600*3
    "Maximum optimal start time";
  parameter Modelica.SIunits.Time minOptTim = 900
    "Minimum optimal start time";
  parameter Modelica.SIunits.Time tOptIni = minOptTim
    "Initial optimal start time";
  parameter Modelica.SIunits.TemperatureSlope temSloIni = 1/3600
    "Initial temperature slope";
  parameter Integer n = 3 "Number of previous days for averaging the temperature slope";
  parameter Boolean heating_only = false
    "Set to true if the HVAC system is heating only"
    annotation(Dialog(enable=not cooling_only));
  parameter Boolean cooling_only = false
    "Set to true if the HVAC system is cooling only"
    annotation(Dialog(enable=not heating_only));
  Interfaces.RealInput TSetZonHea(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    displayUnit="degC",
    min=200) if not cooling_only
    "Zone heating setpoint temperature during occupancy"
    annotation (
      Placement(transformation(extent={{-360,60},{-320,100}}),
        iconTransformation(extent={{-140,60},{-100,100}})));
  Interfaces.RealInput TZon(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    displayUnit="degC",
    min=200) "Zone temperature" annotation (Placement(transformation(extent={{-358,
            -20},{-318,20}}),      iconTransformation(extent={{-140,-20},{-100,
            20}})));
  Interfaces.RealInput TSetZonCoo(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    displayUnit="degC",
    min=200) if not heating_only
    "Zone cooling setpoint temperature during occupancy" annotation (
      Placement(transformation(extent={{-360,-100},{-320,-60}}),
        iconTransformation(extent={{-140,-100},{-100,-60}})));
  Interfaces.RealOutput tOpt(
    final quantity="Time",
    final unit="s",
    displayUnit="h") "Optimal start time of HVAC system"
    annotation (Placement(transformation(extent={{320,-10},{340,10}}),
                    iconTransformation(extent={{100,-10},{120,10}})));
  Interfaces.BooleanOutput Startup "The duration of optimal startup"
    annotation (Placement(transformation(extent={{320,-130},{340,-110}}),
        iconTransformation(extent={{100,-50},{120,-30}})));
  Continuous.Add add(k1=+1, k2=-1) if not cooling_only
    annotation (Placement(transformation(extent={{-300,60},{-280,80}})));
  Continuous.Add add1(k1=+1, k2=-1) if not heating_only
    annotation (Placement(transformation(extent={{-300,20},{-280,40}})));
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
    annotation (Placement(transformation(extent={{-188,-100},{-168,-80}})));
  Continuous.Hysteresis hys(uLow=-0.5*deadband, uHigh=0.5*deadband)
    "Comparing zone temperature with zone setpoint"
    annotation (Placement(transformation(extent={{-210,70},{-190,90}})));
  Logical.Latch lat
    "Stop calculation when the zone temperature reaches setpoint"
    annotation (Placement(transformation(extent={{-140,100},{-120,120}})));
  Logical.Timer tim(reset=true)
    "Record how much time the zone temperature reaches the setpoint"
    annotation (Placement(transformation(extent={{-26,80},{-6,100}})));

  Discrete.TriggeredSampler triSam(y_start=minOptTim)
    "Record how much time it takes to reach the setpoint with the maximum time cutoff"
    annotation (Placement(transformation(extent={{8,80},{28,100}})));
  Logical.FallingEdge falEdg
    "Get the timing when the zone temperature reaches setpoint"
    annotation (Placement(transformation(extent={{-40,50},{-20,70}})));
  Logical.TrueHoldWithReset truHol(duration(displayUnit="h") = occupancy[2] -
      occupancy[1])
    annotation (Placement(transformation(extent={{-60,80},{-40,100}})));
  Continuous.LessEqual lesEqu
    annotation (Placement(transformation(extent={{-200,-10},{-180,10}})));
  Continuous.Sources.Constant stoCal(k=occupancy[1]) "Stop calculation"
    annotation (Placement(transformation(extent={{-240,0},{-220,20}})));
  Logical.Latch latMax "Stop calculation when it reaches the max start time"
    annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
  Discrete.TriggeredSampler triSam1
    annotation (Placement(transformation(extent={{240,-60},{260,-40}})));
  Continuous.Sources.Constant maxStaTim(k=maxOptTim)
    annotation (Placement(transformation(extent={{240,10},{260,30}})));
  Continuous.Min min
    annotation (Placement(transformation(extent={{292,-10},{312,10}})));
  Discrete.MovingMean movMea(n=n, samplePeriod=86400)
    annotation (Placement(transformation(extent={{160,80},{180,100}})));
  Logical.Not not1
    annotation (Placement(transformation(extent={{-180,70},{-160,90}})));
  Continuous.Division temSlo "Calculate temperature slope "
    annotation (Placement(transformation(extent={{100,80},{120,100}})));
  Continuous.Division tOptCal
    "Calculate optimal start time based on the averaged previous temperature slope"
    annotation (Placement(transformation(extent={{280,80},{300,100}})));
  Discrete.TriggeredSampler triSam2(y_start=temSloIni)
    annotation (Placement(transformation(extent={{130,80},{150,100}})));
  Continuous.Sources.Constant dT(k=0) if cooling_only
    "Reset negative temperature difference to zero"
    annotation (Placement(transformation(extent={{-300,100},{-280,120}})));
  Continuous.Max max
    annotation (Placement(transformation(extent={{-260,40},{-240,60}})));
  Continuous.Sources.Constant dT1(k=0) if heating_only
    "Reset negative temperature difference to zero"
    annotation (Placement(transformation(extent={{-300,-20},{-280,0}})));
  Continuous.Sources.Constant dT2(k=0)
    "Reset negative temperature difference to zero"
    annotation (Placement(transformation(extent={{-260,110},{-240,130}})));
  Continuous.Max max1
    annotation (Placement(transformation(extent={{-200,100},{-180,120}})));
  Continuous.LessEqual lesEqu1
    annotation (Placement(transformation(extent={{40,80},{60,100}})));
  Continuous.Sources.Constant zeroOpt(k=0)
    "Avoid zero division cases when the optimal start time is 0"
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));
  Logical.Switch swi
    annotation (Placement(transformation(extent={{60,40},{80,60}})));
  Continuous.Sources.Constant minStaTim(k=minOptTim)
    annotation (Placement(transformation(extent={{0,0},{20,20}})));
  Continuous.LessEqual lesEqu2
    annotation (Placement(transformation(extent={{200,80},{220,100}})));
  Continuous.Sources.Constant zeroTemSlo(k=0)
    "Avoid zero divison when the temperature slope is 0"
    annotation (Placement(transformation(extent={{100,40},{120,60}})));
  Logical.Switch swi1
    annotation (Placement(transformation(extent={{240,80},{260,100}})));
  Continuous.Sources.Constant defTemSlo(k=temSloIni)
    annotation (Placement(transformation(extent={{160,0},{180,20}})));
equation
  connect(mod.y, greEqu.u1) annotation (Line(points={{-218,-80},{-198,-80},{-198,
          -90},{-190,-90}},
                         color={0,0,127}));
  connect(staCal.y, greEqu.u2) annotation (Line(points={{-218,-120},{-196,-120},
          {-196,-98},{-190,-98}}, color={0,0,127}));
  connect(period.y, mod.u2) annotation (Line(points={{-258,-100},{-254,-100},{-254,
          -86},{-242,-86}},
                      color={0,0,127}));
  connect(modTim.y, mod.u1) annotation (Line(points={{-258,-60},{-254,-60},{-254,
          -74},{-242,-74}}, color={0,0,127}));
  connect(tim.y, triSam.u)
    annotation (Line(points={{-4,90},{6,90}}, color={0,0,127}));
  connect(falEdg.y, triSam.trigger)
    annotation (Line(points={{-18,60},{18,60},{18,78.2}},  color={255,0,255}));
  connect(tim.u, truHol.y)
    annotation (Line(points={{-28,90},{-38,90}}, color={255,0,255}));
  connect(lat.y,latMax. u) annotation (Line(points={{-118,110},{-116,110},{-116,
          90},{-102,90}},
                      color={255,0,255}));
  connect(latMax.y, truHol.u)
    annotation (Line(points={{-78,90},{-62,90}},   color={255,0,255}));
  connect(latMax.y, falEdg.u) annotation (Line(points={{-78,90},{-70,90},{-70,60},
          {-42,60}},       color={255,0,255}));
  connect(greEqu.y, triSam1.trigger) annotation (Line(points={{-166,-90},{250,-90},
          {250,-61.8}},                             color={255,0,255}));
  connect(maxStaTim.y, min.u1) annotation (Line(points={{262,20},{280,20},{280,6},
          {290,6}},            color={0,0,127}));
  connect(min.y, tOpt) annotation (Line(points={{314,0},{330,0}},
                   color={0,0,127}));
  connect(hys.y, not1.u)
    annotation (Line(points={{-188,80},{-182,80}},   color={255,0,255}));
  connect(not1.y, lat.clr) annotation (Line(points={{-158,80},{-146,80},{-146,104},
          {-142,104}},color={255,0,255}));
  connect(latMax.y, Startup) annotation (Line(points={{-78,90},{-70,90},{-70,-120},
          {330,-120}}, color={255,0,255}));
  connect(tOptCal.y, triSam1.u) annotation (Line(points={{302,90},{308,90},{308,
          40},{224,40},{224,-50},{238,-50}},
                                         color={0,0,127}));
  connect(temSlo.y,triSam2. u)
    annotation (Line(points={{122,90},{128,90}},
                                               color={0,0,127}));
  connect(mod.y, lesEqu.u2) annotation (Line(points={{-218,-80},{-210,-80},{-210,
          -8},{-202,-8}},   color={0,0,127}));
  connect(triSam2.y, movMea.u)
    annotation (Line(points={{152,90},{158,90}}, color={0,0,127}));
  connect(greEqu.y, lat.u) annotation (Line(points={{-166,-90},{-152,-90},{-152,
          110},{-142,110}},color={255,0,255}));
  connect(triSam2.trigger, triSam1.trigger) annotation (Line(points={{140,78.2},
          {140,-90},{250,-90},{250,-61.8}}, color={255,0,255}));
  connect(tOptCal.u1, temSlo.u1) annotation (Line(points={{278,96},{274,96},{274,
          130},{76,130},{76,96},{98,96}},        color={0,0,127}));
  connect(triSam1.y, min.u2) annotation (Line(points={{262,-50},{280,-50},{280,-6},
          {290,-6}},     color={0,0,127}));
  connect(add1.y, max.u2) annotation (Line(points={{-278,30},{-272,30},{-272,44},
          {-262,44}}, color={0,0,127}));
  connect(add.y, max.u1) annotation (Line(points={{-278,70},{-272,70},{-272,56},
          {-262,56}}, color={0,0,127}));
  connect(dT1.y, max.u2) annotation (Line(points={{-278,-10},{-272,-10},{-272,44},
          {-262,44}}, color={0,0,127}));
  connect(max.y, hys.u) annotation (Line(points={{-238,50},{-220,50},{-220,80},{
          -212,80}}, color={0,0,127}));
  connect(dT.y, max.u1) annotation (Line(points={{-278,110},{-272,110},{-272,56},
          {-262,56}}, color={0,0,127}));
  connect(max.y, max1.u2) annotation (Line(points={{-238,50},{-220,50},{-220,104},
          {-202,104}}, color={0,0,127}));
  connect(max1.y, temSlo.u1) annotation (Line(points={{-178,110},{-164,110},{-164,
          130},{76,130},{76,96},{98,96}}, color={0,0,127}));
  connect(lesEqu.y, latMax.clr) annotation (Line(points={{-178,0},{-126,0},{-126,
          84},{-102,84}}, color={255,0,255}));
  connect(stoCal.y, lesEqu.u1) annotation (Line(points={{-218,10},{-212,10},{-212,
          0},{-202,0}}, color={0,0,127}));
  connect(triSam.y, lesEqu1.u1)
    annotation (Line(points={{30,90},{38,90}}, color={0,0,127}));
  connect(lesEqu1.y, swi.u2) annotation (Line(points={{62,90},{68,90},{68,70},{44,
          70},{44,50},{58,50}}, color={255,0,255}));
  connect(TSetZonCoo, add1.u2) annotation (Line(points={{-340,-80},{-310,-80},{-310,
          24},{-302,24}}, color={0,0,127}));
  connect(TZon, add1.u1) annotation (Line(points={{-338,0},{-314,0},{-314,36},{-302,
          36}}, color={0,0,127}));
  connect(TZon, add.u2) annotation (Line(points={{-338,0},{-314,0},{-314,64},{-302,
          64}}, color={0,0,127}));
  connect(TSetZonHea, add.u1) annotation (Line(points={{-340,80},{-310,80},{-310,
          76},{-302,76}}, color={0,0,127}));
  connect(movMea.y, lesEqu2.u1)
    annotation (Line(points={{182,90},{198,90}}, color={0,0,127}));
  connect(swi.y, temSlo.u2) annotation (Line(points={{82,50},{90,50},{90,84},{98,
          84}}, color={0,0,127}));
  connect(swi1.y, tOptCal.u2) annotation (Line(points={{262,90},{270,90},{270,84},
          {278,84}}, color={0,0,127}));
  connect(lesEqu2.y, swi1.u2)
    annotation (Line(points={{222,90},{238,90}}, color={255,0,255}));
  connect(minStaTim.y, swi.u1) annotation (Line(points={{22,10},{40,10},{40,58},
          {58,58}}, color={0,0,127}));
  connect(triSam.y, swi.u3) annotation (Line(points={{30,90},{36,90},{36,42},{58,
          42}}, color={0,0,127}));
  connect(defTemSlo.y, swi1.u1) annotation (Line(points={{182,10},{210,10},{210,
          70},{230,70},{230,98},{238,98}}, color={0,0,127}));
  connect(movMea.y, swi1.u3) annotation (Line(points={{182,90},{190,90},{190,116},
          {234,116},{234,82},{238,82}}, color={0,0,127}));
  connect(dT2.y, max1.u1) annotation (Line(points={{-238,120},{-220,120},{-220,116},
          {-202,116}}, color={0,0,127}));
  connect(zeroOpt.y, lesEqu1.u2) annotation (Line(points={{-18,30},{32,30},{32,82},
          {38,82}}, color={0,0,127}));
  connect(zeroTemSlo.y, lesEqu2.u2) annotation (Line(points={{122,50},{190,50},{
          190,82},{198,82}}, color={0,0,127}));
  annotation (
defaultComponentName="optSta",
  Documentation(info="<html>
<p>
This block outputs the optimal start time for an HVAC system each day prior to the occupation time. 
The calculation is based on the concept of temperature slope, indicating the 
temperature change rate of a zone, with the unit <code>K/s</code>. The algorithm is described briefly 
in the steps blow.
</p>
<p>
<h4>Step 1: get sampled temperature difference <code>&Delta;T</code></h4>
Each day at a certain time before the occupancy, the algorithm takes a sample of the zone 
temperature. The sampling time is defined as occupancy start
time <code> - maxOptTim</code>, where <code>maxOptTim</code> denotes the maximum
optimal start time.
<p>
After getting zone temperature at the sampling time, the difference <code>&Delta;T</code> between this zone 
temperature and the zone setpoint during occupation is calculated.
</p>
</p>
<p>
<h4>Step 2: calculate temeperature slope <code>Ts</code></h4>
After the HVAC system is started, a timer is used to record how much time <code>&Delta;t</code> the zone temperature 
reaches the setpoint. The temperature slope is thus approximated using the equation: 
<code>Ts=&Delta;T/&Delta;t</code>. 
</p>
<p>
<h4>Step 3: calculate temperature slope moving average</h4>
After getting the temperature slope of each day, the moving average of the temperature slope <code>Ts_m</code> during the 
previous <code>n</code> days is calculated. 
</p>
<p>
<h4>Step 4: calculate optimal start time</h4>
The optimal start time is calculated using <code>&Delta;T</code> from Step 1 and the averaged temperature slope <code>Ts_m</code>
of the previous <code>n</code> days: <code>t_opt = &Delta;T/Ts_m</code>.
</p>
<p>
<h4>Initialization</h4>
During the initial day, the optimal start time is calculated based on the initial temperature slope of 
the zone <code>temSloIni</code>.
</p>
<p>
<h4>Multiple zones</h4>
When there are multiple zones in the system, use the maximum zone temperature for cooling system and minimum zone temperature for 
heating system.
</p>
<h4>Validation</h4>
<p>
A validation can be found at
<a href=\"modelica://Buildings.Controls.OBC.CDL.Utilities.Validation.OptimalStart\">
Buildings.Controls.OBC.CDL.Utilities.Validation.OptimalStart</a>.
</p>
</html>",
revisions="<html>
<ul>
<li>
September 29, 2019, by Kun Zhang:<br/>
First implementation.
</li>
</ul>
</html>"),
Diagram(coordinateSystem(extent={{-320,-140},{320,140}})));
end OptimalStart;
