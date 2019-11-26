within Buildings.Controls.OBC.Utilities;
block OptimalStart
  "Block that outputs the optimal start time for an HVAC system"
  extends Modelica.Blocks.Icons.Block;
  parameter Real occupancy[:] = 3600*{8, 18}
    "Occupancy table, each entry switching occupancy on or off";
  parameter Modelica.SIunits.Time tOptMax = 10800
    "Maximum optimal start time";
  parameter Modelica.SIunits.Time tOptIni = tOptMax/2
    "Initial optimal start time";
  parameter Integer n = 3 "Number of previous days for averaging the temperature slope";
  parameter Boolean heating_only = false
    "Set to true if the HVAC system is heating only"  annotation(Dialog(enable=not cooling_only));
  parameter Boolean cooling_only = false
    "Set to true if the HVAC system is cooling only"  annotation(Dialog(enable=not heating_only));
  parameter Modelica.SIunits.TemperatureDifference uLow = 0
    "Temperature change hysteresis low parameter, should be a non-negative number";
  parameter Modelica.SIunits.TemperatureDifference uHigh = 1
    "Temperature change hysteresis high parameter, should be greater than uLow";
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSetZonHea(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    displayUnit="degC",
    min=200) if not cooling_only
    "Zone heating setpoint temperature during occupancy" annotation (Placement(
        transformation(extent={{-220,60},{-180,100}}), iconTransformation(
          extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TZon(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    displayUnit="degC",
    min=200) "Zone temperature" annotation (Placement(transformation(extent={{-220,
            -20},{-180,20}}), iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSetZonCoo(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    displayUnit="degC",
    min=200) if not heating_only
    "Zone cooling setpoint temperature during occupancy" annotation (Placement(
        transformation(extent={{-220,-100},{-180,-60}}), iconTransformation(
          extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Continuous.Add dTHea(k1=+1, k2=-1) if not cooling_only
    "Temperature difference between heating setpoint and zone temperature"
    annotation (Placement(transformation(extent={{-120,70},{-100,90}})));
  Buildings.Controls.OBC.CDL.Continuous.Add dTCoo(k1=+1, k2=-1) if not heating_only
    "Temperature difference between zone temperature and cooling setpoint"
    annotation (Placement(transformation(extent={{-120,-90},{-100,-70}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.ModelTime modTim
    annotation (Placement(transformation(extent={{-140,20},{-120,40}})));
  Buildings.Controls.OBC.CDL.Continuous.Modulo mod
    annotation (Placement(transformation(extent={{-100,-10},{-80,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant period(k=86400)
    "Period of optimal start calculation algorithm"
    annotation (Placement(transformation(extent={{-140,-40},{-120,-20}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant staCal(k=occupancy[1] - tOptMax)
    "Start calculation"
    annotation (Placement(transformation(extent={{-100,-50},{-80,-30}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterEqual greEqu
    annotation (Placement(transformation(extent={{-40,-30},{-20,-10}})));
  Buildings.Controls.OBC.CDL.Continuous.LessEqual lesEqu
    annotation (Placement(transformation(extent={{-40,10},{-20,30}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant stoCal(k=occupancy[1]) "Stop calculation"
    annotation (Placement(transformation(extent={{-100,30},{-80,50}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput tOpt "Optimal start time of HVAC system"
    annotation (Placement(transformation(extent={{180,-20},{220,20}}),
        iconTransformation(extent={{100,-20},{140,20}})));
  BaseClasses.OptimalStartCalculation optHea(
    final occupancy=occupancy,
    final tOptIni=tOptIni,
    final n=n,
    final uLow=uLow,
    final uHigh=uHigh) if not cooling_only
    annotation (Placement(transformation(extent={{20,64},{40,84}})));
  BaseClasses.OptimalStartCalculation optCoo(
    final occupancy=occupancy,
    final tOptIni=tOptIni,
    final n=n,
    final uLow=uLow,
    final uHigh=uHigh) if not heating_only
    annotation (Placement(transformation(extent={{20,-90},{40,-70}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant maxStaTim(k=tOptMax)
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Min minHea if not cooling_only
    annotation (Placement(transformation(extent={{100,58},{120,78}})));
  Buildings.Controls.OBC.CDL.Continuous.Min minCoo if not heating_only
    annotation (Placement(transformation(extent={{100,-84},{120,-64}})));
  Buildings.Controls.OBC.CDL.Continuous.Max max
    annotation (Placement(transformation(extent={{142,-10},{162,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con2(k=0) if cooling_only
    annotation (Placement(transformation(extent={{100,20},{120,40}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con1(k=0) if heating_only
    annotation (Placement(transformation(extent={{100,-40},{120,-20}})));
equation
  connect(mod.y, greEqu.u1) annotation (Line(points={{-78,0},{-60,0},{-60,-20},{
          -42,-20}},     color={0,0,127}));
  connect(staCal.y, greEqu.u2) annotation (Line(points={{-78,-40},{-60,-40},{-60,
          -28},{-42,-28}},        color={0,0,127}));
  connect(period.y, mod.u2) annotation (Line(points={{-118,-30},{-114,-30},{-114,
          -6},{-102,-6}},
                      color={0,0,127}));
  connect(modTim.y, mod.u1) annotation (Line(points={{-118,30},{-114,30},{-114,6},
          {-102,6}},        color={0,0,127}));
  connect(mod.y, lesEqu.u2) annotation (Line(points={{-78,0},{-60,0},{-60,12},{-42,
          12}},             color={0,0,127}));
  connect(stoCal.y, lesEqu.u1) annotation (Line(points={{-78,40},{-60,40},{-60,20},
          {-42,20}},    color={0,0,127}));
  connect(lesEqu.y, optHea.StoCal) annotation (Line(points={{-18,20},{8,20},{8,67.2},
          {18,67.2}}, color={255,0,255}));
  connect(lesEqu.y, optCoo.StoCal) annotation (Line(points={{-18,20},{8,20},{8,-86.8},
          {18,-86.8}}, color={255,0,255}));
  connect(greEqu.y, optHea.StaCal) annotation (Line(points={{-18,-20},{0,-20},{0,
          74},{18,74}}, color={255,0,255}));
  connect(greEqu.y, optCoo.StaCal) annotation (Line(points={{-18,-20},{0,-20},{0,
          -80},{18,-80}}, color={255,0,255}));
  connect(maxStaTim.y, minHea.u2) annotation (Line(points={{62,0},{80,0},{80,62},
          {98,62}},      color={0,0,127}));
  connect(maxStaTim.y, minCoo.u1) annotation (Line(points={{62,0},{80,0},{80,-68},
          {98,-68}},     color={0,0,127}));
  connect(minHea.y, max.u1) annotation (Line(points={{122,68},{128,68},{128,6},{
          140,6}},   color={0,0,127}));
  connect(minCoo.y, max.u2) annotation (Line(points={{122,-74},{128,-74},{128,-6},
          {140,-6}}, color={0,0,127}));
  connect(TSetZonCoo, dTCoo.u2) annotation (Line(points={{-200,-80},{-160,-80},{
          -160,-86},{-122,-86}},
                               color={0,0,127}));
  connect(TZon, dTCoo.u1) annotation (Line(points={{-200,0},{-160,0},{-160,-74},
          {-122,-74}},
                     color={0,0,127}));
  connect(TZon, dTHea.u2) annotation (Line(points={{-200,0},{-160,0},{-160,74},{
          -122,74}}, color={0,0,127}));
  connect(TSetZonHea, dTHea.u1) annotation (Line(points={{-200,80},{-160,80},{-160,
          86},{-122,86}}, color={0,0,127}));
  connect(max.y, tOpt) annotation (Line(points={{164,0},{200,0}},
                color={0,0,127}));
  connect(con2.y, max.u1) annotation (Line(points={{122,30},{128,30},{128,6},{140,
          6}},       color={0,0,127}));
  connect(con1.y, max.u2) annotation (Line(points={{122,-30},{128,-30},{128,-6},
          {140,-6}},
                color={0,0,127}));
  connect(optHea.tOpt, minHea.u1)
    annotation (Line(points={{42,74},{98,74}}, color={0,0,127}));
  connect(optCoo.tOpt, minCoo.u2)
    annotation (Line(points={{42,-80},{98,-80}}, color={0,0,127}));
  connect(dTCoo.y, optCoo.TDif) annotation (Line(points={{-98,-80},{-40,-80},{-40,
          -74},{18,-74}}, color={0,0,127}));
  connect(dTHea.y, optHea.TDif)
    annotation (Line(points={{-98,80},{18,80}}, color={0,0,127}));
   annotation (
defaultComponentName="optSta",
  Documentation(info="<html>
<p>
This block outputs the optimal start time each day for an HVAC system prior to the occupied time. 
The calculation is based on the concept of temperature slope, indicating the 
temperature change rate of a zone, with the unit <code>K/s</code>. The algorithm is described briefly 
in the steps blow.
</p>
<p>
<h4>Step 1: get sampled temperature difference <code>&Delta;T</code></h4>
Each day at a certain time before the occupancy, the algorithm takes a sample of the zone 
temperature. The sampling time is defined as occupancy start
time <code> - tOptMax</code>, where <code>tOptMax</code> denotes the maximum
optimal start time.
<p>
After getting the zone temperature at the sampling time, the difference <code>&Delta;T</code> between this zone 
temperature and the occupied zone setpoint is calculated.
</p>
</p>
<p>
<h4>Step 2: calculate temeperature slope <code>Ts</code></h4>
After the HVAC system is started, a timer is used to record how much time <code>&Delta;t</code> the zone temperature 
reaches the setpoint. When the time becomes greater than the maximum start time, the maximum start time is used.
The temperature slope is thus approximated using the equation: <code>Ts=&Delta;T/&Delta;t</code>. 
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
During the initial day, the initial optimal start time parameter <code>tOptIni</code> is used.
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
Diagram(coordinateSystem(extent={{-180,-120},{180,120}})));
end OptimalStart;
