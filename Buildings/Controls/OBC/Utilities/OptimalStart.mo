within Buildings.Controls.OBC.Utilities;
block OptimalStart
  "Block that outputs the optimal start time for an HVAC system before occupancy"
  parameter Real tOptMax(
    final quantity="Time",
    final unit="s",
    displayUnit="h",
    final min=0,
    max=21600)=10800
    "Maximum optimal start time";
  parameter Integer nDay(
    min=1)=3
    "Number of previous days used to compute the optimal start up time";
  parameter Boolean computeHeating=false
    "Set to true to compute optimal start for heating";
  parameter Boolean computeCooling=false
    "Set to true to compute optimal start for cooling";
  parameter Real uLow(
    final quantity="TemperatureDifference",
    final unit="K",
    final min=0)=0
    "Threshold to determine if the zone temperature reaches the occupied setpoint,
     must be a non-negative number";
  parameter Real uHigh(
    final quantity="TemperatureDifference",
    final unit="K",
    final min=0)=0.5
    "Threshold to determine the need to start the HVAC system before occupancy,
     must be greater than uLow";
  parameter Real thrOptOn(
    final quantity="Time",
    final unit="s",
    displayUnit="h",
    final min=0,
    max=10800)=60
    "Threshold time, optimal start on signal becomes true when tOpt larger than thrOptOn";
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSetZonHea(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    displayUnit="degC",
    min=200) if computeHeating
    "Zone heating setpoint temperature during occupancy"
    annotation (Placement(transformation(extent={{-180,60},{-140,100}}),
      iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TZon(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    displayUnit="degC",
    min=200)
    "Zone temperature"
    annotation (Placement(transformation(extent={{-180,-60},{-140,-20}}),
      iconTransformation(extent={{-140,-60},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSetZonCoo(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    displayUnit="degC",
    min=200) if computeCooling
    "Zone cooling setpoint temperature during occupancy"
    annotation (Placement(transformation(extent={{-180,20},{-140,60}}),
      iconTransformation(extent={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput tNexOcc(
    final quantity="Time",
    final unit="s",
    displayUnit="h")
    "Time until next occupancy"
    annotation (Placement(transformation(extent={{-180,-100},{-140,-60}}),
      iconTransformation(extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput tOpt(
    final quantity="Time",
    final unit="s",
    displayUnit="h")
    "Optimal start time duration of HVAC system"
    annotation (Placement(transformation(extent={{140,20},{180,60}}),
      iconTransformation(extent={{100,20},{140,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput optOn
    "Outputs true if the HVAC system remains in the optimal start period"
    annotation (Placement(transformation(extent={{140,-60},{180,-20}}),
      iconTransformation(extent={{100,-60},{140,-20}})));
  Buildings.Controls.OBC.Utilities.BaseClasses.OptimalStartCalculation optHea(
    final tOptMax=tOptMax,
    final thrOptOn=thrOptOn,
    final nDay=nDay,
    final uLow=uLow,
    final uHigh=uHigh) if computeHeating
    "Optimal start time for heating system"
    annotation (Placement(transformation(extent={{20,60},{40,80}})));
  Buildings.Controls.OBC.Utilities.BaseClasses.OptimalStartCalculation optCoo(
    final tOptMax=tOptMax,
    final thrOptOn=thrOptOn,
    final nDay=nDay,
    final uLow=uLow,
    final uHigh=uHigh) if computeCooling
    "Optimal start time for cooling system"
    annotation (Placement(transformation(extent={{20,-80},{40,-60}})));
  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold hysSta(
    t=60,
    h=60)
    "Hysteresis to activate the optimal start boolean output"
    annotation (Placement(transformation(extent={{-70,-10},{-50,10}})));

protected
  Buildings.Controls.OBC.CDL.Reals.Max max
    "Get the maximum optimal start time "
    annotation (Placement(transformation(extent={{100,30},{120,50}})));
  Buildings.Controls.OBC.CDL.Reals.AddParameter addPar(
    p=-tOptMax)
    "Maximum optimal start time"
    annotation (Placement(transformation(extent={{-100,-10},{-80,10}})));
  Buildings.Controls.OBC.CDL.Logical.Or or2
    "Get the optimal start boolean output"
    annotation (Placement(transformation(extent={{100,-50},{120,-30}})));
  Buildings.Controls.OBC.CDL.Reals.Subtract dTHea if computeHeating
    "Temperature difference between heating setpoint and zone temperature"
    annotation (Placement(transformation(extent={{-80,70},{-60,90}})));
  Buildings.Controls.OBC.CDL.Reals.Subtract dTCoo if computeCooling
    "Temperature difference between zone temperature and cooling setpoint"
    annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));
  Buildings.Controls.OBC.CDL.Logical.FallingEdge falEdg
    "Stop calculation"
    annotation (Placement(transformation(extent={{-30,-10},{-10,10}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con2(
    final k=0) if not computeHeating
    "Becomes effective when optimal start is only for heating"
    annotation (Placement(transformation(extent={{60,40},{80,60}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con1(
    final k=0) if not computeCooling
    "Becomes effective when optimal start is only for cooling"
    annotation (Placement(transformation(extent={{60,10},{80,30}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con(
    final k=false) if not computeHeating
    "Becomes effective when optimal start is only for heating"
    annotation (Placement(transformation(extent={{60,-30},{80,-10}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con3(
    final k=false) if not computeCooling
    "Becomes effective when optimal start is only for cooling"
    annotation (Placement(transformation(extent={{60,-94},{80,-74}})));

equation
  connect(TSetZonCoo,dTCoo.u2)
    annotation (Line(points={{-160,40},{-132,40},{-132,-56},{-82,-56}},color={0,0,127}));
  connect(TZon,dTCoo.u1)
    annotation (Line(points={{-160,-40},{-90,-40},{-90,-44},{-82,-44}},  color={0,0,127}));
  connect(TZon,dTHea.u2)
    annotation (Line(points={{-160,-40},{-122,-40},{-122,74},{-82,74}},color={0,0,127}));
  connect(TSetZonHea,dTHea.u1)
    annotation (Line(points={{-160,80},{-126,80},{-126,86},{-82,86}},color={0,0,127}));
  connect(max.y,tOpt)
    annotation (Line(points={{122,40},{160,40}},color={0,0,127}));
  connect(con2.y,max.u1)
    annotation (Line(points={{82,50},{88,50},{88,46},{98,46}},color={0,0,127}));
  connect(con1.y,max.u2)
    annotation (Line(points={{82,20},{88,20},{88,34},{98,34}},color={0,0,127}));
  connect(dTCoo.y,optCoo.TDif)
    annotation (Line(points={{-58,-50},{-22,-50},{-22,-62},{18,-62}},color={0,0,127}));
  connect(dTHea.y,optHea.TDif)
    annotation (Line(points={{-58,80},{-8,80},{-8,78},{18,78}},color={0,0,127}));
  connect(tNexOcc,addPar.u)
    annotation (Line(points={{-160,-80},{-120,-80},{-120,0},{-102,0}},color={0,0,127}));
  connect(tNexOcc,optHea.tNexOcc)
    annotation (Line(points={{-160,-80},{-120,-80},{-120,62},{18,62}},color={0,0,127}));
  connect(optCoo.tOpt,max.u2)
    annotation (Line(points={{42,-66},{88,-66},{88,34},{98,34}},color={0,0,127}));
  connect(optHea.tOpt,max.u1)
    annotation (Line(points={{42,74},{88,74},{88,46},{98,46}},color={0,0,127}));
  connect(tNexOcc,optCoo.tNexOcc)
    annotation (Line(points={{-160,-80},{-68,-80},{-68,-78},{18,-78}},color={0,0,127}));
  connect(falEdg.y,optHea.staCal)
    annotation (Line(points={{-8,0},{0,0},{0,70},{18,70}},color={255,0,255}));
  connect(falEdg.y,optCoo.staCal)
    annotation (Line(points={{-8,0},{0,0},{0,-70},{18,-70}},color={255,0,255}));
  connect(or2.y,optOn)
    annotation (Line(points={{122,-40},{160,-40}},color={255,0,255}));
  connect(con.y,or2.u1)
    annotation (Line(points={{82,-20},{92,-20},{92,-40},{98,-40}},color={255,0,255}));
  connect(con3.y,or2.u2)
    annotation (Line(points={{82,-84},{92,-84},{92,-48},{98,-48}},color={255,0,255}));
  connect(optCoo.optOn,or2.u2)
    annotation (Line(points={{42,-74},{50,-74},{50,-48},{98,-48}},color={255,0,255}));
  connect(optHea.optOn,or2.u1)
    annotation (Line(points={{42,66},{92,66},{92,-40},{98,-40}},color={255,0,255}));
  connect(falEdg.u,hysSta.y)
    annotation (Line(points={{-32,0},{-48,0}},color={255,0,255}));
  connect(addPar.y,hysSta.u)
    annotation (Line(points={{-78,0},{-72,0}},color={0,0,127}));
  annotation (
    defaultComponentName="optSta",
    Documentation(
      info="<html>
<p>
This block predicts the shortest time for an HVAC system to meet the occupied setpoint
prior to the scheduled occupancy. The block requires inputs of zone temperature,
occupied zone setpoint(s) and next occupancy. The two outputs are the optimal start
duration <code>tOpt</code> and the optimal start on signal <code>optOn</code> for
the HVAC system.
</p>
<p>
The block estimates the thermal mass of a zone using its measured air temperature gradient
with respect to time. Once the temperature slope of a zone is known, the optimal start
time can be calculated by the difference between the zone temperature
and the occupied setpoint divided by the temperature slope, assuming the zone responds
as if all thermal mass were concentrated in the room air.
</p>
<p>
The temperature slope is self-tuned based on past data. The moving
average of the temperature slope of the past <code>nDay</code> days
is calculated and used for
the prediction of the optimal start time in the current day.
</p>
<h4>Parameters</h4>
<p>
The parameter <code>nDay</code> is used to compute the moving average of the temperature
slope; the first <code>n</code> days of simulation is therefore used to
initialize the block.
</p>
<p>
The parameter
<code>tOptMax</code> is the maximum allowed optimal start time.
</p>
<p>
The block includes two hysteresis parameters <code>uLow</code> and <code>uHigh</code>.
The parameter
<code>uLow</code> is used to determine if the zone temperature reaches
the setpoint. The algorithm assumes that the zone temperature has reached the setpoint if
<code>TSetZonHea-TZon &le; uLow</code> for a heating system, or
<code>TZon-TSetZonCoo &le; uLow</code> for a cooling system, where
<code>TSetZonHea</code>
denotes the zone heating setpoint during occupancy, <code>TSetZonCoo</code>
denotes the zone cooling setpoint during occupancy, and <code>TZon</code> denotes the
zone temperature.
The parameter
<code>uHigh</code> is used by the algorithm to determine if there is a need to
start the HVAC system prior to occupancy. If
<code>TSetZonHea-TZon &le; uHigh</code> for heating case or
<code>TZon-TSetZonCoo &le; uHigh</code> for cooling case,
then there is no need for the system to start before the occupancy.
</p>
<p>
The optimal start is only active (i.e., the optimal start on signal <code>optOn</code>
becomes true) if the optimal start time is larger than the parameter
<code>thrOptOn</code>.
</p>
<h4>Configuration for HVAC systems</h4>
<p>
The block can be used for heating system only or cooling system only or for both
heating and cooling system.
The two parameters <code>computeHeating</code> and <code>computeCooling</code> are
used to configure the block for these three scenarios.
</p>
<p>
The block calculates the optimal start time separately for heating and cooling systems.
The base class
<a href=\"modelica://Buildings.Controls.OBC.Utilities.BaseClasses.OptimalStartCalculation\">
Buildings.Controls.OBC.Utilities.BaseClasses.OptimalStartCalculation</a> is used
for the calculation.
</p>
<h4>Algorithm</h4>
<p>
The algorithm is as follows:
</p>
<h5>Step 1: Calculate temperature slope <code>TSlo</code></h5>
<p>
Once the HVAC system is started, a timer records the time duration
<code>&Delta;t</code> for the zone temperature to reach the
setpoint. At the time when the timer starts, the zone temperature <code>TSam1</code> is sampled.
The temperature slope is
approximated using the equation <code>TSlo = |TSetZonOcc-TSam1|/&Delta;t</code>,
where <code>TSetZonOcc</code> is the occupied zone setpoint. Note that if <code>
&Delta;t</code> is greater than the maximum optimal start time <code>tOptMax</code>,
then <code>tOptMax</code> is used instead of <code>&Delta;t</code>.
This is to avoid corner cases where the setpoint is never reached, e.g., the HVAC
system is undersized, or there is a steady-state error associated with the HVAC control.
</p>
<h5>Step 2: Calculate temperature slope moving average <code>TSloMa</code></h5>
<p>
After computing the temperature slope of each day, the moving average of the
temperature slope <code>TSloMa</code> during the previous <code>nDay</code> days
is calculated. Please refer to
<a href=\"modelica://Buildings.Controls.OBC.CDL.Discrete.TriggeredMovingMean\">
Buildings.Controls.OBC.CDL.Discrete.TriggeredMovingMean</a> for details about
the moving average algorithm.
</p>
<h5>Step 3: Calculate optimal start time <code>tOpt</code></h5>
<p>
Each day at a certain time before the occupancy, the algorithm takes another
sample of the zone temperature, denoted as <code>TSam2</code>. The sample
takes place <code>tOptMax</code> prior to occupancy start time.
</p>
<p>
The optimal start time is then calculated as <code>tOpt = |TSetZonOcc-TSam2|/TSloMa</code>.
</p>
<h4>Validation</h4>
<p>
Validation models can be found in the package
<a href=\"modelica://Buildings.Controls.OBC.Utilities.Validation\">
Buildings.Controls.OBC.Utilities.Validation</a>.
</p>
</html>",
      revisions="<html>
<ul>
<li>
January 30, 2021, by Michael Wetter:<br/>
Refactored sampling of history of temperature slope to only sample when control error requires optimal start up.
Refactored guarding against division by zero.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2345\">Buildings, issue 2345</a>.
</li>
<li>
August 6, 2020, by Michael Wetter:<br/>
Replaced hysteresis with new inequality block.
</li>
<li>
December 15, 2019, by Kun Zhang:<br/>
First implementation.
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1589\">Buildings, issue #1589</a>.
</li>
</ul>
</html>"),
    Diagram(
      coordinateSystem(
        extent={{-140,-100},{140,100}})),
    Icon(
      graphics={
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-70,40},{10,40},{10,-28},{70,-28}},
          color={28,108,200}),
        Line(
          points={{-34,40},{-20,32},{-12,22},{-6,2},{0,-16},{10,-28}},
          smooth=Smooth.Bezier,
          color={238,46,47}),
        Text(
          extent={{-68,56},{-44,40}},
          textColor={28,108,200},
          textString="TSet"),
        Polygon(
          points={{-70,92},{-78,70},{-62,70},{-70,92}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-70,70},{-70,-78}},
          color={192,192,192}),
        Line(
          points={{-88,-60},{70,-60}},
          color={192,192,192}),
        Polygon(
          points={{92,-60},{70,-52},{70,-68},{92,-60}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(
          points={{10,40},{24,32},{32,22},{38,2},{44,-16},{54,-28}},
          smooth=Smooth.Bezier,
          color={28,108,200},
          pattern=LinePattern.Dot),
        Text(
          textColor={0,0,255},
          extent={{-150,110},{150,150}},
          textString="%name"),
        Ellipse(
          extent={{79,-33},{93,-47}},
          lineColor=DynamicSelect({235,235,235},
            if optOn then
              {0,255,0}
            else
              {235,235,235}),
          fillColor=DynamicSelect({235,235,235},
            if optOn then
              {0,255,0}
            else
              {235,235,235}),
          fillPattern=FillPattern.Solid),
        Text(
          extent={{226,106},{106,56}},
          textColor={0,0,0},
          textString=DynamicSelect("",String(tOpt,
            leftJustified=false,
            significantDigits=3)))}));
end OptimalStart;
