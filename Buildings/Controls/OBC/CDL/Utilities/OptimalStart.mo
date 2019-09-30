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
  parameter Integer n = 3 "Number of days for averaging the temperature slopes";
  Interfaces.RealInput TSetZonHea(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    displayUnit="degC",
    min=200) "Zone heating setpoint temperature during occupancy" annotation (
      Placement(transformation(extent={{-320,60},{-280,100}}),
        iconTransformation(extent={{-140,60},{-100,100}})));
  Interfaces.RealInput TZon(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    displayUnit="degC",
    min=200) "Zone temperature" annotation (Placement(transformation(extent={{
            -318,-20},{-278,20}}), iconTransformation(extent={{-140,-20},{-100,
            20}})));
  Continuous.Sources.ModelTime modTim
    annotation (Placement(transformation(extent={{-240,-70},{-220,-50}})));
  Continuous.Modulo mod
    annotation (Placement(transformation(extent={{-200,-90},{-180,-70}})));
  Continuous.Sources.Constant period(k=86400)
    "Period of optimal start calculation algorithm"
    annotation (Placement(transformation(extent={{-240,-110},{-220,-90}})));
  Continuous.Sources.Constant staCal(k=occupancy[1] - maxOptTim)
    "Start calculation"
    annotation (Placement(transformation(extent={{-200,-130},{-180,-110}})));
  Continuous.GreaterEqual greEqu
    annotation (Placement(transformation(extent={{-148,-100},{-128,-80}})));
  Continuous.Hysteresis hys(uLow=-0.5*deadband, uHigh=0.5*deadband)
    "Comparing zone temperature with zone setpoint"
    annotation (Placement(transformation(extent={{-160,90},{-140,110}})));
  Continuous.Add add(k1=+1, k2=-1)
    annotation (Placement(transformation(extent={{-260,64},{-240,84}})));
  Logical.Latch lat
    "Stop calculation when the zone temperature reaches setpoint"
    annotation (Placement(transformation(extent={{-74,96},{-54,116}})));
  Logical.Timer timHea(reset=true)
    annotation (Placement(transformation(extent={{46,80},{66,100}})));
  Interfaces.RealOutput tOpt(
    final quantity="Time",
    final unit="s",
    displayUnit="h") "Optimal start time of HVAC system"
    annotation (Placement(transformation(extent={{280,-10},{300,10}}),
                    iconTransformation(extent={{100,-10},{120,10}})));
  Discrete.TriggeredSampler triSam(y_start=minOptTim)
    annotation (Placement(transformation(extent={{86,80},{106,100}})));
  Logical.FallingEdge falEdg
    "Get the timing when the zone temperature reaches setpoint"
    annotation (Placement(transformation(extent={{26,50},{46,70}})));
  Logical.TrueHoldWithReset truHol(duration(displayUnit="h") = occupancy[2] -
      occupancy[1])
    annotation (Placement(transformation(extent={{6,80},{26,100}})));
  Continuous.LessEqual lesEqu
    annotation (Placement(transformation(extent={{-160,-8},{-140,12}})));
  Continuous.Sources.Constant stoCal(k=occupancy[1]) "Stop calculation"
    annotation (Placement(transformation(extent={{-200,0},{-180,20}})));
  Logical.Latch latHea "Stop calculation when it reaches the max start time"
    annotation (Placement(transformation(extent={{-34,80},{-14,100}})));
  Discrete.TriggeredSampler triSam1
    annotation (Placement(transformation(extent={{200,-60},{220,-40}})));
  Continuous.Sources.Constant maxStaTim(k=maxOptTim)
    annotation (Placement(transformation(extent={{200,10},{220,30}})));
  Continuous.Min min
    annotation (Placement(transformation(extent={{252,-10},{272,10}})));
  Discrete.MovingMean movMea(n=n, samplePeriod=86400)
    annotation (Placement(transformation(extent={{200,80},{220,100}})));
  Interfaces.BooleanOutput Startup "The duration of optimal startup"
    annotation (Placement(transformation(extent={{280,-130},{300,-110}}),
        iconTransformation(extent={{100,-50},{120,-30}})));
  Logical.Not not1
    annotation (Placement(transformation(extent={{-120,90},{-100,110}})));
  Continuous.Division temSlo "Calculate temperature slope "
    annotation (Placement(transformation(extent={{126,80},{146,100}})));
  Continuous.Division tOptCal
    "Calculate optimal start time based on the averaged previous temperature slope"
    annotation (Placement(transformation(extent={{238,80},{258,100}})));
  Discrete.TriggeredSampler triSam2(y_start=temSloIni)
    annotation (Placement(transformation(extent={{162,80},{182,100}})));
  Interfaces.RealInput TSetZonCool(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    displayUnit="degC",
    min=200) "Zone cooling setpoint temperature during occupancy" annotation (
      Placement(transformation(extent={{-320,-100},{-280,-60}}),
        iconTransformation(extent={{-140,-100},{-100,-60}})));
  Continuous.Add add1(k1=+1, k2=-1)
    annotation (Placement(transformation(extent={{-260,18},{-240,38}})));
  Continuous.MultiMax multiMax(nin=2)
    annotation (Placement(transformation(extent={{-220,50},{-200,70}})));
  Continuous.Max max
    annotation (Placement(transformation(extent={{-184,110},{-164,130}})));
  Continuous.Sources.Constant dT(k=0) "Temperature difference"
    annotation (Placement(transformation(extent={{-240,110},{-220,130}})));
