within Buildings.Controls.OBC.Utilities;
block OptimalStart
  "Block that outputs optimal start time for an HVAC system before occupancy"
  extends Modelica.Blocks.Icons.Block;
  parameter Modelica.SIunits.Time tOptMax=10800
    "Maximum optimal start time";
  parameter Integer n = 3 "Number of previous days for averaging the temperature slope";
  parameter Boolean heating_only = false
    "Set to true if the HVAC system is heating only"  annotation(Dialog(enable=not cooling_only));
  parameter Boolean cooling_only = false
    "Set to true if the HVAC system is cooling only"  annotation(Dialog(enable=not heating_only));
  parameter Modelica.SIunits.TemperatureDifference uLow = 0
    "Temperature change hysteresis low parameter, should be a non-negative number";
  parameter Modelica.SIunits.TemperatureDifference uHigh = 0.5
    "Temperature change hysteresis high parameter, should be greater than uLow";

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSetZonHea(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    displayUnit="degC",
    min=200) if not cooling_only
    "Zone heating setpoint temperature during occupancy" annotation (Placement(
        transformation(extent={{-180,60},{-140,100}}), iconTransformation(
          extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TZon(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    displayUnit="degC",
    min=200) "Zone temperature" annotation (Placement(transformation(extent={{-180,
            -50},{-140,-10}}),iconTransformation(extent={{-140,-50},{-100,-10}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSetZonCoo(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    displayUnit="degC",
    min=200) if not heating_only
    "Zone cooling setpoint temperature during occupancy" annotation (Placement(
        transformation(extent={{-180,10},{-140,50}}),    iconTransformation(
          extent={{-140,10},{-100,50}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput tNexOcc(
    final quantity="Time",
    final unit="s",
    displayUnit="h")
    "Time until next occupancy" annotation (
      Placement(transformation(extent={{-180,-100},{-140,-60}}),
        iconTransformation(extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput tOpt(
    final quantity="Time",
    final unit="s",
    displayUnit="h")
    "Optimal start time of HVAC system"  annotation (Placement(transformation(extent={{140,20},{180,60}}),
        iconTransformation(extent={{100,20},{140,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput start
    "Optimal start boolean output" annotation (
     Placement(transformation(extent={{140,-60},{180,-20}}), iconTransformation(
          extent={{100,-60},{140,-20}})));

  Buildings.Controls.OBC.CDL.Continuous.Add dTHea(k1=+1, k2=-1) if not cooling_only
    "Temperature difference between heating setpoint and zone temperature"
    annotation (Placement(transformation(extent={{-80,70},{-60,90}})));
  Buildings.Controls.OBC.CDL.Continuous.Add dTCoo(k1=+1, k2=-1) if not heating_only
    "Temperature difference between zone temperature and cooling setpoint"
    annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));
  Buildings.Controls.OBC.Utilities.BaseClasses.OptimalStartCalculation optHea(
    final tOptMax=tOptMax,
    final tOptIni=tOptIni,
    final n=n,
    final uLow=uLow,
    final uHigh=uHigh) if not cooling_only
    "Optimal start time for heating system"
    annotation (Placement(transformation(extent={{20,60},{40,80}})));
  Buildings.Controls.OBC.Utilities.BaseClasses.OptimalStartCalculation optCoo(
    final tOptMax=tOptMax,
    final tOptIni=tOptIni,
    final n=n,
    final uLow=uLow,
    final uHigh=uHigh) if not heating_only
    "Optimal start time for cooling system"
    annotation (Placement(transformation(extent={{20,-80},{40,-60}})));
  Buildings.Controls.OBC.CDL.Continuous.Max max
    "Get the maximum optimal start time "
    annotation (Placement(transformation(extent={{100,24},{120,44}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con2(k=0) if cooling_only
    "Becomes effective when optimal start is only for heating"
    annotation (Placement(transformation(extent={{60,40},{80,60}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con1(k=0) if heating_only
    "Becomes effective when optimal start is only for cooling"
    annotation (Placement(transformation(extent={{60,6},{80,26}})));
  Buildings.Controls.OBC.CDL.Continuous.AddParameter addPar(p=-tOptMax,k=1)
    "Maximum optimal start time"
    annotation (Placement(transformation(extent={{-100,-10},{-80,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hysSta(
    pre_y_start=true,
    uHigh=0,
    uLow=-60) "Hysteresis to activate the optimal start"
    annotation (Placement(transformation(extent={{-70,-10},{-50,10}})));
  Buildings.Controls.OBC.CDL.Logical.Edge edg
    "Start calculation"
    annotation (Placement(transformation(extent={{-30,20},{-10,40}})));
  Buildings.Controls.OBC.CDL.Logical.FallingEdge falEdg
    "Stop calculation"
    annotation (Placement(transformation(extent={{-30,-40},{-10,-20}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con(k=false) if cooling_only
    "Becomes effective when optimal start is only for heating"
    annotation (Placement(transformation(extent={{60,-30},{80,-10}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con3(k=false) if heating_only
    "Becomes effective when optimal start is only for cooling"
    annotation (Placement(transformation(extent={{60,-94},{80,-74}})));
  Buildings.Controls.OBC.CDL.Logical.Or or2
    "Get the optimal start boolean output"
    annotation (Placement(transformation(extent={{100,-50},{120,-30}})));
protected
    parameter Modelica.SIunits.Time tOptIni = tOptMax/2
    "Initial optimal start time";
equation
  connect(TSetZonCoo, dTCoo.u2) annotation (Line(points={{-160,30},{-132,30},{-132,
          -56},{-82,-56}},     color={0,0,127}));
  connect(TZon, dTCoo.u1) annotation (Line(points={{-160,-30},{-126,-30},{-126,-44},
          {-82,-44}},color={0,0,127}));
  connect(TZon, dTHea.u2) annotation (Line(points={{-160,-30},{-126,-30},{-126,74},
          {-82,74}}, color={0,0,127}));
  connect(TSetZonHea, dTHea.u1) annotation (Line(points={{-160,80},{-126,80},{-126,
          86},{-82,86}},  color={0,0,127}));
  connect(max.y, tOpt) annotation (Line(points={{122,34},{128,34},{128,40},{160,
          40}}, color={0,0,127}));
  connect(con2.y, max.u1) annotation (Line(points={{82,50},{88,50},{88,40},{98,40}},
                     color={0,0,127}));
  connect(con1.y, max.u2) annotation (Line(points={{82,16},{88,16},{88,28},{98,28}},
                color={0,0,127}));
  connect(dTCoo.y, optCoo.TDif) annotation (Line(points={{-58,-50},{-22,-50},{-22,
          -62},{18,-62}}, color={0,0,127}));
  connect(dTHea.y, optHea.TDif)   annotation (Line(points={{-58,80},{-8,80},{-8,78},{18,78}},
                                                color={0,0,127}));
  connect(tNexOcc, addPar.u) annotation (Line(points={{-160,-80},{-120,-80},{-120,
          0},{-102,0}},     color={0,0,127}));
  connect(addPar.y, hysSta.u)   annotation (Line(points={{-78,0},{-72,0}}, color={0,0,127}));
  connect(hysSta.y, falEdg.u) annotation (Line(points={{-48,0},{-40,0},{-40,-30},
          {-32,-30}}, color={255,0,255}));
  connect(hysSta.y, edg.u) annotation (Line(points={{-48,0},{-40,0},{-40,30},{-32,
          30}}, color={255,0,255}));
  connect(tNexOcc, optHea.tNexOcc) annotation (Line(points={{-160,-80},{-120,-80},
          {-120,62},{18,62}}, color={0,0,127}));
  connect(optCoo.tOpt, max.u2) annotation (Line(points={{42,-66},{88,-66},{88,28},
          {98,28}},      color={0,0,127}));
  connect(optHea.tOpt, max.u1) annotation (Line(points={{42,74},{88,74},{88,40},
          {98,40}}, color={0,0,127}));
  connect(tNexOcc, optCoo.tNexOcc) annotation (Line(points={{-160,-80},{-68,-80},
          {-68,-78},{18,-78}}, color={0,0,127}));
  connect(falEdg.y, optHea.StaCal) annotation (Line(points={{-8,-30},{0,-30},{0,
          73},{18,73}}, color={255,0,255}));
  connect(start, start)   annotation (Line(points={{160,-40},{160,-40}}, color={255,0,255}));
  connect(falEdg.y, optCoo.StaCal) annotation (Line(points={{-8,-30},{0,-30},{0,
          -67},{18,-67}}, color={255,0,255}));
  connect(edg.y, optHea.StoCal) annotation (Line(points={{-8,30},{8,30},{8,67},{
          18,67}}, color={255,0,255}));
  connect(edg.y, optCoo.StoCal) annotation (Line(points={{-8,30},{8,30},{8,-73},
          {18,-73}}, color={255,0,255}));
  connect(or2.y, start)   annotation (Line(points={{122,-40},{160,-40}}, color={255,0,255}));
  connect(con.y, or2.u1) annotation (Line(points={{82,-20},{92,-20},{92,-40},{98,
          -40}}, color={255,0,255}));
  connect(con3.y, or2.u2) annotation (Line(points={{82,-84},{92,-84},{92,-48},{98,
          -48}}, color={255,0,255}));
  connect(optCoo.start, or2.u2) annotation (Line(points={{42,-74},{50,-74},{50,-48},
          {98,-48}}, color={255,0,255}));
  connect(optHea.start, or2.u1) annotation (Line(points={{42,66},{92,66},{92,-40},
          {98,-40}}, color={255,0,255}));
   annotation (
defaultComponentName="optSta",
  Documentation(info="<html>
<p>
This block outputs the optimal start time for an HVAC system prior
to the occupied time. The algorithm is based on the concept of
temperature slope (also known as temperature gradient). This variable
indicates the temperature change rate of a homogeneous thermal zone,
with the unit <code>K/s</code>. The algorithm is briefly described as below.
</p>
<p>
<h4>Step 1: calculate temeperature slope <code>TSlo</code></h4>
</p>
<p>
Once the HVAC system is started, a timer records the time duration
(<code>&Delta;t</code>) for the zone temperature to reach the
setpoint. At the time when the timer starts, the zone temperature is sampled,
denoted as <code>TSam1</code>. The temperature slope is thus
approximated using the equation: <code>TSlo = |TSetZonOcc-TSam1|/&Delta;t</code>,
where <code>TSetZonOcc</code> is the occupied zone setpoint. Note that if <code>
&Delta;t</code> is greater than the maximum optimal start time <code>tOptMax</code>,
<code>tOptMax</code> is used in the equation instead of <code>&Delta;t</code>.
This is to avoid corner cases where the setpoint is never reached, e.g., the HVAC
system is undersized, or there is a steady-state error associated with PID controls.
</p>
<p>
<h4>Step 2: calculate temperature slope moving average <code>TSloMa</code></h4>
</p>
<p>
After computing the temperature slope of each day, the moving average of the
temperature slope <code>TSloMa</code> during the previous <code>n</code> days
is calculated. Please refer to
<a href=\"modelica://Buildings.Controls.OBC.CDL.Discrete.TriggeredMovingMean\">
Buildings.Controls.OBC.CDL.Discrete.TriggeredMovingMean</a> for details about
the moving average algorithm.
</p>
<p>
<h4>Step 3: calculate optimal start time <code>tOpt</code></h4>
</p>
<p>
Each day at a certain time before the occupancy, the algorithm takes another
sample of the zone temperature, denoted as <code>TSam2</code>. The sampling time
is defined as occupancy start time - <code>tOptMax</code>.
</p>
<p>
The optimal start time is then calculated as <code>tOpt = |TSetZonOcc-TSam2|/TSloMa</code>.
</p>
<p>
<h4>Initialization</h4>
</p>
<p>
The algorithm needs to compute the moving average of temperature slope from the
previous <code>n</code> days, the first <code>n</code> days of simulation is therefore
initialization period of the block.
</p>
<p>
<h4>Hysteresis</h4>
</p>
<p>
The block includes two hysteresis parameters <code>uLow</code> and <code>uHigh</code>.
</p>
<p>
<code>uLow</code> is used by the algorithm to determine if the zone temperature reaches
the setpoint. The algorithm sees the zone temperature has reached the setpoint if
<code>TSetZonHea-TZon &le; uLow</code> for heating system;
<code>TZon-TSetZonCoo &le; uLow</code> for cooling system. <code>TSetZonHea</code>
denotes the zone heating setpoint during occupancy and <code>TSetZonCoo</code>
denotes the zone cooling setpoint during occupancy.
</p>
<p>
<code>uHigh</code> is used by the algorithm to determine if there is a need to
start the HVAC system before the occupancy. If
<code>TSetZonHea-TSam2 &le; uHigh</code> for heating case or
<code>TSam2-TSetZonCoo &le; uHigh</code> for cooling case,
then there is no need for the system to start before the occupancy.
</p>
<p>
<h4>Configuration for HVAC system</h4>
</p>
<p>
The block calculates optimal start time separately for heating and cooling system.
The base class <a href=\"modelica://Buildings.Controls.OBC.Utilities.BaseClasses.OptimalStartCalculation\">
Buildings.Controls.OBC.Utilities.BaseClasses.OptimalStartCalculation</a> is used
for the calculation.
</p>
<p>
The block can be used for heating system only or cooling system only or heat pumps.
The two parameters <code>heating_only</code> and <code>cooling_only</code> can be
used to configure the block for these three types of systems.
</p>
<p>
<h4>Cases of multiple zones</h4>
</p>
<p>When one HVAC system serves multiple zones, the maximum zone temperature of
those zones should be used for cooling system and minimum zone temperature should
be used for heating system for the input <code>TZon</code>.
</p>
<p>
<h4>Validation</h4>
</p>
<p>
A validation can be found at
<a href=\"modelica://Buildings.Controls.OBC.Utilities.Validation.OptimalStart\">
Buildings.Controls.OBC.Utilities.Validation.OptimalStart</a>.
</p>
</html>",
revisions="<html>
<ul>
<li>
December 15, 2019, by Kun Zhang:<br/>
First implementation.
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1589\">issue #1589</a>.
</li>
</ul>
</html>"),
Diagram(coordinateSystem(extent={{-140,-100},{140,100}})));
end OptimalStart;
