within Buildings.Controls.OBC.Utilities.BaseClasses;
block OptimalStartCalculation
  "Block that outputs the optimal start time for an HVAC system"
  extends Modelica.Blocks.Icons.Block;
  parameter Real occupancy[:]
    "Occupancy table, each entry switching occupancy on or off";
  parameter Modelica.SIunits.Time tOptIni
    "Initial optimal start time";
  parameter Integer n "Number of previous days for averaging the temperature slope";
  parameter Modelica.SIunits.TemperatureDifference uLow
    "Temperature change hysteresis low parameter, should be a non-negative number";
  parameter Modelica.SIunits.TemperatureDifference uHigh
    "Temperature change hysteresis high parameter, should be greater than uLow";
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys(uLow=uLow, uHigh=uHigh)
    "Comparing zone temperature with zone setpoint"
    annotation (Placement(transformation(extent={{-260,10},{-240,30}})));
  Buildings.Controls.OBC.CDL.Logical.Latch lat
    "Stop calculation when the zone temperature reaches setpoint"
    annotation (Placement(transformation(extent={{-190,10},{-170,30}})));
  Buildings.Controls.OBC.CDL.Logical.Timer tim(reset=true)
    "Record how much time the zone temperature reaches the setpoint"
    annotation (Placement(transformation(extent={{-72,20},{-52,40}})));
  Buildings.Controls.OBC.CDL.Discrete.TriggeredSampler triSam(y_start=tOptIni)
    "Record how much time it takes to reach the setpoint with the maximum time cutoff"
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));
  Buildings.Controls.OBC.CDL.Logical.FallingEdge falEdg
    "Get the timing when the zone temperature reaches setpoint"
    annotation (Placement(transformation(extent={{-80,-30},{-60,-10}})));
  Buildings.Controls.OBC.CDL.Logical.TrueHoldWithReset truHol(duration(displayUnit="h") = occupancy[2] -
      occupancy[1])
    annotation (Placement(transformation(extent={{-106,20},{-86,40}})));
  Buildings.Controls.OBC.CDL.Logical.Latch latMax
    "Stop calculation when it reaches the max start time"
    annotation (Placement(transformation(extent={{-146,20},{-126,40}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1 "Becomes true when the setpoint is reached"
    annotation (Placement(transformation(extent={{-226,10},{-206,30}})));
  Buildings.Controls.OBC.CDL.Continuous.Division temSlo "Calculate temperature slope "
    annotation (Placement(transformation(extent={{80,20},{100,40}})));
  Buildings.Controls.OBC.CDL.Continuous.Division tOptCal
    "Calculate optimal start time based on the averaged previous temperature slope"
    annotation (Placement(transformation(extent={{240,20},{260,40}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zeroOpt(k=0)
    "Avoid zero division cases when the optimal start time is 0"
    annotation (Placement(transformation(extent={{-40,-50},{-20,-30}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi
    annotation (Placement(transformation(extent={{40,20},{60,40}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant defOptTim(k=tOptIni)
    "Default optimal start time in case of zero division"
    annotation (Placement(transformation(extent={{0,-50},{20,-30}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zeroTemSlo(k=0)
    "Avoid zero divison when the temperature slope is 0"
    annotation (Placement(transformation(extent={{120,-50},{140,-30}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi1
    annotation (Placement(transformation(extent={{200,20},{220,40}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant defTemSlo(k=temSloDef)
    "Default temperature slope in case of zero division"
    annotation (Placement(transformation(extent={{160,-50},{180,-30}})));
  Buildings.Controls.OBC.CDL.Logical.And and2 "Duration that it takes to reach the setpoint"
    annotation (Placement(transformation(extent={{-116,-30},{-96,-10}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput tOpt "Optimal start time of HVAC system"
    annotation (Placement(transformation(extent={{320,-20},{360,20}}),
        iconTransformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Continuous.Greater gre
    annotation (Placement(transformation(extent={{0,20},{20,40}})));
  Buildings.Controls.OBC.CDL.Continuous.Greater gre1
    annotation (Placement(transformation(extent={{160,20},{180,40}})));
  Buildings.Controls.OBC.CDL.Discrete.TriggeredMovingMean triMovMea(n=n)
    annotation (Placement(transformation(extent={{120,20},{140,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TDif(
    final quantity="TemperatureDifference",
    final unit="K")
    "Zone heating setpoint temperature during occupancy" annotation (Placement(
        transformation(extent={{-320,60},{-280,100}}), iconTransformation(
          extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput StaCal annotation (Placement(transformation(
          extent={{-320,-20},{-280,20}}), iconTransformation(extent={{-140,-20},
            {-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput StoCal annotation (Placement(transformation(
          extent={{-320,-100},{-280,-60}}), iconTransformation(extent={{-140,-88},
            {-100,-48}})));
  Buildings.Controls.OBC.CDL.Discrete.TriggeredSampler triSam1
    annotation (Placement(transformation(extent={{280,20},{300,40}})));
protected
    parameter Modelica.SIunits.TemperatureSlope temSloDef = 1/3600
    "Default temperature slope in case of zero division";
equation
  connect(tim.y, triSam.u)  annotation (Line(points={{-50,30},{-42,30}},
                                              color={0,0,127}));
  connect(falEdg.y, triSam.trigger) annotation (Line(points={{-58,-20},{-30,-20},
          {-30,18.2}},                                                                     color={255,0,255}));
  connect(tim.u, truHol.y)  annotation (Line(points={{-74,30},{-84,30}}, color={255,0,255}));
  connect(latMax.y, truHol.u) annotation (Line(points={{-124,30},{-108,30}}, color={255,0,255}));
  connect(hys.y, not1.u)  annotation (Line(points={{-238,20},{-228,20}},
                                                     color={255,0,255}));
  connect(not1.y, lat.clr) annotation (Line(points={{-204,20},{-198,20},{-198,14},
          {-192,14}}, color={255,0,255}));
  connect(swi1.y, tOptCal.u2) annotation (Line(points={{222,30},{230,30},{230,24},
          {238,24}}, color={0,0,127}));
  connect(swi.y, temSlo.u2) annotation (Line(points={{62,30},{68,30},{68,24},{78,
          24}}, color={0,0,127}));
  connect(and2.u1, truHol.u) annotation (Line(points={{-118,-20},{-120,-20},{-120,
          30},{-108,30}},
                     color={255,0,255}));
  connect(and2.y, falEdg.u)  annotation (Line(points={{-94,-20},{-82,-20}},
                                                                          color={255,0,255}));
  connect(lat.y, and2.u2) annotation (Line(points={{-168,20},{-160,20},{-160,-28},
          {-118,-28}},
                     color={255,0,255}));
  connect(lat.y, latMax.u) annotation (Line(points={{-168,20},{-160,20},{-160,30},
          {-148,30}},     color={255,0,255}));
  connect(temSlo.y, triMovMea.u)  annotation (Line(points={{102,30},{118,30}}, color={0,0,127}));
  connect(triSam.y, gre.u1)   annotation (Line(points={{-18,30},{-2,30}},color={0,0,127}));
  connect(zeroOpt.y, gre.u2) annotation (Line(points={{-18,-40},{-10,-40},{-10,22},
          {-2,22}},color={0,0,127}));
  connect(gre.y, swi.u2)  annotation (Line(points={{22,30},{38,30}}, color={255,0,255}));
  connect(triSam.y, swi.u1) annotation (Line(points={{-18,30},{-10,30},{-10,48},
          {30,48},{30,38},{38,38}}, color={0,0,127}));
  connect(defOptTim.y, swi.u3) annotation (Line(points={{22,-40},{30,-40},{30,22},
          {38,22}}, color={0,0,127}));
  connect(triMovMea.y, gre1.u1) annotation (Line(points={{142,30},{158,30}}, color={0,0,127}));
  connect(zeroTemSlo.y, gre1.u2) annotation (Line(points={{142,-40},{152,-40},{152,
          22},{158,22}},     color={0,0,127}));
  connect(gre1.y, swi1.u2)  annotation (Line(points={{182,30},{198,30}}, color={255,0,255}));
  connect(triMovMea.y, swi1.u1) annotation (Line(points={{142,30},{152,30},{152,
          50},{190,50},{190,38},{198,38}},   color={0,0,127}));
  connect(defTemSlo.y, swi1.u3) annotation (Line(points={{182,-40},{190,-40},{190,
          22},{198,22}}, color={0,0,127}));
  connect(TDif, temSlo.u1) annotation (Line(points={{-300,80},{70,80},{70,36},{78,
          36}},      color={0,0,127}));
  connect(StoCal, latMax.clr) annotation (Line(points={{-300,-80},{-152,-80},{-152,
          24},{-148,24}}, color={255,0,255}));
  connect(StaCal, lat.u) annotation (Line(points={{-300,0},{-196,0},{-196,20},{-192,
          20}}, color={255,0,255}));
  connect(tOptCal.u1, temSlo.u1) annotation (Line(points={{238,36},{230,36},{230,
          80},{70,80},{70,36},{78,36}},    color={0,0,127}));
  connect(TDif, hys.u) annotation (Line(points={{-300,80},{-270,80},{-270,20},{-262,
          20}}, color={0,0,127}));
  connect(tOptCal.y, triSam1.u)  annotation (Line(points={{262,30},{278,30}}, color={0,0,127}));
  connect(triSam1.y, tOpt) annotation (Line(points={{302,30},{310,30},{310,0},{340,
          0}},      color={0,0,127}));
  connect(StaCal, triSam1.trigger) annotation (Line(points={{-300,0},{-260,0},{-260,
          -72},{290,-72},{290,18.2}}, color={255,0,255}));
  connect(and2.y, triMovMea.trigger) annotation (Line(points={{-94,-20},{-88,-20},
          {-88,-60},{100,-60},{100,-10},{130,-10},{130,18}}, color={255,0,255}));
   annotation (
defaultComponentName="optStaCal",
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
Diagram(coordinateSystem(extent={{-280,-100},{320,100}})));
end OptimalStartCalculation;
