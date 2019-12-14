within Buildings.Controls.OBC.Utilities;
block OptimalStart
  "Block that outputs the optimal start time for an HVAC system"
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
  parameter Modelica.SIunits.TemperatureDifference uHigh=0.5
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
  Buildings.Controls.OBC.CDL.Interfaces.RealInput tNexOcc "Time until next occupancy" annotation (
      Placement(transformation(extent={{-180,-100},{-140,-60}}),
        iconTransformation(extent={{-140,-100},{-100,-60}})));

  Buildings.Controls.OBC.CDL.Continuous.Add dTHea(k1=+1, k2=-1) if not cooling_only
    "Temperature difference between heating setpoint and zone temperature"
    annotation (Placement(transformation(extent={{-80,70},{-60,90}})));
  Buildings.Controls.OBC.CDL.Continuous.Add dTCoo(k1=+1, k2=-1) if not heating_only
    "Temperature difference between zone temperature and cooling setpoint"
    annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput tOpt(
   final quantity="Time",
   final unit="s",
   displayUnit="h")
                   "Optimal start time of HVAC system"
    annotation (Placement(transformation(extent={{140,20},{180,60}}),
        iconTransformation(extent={{100,20},{140,60}})));
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

  CDL.Continuous.AddParameter addPar(p=-tOptMax,k=1)
    "Maximum optimal start time"
    annotation (Placement(transformation(extent={{-100,-10},{-80,10}})));
  CDL.Continuous.Hysteresis hysSta(
    pre_y_start=true,
    uHigh=0,
    uLow=-60) "Hysteresis to activate the optimal start"
    annotation (Placement(transformation(extent={{-70,-10},{-50,10}})));
  CDL.Logical.Edge edg "Start calculation"
    annotation (Placement(transformation(extent={{-30,20},{-10,40}})));
  CDL.Logical.FallingEdge falEdg "Stop calculation"
    annotation (Placement(transformation(extent={{-30,-40},{-10,-20}})));
  CDL.Interfaces.BooleanOutput start "Optimal start boolean output" annotation (
     Placement(transformation(extent={{140,-60},{180,-20}}), iconTransformation(
          extent={{100,-60},{140,-20}})));
  CDL.Logical.Sources.Constant con(k=false) if
                                              cooling_only
    annotation (Placement(transformation(extent={{60,-30},{80,-10}})));
  CDL.Logical.Sources.Constant con3(k=false) if
                                               heating_only
    annotation (Placement(transformation(extent={{60,-94},{80,-74}})));
  CDL.Logical.Or or2
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
  connect(dTHea.y, optHea.TDif)
    annotation (Line(points={{-58,80},{-8,80},{-8,78},{18,78}},
                                                color={0,0,127}));
  connect(tNexOcc, addPar.u) annotation (Line(points={{-160,-80},{-120,-80},{-120,
          0},{-102,0}},     color={0,0,127}));
  connect(addPar.y, hysSta.u)
    annotation (Line(points={{-78,0},{-72,0}}, color={0,0,127}));
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
  connect(start, start)
    annotation (Line(points={{160,-40},{160,-40}}, color={255,0,255}));
  connect(falEdg.y, optCoo.StaCal) annotation (Line(points={{-8,-30},{0,-30},{0,
          -67},{18,-67}}, color={255,0,255}));
  connect(edg.y, optHea.StoCal) annotation (Line(points={{-8,30},{8,30},{8,67},{
          18,67}}, color={255,0,255}));
  connect(edg.y, optCoo.StoCal) annotation (Line(points={{-8,30},{8,30},{8,-73},
          {18,-73}}, color={255,0,255}));
  connect(or2.y, start)
    annotation (Line(points={{122,-40},{160,-40}}, color={255,0,255}));
  connect(con.y, or2.u1) annotation (Line(points={{82,-20},{92,-20},{92,-40},{98,
          -40}}, color={255,0,255}));
  connect(con3.y, or2.u2) annotation (Line(points={{82,-84},{92,-84},{92,-48},{98,
          -48}}, color={255,0,255}));
  connect(optCoo.yOpt, or2.u2) annotation (Line(points={{42,-74},{50,-74},{50,-48},
          {98,-48}}, color={255,0,255}));
  connect(optHea.yOpt, or2.u1) annotation (Line(points={{42,66},{92,66},{92,-40},
          {98,-40}}, color={255,0,255}));
   annotation (
defaultComponentName="optSta",
  Documentation(info="<html>
<p>This block outputs the optimal start time each day for an HVAC system prior to the occupied time. The calculation is based on the concept of temperature slope (or temperature gradient). This variable indicates the temperature change rate of a zone, with the unit <span style=\"font-family: monospace;\">K/s</span>. The algorithm is described as below. </p>
<p><b>Step 1: get sampled temperature difference <span style=\"font-family: monospace;\">&Delta;T</span></b></p>
<p>Each day at a certain time before the occupancy, the algorithm takes a sample of the zone temperature. The sampling time is defined as occupancy start time <span style=\"font-family: monospace;\">- tOptMax</span>, where <span style=\"font-family: monospace;\">tOptMax</span> denotes the maximum optimal start time. </p>
<p>After getting the zone temperature at the sampling time, the difference <span style=\"font-family: monospace;\">&Delta;T</span> between this zone temperature and the occupied zone setpoint is calculated. </p>
<p><b>Step 2: calculate temeperature slope <span style=\"font-family: monospace;\">Ts</span></b></p>
<p>After the HVAC system is started, a timer is used to record how much time <span style=\"font-family: monospace;\">&Delta;t</span> the zone temperature reaches the setpoint. When the time becomes greater than the maximum start time, the maximum start time is used. The temperature slope is thus approximated using the equation: <span style=\"font-family: monospace;\">Ts=&Delta;T/&Delta;t</span>. </p>
<p><b>Step 3: calculate temperature slope moving average</b></p>
<p>After getting the temperature slope of each day, the moving average of the temperature slope <span style=\"font-family: monospace;\">Ts_m</span> during the previous <span style=\"font-family: monospace;\">n</span> days is calculated. </p>
<p><b>Step 4: calculate optimal start time</b></p>
<p>The optimal start time is calculated using <span style=\"font-family: monospace;\">&Delta;T</span> from Step 1 and the averaged temperature slope <span style=\"font-family: monospace;\">Ts_m</span> of the previous <span style=\"font-family: monospace;\">n</span> days: <span style=\"font-family: monospace;\">t_opt = &Delta;T/Ts_m</span>. </p>
<p><b>Initialization</b></p>
<p>During the initial day, the initial optimal start time parameter <span style=\"font-family: monospace;\">tOptIni</span> is used. </p>
<p><b>Multiple zones</b></p>
<p>When there are multiple zones in the system, use the maximum zone temperature for cooling system and minimum zone temperature for heating system. </p>
<p><b>Validation</b></p>
<p>A validation can be found at <a href=\"modelica://Buildings.Controls.OBC.Utilities.Validation.OptimalStart\">Buildings.Controls.OBC.CDL.Utilities.Validation.OptimalStart</a>. </p>
</html>",
revisions="<html>
<ul>
<li>
September 29, 2019, by Kun Zhang:<br/>
First implementation.
</li>
</ul>
</html>"),
Diagram(coordinateSystem(extent={{-140,-100},{140,100}})));
end OptimalStart;
