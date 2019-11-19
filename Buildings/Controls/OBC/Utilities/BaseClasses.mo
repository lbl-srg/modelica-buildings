within Buildings.Controls.OBC.Utilities;
package BaseClasses
  extends Modelica.Icons.BasesPackage;
  block TemperatureSlope
    "Block that outputs the optimal start time for an HVAC system"
    extends Modelica.Blocks.Icons.Block;
    parameter Real occupancy[:]
      "Occupancy table, each entry switching occupancy on or off";
    parameter Modelica.SIunits.Time tOptMax
      "Maximum optimal start time";
    parameter Modelica.SIunits.Time tOptIni
      "Initial optimal start time";
    parameter Integer n "Number of previous days for averaging the temperature slope";
    parameter Modelica.SIunits.TemperatureDifference uLow
      "Temperature change hysteresis low parameter, should be a non-negative number";
    parameter Modelica.SIunits.TemperatureDifference uHigh
      "Temperature change hysteresis high parameter, should be greater than uLow";
    CDL.Continuous.Hysteresis hys(uLow=uLow, uHigh=uHigh)
      "Comparing zone temperature with zone setpoint"
      annotation (Placement(transformation(extent={{-220,40},{-200,60}})));
    CDL.Logical.Latch lat
      "Stop calculation when the zone temperature reaches setpoint"
      annotation (Placement(transformation(extent={{-150,10},{-130,30}})));
    CDL.Logical.Timer tim(reset=true)
      "Record how much time the zone temperature reaches the setpoint"
      annotation (Placement(transformation(extent={{-32,20},{-12,40}})));

    CDL.Discrete.TriggeredSampler triSam(y_start=tOptIni)
      "Record how much time it takes to reach the setpoint with the maximum time cutoff"
      annotation (Placement(transformation(extent={{0,20},{20,40}})));
    CDL.Logical.FallingEdge falEdg
      "Get the timing when the zone temperature reaches setpoint"
      annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
    CDL.Logical.TrueHoldWithReset truHol(duration(displayUnit="h") = occupancy[2] -
        occupancy[1])
      annotation (Placement(transformation(extent={{-66,20},{-46,40}})));
    CDL.Logical.Latch latMax
      "Stop calculation when it reaches the max start time"
      annotation (Placement(transformation(extent={{-106,20},{-86,40}})));
    CDL.Logical.Not not1 "Becomes true when the setpoint is reached"
      annotation (Placement(transformation(extent={{-186,10},{-166,30}})));
    CDL.Continuous.Division temSlo "Calculate temperature slope "
      annotation (Placement(transformation(extent={{120,20},{140,40}})));
    CDL.Continuous.Division tOptCal
      "Calculate optimal start time based on the averaged previous temperature slope"
      annotation (Placement(transformation(extent={{280,20},{300,40}})));
    CDL.Continuous.Sources.Constant zeroOpt(k=0)
      "Avoid zero division cases when the optimal start time is 0"
      annotation (Placement(transformation(extent={{0,-30},{20,-10}})));
    CDL.Logical.Switch swi
      annotation (Placement(transformation(extent={{80,20},{100,40}})));
    CDL.Continuous.Sources.Constant defOptTim(k=tOptIni)
      "Default optimal start time in case of zero division"
      annotation (Placement(transformation(extent={{40,-30},{60,-10}})));
    CDL.Continuous.Sources.Constant zeroTemSlo(k=0)
      "Avoid zero divison when the temperature slope is 0"
      annotation (Placement(transformation(extent={{152,-30},{172,-10}})));
    CDL.Logical.Switch swi1
      annotation (Placement(transformation(extent={{240,20},{260,40}})));
    CDL.Continuous.Sources.Constant defTemSlo(k=temSloDef)
      "Default temperature slope in case of zero division"
      annotation (Placement(transformation(extent={{192,-30},{212,-10}})));
    CDL.Logical.And and2 "Duration that it takes to reach the setpoint"
      annotation (Placement(transformation(extent={{-76,-10},{-56,10}})));
    CDL.Interfaces.BooleanOutput yStart
      "Boolean signal of optimal start duration" annotation (Placement(
          transformation(extent={{320,-80},{360,-40}}), iconTransformation(extent=
             {{100,-80},{140,-40}})));
    CDL.Interfaces.RealOutput TSlo "Temperature slope of HVAC system"
      annotation (Placement(transformation(extent={{320,40},{360,80}}),
          iconTransformation(extent={{100,20},{140,60}})));
    CDL.Continuous.Greater gre
      annotation (Placement(transformation(extent={{40,20},{60,40}})));
    CDL.Continuous.Greater gre1
      annotation (Placement(transformation(extent={{200,20},{220,40}})));
    CDL.Discrete.TriggeredMovingMean triMovMea(n=n)
      annotation (Placement(transformation(extent={{160,20},{180,40}})));
    CDL.Interfaces.RealInput TDif(
      final quantity="ThermodynamicTemperature",
      final unit="K",
      displayUnit="degC",
      min=200)
      "Zone heating setpoint temperature during occupancy" annotation (Placement(
          transformation(extent={{-280,60},{-240,100}}), iconTransformation(
            extent={{-140,40},{-100,80}})));
    CDL.Interfaces.BooleanInput StaCal annotation (Placement(transformation(
            extent={{-280,-20},{-240,20}}), iconTransformation(extent={{-140,-20},
              {-100,20}})));
    CDL.Interfaces.BooleanInput StoCal annotation (Placement(transformation(
            extent={{-280,-100},{-240,-60}}), iconTransformation(extent={{-140,-88},
              {-100,-48}})));
  protected
      parameter Modelica.SIunits.TemperatureSlope temSloDef = 1/3600
      "Default temperature slope in case of zero division";
  equation
    connect(tim.y, triSam.u)  annotation (Line(points={{-10,30},{-2,30}},
                                                color={0,0,127}));
    connect(falEdg.y, triSam.trigger) annotation (Line(points={{-18,0},{10,0},{10,
            18.2}},                                                                          color={255,0,255}));
    connect(tim.u, truHol.y)  annotation (Line(points={{-34,30},{-44,30}}, color={255,0,255}));
    connect(latMax.y, truHol.u) annotation (Line(points={{-84,30},{-68,30}},   color={255,0,255}));
    connect(hys.y, not1.u)  annotation (Line(points={{-198,50},{-194,50},{-194,20},
            {-188,20}},                                color={255,0,255}));
    connect(not1.y, lat.clr) annotation (Line(points={{-164,20},{-158,20},{-158,14},
            {-152,14}}, color={255,0,255}));
    connect(swi1.y, tOptCal.u2) annotation (Line(points={{262,30},{270,30},{270,24},
            {278,24}}, color={0,0,127}));
    connect(swi.y, temSlo.u2) annotation (Line(points={{102,30},{108,30},{108,24},
            {118,24}},
                  color={0,0,127}));
    connect(and2.u1, truHol.u) annotation (Line(points={{-78,0},{-80,0},{-80,30},{
            -68,30}},  color={255,0,255}));
    connect(and2.y, falEdg.u)  annotation (Line(points={{-54,0},{-42,0}},   color={255,0,255}));
    connect(lat.y, and2.u2) annotation (Line(points={{-128,20},{-120,20},{-120,-8},
            {-78,-8}}, color={255,0,255}));
    connect(lat.y, latMax.u) annotation (Line(points={{-128,20},{-120,20},{-120,30},
            {-108,30}},     color={255,0,255}));
    connect(and2.y, yStart) annotation (Line(points={{-54,0},{-48,0},{-48,-60},{340,
            -60}},      color={255,0,255}));
    connect(temSlo.y, triMovMea.u)  annotation (Line(points={{142,30},{158,30}}, color={0,0,127}));
    connect(triSam.y, gre.u1)   annotation (Line(points={{22,30},{38,30}}, color={0,0,127}));
    connect(zeroOpt.y, gre.u2) annotation (Line(points={{22,-20},{30,-20},{30,22},
            {38,22}},color={0,0,127}));
    connect(gre.y, swi.u2)  annotation (Line(points={{62,30},{78,30}}, color={255,0,255}));
    connect(triSam.y, swi.u1) annotation (Line(points={{22,30},{30,30},{30,48},{70,
            48},{70,38},{78,38}},     color={0,0,127}));
    connect(defOptTim.y, swi.u3) annotation (Line(points={{62,-20},{70,-20},{70,22},
            {78,22}}, color={0,0,127}));
    connect(triMovMea.y, gre1.u1) annotation (Line(points={{182,30},{198,30}}, color={0,0,127}));
    connect(zeroTemSlo.y, gre1.u2) annotation (Line(points={{174,-20},{186,-20},{186,
            22},{198,22}},     color={0,0,127}));
    connect(gre1.y, swi1.u2)  annotation (Line(points={{222,30},{238,30}}, color={255,0,255}));
    connect(triMovMea.y, swi1.u1) annotation (Line(points={{182,30},{192,30},{192,
            50},{230,50},{230,38},{238,38}},   color={0,0,127}));
    connect(defTemSlo.y, swi1.u3) annotation (Line(points={{214,-20},{230,-20},{230,
            22},{238,22}}, color={0,0,127}));
    connect(hys.y, triMovMea.trigger) annotation (Line(points={{-198,50},{-194,50},
            {-194,-40},{140,-40},{140,6},{170,6},{170,18}}, color={255,0,255}));
    connect(TDif, temSlo.u1) annotation (Line(points={{-260,80},{110,80},{110,36},
            {118,36}}, color={0,0,127}));
    connect(StoCal, latMax.clr) annotation (Line(points={{-260,-80},{-112,-80},{-112,
            24},{-108,24}}, color={255,0,255}));
    connect(StaCal, lat.u) annotation (Line(points={{-260,0},{-156,0},{-156,20},{-152,
            20}}, color={255,0,255}));
    connect(tOptCal.u1, temSlo.u1) annotation (Line(points={{278,36},{270,36},{270,
            80},{110,80},{110,36},{118,36}}, color={0,0,127}));
    connect(tOptCal.y, TSlo) annotation (Line(points={{302,30},{312,30},{312,60},{
            340,60}}, color={0,0,127}));
    connect(TDif, hys.u) annotation (Line(points={{-260,80},{-230,80},{-230,50},{-222,
            50}}, color={0,0,127}));
     annotation (
  defaultComponentName="temSlo",
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
  Diagram(coordinateSystem(extent={{-240,-100},{320,100}})));
  end TemperatureSlope;
end BaseClasses;