equation
  connect(mod.y, greEqu.u1) annotation (Line(points={{-178,-80},{-158,-80},{
          -158,-90},{-150,-90}},
                         color={0,0,127}));
  connect(staCal.y, greEqu.u2) annotation (Line(points={{-178,-120},{-156,-120},
          {-156,-98},{-150,-98}}, color={0,0,127}));
  connect(period.y, mod.u2) annotation (Line(points={{-218,-100},{-214,-100},{
          -214,-86},{-202,-86}},
                      color={0,0,127}));
  connect(modTim.y, mod.u1) annotation (Line(points={{-218,-60},{-214,-60},{
          -214,-74},{-202,-74}},
                            color={0,0,127}));
  connect(TSetZonHea, add.u1)
    annotation (Line(points={{-300,80},{-262,80}}, color={0,0,127}));
  connect(timHea.y, triSam.u)
    annotation (Line(points={{68,90},{84,90}},   color={0,0,127}));
  connect(falEdg.y, triSam.trigger)
    annotation (Line(points={{48,60},{96,60},{96,78.2}},   color={255,0,255}));
  connect(timHea.u, truHol.y)
    annotation (Line(points={{44,90},{28,90}},    color={255,0,255}));
  connect(lesEqu.y, latHea.clr) annotation (Line(points={{-138,2},{-36,2},{-36,
          84}},            color={255,0,255}));
  connect(lat.y, latHea.u) annotation (Line(points={{-52,106},{-50,106},{-50,90},
          {-36,90}},  color={255,0,255}));
  connect(stoCal.y, lesEqu.u1) annotation (Line(points={{-178,10},{-162,10},{
          -162,2}},         color={0,0,127}));
  connect(latHea.y, truHol.u)
    annotation (Line(points={{-12,90},{4,90}},     color={255,0,255}));
  connect(latHea.y, falEdg.u) annotation (Line(points={{-12,90},{-4,90},{-4,60},
          {24,60}},        color={255,0,255}));
  connect(greEqu.y, triSam1.trigger) annotation (Line(points={{-126,-90},{210,
          -90},{210,-61.8}},                        color={255,0,255}));
  connect(maxStaTim.y, min.u1) annotation (Line(points={{222,20},{240,20},{240,
          6},{250,6}},         color={0,0,127}));
  connect(min.y, tOpt) annotation (Line(points={{274,0},{290,0}},
                   color={0,0,127}));
  connect(hys.y, not1.u)
    annotation (Line(points={{-138,100},{-122,100}}, color={255,0,255}));
  connect(not1.y, lat.clr) annotation (Line(points={{-98,100},{-76,100}},
                      color={255,0,255}));
  connect(latHea.y, Startup) annotation (Line(points={{-12,90},{-4,90},{-4,-120},
          {290,-120}}, color={255,0,255}));
  connect(movMea.y,tOptCal. u2) annotation (Line(points={{222,90},{228,90},{228,
          84},{236,84}},   color={0,0,127}));
  connect(tOptCal.y, triSam1.u) annotation (Line(points={{260,90},{268,90},{268,
          40},{180,40},{180,-50},{198,-50}},
                                         color={0,0,127}));
  connect(temSlo.y,triSam2. u)
    annotation (Line(points={{148,90},{160,90}},
                                               color={0,0,127}));
  connect(mod.y, lesEqu.u2) annotation (Line(points={{-178,-80},{-170,-80},{
          -170,-6},{-162,-6}},
                            color={0,0,127}));
  connect(triSam.y, temSlo.u2) annotation (Line(points={{108,90},{114,90},{114,
          84},{124,84}},
                    color={0,0,127}));
  connect(triSam2.y, movMea.u)
    annotation (Line(points={{184,90},{198,90}}, color={0,0,127}));
  connect(add.y, multiMax.u[1]) annotation (Line(points={{-238,74},{-230,74},{
          -230,61},{-222,61}}, color={0,0,127}));
  connect(add1.y, multiMax.u[2]) annotation (Line(points={{-238,28},{-230,28},{
          -230,59},{-222,59}}, color={0,0,127}));
  connect(multiMax.y, hys.u) annotation (Line(points={{-198,60},{-192,60},{-192,
          100},{-162,100}}, color={0,0,127}));
  connect(greEqu.y, lat.u) annotation (Line(points={{-126,-90},{-84,-90},{-84,
          106},{-76,106}}, color={255,0,255}));
  connect(triSam2.trigger, triSam1.trigger) annotation (Line(points={{172,78.2},
          {172,-90},{210,-90},{210,-61.8}}, color={255,0,255}));
  connect(tOptCal.u1, temSlo.u1) annotation (Line(points={{236,96},{228,96},{
          228,130},{118,130},{118,96},{124,96}}, color={0,0,127}));
  connect(triSam1.y, min.u2) annotation (Line(points={{222,-50},{240,-50},{240,
          -6},{250,-6}}, color={0,0,127}));
  connect(TSetZonCool, add1.u2) annotation (Line(points={{-300,-80},{-270,-80},
          {-270,22},{-262,22}}, color={0,0,127}));
  connect(TZon, add1.u1) annotation (Line(points={{-298,0},{-274,0},{-274,34},{
          -262,34}}, color={0,0,127}));
  connect(TZon, add.u2) annotation (Line(points={{-298,0},{-274,0},{-274,68},{
          -262,68}}, color={0,0,127}));
  connect(multiMax.y, max.u2) annotation (Line(points={{-198,60},{-192,60},{
          -192,114},{-186,114}}, color={0,0,127}));
  connect(dT.y, max.u1) annotation (Line(points={{-218,120},{-200,120},{-200,
          126},{-186,126}}, color={0,0,127}));
  connect(max.y, temSlo.u1) annotation (Line(points={{-162,120},{-140,120},{
          -140,130},{118,130},{118,96},{124,96}}, color={0,0,127}));
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
temperature. The sampling time is defined as <code>occupancy start
time - maxOptTim</code>, which is the occupancy start time minus the maximum
optimal start time <code>maxOptTim</code>.
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
Diagram(coordinateSystem(extent={{-280,-140},{280,140}}), graphics={Text(
          extent={{2,16},{166,-2}},
          lineColor={28,108,200},
          fontSize=8,
          fontName="sans-serif",
          textString=
              "Make add blocks optional for cases of only heating or cooling")}));
end OptimalStart;
